# NAME

App::Path::Maker - make files and directories as scaffolding

# SYNOPSIS

    use App::Path::Maker;

    my $maker = App::Path::Maker->new;
    $maker->render_to_file('app.conf.mt' => 'app.conf', {name => 'my app'});
    $maker->create_dir('log');
    $maker->write_file('.gitignore', '*.tar.gz');

    __DATA__

    @@ app.conf.mt
    ? my $arg = shift;
    name = <?= $arg->{name} ?>

# DESCRIPTION

App::Path::Maker helps you make files or directories
as scaffolding.
When I wrote a CLI script for mojo,
I found that [Mojolicious::Command](https://metacpan.org/pod/Mojolicious::Command) is very useful.
This module provides some functionality of that module with
template syntax [Text::MicroTemplate](https://metacpan.org/pod/Text::MicroTemplate).

## CONSTRUCTOR

Constructor `new` accepts following options:

- base\_dir
- package
- template\_header

## METHOD

- `write_file($file, $text)`
- `render($template_name, @arg)`
- `render_to_file($template_name, $file, @arg)`
- `create_dir($dir)`
- `chmod($path)`

# SEE ALSO

[Mojolicious::Command](https://metacpan.org/pod/Mojolicious::Command)

[Text::MicroTemplate](https://metacpan.org/pod/Text::MicroTemplate)

[Text::MicroTemplate::DataSection](https://metacpan.org/pod/Text::MicroTemplate::DataSection)

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@outlook.com>
