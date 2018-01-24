package Nectar::Web::Controller::Browser::Gene;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Gene - Catalyst Controller

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
	$c->stash->{search_this}='gene';

	$c->flash->{uri}=$c->req->uri->path;
=public
	unless($c->user_exists){
		$c->detach('/util/messenger/err_msg', ["What is your gene of interest?", 'no_gene_name', '/boxy/gene_form']);
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?", 'not_logged_in']);
	}
=cut
}


=head2 index

=cut

#/gene
sub index :Path('/gene') :Args(0) {
    my ( $self, $c ) = @_;

	unless($c->user_exists){
		#$c->detach('/util/messenger/err_msg', ["MESSAGE", 'ERROR_CODE', 'DIRECT_POPUP_URL_IF_ANY']);
		$c->detach('/util/messenger/err_msg', ["What is your gene of interest?", 'no_gene_name', '/boxy/gene_form']);
	}else{
		# get the total number of entries
		$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};
		unless($c->stash->{total}){
			$c->stash->{total}=$c->model("CARDIODB::MetaGene")->search(
				{
					'hgnc'=> { '!=' => undef },   # is not null
				},
			)->count();
		}

		# alwasy set $c->stash-{total} before forwarding
		# set paging values (page, limit, pager)
		$c->forward('/pager/set_page', [30]);

		$c->stash->{meta_genes}=[$c->model("CARDIODB::MetaGene")->search(
			{
				'hgnc'=> { '!=' => undef },   # is not null
			},
			{	
				page=>$c->stash->{page},
				rows=>$c->stash->{limit},
			},
		)];
		$c->stash->{template}='Browser/gene_index.tt2';
	}
}


#/gene/*
sub base_gene :PathPart('gene') :Chained('/') :CaptureArgs(1){
	my ( $self, $c, $hgnc) = @_;

	$c->stash->{hgnc}=$hgnc;
	$c->stash->{cons}->{'me.hgnc'}=$hgnc;

	#0. sanitise hgnc 
	$c->forward('/util/sanitiser/hgnc'); # the function should NOT be a Private
	#$c->forward(qw/Controller::Util::Sanitiser hgnc/); # doesn't matter Private or not
}


