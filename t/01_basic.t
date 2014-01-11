use strict;
use warnings;
use Test::More;

use App::Path::Maker;
use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile catdir);
sub slurp { open my $fh, "<:utf8", shift or die; join "", <$fh> }

subtest base_dir => sub {
    my $tempdir = tempdir CLEANUP => 1;

    my $maker = App::Path::Maker->new( base_dir => $tempdir );

    my $file;

    $maker->write_file('write.txt', 'writer!!');
    $file = catfile($tempdir, 'write.txt');
    ok -f $file;
    like slurp($file), qr/writer!!/;

    $maker->render_to_file('hello.mt' => 'hello.txt');
    $file = catfile($tempdir, 'hello.txt');
    ok -f $file;
    like slurp($file), qr/hello world/;

    $maker->render_to_file('arg.mt' => 'arg.txt', qw(foo bar));
    $file = catfile($tempdir, 'arg.txt');
    ok -f $file;
    like slurp($file), qr/foo/;
    like slurp($file), qr/bar/;

    $maker->chmod_file('write.txt', 0777);
    ok -x catfile($tempdir, 'write.txt');

    $maker->create_dir('dir');
    ok -x catdir($tempdir, 'dir');
};


subtest rel_dir => sub {
    my $tempdir = tempdir CLEANUP => 1;
    chdir $tempdir;

    my $maker = App::Path::Maker->new;

    my $file;

    $maker->write_file('write.txt', 'writer!!');
    $file = 'write.txt';
    ok -f $file;
    like slurp($file), qr/writer!!/;

    $maker->render_to_file('hello.mt' => 'hello.txt');
    $file = 'hello.txt';
    ok -f $file;
    like slurp($file), qr/hello world/;

    $maker->render_to_file('arg.mt' => 'arg.txt', qw(foo bar));
    $file = 'arg.txt';
    ok -f $file;
    like slurp($file), qr/foo/;
    like slurp($file), qr/bar/;

    $maker->chmod_file('write.txt', 0777);
    ok -x 'write.txt';

    $maker->create_dir('dir');
    ok -x 'dir';

    chdir "/";
};

done_testing;

__DATA__

@@ hello.mt
hello world

@@ arg.mt
? my ($arg1, $arg2) = @_;
arg1 = <?= $arg1 ?>, arg2 = <?= $arg2 ?>
