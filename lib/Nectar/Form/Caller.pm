#===============================================================================
#
#         FILE:  Nectar::Form::Register::Register.pm
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  http://www.catalyzed.org/2010/03/an-introduction-to-formhandler.html
#       AUTHOR:  Dr. Sungsam Gong (sung), sung@bio.cc
#      COMPANY:  Royal Brompton and Harefield NHS Trust
#      VERSION:  1.0
#      CREATED:  02/03/12 13:34:30
#     REVISION:  ---
#===============================================================================
package Nectar::Form::Caller;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Widget::Form::Table';

# Associate this form with a DBIx::Class result class (schema/Result/YOUR_TABLE.pm)
# Or 'item_class' can be passed in on 'new', or you
# you can always pass in a row object
has '+item_class' => ( default => 'User' );
has '+unique_messages' =>( default => sub { { email =>'Email already registered' } } );
has '+widget_wrapper' => ( default => 'Table' );
has 'created' =>(isa=>'DateTime', is=>'rw');
has 'md5' =>(isa=>'Str', is=>'rw');

has_field 'username' => ( type => 'Text', required=>1, unique=>1);
has_field 'first_name' => ( type => 'Text' );
has_field 'last_name'  => ( type => 'Text' );
has_field 'email'      => (type   => 'Email', required => 1, unique => 1);
has_field 'password'         => ( type => 'Password', required=>1 );
has_field 'password_confirm' => ( type => 'PasswordConf' );
has_field 'submit' => ( type => 'Submit', value => 'Go' );

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;
