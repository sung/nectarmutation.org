package Nectar::Web::Controller::Browser::Run;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Run - Catalyst Controller

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
	$c->stash->{search_this}='run';

	unless($c->user_exists){
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?", 'not_logged_in']);
	}
	$c->detach('/util/messenger/err_msg', ["You're not authorised to get here", "not_auth"]) unless $c->check_user_roles( qw/member/ ); # only member can access 
}


=head2 index

=cut

sub index :Path('/run') :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Browser::Run in Browser::Run.');
	$c->forward('_list');
}

# /run
# no argument (Args(0)) taken
sub _list :Args(0){
    my ( $self, $c ) = @_;

	#/run
	unless($c->req->params->{sample_id} or $c->req->params->{run_id}){
		# for google chart api
		$c->stash->{meta_info}=[$c->model("CARDIODB::Run")->search(
			undef,
			{
				select=>[qw/me.platform count('Samples.id')/],
				as=>[qw/platform sample_num/],
				join=>'Samples',
				group_by=>[qw/me.platform/],
				order_by=>{-desc=>"count('Samples.id')"},
			}
		)];

		$c->stash->{index}=1;
	    $c->stash->{run_indices}=[$c->model("CARDIODB::Run")->search({},{order_by=>{-desc=>'id'}})->all()];
    	$c->stash->{template}='Run/run_index.tt2';
	#/run?sample_id=1 or /run?run_id=1
	}else{
		$c->res->redirect($c->uri_for('/run/sample_id/').'/'.$c->req->params->{sample_id}) if $c->req->params->{sample_id};
		$c->res->redirect($c->uri_for('/run').'/'.$c->model("CARDIODB::Run")->find({id=>$c->req->params->{run_id}})->run_name) if($c->req->params->{run_id})
	}
}


#/run/[run_name]
#(e.g. /run/s0464_20101102_PE_BC)
sub base_run :PathPart('run') :Chained('/') :CaptureArgs(1){
    my ($self, $c, $run_name) = @_;
    $c->stash->{run_name}=$run_name;

	#mysql constraints (e.g. where ...)
	$c->stash->{cons}->{'run_name'}=$c->stash->{run_name};

	# sanitize a given run_name 
	$c->forward('/util/sanitiser/run_name');

	# get run_id
	$c->stash->{run_id}=$c->model("CARDIODB::Run")->find($c->stash->{cons})->id;

}

# /run/sample_id/*
sub base_sample_id :PathPart('run/sample_id') :Chained('/') :CaptureArgs(1){
	my ($self, $c, $sample_id)= @_;

	$c->stash->{cons}->{'id'}=$sample_id;
	
	# sanitize a given run_name 
	$c->forward('/util/sanitiser/sample_id');

	# get info
	$c->stash->{run_name}=$c->model("CARDIODB::Sample")->find($c->stash->{cons})->run_name;
	$c->stash->{sample_name}=$c->model("CARDIODB::Sample")->find($c->stash->{cons})->sample_name;
}

# /run/sample_id/1
sub by_sample_id :PathPart('') :Chained('base_sample_id') :Args(0){
	my ($self, $c)= @_;
	$c->res->redirect($c->uri_for("/run/".$c->stash->{run_name}."/".$c->stash->{sample_name}));
}

# /run/sample_id/*/*
# /run/sample_id/1/[diBayes|GATKs|Samtools|SmallIndels|CGA]
# /run/sample_id/1/[diBayes|GATKs|Samtools|SmallIndels|CGA]/download/csv
sub base_sample_id_and_caller :PathPart('') :Chained('base_sample_id') :CaptureArgs(1){
	my ($self, $c, $v_caller)= @_;

	$c->stash->{v_caller}=$v_caller;
	$c->forward('/util/sanitiser/caller');
}

# /run/sample_id/1/[diBayes|GATKs|Samtools|SmallIndels|CGA]
sub by_sample_id_and_caller :PathPart('') :Chained('base_sample_id_and_caller') :Args(0){
	my ($self, $c)= @_;

	$c->res->redirect($c->uri_for("/run/".$c->stash->{run_name}."/".$c->stash->{sample_name}."/".$c->stash->{v_caller}));
}

