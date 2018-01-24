package Nectar::Web::Controller::Browser::Mutation;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Mutation - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

# always check first whether login or not
sub auto: Private {
    my ( $self, $c ) = @_;

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

#/mutation/
sub index :Path('/mutation') :Args(0) {
    my ( $self, $c ) = @_;

	# /mutation?sample_id=1&caller=[diBayes|GATKs|SmallIndels|Samtools]&id=3854
	# as a Boxy popup window from the page 'search_mutation :Path('/mutation/search')
	if($c->req->params->{'sample_id'} and $c->req->params->{'caller'} and $c->req->params->{'id'}){
		# [todo] check caller
		# redirect to /run/sample_id/1/diBayes/download/boxy?id=1
		$c->res->redirect($c->uri_for("/run/sample_id/".$c->req->params->{'sample_id'}."/".$c->req->params->{'caller'}."/download/boxy", {'id'=>$c->req->params->{id}}));
	}else{
		$c->res->redirect($c->uri_for('/'));
	}
}

# /mutation/1234
# /mutation/3854?is_canon=1&is_protein_coding=1
sub base_mutation_id :PathPart('mutation') :Chained('/') :CaptureArgs(1){
    my ( $self, $c, $id ) = @_;

	$c->stash->{uid}=$id;
	$c->stash->{cons}->{'me.uid'}=$c->stash->{uid}; # 'me' points to 'CARDIODB::MetaCall'
	$c->forward('/util/sanitiser/mutation_id');

	###########################
	# 0. Get meta mutation Info 
	$c->stash->{meta_mut}=$c->model("CARDIODB::UnifiedCall")->find({'me.id'=>$c->stash->{uid}},{'+select'=>{sum=>'is_novel'},'+as'=>'sum_is_novel',join=>'ClassifiedCalls'});
	$c->stash->{any_c1}=$c->model("CARDIODB::ClassifiedCall")->search({uid=>$c->stash->{uid}})->get_column('is_c1')->sum;

	###########################
	# 1. prepare SQL in DBIx way. 
	###########################
	# set up $c->stash->{cons} 
	$c->forward('_prepare_conditions'); #to share with /mutation/1234 and /mutation/search?caller=xx
	$c->stash->{any_novel}=$c->stash->{meta_mut}->get_column('sum_is_novel')>=1? 1:0; #(stash->{any_novel} is set within _prepare_conditions based on 'mut_types')
	$c->forward('_prepare_sql'); #to share with /mutation/search

	###########################
	# 2. get distinct variant call (from MetaCalls)
	# initialise $c->stash->{calls}
	$c->forward('_get_calls'); 
	###########################
}


# /mutation/3854?is_canon=1&is_protein_coding=1
# from 'search_mutation :Path('/mutation/search')
sub by_mutation_id :PathPart('') :Chained('base_mutation_id') :Args(0)  {
    my ( $self, $c ) = @_;

	unless($c->req->params->{download}){
		$c->stash->{template}='by_mutation_id.tt2';
	# downloading results in excel format
	}else{
		# we don't need to go thru sql queires below.
		$c->stash->{template} = 'mutation_search.xml'; #'root/excel/mutation_search.xml'
		$c->detach('View::Excel');
	}
	###########################
	# 1. Get mutation profile statistic 
	# initialise $c->stash->{cmuts}
	$c->forward('_get_cmuts');
	#unless($c->req->param){
		$c->forward('_get_msa');
		$c->stash->{anno_cons}->{'me.uid'}=$c->stash->{uid}; 
		$c->forward('_get_ensembl'); # Model::V2Ensembl

		$c->stash->{anno_cons}->{'V2Ensembls.is_canonical'}=1 if $c->stash->{is_canon}; # defined within _prepar_sql
		$c->stash->{anno_cons}->{'V2Ensembls.ensg_type'}='protein_coding' if $c->stash->{is_protein_coding}; # defined within _prepar_sql

		$c->forward('_get_uniprot'); # Model::2Uniprot
		$c->forward('_get_pdb'); # Model::2Pdb
		$Template::Directive::WHILE_MAX=10000; # set to a big number to cope with TT error (default 300)
	#}
}

sub _get_msa :Private{
    my ( $self, $c) = @_;

	###########################
	# 2. Get distinct Family 
	$c->stash->{families}=[$c->model("CARDIODB::UnifiedCall")->search(
		{'me.id'=>$c->stash->{uid},'EnFamilies.id'=>{ '!=' => undef }},
		{
			join=>{
				'V2Ensembls'=>{
					'V2Families'=>[qw/EnFamilies/]
				},
			},
			distinct=>1,
			'+select'=>[qw/EnFamilies.fam_name EnFamilies.des EnFamilies.mem_cnt/],
			'+as'=>[qw/fam_name des mem_cnt/],
		},
	)];

	###########################
	# 3. Get distinct  members having mutations
	my $mem_rs=$c->model("CARDIODB::UnifiedCall")->search(
		{'me.id'=>$c->stash->{uid},'EnFamilies.id'=>{ '!=' => undef }},
		{
			join=>{
				'V2Ensembls'=>{
					'V2Families'=>[qw/EnFamilies EnMembers/]
				},
			},
			distinct=>1,
			'+select'=>[qw/EnFamilies.fam_name EnMembers.mem_name/],
			'+as'=>[qw/fam_name mem_name/],
		},
	);
	my $dummy_fam_name=''; # to set counter=0 for each family
	my $cnt_mem;
	while(my $rs=$mem_rs->next){
		my $fam_name=$rs->get_column('fam_name');
		$cnt_mem=0 unless $dummy_fam_name eq $fam_name;	
		$c->stash->{mut_mem}->{$fam_name}->[$cnt_mem]->{mem_name}=$rs->get_column('mem_name');
		$dummy_fam_name=$fam_name;$cnt_mem++;	
	}

	###########################
	# 4. Get distinct aln_pos and entropy per family and member 
	my $pos_rs=$c->model("CARDIODB::UnifiedCall")->search(
		{'me.id'=>$c->stash->{uid},'EnFamilies.id'=>{ '!=' => undef }},
		{
			join=>{
				'V2Ensembls'=>{
					'V2Families'=>[qw/EnFamilies EnMembers EnEntropies/]
				},
			},
			distinct=>1,
			'+select'=>[qw/EnFamilies.fam_name EnMembers.mem_name V2Families.aln_pos EnEntropies.gap_freq EnEntropies.entropy EnEntropies.rel_entropy/],
			'+as'=>[qw/fam_name mem_name aln_pos gap_freq entropy rel_entropy/],
		},
	);
	$dummy_fam_name=''; # to set counter=0 for each family
	my $cnt_pos;
	while(my $rs=$pos_rs->next){
		my $fam_name=$rs->get_column('fam_name');

		$cnt_pos=0 unless $dummy_fam_name eq $fam_name;	
		$c->stash->{mut_pos}->{$fam_name}->[$cnt_pos]->{mem_name}=$rs->get_column('mem_name');
		$c->stash->{mut_pos}->{$fam_name}->[$cnt_pos]->{aln_pos}=$rs->get_column('aln_pos');
		$c->stash->{mut_pos}->{$fam_name}->[$cnt_pos]->{gap_freq}=$rs->get_column('gap_freq');
		$c->stash->{mut_pos}->{$fam_name}->[$cnt_pos]->{entropy}=$rs->get_column('entropy');
		$c->stash->{mut_pos}->{$fam_name}->[$cnt_pos]->{rel_entropy}=$rs->get_column('rel_entropy');
		$dummy_fam_name=$fam_name;$cnt_pos++;	
	}

	###########################
	# 5. Get Alignment (per family) 
	my $host=$c->config->{host};my $db=$c->config->{database};my $user=$c->config->{user};my $passwd=$c->config->{passwd};
	# for each family
	my $cnt_fam=0;
	my $size=scalar @{$c->stash->{families}};
	for (0 .. $size-1){
		my $fam_name=$c->stash->{families}->[$cnt_fam]->get_column('fam_name');
		my $cnt_mem=0;
		# for each member (alignment) 
		foreach (split(/\n/,`mysql -h $host -u $user -p$passwd --skip-column-names $db -e "call get_alignment_by_fam('$fam_name')"`)){
			my @dummy=split(/\t/,$_);
			$c->stash->{msa}->{$fam_name}->[$cnt_mem]->{mem_name}=$dummy[0];
			$c->stash->{msa}->{$fam_name}->[$cnt_mem]->{sn}=$dummy[1];
			$c->stash->{msa}->{$fam_name}->[$cnt_mem]->{cn}=$dummy[2];
			$c->stash->{msa}->{$fam_name}->[$cnt_mem]->{aln}=$dummy[3];
			$c->stash->{msa}->{$fam_name}->[$cnt_mem]->{len}=$dummy[4];
			$cnt_mem++;
		}
		$cnt_fam++;
	}
}# end of sub _get_msa

sub _get_ensembl :Private{
    my ( $self, $c) = @_;

	$c->stash->{anno_cons}->{'me.is_canonical'}=1 if $c->stash->{is_canon}; # defined within _prepar_sql
	$c->stash->{anno_cons}->{'me.ensg_type'}='protein_coding' if $c->stash->{is_protein_coding}; # defined within _prepar_sql

	# get Ensembl mapping (from V2Ensembls)
	$c->stash->{ensx}=[$c->model("CARDIODB::V2Ensembl")->search(
		$c->stash->{anno_cons},
		{
			prefetch=>'ClassifiedCalls',
			order_by=>[qw/ClassifiedCalls.which_level/, {-desc=>"ClassifiedCalls.is_c1+ClassifiedCalls.is_c2+ClassifiedCalls.is_c3"}, {-desc=>qw/ClassifiedCalls.is_novel/}, qw/hgnc so_terms/],
		}
	)];

	delete $c->stash->{anno_cons}->{'me.is_canonical'} if $c->stash->{is_canon}; # defined within _prepar_sql
	delete $c->stash->{anno_cons}->{'me.ensg_type'} if $c->stash->{is_protein_coding}; # defined within _prepar_sql
}

sub _get_uniprot :Private {
    my ( $self, $c) = @_;
	###########################
	# 5. join with 2UniProts
	$c->stash->{uniprots}=[$c->model("CARDIODB::2UniProt")->search(
		$c->stash->{anno_cons},
		{
			select=>[qw/ClassifiedCalls.class p_ref p_mut uniprot res_num uniprot_res annotation des blosum62 pam70/, "sum(V2Ensembls.is_canonical)", "group_concat(distinct V2Ensembls.enst)"],
			as=>[qw/class p_ref p_mut uniprot res_num uniprot_res annotation des blosum62 pam70 is_canonical ensts/],
			join=>{V2Ensembls=>'ClassifiedCalls'},
			group_by=>[qw/ClassifiedCalls.class p_ref p_mut uniprot res_num annotation des blosum62 pam70/],
			order_by=>[qw/ClassifiedCalls.which_level/, {-desc=>"ClassifiedCalls.is_c1+ClassifiedCalls.is_c2+ClassifiedCalls.is_c3"}, {-desc=>qw/ClassifiedCalls.is_novel/}],
		},
	)];
}

sub _get_pdb :Private {
    my ( $self, $c) = @_;
	###########################
	# Join with 2PDB 2PDBs
	$c->stash->{pdbs}=[$c->model("CARDIODB::2Pdb")->search(
		$c->stash->{anno_cons},
		{
			select=>[qw/ClassifiedCalls.class pdb chain res_num pdb_res env annotation des esst/, "sum(V2Ensembls.is_canonical)", "group_concat(distinct V2Ensembls.enst)"],
			as=>[qw/class pdb chain res_num pdb_res env annotation des esst is_canonical ensts/],
			join=>{V2Ensembls=>'ClassifiedCalls'},
			group_by=>[qw/ClassifiedCalls.class pdb chain res_num pdb_res env annotation des esst/],
			order_by=>[qw/ClassifiedCalls.which_level/, {-desc=>"ClassifiedCalls.is_c1+ClassifiedCalls.is_c2+ClassifiedCalls.is_c3"}, {-desc=>qw/ClassifiedCalls.is_novel/}],
		},
	)];
}

# /mutation/exref?q=hgmd|icc&id=1&uid=1
# Ajax call within /mutation/search?xxx or exref tab within /mutation/3854
# to display either HGMD or ICC_Mutation as a boxy pop-up window
# html part can be written by a template after tweaking with root/lib/site/wrapper 
# for details: http://wiki.catalystframework.org/wiki/gettingstarted/howtos/disabling_a_tt_wrapper_for_ajax_requests
sub get_exref :Path('/mutation/exref') :Args(0)  {
    my ( $self, $c ) = @_;

	if($c->req->params->{q} eq 'hgmd'){
		$c->stash->{exref}=$c->model("CARDIODB::Cleanedhgmd")->find(
			{acc_num=>$c->req->params->{id}},
			{join=>'Tags','+select'=>[qw/Tags.tag_name Tags.des/],'+as'=>[qw/tag_name des/]},
		);
	}elsif($c->req->params->{q} eq 'icc'){
		$c->stash->{exref}=$c->model("CARDIODB::Iccref")->find({mut_id=>$c->req->params->{id}});
	}elsif($c->req->params->{q} eq 'dbsnp'){
		#$c->stash->{exref}=$c->model("CARDIODB::V2dbSnp")->find({rs_id=>$c->req->params->{id}, uid=>$c->req->params->{uid}});
		$c->stash->{exref}=[$c->model("CARDIODB::V2dbSnp")->search(
			{'me.rs_id'=>$c->req->params->{id}, 'me.uid'=>$c->req->params->{uid}},
			{prefetch=>'V2Phens'}
		)];
	}elsif($c->req->params->{q} eq 'swissvariant'){
		$c->stash->{humsavars}=[$c->model('UNIPROT::SwissVariant')->search({variant_id=>$c->req->params->{id}})];
	}else{
		$c->detach('/util/messenger/err_msg', ["Query should be either 'hgmd', 'icc' or 'dbsnp'", 'no_such_parameter']);
	}
	$c->stash(no_wrapper=>1, template=>'get_exref.tt2');

}

# onClick="Boxy.load('/mutation/annotation?q=xx&id=yy')"
# from root/src/Browser/classified_calls.tt2:
# from root/src/Mutation/list_of_mutation.tt2
sub get_annotation :Path('/mutation/annotation') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{uid}=$c->req->params->{id};
	$c->stash->{vid}=$c->req->params->{vid};
	$c->stash->{class}=$c->req->params->{class};
	$c->stash->{anno_cons}->{'me.uid'}=$c->stash->{uid};
	$c->stash->{anno_cons}->{'ClassifiedCalls.class'}=$c->stash->{class};
	if($c->req->params->{q} eq '2UniProt'){
		$c->forward(qw/Controller::Browser::Mutation _get_uniprot/);
	}elsif($c->req->params->{q} eq '2Pdb'){
		$c->forward(qw/Controller::Browser::Mutation _get_pdb/);
	}elsif($c->req->params->{q} eq 'V2Ensembl'){
		$c->stash->{anno_cons}->{'me.id'}=$c->stash->{vid};
		$c->stash->{any_c1}=$c->model("CARDIODB::ClassifiedCall")->search({uid=>$c->stash->{uid}})->get_column('is_c1')->sum;
		$c->forward(qw/Controller::Browser::Mutation _get_ensembl/);
	}else{
		$c->detach('/util/messenger/err_msg', ["Query should be either '2UniProt', '2Pdb' or 'V2Ensembl'", 'no_such_parameter']);
	}
	$c->stash(no_wrapper=>1,template=>'get_annotation.tt2');
}	

