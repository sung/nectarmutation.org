package Nectar::Web::Controller::Browser::Patient;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Patient - Catalyst Controller

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
	$c->stash->{search_this}='patient';

	unless($c->user_exists){
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?", 'not_logged_in']);
	}
	$c->detach('/util/messenger/err_msg', ["You're not authorised to get here", "not_auth"]) unless $c->check_user_roles( qw/member/ ); # only member can access 
}


=head2 index
/patient
=cut
sub index :Path('/patient') :Args(0) {
    my ( $self, $c ) = @_;

	# for google chart api
	$c->stash->{meta_info}=[$c->model("CARDIODB::MetaDisease")->search('cnt_unique_bru'=>{'!='=>0})];

	# get the total number of entries
	$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};
	unless($c->stash->{total}){
		$c->stash->{total}=$c->model("CARDIODB::MetaPatient")->search()->count();
	}

	# alwasy set $c->stash-{total} before forwarding
	# set paging values (page, limit, pager)
	$c->forward('/pager/set_page', [30]);

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatient")->search(
		{},
		{	
			prefetch=>'Diseases',
			page=>$c->stash->{page},
			rows=>$c->stash->{limit},
		},
	)];
    $c->stash->{template}='Browser/patient_index.tt2';
}

#/patient/10AC00242 or
#/patient/10AC00242/gene or
#/patient/target 
sub base_bru :PathPart('patient') :Chained('/') :CaptureArgs(1){
	my ( $self, $c, $bru) = @_;

	$c->stash->{bru_code}=$bru;
	$c->stash->{cons}->{'me.bru_code'}=$bru;

	# sanitize a given bru_code 
	$c->forward('/util/sanitiser/bru_code');

}


#/patient/10AC00242
sub by_bru :PathPart('') :Chained('base_bru') :Args(0){
	my ( $self, $c) = @_;

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatient")->search($c->stash->{cons},{prefetch=>'Diseases'})];
	$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedPatient")->search($c->stash->{cons})];
    $c->stash->{template}='Browser/by_patient.tt2';
}

#/patient/10AC00242/gene
sub by_bru_gene_index :PathPart('gene') :Chained('base_bru') :Args(0){
	my ( $self, $c) = @_;

	$c->stash->{search_this}='patient_gene'; #root/src/Site/sub_search.tt2
	$c->stash->{hgnc}= 'all';


	# get the total number of entries
	$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};
	unless($c->stash->{total}){
		$c->stash->{total}=$c->model("CARDIODB::MetaPatientGene")->search($c->stash->{cons})->count();
	}

	# alwasy set $c->stash-{total} before forwarding
	# set paging values (page, limit, pager)
	$c->forward('/pager/set_page', [30]);

	#if($c->stash->{total}>=500){
	if($c->stash->{total}){
		# paging 
		$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatientGene")->search($c->stash->{cons},{prefetch=>'Diseases',page=>$c->stash->{page},rows=>$c->stash->{limit}})];
		$c->stash->{template}='Browser/patient_index.tt2';
	}else{
		# listNav
		$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatientGene")->search($c->stash->{cons},{prefetch=>'Diseases'})];
		$c->stash->{template}='Browser/patient_gene_index.tt2'; # using ListNav javascript
	}
}

#/patient/10AC00242/gene/TTN
#/patient/10AC00242/gene/undef
sub by_bru_gene :PathPart('gene') :Chained('base_bru') :Args(1){
	my ( $self, $c, $hgnc) = @_;

	$c->stash->{hgnc}= $hgnc;
	$c->stash->{cons}->{'me.hgnc'}= $hgnc eq 'inter-genic'? undef: $hgnc;

	# sanitize a given bru_code 
	$c->forward('/util/sanitiser/hgnc') unless $hgnc eq 'inter-genic';

	# 0. get uid (mutation id) of this pateint and this gene
	$c->stash->{metacalls}=[$c->model("CARDIODB::MetaCall")->search(
		{
			'V2Ensembls.hgnc'=>$hgnc,
			'Samples.bru_code'=>$c->stash->{bru_code}
		},
		{
			join=>["Samples", {'_UnifiedCalls'=>'V2Ensembls'}],
			distinct=>1,
		}
	)];
	
	# 1. get MetaPatientGene (tab: Mutations)
	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatientGene")->search($c->stash->{cons})];
	$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedGenePatient")->search($c->stash->{cons})];

	# 2. get disease info $c->stash->{disease_annos} (tab: $hgnc)
	$c->forward(qw/Controller::Browser::Disease _get_disease_annotation/, [$hgnc]);
	
	# 3. get HGMD mutation for a given gene  (tab: HGMD)
	$c->stash->{hgmds}=[$c->model("CARDIODB::CleanedHgmd")->search(
		{hgnc=>$hgnc},
		{
			join=>[qw/Tags IsNovel/],
			'+select'=>[qw/Tags.tag_name IsNovel.uid/],
			'+as'=>[qw/tag_name uid/],
			distinct=>1,
			order_by=>'acc_num'
		}
	)];

	# 4. get SwissVairants for a given gene  (tab: HUMSAVAR)
	$c->stash->{humsavars}=[$c->model('UNIPROT::SwissVariant2IsNovel')->search(undef,{bind=>[$hgnc]})];

	# 5. get ICC mutations(tab: ICC)
	$c->stash->{iccs}=[$c->model("CARDIODB::Iccref")->search(
		{hgnc=>$hgnc},
		{
			join=>[qw/IsNovel/],
			'+select'=>[qw/IsNovel.uid/],
			'+as'=>[qw/uid/],
			distinct=>1,
		}
	)];

    $c->stash->{template}='Browser/by_patient.tt2';
}