# /run/sample_id/1/[diBayes|GATKs|Samtools|SmallIndels|CGA]/download/[csv|plain]
# /run/sample_id/1/diBayes/download/csv?id=1
sub download_by_sample_id_and_caller :PathPart('download') :Chained('base_sample_id_and_caller') :Args(1){
	my ($self, $c, $content_type)= @_;

	if($c->req->params->{id}){
		$c->res->redirect($c->uri_for("/run/".$c->stash->{run_name}."/".$c->stash->{sample_name}."/".$c->stash->{v_caller}."/download/$content_type", {id=>$c->req->params->{id}}));
	}else{
		$c->res->redirect($c->uri_for("/run/".$c->stash->{run_name}."/".$c->stash->{sample_name}."/".$c->stash->{v_caller}."/download/$content_type"));
	}
}

#/run/[run_name]/[sample_name]/* 
#(e.g. /run/s0464_20101102_PE_BC/14sg00080)
#(e.g. /run/s0464_20101102_PE_BC/14sg00080/[GATKs|SmallIndels|diBayes|Samtools])
#sub base_sample  :PathPart('run') :Chained('/') :CaptureArgs(2){
sub base_sample  :PathPart('') :Chained('base_run') :CaptureArgs(1){
	#my ($self, $c, $run_name, $sample_name) = @_;
	#$c->stash->{run_name}=$run_name;
	#$c->stash->{sample_name}=$sample_name;

    my ($self, $c, $sample_name) = @_;
	$c->stash->{sample_name}=$sample_name;

	#mysql constraints (e.g. where ...)
	$c->stash->{cons}->{'run_name'}=$c->stash->{run_name};
	$c->stash->{cons}->{'sample_name'}=$c->stash->{sample_name};

	$c->forward('/util/sanitiser/sample_name');

	$c->stash->{sample_id}=$c->model("CARDIODB::Sample")->find($c->stash->{cons})->id;

	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples/], 'runs']);

	## is this merged sample?
	$c->stash->{is_merged}=[$c->model("CARDIODB::MergedSample")->search({sid=>$c->stash->{sample_id}})];
}

#/run/[run_name]/[sample_name]/[GATKs|SmallIndels|diBayes|Samtools|CGA]/* 
#(e.g. /run/s0464_20101102_PE_BC/14sg00080/GATKs
#(e.g. /run/s0464_20101102_PE_BC/14sg00080/GATKs/Ensembls
sub base_caller :PathPart('') :Chained('base_sample') :CaptureArgs(1){
    my ($self, $c, $v_caller) = @_;
	$c->stash->{v_caller}=$v_caller;

	$c->forward('/util/sanitiser/caller');

	# mysql constraints (e.g. where ...)
	# this is only for joining with MetaEnsembls
	# however, there are other sqls joing Samples with Callers (e.g. diBayes)
	$c->stash->{cons}->{'MetaEnsembls.source'}=$c->stash->{v_caller}; #MetaEnsembls.source=?

	## [todo] make a data fetching controller (Controller::Fetcher)
	## Get MetaEnsembl info
	$c->forward('_call_sample', [[qw/MetaEnsembls/], 'meta_ensembls', [qw/source/]]);

	# remove 'MetaEnsembls.source' to join with 'caller' having no MetaEnsembls relationship
	delete $c->stash->{cons}->{'MetaEnsembls.source'};
}

#/run/gene/TTN or 
#/run/gene/TTN/disease/ARR
sub base_gene :PathPart('run/gene') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $hgnc) = @_;

	#$c->stash->{hgnc}= $c->request->query_keywords? $c->request->query_keywords : undef;
	$c->stash->{hgnc}= $hgnc;
	
	$c->stash->{cons}->{'TargetGenes.hgnc'}=$c->stash->{hgnc};

	$c->forward('/util/sanitiser/hgnc');
}


#/run/gene/TTN
# this call is from /gene/TTN
sub by_gene :PathPart('') :Chained('base_gene') :Args(0) {
    my ( $self, $c) = @_;

	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples TargetGenes/], 'runs']);

	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples TargetGenes/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}

