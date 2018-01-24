package Nectar::Web::Controller::Parser::VCF;
use Moose;
use namespace::autoclean;
#use parent qw/Catalyst::Controller::ActionRole/; #does not work

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Parser::VCF - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	#$c->forward(qw/Controller::Parser::VCF vcf/);
	$c->forward('vcf');
}

=head2 vcf
=cut
sub vcf :Path('/vcf') :Args(0){ #sub vcf :Path('/vcf') Does('RequireSSL') :Args(0){ #does not work
    my ( $self, $c ) = @_;

	#$c->require_ssl;    #redirects to https://cardiodb.org/netar/vcf
						# use this on production
	$c->allow_ssl; # both http and https selectively

	############################################################
	## PROCESSING USING THE BASESPACE API
	############################################################
	if($c->req->params->{action} eq 'trigger'){
		$c->stash->{appsessionuri}=$c->req->params->{appsessionuri};

		my %params=(
			grant_type=>$c->config->{grant_type},
			client_id=>$c->config->{client_id},
			client_secret=>$c->config->{client_secret},
			code=>$c->req->params->{authorization_code},
			redirect_uri=>$c->uri_for('/vcf'),
		);
		my $acc_token=$c->model('BASESPACE')->get_token(%params);
		my $basespace_vcf;
		$c->stash->{vcf_calls}=$c->model('VCF')->parse_vcf($basespace_vcf);
	}

	# using lib/Nectar/Form/FileUpload.pm
	my $form = Nectar::Form::FileUpload->new(ctx=>$c);
	$c->stash(template => 'Form/vcf_formhandler.tt2', form=> $form);

	# localhost/vcf (from uploaded file)
	if($c->req->method eq 'POST'){ # from the local web form

		############################################################
		### PROCESSING USING THE LOCAL UPLOADED VCF FILE
		############################################################
		#if($c->req->method eq 'POST'){ # from the local web form
		if(my $upload=$c->req->upload('file')){
			my $copied_file=$upload->filename;
			$upload->copy_to('/tmp/'.$copied_file);
			$form->process( params => {file=>$upload} );
			return unless ( $form->validated );
			# [todo] sanitize a vcf format? or within the FormHandler?
			#$c->forward('/util/sanitiser/vcf');

			# Nectar::Parser::VCF via Nectar::Web::Model::VCF using 'Catalyst::Model::Adaptor';
			$c->stash->{vcf_calls}=$c->model('VCF')->parse_vcf($upload->slurp);
		}#end of if $upload

		#########################################
		# should have set up stash->{vcf_calls} beforehand
		$c->forward('_crawl_nectar', ['vcf_diseases']); # set up $c->stash->{vcf_diseases}
		$c->forward('_crawl_nectar', ['vcf_func']); # set up $c->stash->{vcf_func}
		$c->forward('_crawl_nectar', ['vcf_para']); # set up $c->stash->{vcf_para}
		#########################################

	# localhost/vcf?vep_download=1&target_file=dummy_vcf.txt
	# localhost/vcf?nectar_download=1&target_file=dummy_vcf.txt
	# localhost/vcf
	}else{
		if($c->req->params->{target_file}){
			my $file_content;
			my $a_copy='/tmp/'.$c->req->params->{target_file};
			open(IN, "$a_copy") or $c->res->body("cannot open $a_copy");
			while(<IN>){
				$file_content.=$_;
			}
			close IN;
			$c->stash->{vcf_calls}=$c->model('VCF')->parse_vcf($file_content);
		}

		if($c->req->params->{vep_download}){
			#########################################
			#$c->stash->{veps}
			$c->forward('_ensembl_rest');
			#########################################
			$c->stash->{template} = 'vep.xml'; #'root/excel/vep.xml'
			$c->detach('View::Excel');
		}
		if($c->req->params->{nectar_download}){
			#########################################
			# should have set up stash->{vcf_calls} beforehand
			$c->forward('_crawl_nectar', ['vcf_diseases']); # set up $c->stash->{vcf_diseases}
			$c->forward('_crawl_nectar', ['vcf_func']); # set up $c->stash->{vcf_func}
			$c->forward('_crawl_nectar', ['vcf_para']); # set up $c->stash->{vcf_para}
			#########################################
			$c->stash->{template} = 'nectar.xml'; #'root/excel/nectar.xml'
			$c->detach('View::Excel');
		}
	}



}

