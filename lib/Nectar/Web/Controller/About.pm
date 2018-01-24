package Nectar::Web::Controller::About;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::About - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

# remember where you are 
sub auto: Private {
    my ( $self, $c ) = @_;
	$c->flash->{uri}=$c->req->uri->path;
}

=head2 index
/about
=cut
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::About in About.');
	$c->stash->{template}='about.tt2';

	$c->stash->{ensembl_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'Ensembl','is_current'=>1})->ver;
	if($c->user_exists){
		$c->stash->{ls_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'LifeScope','is_current'=>1})->ver;
		$c->stash->{gatk_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'GATK','is_current'=>1})->ver;
		$c->stash->{samtool_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'Samtools','is_current'=>1})->ver;
		$c->stash->{ts_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'TorrentSuite','is_current'=>1})->ver;
	}else{
		$c->stash->{hgmd_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'HGMD','is_current'=>1})->ver;
		$c->stash->{cosmic_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'COSMIC','is_current'=>1})->ver;
		$c->stash->{uniprot_ver}=$c->model("CARDIODB::Caller")->find({'caller'=>'UniProt','is_current'=>1})->ver;
	}

}

# /about/mutation_profile 
# /about/mutation_profile?boxy=1 (for Boxy.load)
sub mutation_profile :Local :Args(0) {
    my ( $self, $c) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};

	# default template
	$c->stash(template=>'about_mutation_profile.tt2');

}

# /about/so_terms
# /about/so_terms?boxy=1 (for Boxy.load)
sub so_terms :Local :Args(0) {
    my ( $self, $c) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};

	# default template
	$c->stash(template=>'Site/about_so_terms.tt2');

}

# /about/mutation_encoding
# /about/mutation_encoding?boxy=1 (for Boxy.load)
sub mutation_encoding :Local :Args(0) {
    my ( $self, $c) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};

	# default template
	$c->stash(template=>'Site/mut_signal_matrix.tt2');

}

# /about/annotation?id=all&boxy=1
# /about/annotation?id=all&uniprot=1&boxy=1
# /about/annotation?id=HGMD&boxy=1
sub annotation :Local :Args(0) {
    my ( $self, $c) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};

	my $cond; # a hash ref for filtering condition
	if(defined $c->req->params->{id}){
		if($c->req->params->{id} eq 'all'){
			$cond->{is_function}=1;
		}else{
			$cond->{feature}=$c->req->params->{id};
		}
	}

	if(defined $c->req->params->{uniprot}){
		$cond->{url}={-regexp=>'uniprot'};
	}

	if(defined $c->req->params->{disease}){
		$cond->{category}='Disease variants';
	}

	$c->stash->{featuredef}=[$c->model("UNIPROT::FeatureDef")->search($cond)];
	# default template
	$c->stash(template=>'Site/func_anno.tt2');

}



=head2 index
/about/schema
=cut
sub schema :Local :Args(0) {
    my ( $self, $c, $target ) = @_;

	unless($c->user_exists){
		my $cond;
		$cond->{is_function}=1;
		$cond->{url}={-regexp=>'uniprot'};
		$c->stash->{featuredef}=[$c->model("UNIPROT::FeatureDef")->search($cond)];

		$c->stash->{template}='about_schema.tt2';
	# login 
	}else{
		$c->response->status(403); #Forbidden
		$c->detach('/util/messenger/err_msg', ["You're not authorised to get here", "not_auth"]) unless $c->check_user_roles( qw/member/ ); # only member can access 
		$c->stash->{template}='about_cardiodb_schema.tt2';
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