#/run/target
#/run/target/ICCv2
sub base_target :PathPart('run/target') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $target_name) = @_;

	#$c->stash->{hgnc}= $c->request->query_keywords? $c->request->query_keywords : undef;
	$c->stash->{target_name}= $target_name;
	$c->stash->{cons}->{'Targets.target_name'}=$c->stash->{target_name};

	$c->forward('/util/sanitiser/target');
}

#/run/target/ICCv2
# this call is from /target/ICCv2
sub by_target :PathPart('') :Chained('base_target') :Args(0) {
    my ( $self, $c) = @_;

	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples/], 'runs']);

	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples Targets/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}

#/run/target/ICCv3/disease/ARR
# this call is from /target/ICCv3
sub by_target_and_disease :PathPart('disease') :Chained('base_target') :Args(1) {
    my ( $self, $c, $diag_code) = @_;

	$c->stash->{diag_code}= $diag_code;
	$c->stash->{cons}->{'me.diag_code'}=$c->stash->{diag_code};

	$c->forward('/util/sanitiser/diag_code');
	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples/], 'runs']);

	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples Targets/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}

#/run/platform/5500xl
sub base_platform :PathPart('run/platform') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $platform) = @_;

	#$c->stash->{hgnc}= $c->request->query_keywords? $c->request->query_keywords : undef;
	$c->stash->{platform}= $platform;
	$c->stash->{cons}->{'Runs.platform'}=$c->stash->{platform};

	$c->forward('/util/sanitiser/platform');
}

#/run/platform/5500xl
sub by_platform :PathPart('') :Chained('base_platform') :Args(0) {
    my ( $self, $c) = @_;

	$c->forward('_call_sample', [[qw/MergedSamples Runs Targets Diseases MetaSamples/], 'runs']);
	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples Runs/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}

#/run/gene/TTN/disease/ARR
# this call is from /gene/TTN
sub by_gene_and_disease :PathPart('disease') :Chained('base_gene') :Args(1) {
    my ( $self, $c, $diag_code) = @_;

	$c->stash->{diag_code}= $diag_code;
	$c->stash->{cons}->{'me.diag_code'}=$c->stash->{diag_code};

	$c->forward('/util/sanitiser/diag_code');
	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples TargetGenes/], 'runs']);

	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples TargetGenes/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}

#/run/disease/ARR
#/run/disease/ARR/gene/TTN
sub base_disease :PathPart('run/disease') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $diag_code) = @_;

	#$c->stash->{hgnc}= $c->request->query_keywords? $c->request->query_keywords : undef;
	$c->stash->{diag_code}= $diag_code;
	$c->stash->{cons}->{'me.diag_code'}=$c->stash->{diag_code};

	$c->forward('/util/sanitiser/diag_code');
}

#/run/disease/ARR
# this call is from /disease
sub by_disease :PathPart('') :Chained('base_disease') :Args(0) {
    my ( $self, $c) = @_;

	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples/], 'runs']);

	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}


#/run/disease/ARR/gene/TTN
sub by_disease_and_gene :PathPart('gene') :Chained('base_disease') :Args(1) {
    my ( $self, $c, $hgnc) = @_;
	$c->res->redirect($c->uri_for("/run/gene/$hgnc/disease/".$c->stash->{diag_code}));
}

#/run/disease/ARR/target/ICCv4
sub by_disease_and_target :PathPart('target') :Chained('base_disease') :Args(1) {
    my ( $self, $c, $target_name) = @_;
	$c->res->redirect($c->uri_for("/run/target/$target_name/disease/".$c->stash->{diag_code}));
}

#/run/bru/20so00030
sub base_bru_code :PathPart('run/bru') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $bru_code) = @_;
	$c->stash->{bru_code}= $bru_code;
	$c->stash->{cons}->{'me.bru_code'}=$c->stash->{bru_code};

	$c->forward('/util/sanitiser/bru_code');
}

#/run/bru/20so00030
# called by /patient
sub by_bru_code :PathPart('') :Chained('base_bru_code') :Args(0) {
    my ( $self, $c) = @_;

	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples/], 'runs']) ;

	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples/]})];
    $c->stash->{template}='Run/by_run_name.tt2';
}

