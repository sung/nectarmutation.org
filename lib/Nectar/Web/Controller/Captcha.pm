package Nectar::Web::Controller::Captcha;
use Moose;
use namespace::autoclean;
use HTTP::Date;
use Nectar::Form::Captcha;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Captcha - Catalyst Controller

=head1 DESCRIPTION

https://github.com/gshank/formhandler-example/blob/master/lib/MyApp/Controller/Captcha.pm
Catalyst Controller.

=head1 METHODS

=cut


=head2 index
/captcha
=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
	my $form = Nectar::Form::Captcha->new(
		ctx => $c,
	);
	#$c->stash( form => $form );
	$c->stash(template => 'Form/captcha.tt2', form=> $form);
	#my $form=$c->stash->{form};
	if($form->process($c->req->params)){
		$c->res->body("verification succeeded");
		return;
	}
}

# /captcha/image
sub image : Local {
	my ( $self, $c ) = @_;

	my $captcha = $c->session->{captcha};
	$c->response->body($captcha->{image});
	$c->response->content_type('image/'. $captcha->{type});
	$c->res->headers->expires( time() );
	$c->res->headers->header( 'Last-Modified' => HTTP::Date::time2str );
	$c->res->headers->header( 'Pragma'        => 'no-cache' );
	$c->res->headers->header( 'Cache-Control' => 'no-cache' );
}

sub get_rnd :Local{
	my ( $self, $c ) = @_;
	my $captcha = $c->session->{captcha};
	die "no captcha in session" unless $captcha;
	$c->res->body($captcha->{rnd});
}

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
