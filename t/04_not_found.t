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
eval { $maker->render('not_found') };
ok $@;
eval { $maker->render_to_file('not_found' => 'file') };
ok $@;

done_testing;

__DATA__

@@ somefile
