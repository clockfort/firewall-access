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
#       AUTHOR:   (Chris Lockfort), <devnull@csh.rit.edu>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  02/23/10 18:50:38 EST
#     REVISION:  ---
#===============================================================================
use Mysql;
use Time::HiRes qw(time);

#initialize before use
my $host;
my $database;
my $tablename;
my $user;
my $pw;
my $connect; 
my $page_time=0;

# Print a simple HTML table from a given array.
# Usage:
#   print_table_from_array($number_of_columns,@array_to_print_out)
sub print_table_from_array{
    my $cols = shift;
    my $i=0;
    if(scalar(@_) != 0){
        print"\n<table>\n";
        foreach my $item (@_){
	    $i++;
            if($i == 1){
                print "<tr>\n";
            }
            print "\t<td>$item</td>\n";
            if($i == $cols){
                print "</tr>\n";
                $i = 0;
            }
        }
        print "</table>\n";
    }
}

#Performs a SQL Select and places output into an array
#Usage:
#   array_select("* FROM `tablename`");
#Returns:
#   An array with all of the rows returned back from the given query.
sub array_select{
    my @raw_results;
    my @results;
    my $query_postfix = shift;
    my $query = $connect->query("SELECT $query_postfix");
    while(@raw_results = $query->fetchrow()){
        push(@results, @raw_results);
    }
    return @results;
}

sub insert{
	my $input = shift;
	my $query = $connect->query("INSERT $input");
	return $query;
}

sub q_del{
	my $input = shift;
	my $query = $connect->query("DELETE $input");
	return $query;
}

sub sql_connect{
    ($host, $database, $user, $pw) = @_;
    $connect = Mysql->connect($host, $database, $user, $pw);
    $connect->selectdb($database);
}

sub list_tables{
    my @tables = $connect->listtables;
    print_table_from_array(1,"Tables",@tables);
}


sub pre_render{
	$page_time=time();
    $ENV{"PATH"} = "/bin:/usr/local/bin:/usr/bin";
    $ENV{"BASH_ENV"}="";
	my $title = shift;
    print "Content-type: text/html; charset=utf-8\n\n";
	print "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n";
	print "\t<meta charset=\"utf-8\">\n";
	print "\t<link rel=\"stylesheet\" type=\"text/css\" href=\"site.css\" />\n";
	print "\t<title>$title</title>\n</head>\n<body>\n";
}

sub post_render{
    $page_time=time()-$page_time;
    print "<p>Page served in $page_time seconds</p>";
	print "\n</body>\n</html>";
}

sub get_remote_user{
	my $remote_user = $ENV{"REMOTE_USER"};
	return $remote_user;
}

sub get_remote_ip{
	my $remote_ip = $ENV{"REMOTE_ADDR"};
	return $remote_ip;
}

# Prints a file directly. Useful for pushing in larger code blobs from external files.
# Warning: This is bound to be rather slow.
# Usage:
# 	print_file("filename")
sub print_file{
	my $filename = shift;
	open(FILEHANDLE, "<$filename");
	my $line;
	while ($line = <FILEHANDLE>){
		print $line;
	}
	close(FILEHANDLE);
}

sub pretty_print{
##remove nbsp
#s/[ ][ ]*/ /g
#if(new_tag){
#	tab_level++;
#}
#if(tag_closed){
#	tab_level--;
#}
}

1;
