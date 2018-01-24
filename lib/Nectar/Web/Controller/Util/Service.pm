package Nectar::Web::Controller::Util::Service;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Util::Service - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# /service/*
sub begin :Private{
    my ($self, $c) = @_;

	# form within root/src/Site/sub_search.tt2
	# for /service/auto
	$c->stash->{query}= $c->request->params->{'query'};
    $c->stash->{target}=$c->request->params->{'target'}; # [%search_this%] from Site/sub_search.tt2

}


sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Nectar::Web::Controller::Util::Service in Util::Service.');
}

# /service/auto?target=gene&output=json&query=TT
# should return json in the following format:
# {
#  query:'Li',
#  suggestions:['Liberia','Libyan Arab Jamahiriya','Liechtenstein','Lithuania'],
#  data:['LR','LY','LI','LT']
# }
sub auto_complete :Path('/service/auto') :Args(0){
    my ($self, $c) = @_;

	# search conditions
	$c->stash->{cons}->{$c->config->{$c->stash->{target}}}={-like=>"%".$c->stash->{query}."%"};

	# addition parameter
	if($c->stash->{target} eq 'patient_gene'){
		$c->stash->{cons}->{bru_code}=$c->request->params->{'bru_code'};
	}
}

sub end :Private {
	my($self, $c) = @_;

	unless($c->stash->{query}){
    	$c->response->body('Not any value for query parameter');
		$c->res->redirect($c->uri_for('/'));
	}else{
		# this part is a main from action which is to redirect based to queired input
		# see root/src/Site/sub_search.tt2
		# query and target are from the from above
		unless ($c->req->param('output')){ 
			if($c->stash->{target} eq 'patient_gene'){
				$c->res->redirect($c->uri_for("/patient/".$c->req->params->{bru_code}.'/gene/'.$c->stash->{query}));
			}elsif($c->stash->{target} eq 'disease_keyword'){
				$c->res->redirect($c->uri_for("/search/disease/".$c->stash->{query}));
			}else{
				$c->res->redirect($c->uri_for("/".$c->stash->{target}."/".$c->stash->{query}));
			}
		# below is to suggest auto-completion based on quried input
		# query and target are from lib/js/jquery_autocomplete.tt2
		# not from the form itself.
		}else{
			my $query=$c->stash->{query};
			my $target=$c->stash->{target};
			$c->stash->{suggestions}=[$c->model($c->config->{'model_'.$target})->search(
				#{$c->config->{$target}=>{-like=>"%".$c->stash->{query}."%"}},
				$c->stash->{cons},
				{select=>$c->config->{$target}}
			)->get_column($c->config->{$target})->all];

			if ($c->req->param('output') eq 'json' or $c->req->param('output') eq 'JSON'){
				$c->forward('View::JSON');
			}else{
				$c->response->body($c->stash->{suggestions});
			}
		}
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