# /mutation/search?
# coming from 
# 1. /gene/TTN (/mutation/search?diag_code=ARR&hgnc=TTN&mut_typeARR=a01&mut_typeARR=a00)
# 2. /disease/HCM (/mutation/search?diag_code=HCM&mut_type=a11)
# 3. /target/ICCv2 (/mutation/search?target_name=xx&mut_type=a11)
# 4. /run/s0464_20101102_PE_BC/10DP00401DN (/mutation/search?sample_id=10&mut_type=a01
# 5. /patient/10AM00335 (/mutation/search?bru_code=10AA00306&caller=patient&mut_type=a00)
# 6. /patient/10AM00335/gene/TTN (/mutatin/search?bru_code=10AA00306&hgnc=TTN&caller=patient&mut_type=b10)
sub search_mutation :Path('/mutation/search') :Args(0){
    my ( $self, $c ) = @_;
	
	$c->detach('/util/messenger/err_msg', ["no caller defined", 'no_such_parameter']) unless $c->req->params->{caller};
	###########################
	# 0 prepare SQL in DBIx way. 
	# set up: $c->stash->{caller}, $c->stash->{any_novel} and  $c->stash->{cons},
	$c->forward('_prepare_conditions'); #to share with 'sub by_mutation_id' 
	###########################

	###########################
	# 1. prepare SQL in DBIx way. 
	# set up: $c->stash->{ref_metacall}, $c->stash->{ref_select}, and $c->stash->{ref_as}
	$c->forward('_prepare_sql'); #to share with 'sub by_mutaiton_id'
	###########################

	unless($c->req->params->{download}){
		###########################
		# 4. SQL-3 get the stat of classified calls (e.g. stash->cmuts) depending on the caller (gene|disease|target|patient|sample|locus)
		# initialise $c->session->{cmuts}
		$c->forward('_get_cmuts') unless $c->req->params->{page};
		###########################

		###########################
		# 2. SQL-1. get the TOTAL number of entries for pagination 
		###########################
		$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};
		unless($c->stash->{total}){
			$c->stash->{total}=$c->model("CARDIODB::MetaCall")->search(
				$c->stash->{cons},
				{
					join=>$c->stash->{ref_metacall},
					distinct=>1,
					'+select'=>$c->stash->{ref_select},
					'+as'=>$c->stash->{ref_as},
				},
			)->count();
		}

		# alwasy set $c->stash-{total} before forwarding
		# set paging values (page, limit, pager)
		$c->forward('/pager/set_page', [20]);
	}

	###########################
	# 3. SQL-2 get distinct variant call (from MetaCalls)
	# initialise $c->stash->{calls}
	$c->forward('_get_calls'); #to share with /mutation/1234
	###########################

	unless($c->req->params->{download}){
		$c->stash->{template}='search_mutation.tt2';
	# downloading results in excel format
	}else{
		$c->stash->{template} = 'mutation_search.xml'; #'root/excel/mutation_search.xml'
		$c->detach('View::Excel');
	}
}#end of sub search_mutation