# /run/s0464_20101102_PE_BC
sub by_run_name :PathPart('') :Chained('base_run') :Args(0)  {
    my ( $self, $c) = @_;

	# get variation caller(LifeScope, GATK, Samtools) info (e.g. version info, calling criteria)
	$c->stash->{callers}=[$c->model("CARDIODB::Caller")->search(
		$c->stash->{cons},
		{
			join=>{'Sample2Callers'=>'Samples'},
			distinct=>1,
		},
	)];

	# this instantiates $c->stash->{runs}
	$c->forward('_call_sample', [[qw/MergedSamples Targets Diseases MetaSamples/], 'runs', [qw/me.id/]]);

	# get run info
	$c->stash->{run_indices}=[$c->model("CARDIODB::Run")->search($c->stash->{cons})->all()];

	## any merged sample?
	$c->stash->{cons}->{'MergedSamples.id'}={'!='=>undef};
	$c->stash->{is_merged}=[$c->model("CARDIODB::Sample")->search($c->stash->{cons},{join=>[qw/MergedSamples/]})];

	$c->stash->{template}='Run/by_run_name.tt2';
}

# /run/s0464_20101102_PE_BC/14sg00080
sub by_sample_name :PathPart('') :Chained('base_sample') :Args(0)  {
	my ($self, $c) = @_;

	## Get EnrichmentReports
	$c->forward('_call_sample', [[qw/EnrichmentReports/], 'reports']);

	## Get run info
	$c->stash->{run_indices}=[$c->model("CARDIODB::Run")->search({run_name=>$c->stash->{run_name}})->all()];

	## Get MetaEnsembl info
	$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedSample")->search({'sample_id'=>$c->stash->{sample_id}})];

	## Get MetaEnsembl info
	$c->forward('_call_sample', [[qw/MetaEnsembls/], 'meta_ensembls', [qw/source/]]);

    $c->stash->{template}='Run/by_sample_name.tt2';
}

# /run/s0464_20101102_PE_BC/14sg00080/[GATKs|SmallIndels|diBayes|Samtools|CGA]
sub variant_caller: PathPart('') :Chained('base_caller') :Args(0)  {
	my ($self, $c) = @_;

	my $v_caller=$c->stash->{v_caller};
		
	# get the total number of entries
	# joined based on the caller
	$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};
	$c->forward('_call_sample', [[$v_caller], 'total']) unless $c->stash->{total};

	# alwasy set $c->stash-{total} before forwarding
	# set paging values (page, limit, pager)
	$c->forward('/pager/set_page', [30]);

	$c->forward('_call_sample', [[$v_caller], 'variations']);

	$c->stash->{template}="Run/caller.tt2";
}

# /run/s0464_20101102_PE_BC/14sg00080/[GATKs|SmallIndel|diBayes|Samtools]/Ensembl?*
# /run/CMR000070_20111114_NAD1/10SC00570/diBayes/Ensembl?NON_SYNONYMOUS_CODING,SPLICE_SITE
sub ensembl_mapping: PathPart('Ensembl') Chained('base_caller') Args(0)  {
	my ($self, $c) = @_;

	$c->stash->{snp_type}= $c->request->query_keywords? $c->request->query_keywords : undef;
	$c->stash->{cons}->{'snp_type'}=$c->stash->{snp_type} if defined $c->stash->{snp_type};
	$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};

	my $v_caller=$c->stash->{v_caller};

	# get them all
	$c->forward('_call_sample', [[$v_caller], 'total']) unless $c->stash->{total};

	# alwasy set $c->stash-{total} before forwarding
	# set paging values (page, limit, pager)
	$c->forward('/pager/set_page', [30]);

	$c->forward('_call_sample', [[$v_caller], 'variations']);

	$c->stash->{template}="Run/V2Ensembls.tt2";
}

