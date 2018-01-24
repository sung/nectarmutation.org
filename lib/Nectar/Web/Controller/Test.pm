package Nectar::Web::Controller::Test;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Test - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Nectar::Web::Controller::Test in Test.');
}

sub insert1 :Local :Args(0) {
    my ( $self, $c ) = @_;

	$c->model("NECTAR::User")->populate(
		[{
		username=>'test',
		password=>'test',
		email=>'test@example.com',
		first_name=>'test',
		last_name=>'test'
		}]
	);
    $c->response->body('Test inserted');
}

# Caught exception in Nectar::Web::Controller::Test->insert2 
# "Can't use an undefined value as a HASH reference at /home/sung/perl5/lib/perl5/DBIx/Class/Row.pm line 679."
sub insert2 :Local :Args(0) {
    my ( $self, $c ) = @_;

	#my $new_user=$c->model("NECTAR::User")->new_result(
	my $new_user=$c->model("NECTAR")->schema->resultset('User')->new_result(
		{
		id=>4,
		username=>'test2',
		password=>'test',
		email=>'test2@example.com',
		first_name=>'test',
		last_name=>'test',
		roles=>'member',
		active=>0,
		created=>'2011-01-01',
		last_log=>'2012-03-08 12:20:05',
		md5=>undef,
		}
	);
	$new_user->insert;

    $c->response->body('Test inserted');
}

sub debug:Local {
    my ( $self, $c, $uid ) = @_;

	my $schema=	$c->model("NECTAR")->schema; # an instance of Nectar::Schema::NECTAR
	my $user = $schema->resultset('User')->find($uid);
	#my $user = $schema->resultset('User')->new_result({});
	if($user){
		use Nectar::Form::Register;
		my $form = Nectar::Form::Register->new( item => $user );
		my $msg;

		#ref( $form->schema) eq 'Nectar::Schema::NECTAR'? $msg='schema is correct</br>':$msg='schema is incorrect</br>';
		#$form->item_class eq 'User'? $msg.='correct item_class</br>':$msg.='incorrect item_class</br>';

		if(ref( $form->schema->resultset('User')) eq 'DBIx::Class::ResultSet'){
			$msg='User is ResultSet</br>';
		}else{
			$msg='User is NOT ResultSet</br>';
			$msg.=ref($form->schema->resultset('User'));
		}

		if(ref( $form->schema) eq 'Nectar::Schema::NECTAR'){
			$msg.='schema is correct</br>';
		}else{
			$msg.='schema is incorrect</br>';
		}

		if($form->item_class eq 'User'){
			$msg.='correct item_class</br>';
		}else{
			$msg.='incorrect item_class</br>';
		}

		if(ref($form->item) eq 'Nectar::Schema::NECTAR::Result::User'){
			$msg.='correct item</br>';
		}else{
			$msg.='incorrect item</br>';
			$msg.=ref($form->item);
		}

		$c->res->body("Hello ".$user->username."</br>$msg");
	}else{
		# Create an empty row object for the desired table
		# the default value is set in the form module (+item_class)
		my $model_nectar=	$c->model("NECTAR"); # an instance of Nectar::Web::Model::NECTAR
		my $schema=	$c->model("NECTAR")->schema; # an instance of Nectar::Schema::NECTAR
		my $user_source=$model_nectar->source('User'); # a result source (an instance of Schema/Result/User.pm)
		#my $user_source=$schema->source('User'); # a result source (an instance of Schema/Result/User.pm)
		my $user_resultset=$schema->resultset('User'); # same as $c->model("NECTAR::User");
		my $ref_user_resultset=ref($user_resultset); # isa DBIx::Class::ResultSet
		#my $user_resultset=$c->model("NECTAR")->resultset('User'); #same as $c->model("NECTAR::User");
		my $rs_user= $c->model("NECTAR::User");
		my $ref_rs_user= ref($c->model("NECTAR::User")); # isa DBIx::Class::ResultSet
		my $rs_news= $c->model("NECTAR::News");

		my $new_user1= $c->model("NECTAR::User")->find(1); 
		my $ref_new_user1=ref($new_user1);
		my $new_user2=$c->model("NECTAR::User")->new_result({});
		my $ref_new_user2=ref($new_user2);
		#my $new_user2= $c->model("NECTAR::User")->new_result({}); #my $new_user= $user_resultset->new_result({});

		my $source1=$new_user1->result_source; # a result source (an instance of Schema/NECTAR/Result/User.pm) #is a DBIx::Class::ResultSource::Table
		my $user1_username=$new_user1->get_column('username'); 
		my $source2=$new_user2->result_source; # a result source (an instance of Schema/NECTAR/Result/User.pm)
		my $user2_username=$new_user2->get_column('username'); 

		my $storage_from_source1=$source1->schema->storage;
		my $storage_from_source2=$source2->schema->storage;

		$c->res->body("model_nectar=$model_nectar</br>schema=$schema</br>user_source=$user_source</br>user_resultset=$user_resultset</br>ref_user_resultset=$ref_user_resultset</br>rs_user=$rs_user</br>ref_rs_user=$ref_rs_user</br>rs_news=$rs_news</br>new_user1=$new_user1</br>ref_new_user1=$ref_new_user1</br>new_user2=$new_user2</br>ref_new_user2=$ref_new_user2</br>source1=$source1</br>user1_username=$user1_username</br>user2_username=$user2_username</br>source2=$source2</br>storage_from_source1=$storage_from_source1</br>storage_from_source2=$storage_from_source2");

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
