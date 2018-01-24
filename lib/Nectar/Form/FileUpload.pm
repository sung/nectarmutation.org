#
#===============================================================================
#
#         FILE:  FileUpload.pm
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Sungsam Gong (sung), sung@bio.cc
#      COMPANY:  Royal Brompton and Harefield NHS Trust
#      VERSION:  1.0
#      CREATED:  11/03/13 13:08:26
#     REVISION:  ---
#===============================================================================
package Nectar::Form::FileUpload;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
#with 'HTML::FormHandler::Widget::Form::Table';

#has '+widget_wrapper' => ( default => 'Table' );
has '+enctype' => ( default => 'multipart/form-data');
has_field 'file' => (
				type => 'Upload',
				required => 1,
				max_size => 2000000, # 2MB
				#max_size => 300, # 300 Byes
			);

has_field 'submit' => ( id=>'btn_submit', type => 'Submit', value => 'Upload', html_attr => {onClick => "\$('#my_activity').activity()"}); #HFH 0.36003

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;