# /run/s0464_20101102_PE_BC/14sg00080/[GATKs|SmallIndel|diBayes|Samtools]/download/[csv|plain]
# /run/samle_id/1/GATKs/download/csv?id=1
sub download_caller: PathPart('download') :Chained('base_caller') :Args(1){
    my ($self, $c, $content_type) = @_;

	$c->stash->{content_type}=$content_type;

	my $v_caller=$c->stash->{v_caller};
	# base_caller->base_sample initialise cons->run_name and cons->sample_name
	#$c->stash->{cons}->{'Samples.run_name'}=$c->stash->{run_name};
	#$c->stash->{cons}->{'Samples.sample_name'}=$c->stash->{sample_name};
	$c->stash->{cons}->{'me.id'}=$c->req->params->{id} if $c->req->params->{id};

	$c->forward('_call_sample', [[$v_caller], 'dump']);
	
	# serialize the data from array reference my ($cnt,@data);
	my $cnt=0;
	my @data;
	# Type, Chr, Start, End, Qual, Filter, Allele, dbSNP, Info, GT, AD, DP, GQ, PL
	# header
	if($v_caller eq 'GATKs'){
		$data[$cnt]=['#Type', 'Chr', 'Start', 'End', 'Qual', 'Filter', 'Allele', 'dbSNP', 'Info', 'GT', 'AD', 'DP', 'GQ', 'PL'];
	}elsif($v_caller eq 'SmallIndels'){
		$data[$cnt]=['#Type', 'Chr', 'Start', 'End', 'Allele', 'Allele_count', 'Non-read', 'Coverage_ratio', 'Zygosity', 'Zygosity_score', 'dbSNP'];
	}elsif($v_caller eq 'diBayes'){
		$data[$cnt]=['#Type', 'Chr', 'Start', 'End', 'Score', 'Coverage', 'Allele', 'Ref_allele_count', 'Ref_allele_start', 'Ref_allele_meanQV', 'Novel_allele_count', 'Novel_allele_start', 'Novel_allele_meanQV', 'MADD2', 'SADD3', 'Het?'];
	}elsif($v_caller eq 'Samtools'){
		$data[$cnt]=['#Type', 'Chr', 'Start', 'End', 'Qual', 'Allele', 'Info', 'GT', 'PL', 'GQ'];
	}elsif($v_caller eq 'CGA'){
		$data[$cnt]=['#Type', 'Chr', 'Start', 'End', 'Allele', 'Locus', 'VAF_score', 'EAF_score', 'Quality'];
	}else{
		$c->res->body('No such caller type');
		return;
	}
	$cnt++; #$cnt==1;
	foreach my $v(@{$c->stash->{dump}}){
		# data in contents
		if($v_caller eq 'GATKs'){
			$data[$cnt]=[$v->variant_type, $v->chr, $v->v_start, $v->v_end, $v->qual, $v->filter, $v->reference.'/'.$v->genotype, $v->rs_id, $v->info, $v->gt, $v->ad, $v->f_dp, $v->gq, $v->pl];
		}elsif($v_caller eq 'SmallIndels'){
			$data[$cnt]=[$v->variant_type, $v->chr, $v->v_start, $v->v_end, $v->reference.'/'.$v->genotype, $v->allele_count, $v->no_nonred_reads, $v->coverage_ratio, $v->zygosity, $v->zygosity_score, $v->rs_ids];
		}elsif($v_caller eq 'diBayes'){
			$data[$cnt]=[$v->variant_type, $v->chr, $v->v_start, $v->v_end, $v->score, $v->coverage, $v->reference.'/'.$v->genotype, $v->ref_allele_counts, $v->ref_allele_starts, $v->ref_allele_meanqv, $v->novel_allele_counts, $v->novel_allele_starts, $v->novel_allele_meanqv, $v->maad2, $v->saad3, $v->het];
		}elsif($v_caller eq 'Samtools'){
			$data[$cnt]=[$v->variant_type, $v->chr, $v->v_start, $v->v_end, $v->qual, $v->reference.'/'.$v->genotype, $v->info, $v->gt, $v->pl, $v->gq];
		}elsif($v_caller eq 'CGA'){
			$data[$cnt]=[$v->variant_type, $v->chr, $v->v_start, $v->v_end, $v->reference.'/'.$v->genotype, $v->locus, $v->vaf_score, $v->eaf_score, $v->qual];
		}else{
			$c->res->body('No such caller type');
			return;
		}
		$cnt++;
	}

	$c->stash->{file_name}=$c->stash->{run_name}.'_'.$c->stash->{sample_name}.'_'.$c->stash->{v_caller}.'.txt';
	$c->stash->{download_data}=\@data;
	$c->forward('/util/downloader/export');
	#$c->forward('Nectar::Web::Controller::Util::Downloader::export');
}

