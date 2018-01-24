package Nectar::Web::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# always check first whether login or not
sub auto: Private {
    my ( $self, $c ) = @_;

	unless($c->user_exists){
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?"]);
		return;
	}
}

#/user
sub index :Path('/user') :Args(0) {
    my ( $self, $c ) = @_;

	my $user_form = Nectar::Form::Register->new(ctx=>$c);
	$c->stash(template=>'User.tt2', user_form=>$user_form);

	$user_form->process(
		item_id   => $c->user->id,
		params => $c->request->parameters,
		schema => $c->model("NECTAR")->schema,
	);
	# This returns on GET (new user_form) and a POSTed user_form that's invalid.
	return unless $user_form->validated;
}



=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
