package Nectar::Web::Controller::Util::Messenger;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Util::Messenger - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Util::Messenger in Util::Messenger.');
	$c->res->redirect($c->uri_for('/'));
}

# [todo] popup message using javascript
sub err_msg: Private{
    my ($self, $c) = @_;

	$c->stash->{msg}=$c->req->args->[0] if defined $c->req->args->[0];
	$c->stash->{error_code}=$c->req->args->[1] if defined $c->req->args->[1];
	$c->stash->{no_static}=$c->req->args->[2] if defined $c->req->args->[2];
	$c->stash->{template}='Messenger/customed_err.tt2';
} 

# it's Private (no URL match)
sub email :Path('/sendmail') :Args(0) {
    my ( $self, $c ) = @_;

	# get parameters
    $c->stash->{subject}= $c->req->params->{'subject'};
    $c->stash->{sender}= $c->req->params->{'sender'};
    $c->stash->{comment}= $c->req->params->{'comment'};

	#[todo] QC for email address of a sender
	# Catalyst::Plugin::Email 
	$c->email(
		header => [
			From    => $c->stash->{sender},
			To      => $c->config->{admin_to},
			Cc      => $c->config->{admin_cc},
			Subject => $c->stash->{subject}
		],
		#body => $c->view('TT')->render($c,'Messenger/feedback.tt2'),
		body => $c->stash->{comment},
	);

	# Error handing 
	if ( scalar( @{ $c->error } ) ) {
		$c->error(0); # Reset the error condition if you need to
		$c->response->body('Sorry, failed to send your comemnts. Something went wrong!');
	} else {
		$c->response->body('Many thanks for sending your comments. We will get back to you as soon as possible.');
	}
}

=head2 news
	/news/xx
=cut
sub news :Path('/news') {
    my ( $self, $c, $news_id ) = @_;

	if(defined $news_id){
		$c->stash->{news_id}=$news_id if defined $news_id;
		# sanitize a given run_name 
		$c->forward('/util/sanitiser/news_id');
	}

	# get rss feed data (maybe thru local DBMS)
	my $cond=undef;
	$c->stash->{news}=[$c->model("NECTAR::News")->search($cond)];

	$c->stash->{template}='Messenger/news.tt2';
}

=head2 new rss feeder
	htp://localhost/rss
	XML RSS generator via Catalyst::View::XML::Feed
=cut
sub rss :Path('/rss') :Args(0){
    my ( $self, $c ) = @_;

	my $feed; # a hash ref
	$feed->{format}=$c->config->{format};
	$feed->{title}=$c->config->{name} . ' RSS feed' ;
	$feed->{modified}=DateTime->now;
	$feed->{description}=$c->config->{description};
	$feed->{author}=$c->config->{author};
	$feed->{language}=$c->config->{lang};
	$feed->{generator}=$c->config->{rss_generator};
	$feed->{base}=$c->uri_for('/');
	$feed->{link}=$c->uri_for('/news'); # link to the site.

	# get rss feed data (maybe thru local DBMS)
	my $cond=undef;
	# Process the entries (array ref)
	$feed->{entries}=[$c->model("NECTAR::News")->search($cond,{order_by=>['id desc']})];

	$c->stash->{feed}=$feed;
	$c->forward('View::Feed');
}

# old RSS feed (XML::Feed)
=old
sub rss :Path('/rss') {
    my ( $self, $c ) = @_;

	# get rss feed data (maybe thru local DBMS)
	my $news=$c->model("NECTAR::News")->search_rs(undef,{order_by=>['id desc']});
	my $last_modified= $news->get_column('issued')->max(); # a string (2010-03-12 11:33:26)

	# Meta <channel> information here
	my $feed = XML::Feed->new('RSS');
	$feed->title( $c->config->{name} . ' RSS feed' );
	$feed->base($c->uri_for('/'));
	$feed->link( $c->uri_for('/news')); # link to the site.
	$feed->description($c->config->{description});
	$feed->author($c->config->{author});
	$feed->language($c->config->{lang});
	$feed->generator($c->config->{rss_generator});

	#$c->forward('get_datetime', [$last_modified]);
	#$feed->modified($c->stash->{dt});
	$feed->{modified}=DateTime->now;

	# not working
	#$feed->image->title($c->config->{name}.' Logo');
	#$feed->image->url($c->config->{logo});
	#$feed->image->link($c->uri_for('/'));

	# Process the entries
	while( my $entry=$news->next ) {
		my $feed_entry = XML::Feed::Entry->new('RSS');
		$feed_entry->title($entry->title);
		$feed_entry->content($entry->content);
		$feed_entry->link( $c->uri_for($entry->link) ) if $entry->link;
		$feed_entry->summary($entry->content);
		$feed_entry->tags($entry->tags);
		$feed_entry->issued($entry->issued);
		#$c->forward('get_datetime', [$entry->issued]);
		#$feed_entry->issued($c->stash->{dt});
		$feed->add_entry($feed_entry);
	}

	$c->res->content_type('application/rss+xml');
	$c->res->body( $feed->as_xml );

}
=cut

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
