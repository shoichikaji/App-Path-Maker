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

Constructor `$maker = App::Path::Maker->new` accepts following options:

- base\_dir

    If relative path is specified to methods `chmod`, `create_dir`,
    `render_to_file` or `write_file`, then it is assumed to relative to the `base_dir`.
    Default: current working directory.

- package

    Whose `__DATA__` section to be read.
    Default: `caller`.

- template\_header

    If `template_header` is provided, it is inserted to every template files.
    See `eg/template_header.pl` for example.

- template\_dir

    By default, App::Path::Maker searches for template files in
    `__DATA__` section.
    If `template_dir` is provided, it also searches for template files in
    `template_dir`.

Note that other options may be recognized by [Text::MicroTemplate::File](https://metacpan.org/pod/Text::MicroTemplate::File).

## METHOD

- `$maker->chmod($path)`

    Change permission of `$path`.

- `$maker->create_dir($dir)`

    Create directory `$dir`.

- `$string = $maker->render($template_name, @arg)`

    Render `$template_name` with `@arg`.

- `$maker->render_to_file($template_name, $file, @arg)`

    Render `$template_name` to `$file` with `@arg`.

- `$maker->write_file($file, $string)`

    Write `$string` to `$file`.

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
