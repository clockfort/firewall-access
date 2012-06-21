#!/usr/bin/perl -wT
use CGI qw(:standard);
require "./clockwork.pm";
require "./start.pm";

{
	my $ip = get_remote_ip();
	my $data = param('ip');
	sql_connect("db.csh.rit.edu","printeronfirewall","printeronfire","password");
	pre_render("ClockStart Home");
	print_navbar("index.cgi");
	print "<p>Currently logged in as user: ".get_remote_user()."<p>\n";
	print "<form action=\"index.cgi\">\n";
	print "<div>IP to register: <input name=\"ip\" size=\"20\" value=\"$ip\"><input type=\"submit\"></div>\n";
	print "</form>\n";
	post_render();
}
