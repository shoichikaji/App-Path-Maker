package App::Path::Maker;
use 5.008005;
use strict;
use warnings;
use Carp qw(croak);
use Cwd qw(getcwd);
use File::Path qw(mkpath);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir catfile file_name_is_absolute);
use Text::MicroTemplate::DataSection;

our $VERSION = "0.001";

sub new {
    my $class = shift;
    my %opt   = ref $_[0] ? %{ $_[0] } : @_;
    my $base_dir = delete $opt{base_dir};
    my $data_section  = Text::MicroTemplate::DataSection->new(
        package => scalar(caller),
        %opt,
    );
    bless {
        base_dir => $base_dir,
        data_section => $data_section
    }, $class;
}

sub _abs_path {
    my ($self, $path) = @_;
    return $path if file_name_is_absolute $path;
    return catdir( $self->{base_dir} || getcwd, $path );
}

sub render {
    my ($self, $template_name, @arg) = @_;
    $self->{data_section}->render_file($template_name, @arg);
}
sub chmod_file {
    my ($self, $file, $mod) = @_;
    $file = $self->_abs_path($file);
    my $oct_mod = sprintf '%lo', $mod;
    chmod $mod, $file or croak "chmod $oct_mod $file: $!";
}
sub create_dir {
    my ($self, $dir) = @_;
    $dir = $self->_abs_path($dir);
    return if -d $dir;
    mkpath $dir or croak "mkpath $dir: $!";
}
sub render_to_file {
    my ($self, $template_name, $file, @arg) = @_;
    $file = $self->_abs_path($file);
    my $dir = dirname $file;
    $self->create_dir($dir);
    $self->write_file( $file, $self->render($template_name, @arg) );
}
sub write_file {
    my ($self, $file, $text) = @_;
    $file = $self->_abs_path($file);
    open my $fh, ">:utf8", $file or croak "open $file: $!";
    print {$fh} $text;
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Path::Maker - make files and directories as scaffolding

=head1 SYNOPSIS

    use App::Path::Maker;

    my $maker = App::Path::Maker->new;
    $maker->render_to_file('app.conf.mt' => 'app.conf', {name => 'my app'});
    $maker->create_dir('log');
    $maker->write_file('.gitignore', '*.tar.gz');

    __DATA__

    @@ app.conf.mt
    ? my $arg = shift;
    name = <?= $arg->{name} ?>

=head1 DESCRIPTION

App::Path::Maker helps you make files or directories
as scaffolding.
When I wrote a CLI script for mojo,
I found that L<Mojolicious::Command> is very useful.
This module provides some functionality of that module with
template syntax L<Text::MicroTemplate>.

=head2 CONSTRUCTOR

Constructor C<new> accepts following options:

=over 4

=item base_dir

=item package

=back

=head2 METHOD

=over 4

=item C<< write_file($file, $text) >>

=item C<< render($template_name, @arg) >>

=item C<< render_to_file($template_name, $file, @arg) >>

=item C<< create_dir($dir) >>

=item C<< chmod_file($file) >>

=back

=head1 SEE ALSO

L<Mojolicious::Command>

L<Text::MicroTemplate>

L<Text::MicroTemplate::DataSection>

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@outlook.comE<gt>

=cut