sub _prepare_conditions :Private{
    my ( $self, $c) = @_;

	###########################
	# mandatory parameter 
	###########################
	# 0. caller of this URI (e.g. /gene/TTN) this is set as a param within 'classified_calls.tt2'
	$c->stash->{caller}=$c->req->params->{caller};
	###########################
	# 1. mut_type from the checkbox input (NB. mut_typeARR for /gene/TTN)
	if($c->stash->{caller} eq 'gene'){
		$c->stash->{mut_type}= $c->req->params->{'mut_type'.$c->req->params->{diag_code}};
	}elsif($c->stash->{caller} eq 'target'){
		$c->stash->{mut_type}= $c->req->params->{'mut_type'.$c->req->params->{diag_code}};
	}elsif($c->stash->{caller} eq 'disease'){
		$c->stash->{mut_type}= $c->req->params->{'mut_type'.$c->req->params->{target_name}};
	}elsif($c->stash->{caller} eq 'form'){
		# correct mut_type
		@{$c->stash->{my_novels}}=defined $c->req->params->{is_novel}? 
			ref($c->req->params->{is_novel}) eq 'ARRAY'? @{$c->req->params->{is_novel}} : ($c->req->params->{is_novel}) 
			: (1,0);
	   	if(defined $c->req->params->{mut_type}){ # a0|b3|b2|b1|b0|c0|d0
			my @mut_types=ref($c->req->params->{mut_type}) eq 'ARRAY'? @{$c->req->params->{mut_type}} : ($c->req->params->{mut_type}); 
			if(scalar @mut_types == 7 and scalar @{$c->stash->{my_novels}} ==2){

			}else{
				foreach my $my_novel (@{$c->stash->{my_novels}}){
					foreach my $mut (@mut_types){
						push @{$c->stash->{mut_type}}, $mut.$my_novel;
					}
				}
			}
		}else{
			if(defined $c->req->params->{is_novel}){
				foreach my $my_novel (@{$c->stash->{my_novels}}){
					push @{$c->stash->{mut_type}}, ('a0'.$my_novel, 'b3'.$my_novel,  'b2'.$my_novel, 'b1'.$my_novel, 'b0'.$my_novel, 'c0'.$my_novel, 'd0'.$my_novel);
				}
			}
		}

		## either '&query=TTN' or 'chr=chr1' 
		if($c->req->params->{chr}){
		# chr:start-end (either locus or gene)
			$c->stash->{chr}=$c->req->params->{chr};
			$c->stash->{v_start}=$c->req->params->{v_start};
			$c->stash->{v_end}=$c->req->params->{v_end};
			$c->detach('/util/messenger/err_msg', ["v_start not defined", 'no_such_parameter']) unless $c->stash->{v_start};
			$c->detach('/util/messenger/err_msg', ["v_end not defined", 'no_such_parameter']) unless $c->stash->{v_end};
			$c->stash->{cons}->{"_UnifiedCalls.chr"}=$c->stash->{chr};
			$c->stash->{cons}->{"_UnifiedCalls.v_start"}={-between=>[$c->stash->{v_start}, $c->stash->{v_end}]};
		}else{
			# correct hgnc
			$c->req->params->{hgnc}=$c->req->params->{query} if $c->req->params->{query}; #inital run from boxy/main_search_form?search_mode=Gene
		}
	# from sample or patient 
	}else{
	   	$c->stash->{mut_type}= $c->req->params->{mut_type};
	}
	$c->stash->{cons}->{"ClassifiedCalls.class"}=$c->stash->{mut_type} if defined $c->stash->{mut_type}; #either string of ARRAY (for more than 2 mut_type)

	# mut_type_string is for the table 'refresh_mutations' within search_mutation.tt2
	my $dummy_mut_type=$c->stash->{caller} eq 'form'? $c->req->params->{mut_type} : $c->stash->{mut_type};
	$c->stash->{mut_type_string}=ref($dummy_mut_type) eq 'ARRAY'? join ('/', @{$dummy_mut_type}) : $dummy_mut_type;

	# flag for novel (1: novel only, 0: including any known mutation) to display 'ExRef' tab
	my $any_novel=1; 
	if (ref($c->stash->{mut_type}) eq 'ARRAY'){
		foreach (@{$c->stash->{mut_type}}){ ##e.g. a00 a01 
			$any_novel=$any_novel*substr($_,2,1);
		}
	}else{
		$any_novel= defined $c->stash->{mut_type}? $any_novel*substr($c->stash->{mut_type},2,1) : 0;
	}
	$c->stash->{any_novel}=$any_novel;

	###########################
	# 2. MergedSamples.merged_to is NULL (get mutation from non-merged samples only)
	$c->stash->{cons}->{'MergedSamples.merged_to'}=undef;

	###########################
	# Known Mutations
	# HGMD|dbSNP|ICC|HUMSAVAR 
	###########################
	$c->stash->{hgmd_tag}=$c->req->params->{hgmd_tag}; 
	if($c->stash->{hgmd_tag}){
		unless ($c->req->params->{hgmd_tag} eq 'zom'){
			if($c->req->params->{hgmd_tag} eq 'any'){
				$c->stash->{cons}->{'IsNovel.tag'}={'!='=>undef};
			}else{
				$c->stash->{cons}->{'IsNovel.tag'}=$c->stash->{hgmd_tag}; 
			}
		}
	}
	$c->stash->{var_type}=$c->req->params->{var_type}; 
	if($c->stash->{var_type}){
		unless ($c->req->params->{var_type} eq 'zom'){
			if($c->req->params->{var_type} eq 'any'){
				$c->stash->{cons}->{'IsNovel.var_type'}={'!='=>undef};
			}else{
				$c->stash->{cons}->{'IsNovel.var_type'}=$c->stash->{var_type}; 
			}
		}
	}
	$c->stash->{is_dbsnp}=$c->req->params->{is_dbsnp};
	$c->stash->{cons}->{'IsNovel.rs_id'}={'!='=>undef} if $c->req->params->{is_dbsnp};
	$c->stash->{is_icc}=$c->req->params->{is_icc};
	$c->stash->{cons}->{'IsNovel.mut_id'}={'!='=>undef} if $c->req->params->{is_icc};
	$c->stash->{is_humsavar}=$c->req->params->{is_humsavar};
	$c->stash->{cons}->{'IsNovel.humsavar'}={'!='=>undef} if $c->req->params->{is_humsavar};

	###########################
	# Annotation (Ensembl|PDB|UniProt) 
	###########################
	$c->stash->{is_canon}=$c->req->params->{is_canon}; 
	$c->stash->{cons}->{'V2Ensembls.is_canonical'}=1 if $c->req->params->{is_canon};
	$c->stash->{is_protein_coding}=$c->req->params->{is_protein_coding}; 
	$c->stash->{cons}->{'V2Ensembls.ensg_type'}='protein_coding' if $c->req->params->{is_protein_coding};

	$c->stash->{ft_tag}=$c->req->params->{ft_tag}; 
	#$c->stash->{cons}->{'2UniProts.id'}={'!='=>undef} if $c->req->params->{ft_tag};
	if($c->stash->{ft_tag}){
		unless ($c->req->params->{ft_tag} eq 'zom'){
			if($c->req->params->{ft_tag} eq 'any'){
				$c->stash->{cons}->{'2UniProts.annotation'}={'!='=>undef};
			}else{
				$c->stash->{cons}->{'2UniProts.annotation'}=$c->stash->{ft_tag}; 
			}
		}
	}

	$c->stash->{is_pdb}=$c->req->params->{is_pdb}; 
	$c->stash->{cons}->{'2PDBs.id'}={'!='=>undef} if $c->req->params->{is_pdb};

	###########################
	# Read depth of coverage (DP)
	###########################
	my $DP=$c->req->params->{DP};
	if($DP){
		$c->stash->{cons}->{"me.dp_dibayes"}=[undef,{'>='=>$DP}];
		$c->stash->{cons}->{"me.dp_gatk"}=[undef,{'>='=>$DP}];
		$c->stash->{cons}->{"me.dp_samtool"}=[undef,{'>='=>$DP}];
		$c->stash->{DP}=$DP;
	}
=dp
AND (dp_dibayes IS NULL OR dp_dibayes>=7)
AND (dp_dp_gatk IS NULL OR dp_gatk>=7)
AND (dp_dp_samtool IS NULL OR dp_samtool>=7)
=cut

	###########################
	# mutation caller checkbox
	###########################
	$c->stash->{dibayes}=$c->req->params->{dibayes};
	$c->stash->{cons}->{'me.dibayes'}={'!='=>undef} if $c->req->params->{dibayes};
	$c->stash->{smallindel}=$c->req->params->{smallindel};
	$c->stash->{cons}->{'me.smallindel'}={'!='=>undef} if $c->req->params->{smallindel};
	$c->stash->{gatk}=$c->req->params->{gatk};
	$c->stash->{cons}->{'me.gatk'}={'!='=>undef} if $c->req->params->{gatk};
	$c->stash->{samtool}=$c->req->params->{samtool};
	$c->stash->{cons}->{'me.samtool'}={'!='=>undef} if $c->req->params->{samtool};
	
	###########################
	# optional field depending on the caller (gene|run|disease|patient)
	###########################
	# 0. target_name from /target) (hidden input (from /target/ICCv2)
	$c->stash->{target_name}=$c->req->params->{target_name}; 
	# 'any' from root/src/Form/main_search_form.tt2 called by /boxy/main_search_form
	$c->stash->{cons}->{'Targets.target_name'}=$c->stash->{target_name} if $c->req->params->{target_name} and $c->req->params->{target_name} ne 'any'; 

	# 1. diag_code (from /gene and /diseaes) (hidden input (from /gene/TTN)
	$c->stash->{diag_code}=$c->req->params->{diag_code}; 
	# 'any' from root/src/Form/main_search_form.tt2 called by /boxy/main_search_form
	$c->stash->{cons}->{'Samples.diag_code'}=$c->stash->{diag_code} if $c->req->params->{diag_code} and $c->req->params->{diag_code} ne 'any' ;

	# 2. hgnc (from /gene or /patient/10AA00306/gene/TTN)
	$c->stash->{hgnc}=$c->req->params->{hgnc}; 
	if(defined $c->req->params->{hgnc}){
		$c->stash->{cons}->{'V2Ensembls.hgnc'}= $c->req->params->{hgnc} eq 'undef'? undef : $c->stash->{hgnc};
	}

	# 3. sample_id (from /run) hidden input (from /run/s0464_20101102_PE_BC/10DP00401DN)
	$c->stash->{sample_id}=$c->req->params->{sample_id}; 
	$c->stash->{cons}->{'Samples.id'}=$c->stash->{sample_id} if $c->req->params->{sample_id};

	# 4. patient code (from /patient) hidden input 
	$c->stash->{bru_code}=$c->req->params->{bru_code}; 
	$c->stash->{cons}->{'Samples.bru_code'}=$c->stash->{bru_code} if $c->req->params->{bru_code};
} # end of sub _prepare_condition



