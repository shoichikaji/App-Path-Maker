use strict;
use warnings;
use Test::More;

use App::Path::Maker;
use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile catdir);
sub slurp { open my $fh, "<:utf8", shift or die; join "", <$fh> }

subtest header => sub {
    my $tempdir = tempdir CLEANUP => 1;
    chdir $tempdir;

    my $maker = App::Path::Maker->new(
        template_header => "? my \$arg = shift;\n",
    );

    $maker->render_to_file('with-header' => 'hello.txt', {
        arg1 => 1, arg2 => 2
    });
    my $file = 'hello.txt';
    ok -f $file;
    like slurp($file), qr/12/;
    chdir "/";
};

done_testing;

__DATA__

@@ with-header
<?= $arg->{arg1} ?><?= $arg->{arg2} ?>
