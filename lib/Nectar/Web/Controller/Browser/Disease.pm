package Nectar::Web::Controller::Browser::Disease;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Disease - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

# always check first whether login or not
sub auto: Private {
    my ( $self, $c ) = @_;

	#root/lib/site/indicator	
	$c->stash->{sub_search}=1;
	#root/src/Site/sub_search.tt2
	$c->stash->{search_this}='disease';

	unless($c->user_exists){
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?", 'not_logged_in']);
	}
}


=head2 index

=cut

#/disease
sub index :Path('/disease') :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Browser::Disease in Browser::Disease.');
	$c->stash->{meta_diseases}=[$c->model("CARDIODB::MetaDisease")->search('cnt_unique_bru'=>{'!='=>0})];
    $c->stash->{template}='Browser/disease_index.tt2';
}

#/disease/*
sub base_disease :PathPart('disease') :Chained('/') :CaptureArgs(1){
	my ( $self, $c, $diag_code) = @_;

	$c->stash->{diag_code}=$diag_code;
	$c->stash->{cons}->{diag_code}=$diag_code;

	#0. sanitise diag_code 
	$c->forward('/util/sanitiser/diag_code');
}

#/disease/HCM
sub by_disease :PathPart('') :Chained('base_disease') :Args(0){
	my ( $self, $c) = @_;

	#1. NO. of samples for a given disease
	$c->stash->{meta_diseases}=[$c->model("CARDIODB::MetaDisease")->search($c->stash->{cons})];
	$c->stash->{meta_x_diseases}=[$c->model("CARDIODB::MetaTargetDisease")->search(
		$c->stash->{cons},{prefetch=>qw/Targets/}
	)];

	#2. get the stat for a given diase name
	#$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedDisease")->search($c->stash->{cons})];
	$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedTargetDisease")->search($c->stash->{cons})];

    $c->stash->{template}='Browser/by_disease.tt2';
}

# get disease comments from UniProt
#lib/Nectar/WebV2/Controller/Browser/Gene.pm:    $c->forward(qw/Controller::Browser::Disease _get_disease_annotation/, [$hgnc]);
#lib/Nectar/WebV2/Controller/Browser/Patient.pm: $c->forward(qw/Controller::Browser::Disease _get_disease_annotation/, [$hgnc]);
sub _get_disease_annotation :Private{
    my ( $self, $c) = @_;

	my $gene= $c->req->args->[0];
	#[todo] sanitise $gene
	#$c->forward('/util/sanitiser/gene');
	$c->stash->{disease_annos}=[$c->model("UNIPROT::Disease")->search(
		{gene=>$gene},
		{
			select=>[qw/me.acc me.disease_id me.disease_name me.disease_abr me.type me.mim me.des/, "GROUP_CONCAT(DISTINCT(CONCAT_WS(':', Evidences.source, Evidences.ref)))"],
			as=>[qw/acc disease_id disease_name disease_abr type mim des refs/],
			join=>{'diseaseEvi'=>'Evidences'},
			group_by=>[qw/me.id/],
		}
	)];
#$c->stash->{disease_annos}=[$c->model("UNIPROT::DiseaseEvi")->search({acc=>$gene})];
}

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
