#
#===============================================================================
#
#         FILE:  Captcha.pm
#
#  DESCRIPTION:  https://github.com/gshank/formhandler-example/blob/master/lib/MyApp/Form/Captcha.pm 
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Sungsam Gong (sung), sung@bio.cc
#      COMPANY:  Royal Brompton and Harefield NHS Trust
#      VERSION:  1.0
#      CREATED:  14/03/12 11:55:39
#     REVISION:  ---
#===============================================================================
package Nectar::Form::Captcha;

use HTML::FormHandler::Moose;
extends qw/HTML::FormHandler/;
with 'HTML::FormHandler::TraitFor::Captcha';
#with qw/
## HTML::FormHandler::Render::Simple
## HTML::FormHandler::TraitFor::Captcha
##/;
#
has_field submit => ( type => "Submit", value=>'Go' );

# Default is '/captcha/image'. Override in a form to change.
# see /data/Live/sung/perl5/lib/perl5/HTML/FormHandler/TraitFor/Captcha.pm
sub captcha_image_url { return '/main/captcha/image' }

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;