# /run/s0464_20101102_PE_BC/14sg00080/[GATKs|SmallIndel|diBayes|Samtools]/Ensembl/download/[csv|plain]?
# e.g. /run/CMR000070_20111114_NAD1/10SC00570/diBayes/Ensembl?NON_SYNONYMOUS_CODING/download
sub download_ensembl: PathPart('Ensembl/download') Chained('base_caller') Args(1){
    my ($self, $c, $content_type) = @_;

	$c->stash->{snp_type}= $c->request->query_keywords? $c->request->query_keywords : undef;
	$c->stash->{content_type}=$content_type;

	my %cond; # hash for constraints on sql query
	$cond{source}=$c->stash->{v_caller}.'s';
	$cond{'Samples.sample_name'}=$c->stash->{sample_name};

	$c->stash->{variations}=[$c->model("CARDIODB::V2Ensembl")->search(
		\%cond,
		{	
			join=>[qw/Samples/],
		},
	)];

	# serialize the data from array reference
	my $cnt=0;
	my @data;
	foreach my $v (@{$c->stash->{variations}}){
		# header
		unless($cnt){
			$data[$cnt]=['ENSG', 'Gene', 'Chr', 'Strand', 'Start', 'End', 'Allele', 'ENSG_type', 'ENST', 'Start', 'End', 'CDS_start', 'CDS_end', 'Codon', 'ENST_type', 'CCDS', 'SNP_type', 'dbSNPs', 'HGMDs', 'ENSP', 'Start', 'End', 'Allele', 'SIFT', 'SIFT_score', 'Polyphen', 'Polyphen_score'];
		}else{
			$data[$cnt]=[$v->ensg, $v->hgnc, $v->chr, $v->strand, $v->g_start, $v->g_end, $v->allele, $v->ensg_type, $v->enst, $v->t_start, $v->t_end, $v->cds_start, $v->cds_end, $v->codon, $v->enst_type, $v->ccds, $v->snp_type, $v->rs_ids, $v->hgmds, $v->ensp, $v->p_start, $v->p_end, $v->p_allele, $v->sift, $v->sift_score, $v->polyphen, $v->polyphen_score];
		}
		++$cnt;
	}

	$c->stash->{file_name}=$c->stash->{run_name}.'_'.$c->stash->{sample_name}.'_'.$c->stash->{v_caller}.'_ensembl.txt';
	$c->stash->{download_data}=\@data;
	$c->forward('/util/downloader/export');

}

sub _call_sample :Private {
    my ($self, $c) = @_;

	my $table_ref= $c->req->args->[0]; #a arrayref 
	my $my_stash= $c->req->args->[1]; #a string

	if($my_stash eq 'total'){
		#pagination for callers
		my $db=$c->config->{$table_ref->[0]}; # [$c->stash->{v_caller}]
		$c->stash->{$my_stash}=$c->model("CARDIODB::$db")->search(
			$c->stash->{cons},
			{	
				join=>[qw/Samples/],
			},
		)->count();
	}elsif($my_stash eq 'variations'){
		#pagination for callers
		my $db=$c->config->{$table_ref->[0]}; # [$c->stash->{v_caller}]
		$c->stash->{$my_stash}=[$c->model("CARDIODB::$db")->search(
			$c->stash->{cons},
			{	
				join=>[qw/Samples/],
				page=>$c->stash->{page},
				rows=>$c->stash->{limit},
			},
		)];
	}elsif($my_stash eq 'dump'){
		#pagination for callers
		my $db=$c->config->{$table_ref->[0]}; # [$c->stash->{v_caller}]
		$c->stash->{$my_stash}=[$c->model("CARDIODB::$db")->search(
			$c->stash->{cons},
			{	
				join=>[qw/Samples/],
			},
		)];
	# mainly for $c->stash->{runs}
	}else{
		my $join;
		$join->{'prefetch'}=$table_ref; # a arrayref
		$join->{'order_by'}=$c->req->args->[2] if defined $c->req->args->[2];
		$c->stash->{$my_stash}=[$c->model("CARDIODB::Sample")->search(
			$c->stash->{cons},
			$join,
		)];
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
