use strict;
use warnings FATAL => 'all';
use utf8;
use Test::More;

use App::Path::Maker;
use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile catdir);
sub slurp { open my $fh, "<:utf8", shift or die; join "", <$fh> }
sub spew  { open my $fh, ">:utf8", $_[0] or die; print {$fh} $_[1] }

my $tempdir = tempdir CLEANUP => 1;
my $template_dir = catdir($tempdir, "template");
mkdir $template_dir or die;
spew catfile($template_dir, 'file1'), 'hello <?= $_[0] ?>';
my $maker = App::Path::Maker->new( base_dir => $tempdir, template_dir => $template_dir );
like $maker->render('file1', 'John'), qr/hello John/;
like $maker->render('file2', 'John'), qr/morning John/;

done_testing;

__DATA__

@@ file2
morning <?= $_[0] ?>

