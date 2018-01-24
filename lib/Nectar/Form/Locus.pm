#===============================================================================
#
#         FILE:  Nectar::Form::Locus.pm
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  http://www.catalyzed.org/2010/03/an-introduction-to-formhandler.html
#       AUTHOR:  Dr. Sungsam Gong (sung), sung@bio.cc
#      COMPANY:  Royal Brompton and Harefield NHS Trust
#      VERSION:  1.0
#      CREATED:  10/08/12
#     REVISION:  ---
#===============================================================================
package Nectar::Form::Locus;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Widget::Form::Table';

has '+widget_wrapper' => ( default => 'Table' );
has_field 'chr' => ( label=>'Chr', type => 'Select', required=>1 );
has_field 'v_start'      => (label=>'Start', type   => 'PosInteger', required => 1);
has_field 'v_end'      => (label=>'End', type   => 'PosInteger', required => 1);
has_field 'submit' => ( type => 'Submit', value => 'Go', html_attr => {onClick => "\$('#my_activity').activity()"}); #HFH 0.36003

sub options_chr{
	return(
		chr1=>'chr1',
		chr2=>'chr2',
		chr3=>'chr3',
		chr4=>'chr4',
		chr5=>'chr5',
		chr6=>'chr6',
		chr7=>'chr7',
		chr8=>'chr8',
		chr9=>'chr9',
		chr10=>'chr10',
		chr11=>'chr11',
		chr12=>'chr12',
		chr13=>'chr13',
		chr14=>'chr14',
		chr15=>'chr15',
		chr16=>'chr16',
		chr17=>'chr17',
		chr18=>'chr18',
		chr19=>'chr19',
		chr20=>'chr20',
		chr21=>'chr21',
		chr22=>'chr22',
		chrX=>'chrX',
		chrY=>'chrY'
	);	
}

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;
