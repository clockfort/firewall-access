#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  purge_printer_firewall_database.pl
#
#        USAGE:  ./purge_printer_firewall_database.pl  
#
#  DESCRIPTION:  Run on cronjob to remove old printer firewall entries
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Chris Lockfort (clockfort@csh.rit.edu) 
#      COMPANY:  Computer Science House
#      VERSION:  1.0
#      CREATED:  03/28/11 13:26:15
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


require "/users/u15/clockfort/.html_pages/firewall/clockwork.pm";

sql_connect("db.csh.rit.edu","printeronfirewall","printeronfire","password");
my @hosts = array_select("ip_addr, timestamp from `allowed_hosts` where now() - timestamp > 14400");
for(my $i=0; $i<@hosts; $i+=2){
	my $int_ip = $hosts[$i];
	q_del("from `allowed_hosts` where ip_addr = $int_ip;");
}