#/patient/gene/TTN or 
#/patient/gene/TTN/disease/ARR
sub base_gene :PathPart('patient/gene') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $hgnc) = @_;

	$c->stash->{hgnc}= $hgnc;
	$c->stash->{cons}->{'me.hgnc'}=$c->stash->{hgnc};
	
	# sanitize a given diag_code 
	$c->forward('/util/sanitiser/hgnc');
}

#/patient/gene/TTN
# this call is from /gene/TTN ( patients having mutations within TTN)
sub by_gene :PathPart('') :Chained('base_gene') :Args(0) {
    my ( $self, $c) = @_;

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatientGene")->search(
		$c->stash->{cons},
		{prefetch=>'Diseases'}
	)];
	# for gogole chart api
	$c->stash->{meta_info}=$c->stash->{meta_patients};

    $c->stash->{template}='Browser/patient_index.tt2';
}	

#/patient/gene/TTN/disease/ARR
# this call is from /gene/TTN
sub by_gene_and_disease :PathPart('disease') :Chained('base_gene') :Args(1) {
    my ( $self, $c, $diag_code) = @_;

	$c->stash->{diag_code}= $diag_code;
	$c->stash->{cons}->{'me.diag_code'}=$c->stash->{diag_code};

	# sanitize a given diag_code 
	$c->forward('/util/sanitiser/diag_code');

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatientGene")->search(
		$c->stash->{cons},
		{prefetch=>'Diseases'}
	)];

    $c->stash->{template}='Browser/patient_index.tt2';
}

#/patient/disease/DCM
#/patient/disease/DCM/gene/TTN
sub base_disease :PathPart('patient/disease') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $diag_code) = @_;

	$c->stash->{diag_code}= $diag_code;
	$c->stash->{cons}->{'me.diag_code'}=$c->stash->{diag_code};
	
	# sanitize a given diag_code 
	$c->forward('/util/sanitiser/diag_code');
}


#/patient/disease/DCM
# this call is from /disease/DCM or from /patient/disease
sub by_disease: PathPart('') :Chained('base_disease') :Args(0) {
    my ( $self, $c) = @_;

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatient")->search(
		$c->stash->{cons},
		{prefetch=>'Diseases'}
	)];
    $c->stash->{template}='Browser/patient_index.tt2';
}

#/patient/disease/DCM/target/ICCv4
sub by_disease_and_target :PathPart('target') :Chained('base_disease') :Args(1) {
    my ( $self, $c, $target_name) = @_;

	$c->res->redirect($c->uri_for("/patient/target/$target_name/disease/".$c->stash->{diag_code}));
}

#/patient/target/ICCV2
sub base_target :PathPart('patient/target') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $target_name) = @_;

	$c->stash->{target_name}= $target_name;
	$c->stash->{cons}->{'Targets.target_name'}=$c->stash->{target_name};

	# sanitize a given diag_code 
	$c->forward('/util/sanitiser/target');
}
#/patient/target/ICCV2
# this call is from /target/ICCV2
sub by_target :PathPart('') :Chained('base_target') :Args(0) {
    my ( $self, $c) = @_;

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatient")->search(
		$c->stash->{cons},
		{
			prefetch=>['Diseases',{'Samples'=>'Targets'}],
			distinct=>1,
		},
	)];
    $c->stash->{template}='Browser/patient_index.tt2';
}

#/patient/target/ICCv3/disease/ARR
# this call is from /target/ICCv3
sub by_target_and_disease :PathPart('disease') :Chained('base_target') :Args(1) {
    my ( $self, $c, $diag_code) = @_;

	$c->stash->{diag_code}= $diag_code;
	$c->stash->{cons}->{'me.diag_code'}=$c->stash->{diag_code};

	# sanitize a given diag_code 
	$c->forward('/util/sanitiser/diag_code');

	$c->stash->{meta_patients}=[$c->model("CARDIODB::MetaPatient")->search(
		$c->stash->{cons},
		{
			prefetch=>['Diseases',{'Samples'=>'Targets'}],
			distinct=>1,
		},
	)];

    $c->stash->{template}='Browser/patient_index.tt2';
}

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