sub _prepare_sql :Private{
    my ( $self, $c) = @_;

	my ($ref_metacall,$ref_select,$ref_as,$ref_dummy_array1,$ref_dummy_array2);
	$ref_dummy_array1=[qw/MergedSamples/]; 
	push @{$ref_dummy_array1}, 'Targets' if $c->req->params->{target_name};
	push @{$ref_dummy_array2}, {ClassifiedCalls=>{'V2Ensembls'=>[qw/2UniProts 2PDBs/]}};
	push @{$ref_dummy_array2}, 'IsNovel' unless $c->stash->{any_novel};

	$ref_metacall->[0]={'Samples'=>$ref_dummy_array1};
	$ref_metacall->[1]={'_UnifiedCalls'=>$ref_dummy_array2};

	unless($c->req->params->{download}){
		$ref_select=[qw/ClassifiedCalls.class V2Ensembls.id V2Ensembls.hgnc V2Ensembls.hgvs_coding V2Ensembls.is_canonical 2UniProts.uid 2PDBs.uid/];
		$ref_as=[qw/class vid hgnc hgvs_coding is_canonical uuid puid/];
	}else{
		$ref_select=[qw/ClassifiedCalls.class V2Ensembls.hgnc V2Ensembls.so_terms V2Ensembls.hgvs_coding 2UniProts.uid 2PDBs.uid/];
		$ref_as=[qw/class hgnc so_terms hgvs_coding uuid puid/];
	}

	unless($c->stash->{any_novel}){
		push @{$ref_select}, qw/IsNovel.acc_num IsNovel.rs_id IsNovel.mut_id IsNovel.humsavar IsNovel.tag/;
		push @{$ref_as}, qw/acc_num rs_id mut_id humsavar tag/;
		$c->session->{tags}=[$c->model("CARDIODB::Tag")->search()->all()] unless $c->session->{tags}; # remain across pages 
	}

	$c->session->{ft_tags}=[$c->model("UNIPROT::FeatureDef")->search({is_function=>1},{order_by=>'feature'})->all()] unless $c->session->{ft_tags}; # remain across pages 

	$c->stash->{ref_metacall}=$ref_metacall;
	$c->stash->{ref_select}=$ref_select;
	$c->stash->{ref_as}=$ref_as;
}


