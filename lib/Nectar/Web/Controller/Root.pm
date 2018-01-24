package Nectar::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Nectar::Web::Controller::Root - Root Controller for Nectar::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

# remember where you are 
sub auto: Private {
    my ( $self, $c ) = @_;
	$c->flash->{uri}=$c->req->uri->path;
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
	#$c->response->body( $c->welcome_message );
	$c->stash->{cache}->{cache_for}=$c->config->{cache_for}; # 500 by default (see nectar_web2.conf)

	# a default template
	$c->stash->{template}='index.tt2';

	unless($c->user_exists){
		#$c->stash->{count_gene}=$c->model("NECTAR::Hpmd")->search(undef, {select=>'hgnc',distinct=>1})->count();
		$c->stash->{count_gene}=$c->model("NECTAR::DistinctGene")->search(undef, {select=>'hgnc'})->count();
		$c->stash->{count_disease_gene}=$c->model("NECTAR::Hpmd")->search(
			{
				-or=>[
					feature=>'HUMSAVAR',
					feature=>'COSMIC',
					feature=>'HGMD',
					feature=>'ClinVar',
					],
			},
			{
				select=>'hgnc',
				distinct=>1,
				join=>'featureDef',
			}
		)->count();
		# NO. of enrichment from the source
		unless($c->stash->{stats}=$c->cache->get('stats')){
			$c->stash->{stats}=[$c->model("NECTAR::Stat")->search(undef,{prefetch=>'featureDef'})];
			$c->cache->set('stats',$c->stash->{stats});
		}
		# NO. of paralouge annotations
		$c->stash->{para_stat}=$c->model("NECTAR::Stat")->find({fid=>'0'});
		# get source version
		$c->stash->{sources}=[$c->model("NECTAR::Source")->search(undef)];
	}else{
		# count_disease
		unless($c->stash->{count_disease}=$c->cache->get('count_disease')){
			$c->stash->{count_disease}=$c->model("CARDIODB::MetaDisease")->search(undef,$c->stash->{cache})->count();
			$c->cache->set('count_disease',$c->stash->{count_disease});
		}
		#$c->stash->{count_disease}=$c->model("CARDIODB::MetaDisease")->search()->count();

		# count_gene
		unless($c->stash->{count_gene}=$c->cache->get('count_gene')){
			$c->stash->{count_gene}=$c->model("CARDIODB::MetaGene")->search({'hgnc'=> {'!=' => undef}},$c->stash->{cache})->count();
			$c->cache->set('count_gene',$c->stash->{count_gene});
		}
		#$c->stash->{count_gene}=$c->model("CARDIODB::MetaGene")->search({'hgnc'=> {'!=' => undef}})->count();

		# count_patient
		unless($c->stash->{count_patient}=$c->cache->get('count_patient')){
			$c->stash->{count_patient}=$c->model("CARDIODB::MetaPatient")->search(undef,$c->stash->{cache})->count();
			$c->cache->set('count_patient',$c->stash->{count_patient});
		}
		#$c->stash->{count_patient}=$c->model("CARDIODB::MetaPatient")->search()->count();

		# count_nad
		unless($c->stash->{count_nad}=$c->cache->get('count_nad')){
			$c->stash->{count_nad}=$c->model("CARDIODB::Sample")->search({'diag_code'=>{-like=>"\%NAD"}},{select=>'bru_code',distinct=>1},$c->stash->{cache})->count();
			$c->cache->set('count_nad',$c->stash->{count_nad});
		}
		#$c->stash->{count_nad}=$c->model("CARDIODB::Sample")->search({'diag_code'=>{-like=>"\%NAD"}},{select=>'bru_code',distinct=>1})->count();

		# count_run
		unless($c->stash->{count_run}=$c->cache->get('count_run')){
			$c->stash->{count_run}=$c->model("CARDIODB::Run")->search(undef,$c->stash->{cache})->count();
			$c->cache->set('count_run',$c->stash->{count_run});
		}
		#$c->stash->{count_run}=$c->model("CARDIODB::Run")->search()->count();

		# count_mutation
		unless($c->stash->{count_mutation}=$c->cache->get('count_mutation')){
			$c->stash->{count_mutation}=$c->model("CARDIODB::UnifiedCall")->search(undef,$c->stash->{cache})->count();
			$c->cache->set('count_mutation',$c->stash->{count_mutation});
		}
		#$c->stash->{count_mutation}=$c->model("CARDIODB::UnifiedCall")->search()->count();
	}

}

=head2 default

Standard 404 error page 
=cut

sub default :Path {
    my ( $self, $c ) = @_;
	$c->response->status(404);
	#$c->response->body( 'Page not found' );
	$c->detach('/util/messenger/err_msg', ["Page not found"]);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
	#http://dev.catalyst.perl.org/wiki/gettingstarted/howtos/dynamic_meta_titles_tt
	$c->stash(meta => {});
}
=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
