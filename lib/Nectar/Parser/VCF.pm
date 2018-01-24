package Nectar::Parser::VCF;

use Moose;
use namespace::clean -except=>'meta';

#ensembl-variation/modules/Bio/EnsEMBL/Variation/Utils/VEP.pm
sub parse_vcf{
	my ($self, $chunk)=@_;

	my @calls; my $cnt_calls=-1; #always set as -1
	foreach(split /\n/, $chunk){
		next if $_=~/^$/;
		next if $_=~/^#/;
    	my @data = split /\s+/, $_;

		# get relevant data
		my ($chr, $start, $end, $ref, $alt) = ($data[0], $data[1], $data[1], $data[3], $data[4]);
		next unless defined $chr;

		# adjust end coord
		$end += (length($ref) - 1);

		# structural variation
		if((defined($data[7]) && $data[7] =~ /SVTYPE/) || $alt =~ /\<|\[|\]|\>/) {
			# do not process SV at the mo
    	# normal variation
		}else{
			$cnt_calls++;
			# find out if any of the alt alleles make this an insertion or a deletion
			my ($is_indel, $is_sub, $ins_count, $total_count);
			foreach my $alt_allele(split /\,/, $alt) {
				$is_indel = 1 if $alt_allele =~ /D|I/;
				$is_indel = 1 if length($alt_allele) != length($ref);
				$is_sub = 1 if length($alt_allele) == length($ref);
				$ins_count++ if length($alt_allele) > length($ref);
				$total_count++;
			}
			
			# multiple alt alleles?
			if($alt =~ /\,/) {
				if($is_indel) {
					my @alts;
					
					if($alt =~ /D|I/) {
						foreach my $alt_allele(split /\,/, $alt) {
							# deletion (VCF <4)
							if($alt_allele =~ /D/) {
								push @alts, '-';
							}
							
							elsif($alt_allele =~ /I/) {
								$alt_allele =~ s/^I//g;
								push @alts, $alt_allele;
							}
						}
					}
					
					else {
						$ref = substr($ref, 1) || '-';
						$start++;
						
						foreach my $alt_allele(split /\,/, $alt) {
							$alt_allele = substr($alt_allele, 1);
							$alt_allele = '-' if $alt_allele eq '';
							push @alts, $alt_allele;
						}
					}
					
					$alt = join "/", @alts;
				}
				
				else {
					# for substitutions we just need to replace ',' with '/' in $alt
					$alt =~ s/\,/\//g;
				}
			}
			
			elsif($is_indel) {
				# deletion (VCF <4)
				if($alt =~ /D/) {
					my $num_deleted = $alt;
					$num_deleted =~ s/\D+//g;
					$end += $num_deleted - 1;
					$alt = "-";
					$ref .= ("N" x ($num_deleted - 1)) unless length($ref) > 1;
				}
				
				# insertion (VCF <4)
				elsif($alt =~ /I/) {
					$ref = '-';
					$alt =~ s/^I//g;
					$start++;
				}
				
				# insertion or deletion (VCF 4+)
				elsif(substr($ref, 0, 1) eq substr($alt, 0, 1)) {
					
					# chop off first base
					$ref = substr($ref, 1) || '-';
					$alt = substr($alt, 1) || '-';
					
					$start++;
				}
			}
			
			# create an call hash
			$calls[$cnt_calls]={
				'chr'=>$chr,
				'start'=>$start,
				'end'=>$end,
				'ref'=>$ref,
				'alt'=>$alt,
				'line'=>$_,
			};
		}#end of else SV
	} #end of foreach 
	return \@calls;
}

__PACKAGE__->meta->make_immutable;
1;
