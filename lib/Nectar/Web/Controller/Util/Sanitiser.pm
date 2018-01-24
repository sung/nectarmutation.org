package Nectar::Web::Controller::Util::Sanitiser;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Util::Sanitiser - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Util::Sanitiser in Util::Sanitiser.');
	$c->res->redirect($c->uri_for('/'));
}

# from run/base_run
sub run_name :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::Run")->find($c->stash->{cons});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a run name:'.$c->stash->{run_name}, 'no_such_parameter']) unless $ref;
}

# from run/base_sample
sub sample_name :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::Sample")->find($c->stash->{cons});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a sample name:'.$c->stash->{sample_name}, 'no_such_parameter']) unless $ref;
}

# from run/base_platform
sub platform :Args(0) {
    my ( $self, $c ) = @_;
	my $ref=$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>'Runs'});
	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a platform'.$c->stash->{platform}, 'no_such_parameter']) unless $ref;
}

# from run/base_gene
sub hgnc :Args(0) {
    my ( $self, $c ) = @_;

	my $ref;
	if($c->user_exists){
		$ref=$c->model("CARDIODB::MetaGene")->find({hgnc=>$c->stash->{hgnc}});
	}else{
		$ref=$c->model("UNIPROT::UniProtSeq")->find({gene=>$c->stash->{hgnc},tax_id=>9606});
	}

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a gene name:'.$c->stash->{hgnc}, 'no_such_parameter']) unless $ref;
}

# from run/base_target
sub target :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::Target")->find({target_name=>$c->stash->{target_name}});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a target name:'.$c->stash->{target_name}, 'no_such_parameter']) unless $ref;
}

# from run/by_gene_and_disease
sub diag_code :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::Disease")->find({diag_code=>$c->stash->{diag_code}});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a diagnostic code:'.$c->stash->{diag_code}, 'no_such_parameter']) unless $ref;
}

# from run/base_bru_code
sub bru_code :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::MetaPatient")->find({bru_code=>$c->stash->{bru_code}});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a patient code:'.$c->stash->{bru_code}, 'no_such_parameter']) unless $ref;
}

# from run/base_sample_id
sub sample_id :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::Sample")->find($c->stash->{cons});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a sample ID:'.$c->stash->{run_name}, 'no_such_parameter']) unless $ref;
}

# from mutation/base_mutation_id
sub mutation_id :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->model("CARDIODB::UnifiedCall")->find({id=>$c->stash->{uid}});

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a mutation ID:'.$c->stash->{uid}, 'no_such_parameter']) unless $ref;
}

# from run/base_caller
sub caller :Args(0) {
    my ( $self, $c ) = @_;

	my $ref=$c->config->{$c->stash->{v_caller}};

	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a caller'.$c->stash->{run_name}, 'no_such_parameter']) unless $ref;
}

# from news/1
sub news_id :Args(0){
    my ( $self, $c ) = @_;

	my $ref=$c->model("NECTAR::News")->find({id=>$c->stash->{news_id}});
	$c->response->status(404); #Not Found
	$c->detach('/util/messenger/err_msg', ['No such a news ID:'.$c->stash->{news_id}, 'no_such_parameter']) unless $ref;
}

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
