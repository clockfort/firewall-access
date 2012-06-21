#!/usr/bin/perl -wT
use CGI qw(:standard);
require "./clockwork.pm";
require "./start.pm";
#require "./legacy_start.pm";

{
	my $ip = get_remote_ip();
	my $user_to_fetch = param('user');
	my $error = 0;
	my @names;
	my @ips;
	unless($user_to_fetch eq ""){ #Fuck off I know there should be input validation here
#		my @data = get_machines_for_user($user_to_fetch);
#		print "<p>foo:@data<\p>";
#		@names = $data[0];
#		@ips = $data[1];
	}
	pre_render("Error: Printer on Fire(wall)");
	print_navbar("listmachines.cgi?user=".get_remote_user());
	
	print "<p>Currently logged in as user: ".get_remote_user()."<p>\n";

	post_render();
}