#/gene/TTN
sub by_hgnc :PathPart('') :Chained('base_gene') :Args(0){
	my ( $self, $c) = @_;

	my $hgnc=$c->stash->{hgnc};

	#############################################################################
	# 0. corresponding UniProt entries 
	$c->stash->{uniprot_seq}=[$c->model('UNIPROT::UniProtSeq')->search({gene=>$hgnc,tax_id=>9606,is_sp=>1})];
	$c->stash->{ensx}=[$c->model('NECTAR::Ensx')->search({hgnc=>$hgnc,is_canonical=>1})];

	#############################################################################
	if($c->user_exists){
		# 1-a. get MetaGene & MetaGeneDisease (tab: Mutations) 
		$c->stash->{meta_genes}=[$c->model("CARDIODB::MetaGene")->search($c->stash->{cons})];
		$c->stash->{meta_x_diseases}=[$c->model("CARDIODB::MetaGeneDisease")->search(
			$c->stash->{cons},{prefetch=>qw/Diseases/}
		)];
		# 1-b. get the stat per each diag_code (tab: Mutations & Coda-Slider)
		$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedGeneDisease")->search($c->stash->{cons})];
	}

	#############################################################################
	# 2. get disease info $c->stash->{disease_annos} (tab: $hgnc)
	$c->forward(qw/Controller::Browser::Disease _get_disease_annotation/, [$hgnc]);

	#############################################################################
	# 3-1. get HGMD-PUBLIC mutation for a given gene  (tab: HGMD-PUBLIC)
	if($c->user_exists){
		$c->stash->{hgmds}=[$c->model("CARDIODB::CleanedHgmd")->search(
			$c->stash->{cons},
			{
				join=>[qw/Tags IsNovel/],
				'+select'=>[qw/Tags.tag_name IsNovel.uid/],
				'+as'=>[qw/tag_name uid/],
				distinct=>1,
				order_by=>'acc_num'
			}
		)];

		# 3-2. get SwissVairants for a given gene  (tab: HUMSAVAR)
		$c->stash->{humsavars}=[$c->model('UNIPROT::SwissVariant2IsNovel')->search(undef,{bind=>[$hgnc]})];

		# 3-3. get COSMIC (tab: COSMIC)
		$c->stash->{cosmics}=[$c->model('COSMIC::CosmicMutant')->search({'gene'=>$hgnc})];

		# 3-4. get ICC mutations(tab: ICC)
			$c->stash->{iccs}=[$c->model("CARDIODB::Iccref")->search(
				$c->stash->{cons},
				{
					join=>[qw/IsNovel/],
					'+select'=>[qw/IsNovel.uid/],
					'+as'=>[qw/uid/],
					distinct=>1,
				}
			)];
	}

	# public data only
	$c->stash->{cons}->{'me.is_pub'}=1;
	# annotaions (HPMDs) on canonical transcript only  (ENSXs.is_canonical=1)
	$c->stash->{cons}->{'p2ENSX.is_canonical'}=1;

	#############################################################################
	# 4-1. get stats of functional annotations (HPMD)
	$c->stash->{hpmd_stats}=[$c->model("NECTAR::Hpmd")->search(
		$c->stash->{cons},
		{
			select=>[qw/featureDef.category featureDef.feature featureDef.des/, 'count(distinct me.res_num)'],
			as=>[qw/category feature des cnt/],
			join=>['p2ENSX', 'HPMDRefs', 'featureDef'],
			group_by=>[qw/featureDef.category featureDef.feature/],
			order_by=>['featureDef.category', {-desc=>'count(distinct me.res_num)'}],
		}
	)];

	# 4-2. get actual functional annotations (HPMD)
	$c->stash->{hpmds}=[$c->model("NECTAR::Hpmd")->search(
		$c->stash->{cons},
		{
			join=>['p2ENSX', 'HPMDRefs', 'featureDef'],
			'+select'=>[qw/featureDef.feature HPMDRefs.des HPMDRefs.omim HPMDRefs.pmid/],
			'+as'=>[qw/feature des omim pmid/],
			order_by=>['featureDef.feature', 'me.res_num'],
		}
	)];

	#############################################################################
	# 5-1 get stat of paralogue annotation
	$c->stash->{cons}={}; #initialize
	$c->stash->{cons}->{'h2ENSX.hgnc'}=$hgnc;
	$c->stash->{cons}->{'h2ENSX.is_canonical'}=1;
	$c->stash->{cons}->{'q2ENSX.is_canonical'}=1;
	# public data only
	$c->stash->{cons}->{'HPMDs.is_pub'}=1;

	$c->stash->{para_stats}=[$c->model("NECTAR::Hpmdalign")->search(
		$c->stash->{cons},
		{
			select=>[qw/Alignments.hit HPMDs.hgnc HPMDs.ensp avg(HSPs.evalue) avg(HSPs.pid)/, 'count(distinct Alignments.h_index)'],
			as=>[qw/ensp para_hgnc para_ensp evalue pid cnt/],
			join=>['HSPs', {'Alignments'=>[qw/q2ENSX h2ENSX/]}, {'HPMDs'=>'featureDef'}],
			#group_by=>[qw/Alignments.hit HPMDs.hgnc HPMDs.ensp featureDef.category featureDef.feature/],
			group_by=>[qw/Alignments.hit HPMDs.hgnc HPMDs.ensp/],
			order_by=>{-desc=>'count(me.id)'},
		}

	)];

	# 5-2 get paralogue annotation
	$c->stash->{para_annos}=[$c->model("NECTAR::Hpmdalign")->search(
		$c->stash->{cons},
		{
			select=>[qw/Alignments.hit Alignments.h_index Alignments.h_res featureDef.feature HPMDs.xref HPMDs.hgnc HPMDs.ensp HPMDs.res_num HPMDs.p_ref HPMDs.p_mut/],
			as=>[qw/ensp res_num res para_feature para_xref para_hgnc para_ensp para_res_num para_p_ref para_p_mut/],
			join=>[{'Alignments'=>[qw/q2ENSX h2ENSX/]}, {'HPMDs'=>'featureDef'}],
			#join=>['HSPs', {'Alignments'=>[qw/q2ENSX h2ENSX/]}, {'HPMDs'=>'featureDef'}],
		}

	)];

	if($c->req->params->{download}){
		$c->stash->{template} = 'known_mutation_of_gene.xml'; ##'root/excel/xx.xml'
		if($c->req->params->{source}){
			$c->stash->{source}=$c->req->params->{source};
			$c->stash->{template} = $c->stash->{source}.'_by_gene.xml'; 
		}
		$c->detach('View::Excel');
	}else{
    	$c->stash->{template}='Browser/by_gene_name.tt2';
	}

}

