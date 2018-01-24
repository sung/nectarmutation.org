#
#===============================================================================
#
#         FILE:  EnsemblRest.pm
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Sungsam Gong (sung), sung@bio.cc
#      COMPANY:  Royal Brompton and Harefield NHS Trust
#      VERSION:  1.0
#      CREATED:  18/03/13 14:18:33
#     REVISION:  ---
#===============================================================================
package Nectar::Agent::EnsemblRest;
use Moose;
use namespace::clean -except=>'meta';
use HTTP::Tiny;

sub get_rest{
	my ($self, $call_ref, $server)=@_;

	my $http = HTTP::Tiny->new();
	#my $server=$c->config->{ens_rest};

	$call_ref->{'chr'}=~s/^chr//g;
	my $chr=$call_ref->{'chr'};
	my $start=$call_ref->{'start'};
	my $end=$call_ref->{'end'};
	my $alt=$call_ref->{'alt'};

	#'/vep/human/9:22125503-22125502:1/C/consequences?';
	my $ext = "/vep/human/$chr:$start-$end/$alt/consequences?";
	my $response = $http->get($server.$ext, {
			headers => { 'Content-type' => 'application/json' }
		});
	
	die "Failed!\n" unless $response->{success};
	
	
	use JSON;
	use Data::Dumper;
	if(length $response->{content}) {
		#return $response->{content};
		my $hash = decode_json($response->{content});
		$hash->{data}->[0]->{alt}=$alt; # to print $hash->{data}->[0]->{hgvs}->{$alt};
		return @{$hash->{data}};
=dumper
		my $hash = decode_json($response->{content});
		local $Data::Dumper::Terse = 1;
		local $Data::Dumper::Indent = 1;
		print Dumper $hash;
		return $hash;
=cut
	}
}


# methods

__PACKAGE__->meta->make_immutable;
1;


