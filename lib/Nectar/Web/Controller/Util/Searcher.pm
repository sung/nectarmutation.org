package Nectar::Web::Controller::Util::Searcher;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Util::Searcher - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	#$c->response->body('Matched Nectar::Web::Controller::Util::Searcher in Util::Searcher.');
	$c->res->redirect($c->uri_for('/'));
}

=head2 by_ids
	Integrated search form (two parameters: 'id_type' and 'id')
	action from a form (/search/by_ids?id=xx&id_type=yy')
	Search 'id' from various table depending on in_type (/search/pdb, search/uniprot, search/snp, search/gene and search/by_keywords)
	forward to (/search/pdb/xx, /search/uniprot/xx, /search/snp/xx, /search/gene/xx, /search/disease/xx)
=cut
sub by_ids :Path('/search/by_ids') :Args(0){
    my ($self, $c) = @_;

	# get parameters (from the form)
	my $id= $c->req->params->{id};
	# or get argument if  
	$id=$c->req->args->[0] unless defined $id;

	$c->res->redirect($c->uri_for("/")) unless defined $id;

	# keyword
	my $id_type= $c->req->params->{id_type};

    $c->stash->{id} = $id; 
    $c->stash->{id_type} = $id_type; 

	$c->res->redirect($c->uri_for("/search/$id_type/$id"));
}

=head2 keyword
	/search/disease/xx (from URL directly)
	/search/disease?id=xx (from a Boxy modal)
	/search/by_ids?id_type='by_keywords'&id=xx (from a form field)
=cut
sub keyword :Path('/search/disease') {
    my ($self, $c, $keyword) = @_;

	#root/lib/site/indicator
	$c->stash->{sub_search}=1; # a flag for a sub search
	#root/src/Site/sub_search.tt2
	$c->stash->{search_this}='disease_keyword';

	my $id;
	# from /search/diseaes/xx
	if($keyword){
		$id=$keyword;
		$c->stash->{keyword} = $keyword; 
		$c->stash->{total}= $c->request->params->{total} if $c->request->params->{total};

		#######
		# OR example
		# $cd_rs->search([ { year => 2005 }, { year => 2004 } ]);  # year = 2005 OR year = 2004

		# get total number of entries
		unless($c->stash->{total}){
			$c->stash->{total} = $c->model('UNIPROT::Disease')->search(
				[{disease_name=>{-regexp=>"$keyword"}},{des=>{-regexp=>"$keyword"}}], # (disease_name regexp 'keyword' or des regexp 'keyword')
				#{des=>{-regexp=>"$keyword"}},
				{column=>[qw/id/]}
			)->count();
		}

		# no result 
		unless($c->stash->{total}){
			$c->response->status(404);
			$c->detach('/util/messenger/err_msg', ["No result found for $keyword"]);
		# there's hit for this keyword!
		}else{
			# alwasy set $c->stash-{total} before forwarding
			# set paging values (page, limit, pager)
			$c->forward('/pager/set_page', [10]);

			# get data
			$c->stash->{disease_annos} = [$c->model('UNIPROT::Disease')->search(
				[{disease_name=>{-regexp=>"$keyword"}},{des=>{-regexp=>"$keyword"}}], # (disease_name regexp 'keyword' or des regexp 'keyword')
				#{des=>{-regexp=>"$keyword"}},
				{
					select=>[qw/me.acc me.gene me.disease_id UniProtSeq.name  me.disease_name me.disease_abr me.type me.mim me.des/, "GROUP_CONCAT(DISTINCT(CONCAT_WS(':', Evidences.source, Evidences.ref)))"],
					as=>[qw/acc gene disease_id name disease_name disease_abr type mim des refs/],
					join=>['UniProtSeq', {'diseaseEvi'=>'Evidences'}],
					group_by=>[qw/me.id/],
					order_by=>[qw/gene disease_abr/],
					page=>$c->stash->{page},
					rows=>$c->stash->{limit},
				}
			)];
		}
	# from /search/disease?id=xx (maybe from Boxy modal?)
	}else{
		$id=$c->request->params->{id};
		$c->res->redirect($c->uri_for("/search/disease/$id")) if $id;
	}

	# should have a id by now
	$c->detach('/util/messenger/err_msg', ["Please type your key words"]) unless $id;
    $c->stash->{template} = 'Util/by_disease.tt2';
}# end of 'sub keyword'


=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