=head 2
 local ensembl rest api service
 /data/Serve/Web/ensembl-rest
=cut
sub _ensembl_rest :Private {
    my ( $self, $c ) = @_;
	foreach my $call_ref (@{$c->stash->{vcf_calls}}){
		my $vcf_entry;
		push @{$c->stash->{veps}}, $c->model('VEP')->get_rest($call_ref,$c->config->{ens_rest}); # lib/Nectar/Agent/EnsemblRest.pm
	}#end of foreach $call_ref

}

sub _crawl_nectar :Private {
    my ( $self, $c ) = @_;

	# either 'vcf_diseases', 'vcf_func', or 'vcf_para'
	my $filter= $c->req->args->[0]; #a string

	my $cond; # a hash ref for the where condition
	$cond->{'me.codon'}={'!='=>undef}; # me.codon is not null
	$cond->{'v2ENSX.is_canonical'}=1; # V2Ensembl canonical transcript only
	my $my_select=[qw/_UnifiedCalls.chr _UnifiedCalls.v_start _UnifiedCalls.v_end _UnifiedCalls.reference _UnifiedCalls.genotype featureDef.category featureDef.feature/];
	my $my_as=[qw/chr v_start v_end reference genotype category feature/];

	my $my_table;
	if($filter eq 'vcf_para'){
		########################################
		## get paralogue annotations 
		########################################
		$my_table=['i2ENSX', {'ParaHPMDs'=>'featureDef'}];
		$cond->{'i2ENSX.is_canonical'}=1; # inSilicoSNVs canonical transcript
		$cond->{'ParaHPMDs.id'}={'!='=>undef}; # at least one para hgmd annotation

		push @{$my_select}, qw/ParaHPMDs.para_hgnc ParaHPMDs.para_ensp ParaHPMDs.para_res_num ParaHPMDs.para_xref ParaHPMDs.para_ref_res ParaHPMDs.para_mut_res/;
		push @{$my_as}, qw/para_hgnc ensp res_num xref hpmd_ref hpmd_mut/;

	}else{
		########################################
		## get disease or functional annotation
		########################################
		$my_table={'HPMDs'=>[qw/featureDef p2ENSX/]};
		$cond->{'HPMDs.is_pub'}=1; # public data only
		$cond->{'p2ENSX.is_canonical'}=1; # HPMDs canonical transcript
		if($filter eq 'vcf_diseases'){
			$cond->{'-or'}=[feature=>'HUMSAVAR',feature=>'HGMD-PUBLIC',feature=>'COSMIC'];
		}elsif($filter eq 'vcf_func'){
			$cond->{'featureDef.url'}={-regexp=>'manual'};
		}
		push @{$my_select}, qw/HPMDs.ensp HPMDs.res_num HPMDs.xref HPMDs.p_ref HPMDs.p_mut/;
		push @{$my_as}, qw/ensp res_num xref hpmd_ref hpmd_mut/;
	}

	foreach my $call_ref (@{$c->stash->{vcf_calls}}){
		$cond->{'_UnifiedCalls.chr'}=$call_ref->{'chr'}=~/^chr/? $call_ref->{'chr'} : 'chr'.$call_ref->{'chr'};
		$cond->{'_UnifiedCalls.v_start'}=$call_ref->{'start'};
		$cond->{'_UnifiedCalls.v_end'}=$call_ref->{'end'};
		$cond->{'_UnifiedCalls.reference'}=$call_ref->{'ref'};
		$cond->{'_UnifiedCalls.genotype'}=$call_ref->{'alt'};

		push @{$c->stash->{$filter}}, $c->model('NECTAR::V2Ensembl')->search(
			$cond,
			{
				join=>['v2ENSX', {'_UnifiedCalls'=>{'inSilicoSNVs'=>$my_table}}],
				'+select'=>$my_select,
				'+as'=>$my_as,
			}
		);
	}#end of foreach $call_ref

}	

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
