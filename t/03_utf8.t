use strict;
use warnings FATAL => 'all';
use utf8;
use Test::More;

use App::Path::Maker;
use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile catdir);
sub slurp { open my $fh, "<:utf8", shift or die; join "", <$fh> }

my $tempdir = tempdir CLEANUP => 1;
my $maker = App::Path::Maker->new( base_dir => $tempdir );
$maker->render_to_file('utf8.mt' => 'utf8.txt', 'かきくけこ');
my $file = catfile($tempdir, 'utf8.txt');
ok -f $file;
my $c = slurp($file);
like $c, qr/あいうえお かきくけこ/;


done_testing;

__DATA__

@@ utf8.mt
あいうえお <?= $_[0] ?>
