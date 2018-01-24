package Nectar::Agent::Basespace;

use Moose;
use namespace::clean -except=>'meta';
use REST::Client;
# Role::REST::Client
# REST::Client
# https://developer.atlassian.com/display/FECRUDEV/Writing+a+REST+Client+in+Perl

has 'rest_api' => (
	is=> 'ro',
	isa=>'Str', 
	lazy_build=>1,
	);

sub _build_rest_api {
	my ($self)=@_;
	return 'REST::Client';
}


=head2 

# https://uri.to/your/application?action=trigger&appsessionuri=v1pre3/appsessions/{AppSessionId}&authorization_code={code}
# https://cardiodb.org/nectar/vcf?action=trigger&appsessionuri=v1pre3/appsessions/cfb9f8c2856c48c7847fe87c5005be4f&authorization_code=222b84c33f684d11af21bc415860f6fa&state=appResultId%20-1
# or from local web form
1. get the access_token with the auth_code above
	: https://api.basespace.illumina.com/v1pre3/oauthv2/token
2. Fetching the App session (meta info of the user & project or sample)
	: http://api.basespace.illumina.com/v1pre3/appsessions/{AppSessionId}
3. Using the Access Token to get BaseSpace Data
	: With every API request your app will need to pass the access_token

client_id f51e778c417d478caeab6264459d136e
client_secret b47d2e8675074fc79e270c84d515e65a
code 222b84c33f684d11af21bc415860f6fa
redirect_uri https://cardiodb.org/nectar/vcf
grant_type authorization_code
=cut
sub get_token {
	my ($self, $ref_param)=@_;


}

__PACKAGE__->meta->make_immutable;
1;
