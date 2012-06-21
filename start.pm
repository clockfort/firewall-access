#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  clockwork.pl
#
#        USAGE:  ./clockwork.pl 
#
#  DESCRIPTION:  Web Framework Utility Functions
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:   (), <>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  02/23/10 18:50:38 EST
#     REVISION:  ---
#===============================================================================
#use Git;

sql_connect("db.csh.rit.edu","printeronfirewall","printeronfire","password");

sub list_projects{
#	my $version = Git::command_oneline('version');
    my @projects = array_select("id,name,url FROM `projects`");
	print "<div id=\"projects\">\n";
	foreach my $project (@projects){
		my ($id, $name, $url) = (shift(@projects), shift(@projects), shift(@projects));
		my $little_name = maxlen_str(35,$name);
		my $little_url = maxlen_str(50,$url);
		my @owners = array_select("person_id FROM `ownership` WHERE project_id='$id'");
		print "\t<div class=\"project\" onclick=\"location.href='project.cgi?project=$id';\" style=\"cursor:pointer;\">\n";
		print "\t<img class=\"icon\" src=\"media/git_logo_transparent_vertical.png\" alt=\"Git\" />\n";
		print "\t\t<h1 class=\"title\">$little_name</h1>\n";
		print "\t\t<h3 class=\"url\">Location: <a href=\"$url\">$little_url</a></h3>\n";
#		print "\t\t<h3 class=\"url\">Git version: $version</h3>\n";
		foreach my $owner (@owners){
			my $owner_name = whois($owner);
			print "\t\t<h3 class=\"url\">Project member: <a href=\"project.cgi?user=$owner_name\">$owner_name</a></h3>\n";
		}
		print "\t</div>\n";
	}
	print "</div>\n";
}

sub add_project{
	my ($name, $url, $command_requirements) = (shift(@_), shift(@_), shift(@_));
	#check for field validity/safety should go here
	insert("INTO `buildserve`.`projects` (`id`, `name` , `url` , `command_requirements`, `library_requirements`) VALUES (NULL, '$name', '$url', '$command_requirements', '');");
}

sub list_projects_detail{
	my @projects;
	foreach(@_){
		push (@projects,array_select("id,name,url,command_requirements FROM `projects` WHERE id='$_'"));
	}
	print "<div id=\"projects-detail\">\n";
	foreach my $project (@projects){
		my ($id, $name, $url, $com_req) = (shift(@projects), shift(@projects), shift(@projects), shift(@projects));
		my $little_name = maxlen_str(80, $name);
		my $little_url = maxlen_str(80, $url);
		my @owners = array_select("person_id FROM `ownership` WHERE project_id='$id'");
		print "\t<div class=\"project-detail\">\n";
		print "\t\t<h1 class=\"title\">$little_name</h1>\n";
		print "\t\t<h3 class=\"url\">Location: <a href=\"$url\">$little_url</a></h3>\n";
		print "\t\t<h3 class=\"url\">Command Requirements: $com_req</h3>\n";
		foreach my $owner (@owners){
			my $owner_name = whois($owner);
			print "\t\t<h3 class=\"url\">Project member: $owner_name</h3>\n";
		}
		print "\t</div>\n";
	}
	print "</div>\n";
}

sub maxlen_str{
	my $max = shift;
	my $str = shift;
	my $ret = $str;
	if (length($str)>$max){
		my $too_many = length($str)-$max+3;
		$ret = substr($str, 0, -1*($max/2)-$too_many)."...".substr($str, -1*($max/2));
	}
	return $ret;
}

sub print_navbar{
	my $current_page = shift;
	my $remote_user = get_remote_user();
	my %pages = (
		"My Firewall Rules" => "index.cgi",
		"My Machines" => "listmachines.cgi?user=$remote_user",
		"External IP Printing" => "print.cgi",
		"Admin Panel" => "#"
	);
	#Enforce non-hashibetical ordering
	my @descriptions = ("My Firewall Rules", "My Machines", "External IP Printing", "Admin Panel");

	
    print <<EOM;
    <div id="navcontainer">
    	<ul id="navlist">
EOM
;
	foreach my $description (@descriptions){
	my $location = $pages{$description};
#	while( my ($description, $location) = each(%pages)){
			print "<li";
			if($current_page eq $location){print " id=\"active\"";}
			print "><a href=\"$location\"> $description</a></li>";
	}
    print <<EOM
		</ul>
    </div>
    
    <div id="logo">
    	<img src="media/firewall_csh_logo.png" alt="CSH Logo" />
    </div>
EOM
;
}

1;