# Boxy.load('/get_alignments?query=ENSP00000396320&hit=ENSP00000303540&boxy=1')
sub _get_para_alignments :Path('/get_alignments') :Args(0) {
    my ( $self, $c ) = @_;

	my $cond; # a hash ref for the where condition
	# mandatory
	$c->stash->{query}=$c->req->params->{query};
	$cond->{'me.query'}=$c->stash->{query} if $c->stash->{query};
	$c->stash->{hit}=$c->req->params->{hit};
	$cond->{'me.hit'}=$c->stash->{hit} if $c->stash->{hit};

	$c->stash->{alignments}=[$c->model("NECTAR::Hsp")->search(
		$cond,
		{
			join=>'Alignments',
			'+select'=>["GROUP_CONCAT(Alignments.q_res ORDER BY Alignments.id SEPARATOR '')", "GROUP_CONCAT(Alignments.h_res ORDER BY Alignments.id SEPARATOR '')"],
			'+as'=>[qw/q_seq h_seq/],
			group_by=>'me.id',
		}
	)];

	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};
	$c->stash(template=>'Browser/get_alignments.tt2');
}

# Boxy.load('/get_colocated_mutations?hgnc=MYL2&feature=HGMD-PUBLIC&xref=CM014978') : cleaned_hgmds.tt2
# Boxy.load('/get_colocated_mutations?hgnc=MYL2&feature=HUMSAVAR&xref=VAR_004601&mut_aa=T') : humsavar.tt2
# Boxy.load('/get_colocated_mutations?hgnc=MYL2&feature=CA_BIND&xref=919105&ensp=ENSP00000228841&res_num=37') : hpmd_easy_slider.tt2
# Boxy.load('/get_colocated_mutations?hgnc=SCN3A&feature=HGMD-PUBLIC&ensp=ENSP00000283254&res_num=354&xref=CM080524') : para_anno.tt2
# Boxy.load('/get_colocated_mutations?hgnc=MYL2&ensp=ENSP00000228841&res_num=15') : /para_anno.tt2
# cleaned_hgmds.tt2, humsavar.tt2, and /hpmd_easy_slider.tt2
# which are called within by_gene_name.tt2
# similar with Controller::Browser::Mutation::get_annotation
sub _get_colocated_mutation :Path('/get_colocated_mutations') :Args(0) {
    my ( $self, $c ) = @_;

	#####################
	# mandatory options #
	#####################
	my $cond; # a hash ref for the where condition
	$cond->{'v2ENSX.is_canonical'}=1; # V2Ensembl canonical transcript only

	$c->stash->{hgnc}=$c->req->params->{hgnc}; # a proper gene name
	unless ($c->stash->{hgnc}){
		$c->detach('/util/messenger/err_msg', ["hgnc not defined", 'no_such_parameter']);
	}else{
		$cond->{'me.hgnc'}=$c->stash->{hgnc};
	}

	# From UniProt functional annotations (not from HGMD-PUBLIC and HUMSAVAR and COSMIC): hpmd_easy_slider.tt2
	# and paralogues annotations: para_anno.tt2
	$c->stash->{ensp}=$c->req->params->{ensp}; # a proper ensembl protein ID (ENSP)
	unless ($c->stash->{ensp}){
		$c->detach('/util/messenger/err_msg', ["ensp not defined", 'no_such_parameter']);
	}else{
		$cond->{'inSilicoSNVs.ensp'}=$c->stash->{ensp}; 
	}

	$c->stash->{res_num}=$c->req->params->{res_num}; # and the amino acid position
	unless ($c->stash->{res_num}){
		$c->detach('/util/messenger/err_msg', ["res_num not defined", 'no_such_parameter']);
	}else{
		$cond->{'inSilicoSNVs.res_num'}=$c->stash->{res_num};
	}

	if($c->req->params->{xref}){
		$c->stash->{xref}=$c->req->params->{xref};
		$cond->{'HPMDs.xref'}=$c->stash->{xref};
		# optional (either disease_mutation tab or functional_annotaion tab)
		$c->stash->{feature}=$c->req->params->{feature};
		$cond->{'featureDef.feature'}=$c->stash->{feature} if $c->stash->{feature};

		$c->stash->{i2ENSX}={'HPMDs'=>[qw/featureDef p2ENSX/]},
		$cond->{'p2ENSX.is_canonical'}=1; # HPMDs canonical transcript

		# to highlight HGMD-PUBIC locus
		if(defined $c->stash->{feature} and $c->stash->{feature} eq 'HGMD-PUBLIC'){
			$c->stash->{hgmd_start}=$c->model("CARDIODB::CleanedHgmd")->find({acc_num=>$c->stash->{xref}})->g_start;
		}
	}else{
		# from para_anno.tt2 
		# no ensp/res_num can be found from HPMDs as this is from paralogue annotations
		$c->stash->{i2ENSX}='i2ENSX';
		$cond->{'i2ENSX.is_canonical'}=1; # inSilicoSNVs canonical transcript
	}

	# optional params->{mut_aa} is either from humsavar.tt2 or para_anno.tt2
	if($c->req->params->{mut_aa}){
		$c->stash->{mut_aa}=$c->req->params->{mut_aa};
	}else{
		# note that no xref for the Paralogue Annotation tab
		# note that HGMD-PUBLIC details, including mut_aa, has been masked for public access 
		$c->stash->{mut_aa}=$c->model('NECTAR::Hpmd')->find(
			{'xref'=>$c->stash->{xref}},{select=>'p_mut',distinct=>1}
		)->p_mut if $c->stash->{xref} and $c->stash->{feature} ne 'HGMD-PUBLIC';
	}

	## get co-located mutations now
	$c->stash->{colocates}=[$c->model('NECTAR::V2Ensembl')->search(
		$cond,
		{
			#join=>['v2ENSX', {'_UnifiedCalls'=>{'inSilicoSNVs'=>{'HPMDs'=>[qw/featureDef p2ENSX/]}}}],
			join=>['v2ENSX', {'_UnifiedCalls'=>{'inSilicoSNVs'=>$c->stash->{i2ENSX}}}],
			'+select'=>[qw/_UnifiedCalls.chr _UnifiedCalls.v_start _UnifiedCalls.v_end _UnifiedCalls.reference _UnifiedCalls.genotype/],
			'+as'=>[qw/chr v_start v_end reference genotype/],
			#distinct=>1,
		}
	)];

	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};
	$c->stash(template=>'Browser/get_colocated_mutations.tt2');
}

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
