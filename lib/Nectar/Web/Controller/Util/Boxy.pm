package Nectar::Web::Controller::Util::Boxy;
use Moose;
use namespace::autoclean;

# HTF
use Nectar::Form::Locus;
use Nectar::Form::FileUpload;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Nectar::Web::Controller::Util::Boxy - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	$c->res->redirect($c->uri_for('/'));
}


# maybe disabled?
# /boxy/locus_form from root/lib/site/menu
sub locus_form :Path('/boxy/locus_form') :Args(0) {
    my ( $self, $c ) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};

	# lib/Nectar/Form/Locus.pm
	my $form = Nectar::Form::Locus->new(ctx=>$c,action=>$c->uri_for('/locus'),http_method=>'post');

	# Stash the form and the template to render it
	#$c->stash(template => 'Form/locus.tt2', form=> $form);

	# Process the form with the parameters, a schema and a row object
	delete $c->request->parameters->{_}; # to remove '_' param of boxy
	#$form->process(params => $c->request->parameters);

	# no form validation at all because action=>$c_uri_fur('/locus')
	unless($form->validated){
		$c->res->body($form->render);
	}
}

sub file_upload_form :Path('/boxy/file_upload') :Args(0) {
    my ( $self, $c ) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};

	# lib/Nectar/Form/FileUpload.pm
	my $form = Nectar::Form::FileUpload->new(ctx=>$c,action=>$c->uri_for('/vcf'),http_method=>'post');
	$c->stash(template => 'Form/vcf_file_upload.tt2', form=> $form);

}

# from root/lib/site/menu
sub gene_form :Path('/boxy/gene_form') :Args(0){
    my ( $self, $c ) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};
	$c->stash(template => 'Form/gene_form.tt2');

}

# from root/lib/site/menu
sub disease_form :Path('/boxy/disease_form') :Args(0){
    my ( $self, $c ) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};
	$c->stash(template => 'Form/disease_form.tt2');

}

# "ask-mutation" from root/lib/site/menu
# then boxy-ask javascript (root/lib/js/boxy_search_popup.tt2)
sub main_search_form :Path('/boxy/main_search_form') :Args(0) {
    my ( $self, $c ) = @_;

	#?boxy=1
	$c->stash->{no_wrapper}=1 if $c->req->params->{boxy};
	$c->stash->{search_mode}=defined $c->req->params->{search_mode}? $c->req->params->{search_mode}:'Gene';
	$c->stash->{diseases}=[$c->model('CARDIODB::MetaDisease')->search({cnt_call=>{'>'=>0}})->all()];
	$c->stash->{targets}=[$c->model('CARDIODB::MetaTarget')->search()->all()];
	$c->stash(template => 'Form/main_search_form.tt2');
}

#/gbrowse?ensp=ENSP00000228841&xref=?VAR_004601
sub gbrowse_img :Path('/gbrowse') :Args(0) {
    my ( $self, $c ) = @_;

	my $gb_link='http://cardiodb/gb2/gbrowse_img/nectar/?label=HUMSAVAR-HGMD-COSMIC;name=';
	my $ensp=$c->req->params->{ensp};
	my $xref=$c->req->params->{xref};
#<a href='[%gbrowse.link%][%ensp%]'><img src='[%gbrowse.img%][%xref%];h_feat=[%xref%]@yellow;h_region=' border=0></a>
	my $gb_tag="<img src='$gb_link$ensp' border=0>";
	$c->res->body($gb_tag);
}

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