# initialise $c->stash->{calls}
sub _get_calls :Private{
    my ( $self, $c) = @_;

	# just to make SQL syntax sane (this was not needed to get the total number, but is's required now to display)
	unshift @{$c->stash->{ref_select}}, "concat(_UnifiedCalls.chr, ':',  _UnifiedCalls.v_start, '-', _UnifiedCalls.v_end, '(', _UnifiedCalls.reference, '/', _UnifiedCalls.genotype, ')')";
	unshift @{$c->stash->{ref_as}}, 'variant';

	my $main_hash_ref={
			join=>$c->stash->{ref_metacall},
			distinct=>1,
			'+select'=>$c->stash->{ref_select},
			'+as'=>$c->stash->{ref_as},
			order_by=>[qw/ClassifiedCalls.which_level/, {-desc=>"ClassifiedCalls.is_c1+ClassifiedCalls.is_c2+ClassifiedCalls.is_c3"}, {-desc=>qw/ClassifiedCalls.is_novel/}, 'ClassifiedCalls.uid'],
		};

	$main_hash_ref->{page}=$c->stash->{page} if $c->stash->{page};
	$main_hash_ref->{rows}=$c->stash->{limit} if $c->stash->{limit}; 

	$c->stash->{calls}=[$c->model("CARDIODB::MetaCall")->search(
		$c->stash->{cons},
		$main_hash_ref,
	)];
}

