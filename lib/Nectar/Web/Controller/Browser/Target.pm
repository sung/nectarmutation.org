package Nectar::Web::Controller::Browser::Target;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Target - Catalyst Controller

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
	$c->stash->{search_this}='target';

	unless($c->user_exists){
		#$c->flash->{uri}=$c->req->path;
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?", 'not_logged_in']);
	}
	$c->detach('/util/messenger/err_msg', ["You're not authorised to get here"]) unless $c->check_user_roles( qw/member/ ); # only member can access 
}


=head2 index
/target
=cut
sub index :Path('/target') :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Browser::Target in Browser::Target.');
	$c->stash->{meta_targets}=[$c->model("CARDIODB::MetaTarget")->search()->all()];
    $c->stash->{template}='Browser/target_index.tt2';
}

#/target/*
sub base_target :PathPart('target') :Chained('/') :CaptureArgs(1){
	my ( $self, $c, $target_name) = @_;

	$c->stash->{target_name}=$target_name;
	$c->stash->{cons}->{target_name}=$target_name;

	#0. sanitise target_name 
	$c->forward('/util/sanitiser/target');
}

#/target/ICCv2
sub by_target :PathPart('') :Chained('base_target') :Args(0){
	my ( $self, $c ) = @_;

	#1. NO. of samples for a given target
	$c->stash->{meta_targets}=[$c->model("CARDIODB::MetaTarget")->search($c->stash->{cons})->all()];
	$c->stash->{meta_x_diseases}=[$c->model("CARDIODB::MetaTargetDisease")->search(
		$c->stash->{cons},{prefetch=>qw/Diseases/}
	)];

	# 2. get the stat per each diag_code (tab: Mutations & Coda-Slider)
	$c->stash->{cmuts}=[$c->model("CARDIODB::ClassifiedTargetDisease")->search($c->stash->{cons})];

	# 3. get target regions
	# get total
	$c->stash->{cons}->{'me.hgnc'}={'!='=>undef}; # hgnc is not null
	$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};
	unless($c->stash->{total}){
		$c->stash->{total}=$c->model("CARDIODB::TargetRegion")->search(
			$c->stash->{cons},
			{
				select=>[qw/chr g_start g_end hgnc ensg strand/],
				join=>'Targets',
				distinct=>1,
			}
		)->count();
	}

	# alwasy set $c->stash-{total} before forwarding
	# set paging values (page, limit, pager)
	$c->forward('/pager/set_page', [30]);

	$c->stash->{regions}=[$c->model("CARDIODB::TargetRegion")->search(
		$c->stash->{cons},
		{
			select=>[qw/chr g_start g_end hgnc ensg strand/],
			join=>'Targets',
			distinct=>1,
			page=>$c->stash->{page},
			rows=>$c->stash->{limit},
		}
	)];

    $c->stash->{template}='Browser/by_target.tt2';
}


=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
