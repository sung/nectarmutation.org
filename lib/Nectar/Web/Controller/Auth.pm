package Nectar::Web::Controller::Auth;
use Moose;
use namespace::autoclean;

# HTF for user registration
use Nectar::Form::Register;
use Digest::MD5 qw/md5_hex/;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

#sub index :Path :Args(0) {
#    my ( $self, $c ) = @_;
#	#$c->response->body('Matched Nectar::Web::Controller::Auth in Auth.');
#	$c->forward('login');
#}

sub login :Path('/login') :Args(0) {
    my ( $self, $c ) = @_;

	if ( my $user= $c->req->params->{username} and my $password = $c->req->params->{password} ){
		#my $to= $c->req->referer ? $c->req->referer : '/'; # http://localhost:3000/auth/http://localhost:3000/run/s0464_20101102_PE_BC/sample/10BD00422DN/DiBaye/Ensembl
		my $to= $c->flash->{uri} ? $c->flash->{uri} : '/';
		$to=$c->flash->{query_keywords} ? $to.'?'.$c->flash->{query_keywords} : $to;
		$to=~s/%3F/\?/;

		#the default realm (default_realm) is checked
		if ( $c->authenticate( { username => $user, password => $password} ) ) {

			# if login successful, update last_log 
			$c->model('NECTAR::User')->find({username=>$user})->update({last_log=>DateTime->now});

			# check whether the account is active or not
			if ( $c->authenticate( { username => $user, password => $password, active=>1} ) ) {
				# /root/static/site/not_logged_in.html
				if($c->req->params->{not_boxy}){
					$c->response->redirect($c->uri_for('/'));
				}else{
					$c->res->body("auth_ok");
					# ajax callback (look at 'loginBoxy' of root/static/js/nectar.js)
				}
			}else{
				$c->logout;
				$c->res->body("You account has not been activated yet (or deactivated)<br/>Check your email!");
			}
		}else{
			$c->res->body("Login failed<br/>No such ID or password");
		}
	}else{
			# invalid form input
			$c->detach('/util/messenger/err_msg', ['Something terribly went wrong! No username and password returned from the login form']);
	}
}

sub logout :Path('/logout') :Args(0) {
    my ( $self, $c ) = @_;
	# if login successful, update last_log 
	unless($c->user_exists){
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg',["You're not logged in?"]);
		return;
	}else{
		$c->model('NECTAR::User')->find({username=>$c->user->username})->update({last_log=>DateTime->now});

		# Clear the user's state
		$c->logout;
		$c->response->redirect($c->uri_for('/'));
	}
}

# only if user not logged in (implemented within the form)
sub register :Path('/register') :Args(0) {
    my ( $self, $c ) = @_;

	# Create an empty row object for the desired table
	# the default value is set in the form module (+item_class)
	my $new_user= $c->model("NECTAR::User")->new_result({});

	my $form = Nectar::Form::Register->new(ctx=>$c);

	# Stash the form and the template to render it
	$c->stash(template => 'Form/register.tt2', form=> $form);

	# generate a random md5
	my $md5=md5_hex(rand);

	# Process the form with the parameters, a schema and a row object
	$form->process(
		item   => $new_user,
		params => $c->request->parameters,
		created => DateTime->today, #2012-03-20T00:00:00
		md5=> $md5,
		#schema => $c->model("NECTAR")->schema, # you don't need this if DBIC binding works well
		#init_object=>{'username'=>'sung','first_name'=>'sung','last_name'=>'gong','email'=>'gong.sungsam@gmail.com'},
	);

	# This returns on GET (new form) and a POSTed form that's invalid.
	return unless $form->validated;

	# send a confirmation email
	my $user_email=$c->req->params->{email};
	my $comment='Dear '.$c->req->params->{username}.', Please visit '.$c->uri_for($c->controller('Auth')->action_for('activate'),{email=>$user_email,md5=>$md5}).' to confirm your registration';

	# Catalyst::Plugin::Email 
	$c->email(
		header => [
			From    => $c->config->{admin_to},
			To      => $user_email,
			Bcc 	=> $c->config->{admin_cc},
			Subject => 'NECTAR user confirmation',
		],
		body => $comment,
	);
}

# activate user registration
# /activate?email=admin@example.com&md5=c47662ba2504508bcdd5cb75106110a6
# doesn't matter logged in or not
sub activate :Path('/activate') :Arg(0) {
    my ( $self, $c ) = @_;
	my $email= $c->req->params->{email};
	my $md5= $c->req->params->{md5};

	# Stash the form and the template to render it
	$c->stash(template => 'Form/activate.tt2');

	unless($c->req->params->{email} and $c->req->params->{md5}){
		$c->detach('/util/messenger/err_msg', ["No Email and MD5"]);
	}else{
		# check whether email is in the DB
		unless($c->model('NECTAR::User')->find({email=>$email})){
			$c->detach('/util/messenger/err_msg', ["No such a user having the email address"]);
		}else{
			# get md5 of the email from the DB
			# check md5 (param) is the same?
			if ($md5 eq $c->model('NECTAR::User')->find({email=>$email})->md5){
				# if same, update activate=1 & md5=null
				$c->model('NECTAR::User')->find({email=>$email})->update({active=>1,md5=>undef});
				# display message and redirect to login page
				$c->stash(msg=>"Activation success: you may now log in");
			}else{
				$c->detach('/util/messenger/err_msg', ["Activation failed: MD5 is wrong"]);
			}
		}
	}

}

# /register/tnc
# see static/site/reg_warning.html
sub tnc :Path('/register/tnc') :Args(0){
    my ( $self, $c ) = @_;

	$c->response->redirect($c->uri_for('/')) unless (defined $c->req->params->{agree} or $c->req->params->{disagree});

	if(defined $c->req->params->{agree} and $c->req->params->{agree} eq 'Agree'){
		$c->session->{agree}=1;
		$c->response->redirect($c->uri_for('/register'));
	}
	if(defined $c->req->params->{disagree} and $c->req->params->{disagree} eq 'Disagree'){
		$c->response->redirect($c->uri_for('/'));
	}
	# root/static/site/warning.html
	if($c->req->params->{has_read}){
		$c->session->{do_not_popup}=1;
		$c->response->redirect($c->uri_for('/'));
	}

}
=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
