package Nectar::Web::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        Nectar::Web->path_to( 'root', 'src' ),
        Nectar::Web->path_to( 'root', 'src', 'Site' ),
        Nectar::Web->path_to( 'root', 'src', 'Browser' ),
        Nectar::Web->path_to( 'root', 'src', 'Mutation' ),
        Nectar::Web->path_to( 'root', 'src', 'Run' ),
        Nectar::Web->path_to( 'root', 'src', 'Messenger' ),
        Nectar::Web->path_to( 'root', 'src', 'Util' ),
        Nectar::Web->path_to( 'root', 'lib' ),
        Nectar::Web->path_to( 'root', 'lib', 'js'),
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    render_die   => 1,
});

=head1 NAME

Nectar::Web::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<Nectar::Web>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

