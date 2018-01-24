package Nectar::Web::View::Download;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::Download';

__PACKAGE__->config(
    'stash_key'    => 'download',
    'default'      => 'text/plain',
    'content_type' => {
        'text/csv' => {
			# not working for CSV options (manually modified Catalyst::View::Download::CSV)
    		'stash_key'   => 'csv',
		    'quote_char'  => '',
		    'escape_char' => '/',
		    'sep_char'    => "\t",
		    'eol'         => "\n",
            'module'  => '+Download::CSV',
        },
        'text/plain' => {
    		'stash_key'   => 'plain',
            'module'  => '+Download::Plain',
        },
    },
);
=head1 NAME

Nectar::Web::View::Download - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
