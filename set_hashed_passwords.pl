#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  set_hashed_passwords.pl
#
#        USAGE:  ./set_hashed_passwords.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Dr. Sungsam Gong (sung), sung@bio.cc
#      COMPANY:  Royal Brompton and Harefield NHS Trust
#      VERSION:  1.0
#      CREATED:  27/03/12 12:17:42
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Nectar::Schema::NECTAR;

my $schema = Nectar::Schema::NECTAR->connect('dbi:mysql:database=NECTAR;host=fs01;user=samul;password=snrnsk');
 
my @users = $schema->resultset('User')->all;
 
foreach my $user (@users) {
	    $user->password('cost4ric4n');
		$user->update;
}

