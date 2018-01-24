package Nectar::Web;
use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.80;

use Cache::Memcached::GetParserXS;
use Cache::Memcached;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
	Email
    Static::Simple
	StackTrace
	AutoCRUD
	Authentication
	Authorization::Roles
	Session
	Session::State::Cookie
	Session::Store::File
	Cache
	RequireSSL
/;
#Session::Store::Cache

extends 'Catalyst';

our $VERSION = '1.00';

# Configure the application.
#
# Note that settings in nectar_webv2.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
	name =>'NECTAR',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
	'View::JSON' => {
		allow_callback  => 1,    # defaults to 0
		callback_param  => 'nectar', # defaults to 'callback'
		#expose_stash    => [qw/json/], # defaults to everything
		encoding => 'en_gb',
	},
	'View::Excel' =>{
		etp_config => {
			INCLUDE_PATH =>  __PACKAGE__->path_to('root') . '/excel' ,
		},
		etp_engine => 'TT',
	},
	#'uploadtmp'=>'/data/tmp/Nectar',
	'Static::Simple'=>{
		#By default, files with the extensions tmpl, tt, tt2, html, and xhtml will be ignored by Static::Simple
		ignore_extensions=>[qw/tt tt2 tmpl html htm/] 
	}
);

__PACKAGE__->config->{email} = ['Sendmail'];
# it does not send an email, although it looks successful without 'ssl=>1'
#__PACKAGE__->config->{email} = ['SMTP','smtp.gmail.com:465',username=>'gong.sungsam',password=>'PWD',ssl=>1];
#__PACKAGE__->config->{email} = ['SMTP','192.168.81.25:25']; #Bromton SMTP works only with @rbht.nhs.uk (BHXCAS)
#__PACKAGE__->config->{email} = ['SMTP','193.61.118.187:25']; #Bromton SMTP works only with @rbht.nhs.uk (bracuda)

# Start the application
__PACKAGE__->setup();

=head2 
	# prevent dumping config (e..g password) on the error page
	http://wiki.catalystframework.org/wiki/faq#How_do_I_hide_certain_variables_.28e.g._user.2Fpassword.29_from_the_debug_screen.3F	
=cut
use MRO::Compat;
sub dump_these {
	my $c = shift;
	my @variables = $c->next::method(@_);
	return grep { $_->[0] ne 'Config' } @variables;
}

=head1 NAME

Nectar::Web - Catalyst based application

=head1 SYNOPSIS

    script/nectar_webv2_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Nectar::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