# initialise $c->session->{cmuts}
sub _get_cmuts :Private{
    my ( $self, $c) = @_;

	my ($ref_stat_select, $ref_stat_as); # a hash ref to join with MetaCalls
	$ref_stat_select= $c->stash->{uid}? 
		[qw/ClassifiedCalls.which_level ClassifiedCalls.is_c1 ClassifiedCalls.is_c2 ClassifiedCalls.is_c3 ClassifiedCalls.category ClassifiedCalls.is_novel ClassifiedCalls.class/]
		:[qw/ClassifiedCalls.which_level ClassifiedCalls.category ClassifiedCalls.is_novel ClassifiedCalls.class/];
	push @{$ref_stat_select}, ('count(distinct me.uid)', 'count(distinct me.id)', 'count(distinct me.sample_id)', 'count(distinct Samples.bru_code)');

	$ref_stat_as= $c->stash->{uid}? 
		[qw/which_level is_c1 is_c2 is_c3 category is_novel class/]
		:[qw/which_level category is_novel class/];
	push @{$ref_stat_as}, qw/cnt_unique_call cnt_call cnt_unique_sample cnt_unique_bru/;

	unless($c->stash->{any_novel}){
		push @{$ref_stat_select}, ("COUNT(DISTINCT IsNovel.acc_num)", "COUNT(DISTINCT IsNovel.rs_id)", "COUNT(DISTINCT IsNovel.mut_id)", "COUNT(DISTINCT IsNovel.humsavar)");
		push @{$ref_stat_as}, qw/cnt_unique_hgmd cnt_unique_dbsnp cnt_unique_icc cnt_unique_humsavar/; 
	}
	
	my $ref_group_by= $c->stash->{uid}?
		[qw/ClassifiedCalls.which_level ClassifiedCalls.is_c1 ClassifiedCalls.is_c2 ClassifiedCalls.is_c3 ClassifiedCalls.category ClassifiedCalls.is_novel ClassifiedCalls.class/]
		:[qw/ClassifiedCalls.class/];
	my $ref_order_by=[qw/ClassifiedCalls.which_level/, {-desc=>"ClassifiedCalls.is_c1+ClassifiedCalls.is_c2+ClassifiedCalls.is_c3"}, {-desc=>qw/ClassifiedCalls.is_novel/}];


	my $main_hash_ref={
		select=>$ref_stat_select,
		as=>$ref_stat_as,
		join=>$c->stash->{ref_metacall},
		group_by=>$ref_group_by,
		order_by=>$ref_order_by,
	};

	#$main_hash_ref->{order_by}=$ref_order_by unless $c->stash->{uid};

	# NB. this is stored as a session to remain same across pages
	if(defined $c->stash->{uid}){
		$c->stash->{cmuts}=[$c->model("CARDIODB::MetaCall")->search($c->stash->{cons},$main_hash_ref)];
	}else{
		$c->session->{cmuts}=[$c->model("CARDIODB::MetaCall")->search($c->stash->{cons},$main_hash_ref)];
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
