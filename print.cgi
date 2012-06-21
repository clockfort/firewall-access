#!/usr/bin/perl -wT
use CGI qw(:standard);
require "./clockwork.pm";
require "./start.pm";

{
	my $ip = get_remote_ip();
	my $data = param('ip');
	my $error = 0;
	
	if(defined($data)){ #Fuck off I know there should be input validation here
		my @num_machines = array_select("count(username) from `allowed_hosts` where username='".get_remote_user()."' group by username;");
		if($num_machines[0] > 5){
			$error = 1;
		}
		else{
			insert("into `allowed_hosts` values (inet_aton(\'$data\'), now(), '".get_remote_user()."' );");
			my $q = CGI->new();
			print $q->redirect( -URL => "print.cgi");
		}
	}

	pre_render("Error: Printer on Fire(wall)");
	print_navbar("print.cgi");
	if($error){
		print "<p>ERROR: You may only have 5 remote IPs to your name at a time, to prevent evil users from filling the database/firewall rules table.</p>\n";
	}
	print "<p>Currently logged in as user: ".get_remote_user()."<p>\n";
	print "<form action=\"print.cgi\">\n";
	print "<div>IP to whitelist: <input name=\"ip\" size=\"20\" value=\"$ip\"><input type=\"submit\"></div>\n";
	print "</form>\n";
	print "<p>Currently allowed persons: (Registrations automagically expire in 5 hours)</p>\n";
	print_table_from_array(2,array_select("inet_ntoa(ip_addr), concat('(', username, ')') from `allowed_hosts` order by timestamp"));
	print "<p>Permanently allowed address ranges:</p>\n";
	print_table_from_array(2,array_select("inet_ntoa(ip_addr), concat('(', inet_ntoa(netmask), ')') from `permanently_allowed_ranges` order by ip_addr"));
	post_render();
}
