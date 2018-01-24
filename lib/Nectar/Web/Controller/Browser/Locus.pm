package Nectar::Web::Controller::Browser::Locus;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Browser::Locus - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

# always check first whether login or not
sub auto: Private {
    my ( $self, $c ) = @_;

	unless($c->user_exists){
		$c->flash->{uri}=$c->req->uri->path;
		$c->flash->{query_keywords}=$c->req->query_keywords? $c->req->query_keywords : undef;
		$c->detach('/util/messenger/err_msg', ["You're not logged in?", 'not_logged_in']);
	}
}


=head2 index

=cut

sub base_locus :PathPart('locus') :Chained('/') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

	$c->stash->{chr}=$c->req->params->{chr};
	$c->stash->{v_start}=$c->req->params->{v_start}; 
	$c->stash->{v_end}=$c->req->params->{v_end};

	$c->detach('/util/messenger/err_msg', ["chr not defined", 'no_such_parameter']) unless $c->stash->{chr};
	$c->detach('/util/messenger/err_msg', ["v_start not defined", 'no_such_parameter']) unless $c->stash->{v_start};
	$c->detach('/util/messenger/err_msg', ["v_end not defined", 'no_such_parameter']) unless $c->stash->{v_start};

	$c->stash->{cons}->{"_UnifiedCalls.chr"}=$c->stash->{chr};
	$c->stash->{cons}->{"_UnifiedCalls.v_start"}={-between=>[$c->stash->{v_start}, $c->stash->{v_end}]};
	$c->stash->{cons}->{'MergedSamples.merged_to'}=undef;

	$c->stash->{ref_select}=[("COUNT(DISTINCT Samples.run_id)", "COUNT(DISTINCT Samples.id)", "COUNT(DISTINCT Samples.bru_code)", "COUNT(DISTINCT me.uid)", "COUNT(DISTINCT me.id)")]; 
	$c->stash->{ref_as}=[qw/cnt_unique_run cnt_unique_sample cnt_unique_bru cnt_unique_call cnt_call/];
}

sub by_locus :PathPart('') :Chained('base_locus') :Args(0) {
    my ( $self, $c ) = @_;

	# init $c->stash->{meta_calls}
	$c->forward('_get_meta_calls');

	$c->forward('_by_disease');
	$c->forward('_by_target');
	$c->forward('_by_gene');

    $c->stash->{template}='Browser/by_locus.tt2';
}


sub _get_meta_calls :Private{
    my ( $self, $c) = @_;

	# init $c->stash->{ref_metacall};
	$c->forward('_prepare_sql', [qw/call/]); 
	$c->stash->{meta_locus_calls}=$c->forward('_exec_sql', [qw/call/]); 
}

sub _by_disease :Private{
    my ( $self, $c) = @_;

	# add 'diag_code' to the beginning of 'select' sentence
	unshift @{$c->stash->{ref_select}}, qw/Samples.diag_code Diseases.des/;
	unshift @{$c->stash->{ref_as}}, qw/diag_code des/;

	# init $c->stash->{ref_metacall};
	$c->forward('_prepare_sql', [qw/disease/]); 
	$c->stash->{meta_locus_disease}=$c->forward('_exec_sql', [qw/disease/]); 
}

sub _by_target :Private{
    my ( $self, $c) = @_;

	# add 'diag_code' to the beginning
	unshift @{$c->stash->{ref_select}}, qw/Targets.target_name Targets.des/;
	unshift @{$c->stash->{ref_as}}, qw/target_name des/;

	# init $c->stash->{ref_metacall};
	$c->forward('_prepare_sql', [qw/target/]); 
	$c->stash->{meta_locus_target}=$c->forward('_exec_sql', [qw/target/]); 
}

sub _by_gene :Private{
    my ( $self, $c) = @_;

	# add 'diag_code' to the beginning
	unshift @{$c->stash->{ref_select}}, "V2Ensembls.hgnc";
	unshift @{$c->stash->{ref_as}}, "hgnc";

	# init $c->stash->{ref_metacall};
	$c->forward('_prepare_sql', [qw/gene/]); 
	$c->stash->{meta_locus_gene}=$c->forward('_exec_sql', [qw/gene/]); 

}

sub _prepare_sql :Private{
    my ( $self, $c) = @_;

	my ($ref_dummy_array1, $ref_metacall);

	$ref_dummy_array1=[qw/MergedSamples/]; 
	$ref_metacall->[0]={'Samples'=>$ref_dummy_array1};


	if($c->req->args->[0] eq 'target'){
		push @{$ref_dummy_array1}, 'Targets';
	}elsif($c->req->args->[0] eq 'disease'){
		push @{$ref_dummy_array1}, 'Diseases';
	}

	if($c->req->args->[0] eq 'gene'){
		$ref_metacall->[1]= {'_UnifiedCalls'=>'V2Ensembls'};
	}else{
		$ref_metacall->[1]= '_UnifiedCalls';
	}	

	$c->stash->{ref_metacall}=$ref_metacall;
}

sub _exec_sql :Private{
    my ( $self, $c) = @_;

	my $main_hash_ref={
		select=>$c->stash->{ref_select},
		as=>$c->stash->{ref_as},
		join=>$c->stash->{ref_metacall},
	};

	if($c->req->args->[0] eq 'disease'){
		$main_hash_ref->{group_by}='Samples.diag_code';
	}elsif($c->req->args->[0] eq 'target'){
		$main_hash_ref->{group_by}='Targets.target_name';
	}elsif($c->req->args->[0] eq 'gene'){
		$main_hash_ref->{group_by}='V2Ensembls.hgnc';
	}

	my $dbix_result=[$c->model("CARDIODB::MetaCall")->search($c->stash->{cons},$main_hash_ref)];

	unless($c->req->args->[0] eq 'call'){
		if($c->req->args->[0] eq 'gene'){
			shift @{$c->stash->{ref_select}};
			shift @{$c->stash->{ref_as}};
		}else{ #'target' or 'gene'
			shift @{$c->stash->{ref_select}};
			shift @{$c->stash->{ref_select}};
			shift @{$c->stash->{ref_as}};
			shift @{$c->stash->{ref_as}};
		}
	}

	return $dbix_result;
}
=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
