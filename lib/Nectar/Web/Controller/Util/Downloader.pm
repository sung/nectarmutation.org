package Nectar::Web::Controller::Util::Downloader;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Util::Downloader - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Util::Downloader in Util::Downloader.');
	$c->res->redirect($c->uri_for('/'));
}

sub export :Private{
    my ( $self, $c ) = @_;

	my $content_type=$c->stash->{content_type};
	# 'plain', 'csv', 'html', or 'xml'
	# my $content_type = $c->request->params->{'content_type'} or 'plain';
	# Set the content type so Catalyst::View::Download can determine how 
    # to process it.
	#$c->header('Content-Type' => 'text/'.$content_type); 
    # Or set the content type in the stash variable 'download' 
    # to process it. (Note: this is configurable)
    $c->stash->{'download'} = 'text/'.$content_type; 

	$c->view('Download')->config(
		'content_type' => {
			"text/$content_type" => {
				'outfile' => $c->stash->{file_name},
			},
		},
	);

	if($content_type eq 'plain'){
		use Data::Dumper;
    	$c->stash->{$content_type} = {
			data => Dumper( $c->stash->{download_data} ),
	    };
	}elsif($content_type eq 'csv'){
    	$c->stash->{$content_type} = {
			data => $c->stash->{download_data},
	    };
	# to display using boxy pop-up window
	# from /mutatin/search page
	}elsif($content_type eq 'boxy'){
		use Data::Dumper;
		$c->res->body('<div class=\'desc\' style=\'width:800px\'>'.Dumper($c->stash->{download_data}).'</div>');
	}else{
		my $messenger;
		$messenger="[ERROR] $content_type not supported yet";	
		$messenger.="choose either 'csv' or 'plain'";	
		$c->res->body($messenger);
		return;
	}

	# Finally forward processing to the Download View
	$c->forward('Nectar::Web::View::Download');
}


=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
