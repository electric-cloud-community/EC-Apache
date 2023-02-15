# -------------------------------------------------------------------------
# File
#    ApacheDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    creates a command line to start/stop apache
#
# Plugin Version
#    1.0.1
#
# Date
#    07/16/2012
#
# Engineer
#    Rafael Sanchez
#
# Copyright (c) 2012 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

package ApacheDriver;


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use lib $ENV{COMMANDER_PLUGINS} . '/@PLUGIN_NAME@/agent/lib';
use strict;
use warnings;
use ElectricCommander;
use ElectricCommander::PropDB;
use Readonly;
use open IO => ':encoding(utf8)';
$|=1;

# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
my $ec = new ElectricCommander();
$ec->abortOnError(0);
	
###########################################################################
=head2 main

Title    	: main
Usage    	: main();
Function 	: contains the whole process to be done by the plugin, includen the start/stop apache
Returns  	: none
Args     	: none

=cut
###########################################################################
sub main() {
    
    my $Path2Apache2    = ($ec->getProperty("Path2Apache2") )->findvalue("//value");     
    my $Action          = ($ec->getProperty("Action") )->findvalue("//value");
    my $debug           = ($ec->getProperty("debug") )->findvalue("//value");
    
	# create args array
	my $cmd = "";
    my %props;	
	
	if($Path2Apache2 && $Path2Apache2 ne ""){
		my $execPath = "\"" . $Path2Apache2 . "\\httpd" . "\"";
		$cmd = $execPath;
	}else{
		$cmd = "apache2";
	}
	
	#available options: start, stop, restart
	if($Action && $Action ne ""){
		print "Action: $Action\n";
		$cmd = $cmd . " -k " . $Action;
	}
	
	if($debug && $debug eq "1"){
		$cmd = $cmd . " --debug";
	}

    #add masked command line to properties object
    $props{'cmdLine'} = $cmd;
    setProperties(\%props);
	
	my $content;
	my $result;
	
	if ($Action eq "start") {
		
		#execute the start command
		$content = `$cmd`;
		print $content;
		
		#wait and check if the server was started
		sleep 15;
		$result = verifyContainer();
		
		if ($result eq "not found") {
			print "URL not found for start\n";
		} else {
			print "Apache service is running \n";
		}
	} elsif ($Action eq "restart") {
		
		#checl if the server is running to restart it
		$result = verifyContainer();
		
		if ($result eq "not found") {
			print "URL not found for restart \n";			
		} else {		
			#execute the restart command
			$content = `$cmd`;
			print $content;
			
			#wait and check if the server was started
			sleep 15;
			$result = verifyContainer();
			
			if ($result eq "not found") {
				print "URL to check not found for restart \n";
			} else {
				print "Apache service has restarted \n";
			}
		}
	} else {
		#checl if the server is running to stop it
		$result = verifyContainer();
		
		if ($result eq "not found") {
			print "URL not found for stop \n";			
		} else {		
			#execute the restart command
			$content = `$cmd`;
			print $content;
			
			#wait and check if the server was started
			sleep 15;
			$result = verifyContainer();
			
			if ($result eq "not found") {
				print "Apache service has stopped \n";
			} else {
				print "URL to check not found for stop \n";
			}
		}
	}
}

###########################################################################
=head2 verifyContainer
 
	Title    	: verifyContainer
	Usage    	: verifyContainer(\%props);
	Function 	: check if the server container is running
	Returns  	: "found" or "not found"
	Args     	: none
=cut
###########################################################################
sub verifyContainer {	
    my $url           = ($ec->getProperty("ListenURL") )->findvalue("//value");
	print "URL: $url \n";
	
    #create all objects needed for response-request operations
    my $agent = LWP::UserAgent->new(env_proxy => 1,keep_alive => 1, timeout => 30);
    my $header = HTTP::Request->new(GET => $url->value());
    my $request = HTTP::Request->new('GET', $url->value(), $header);
	
	
	my $response = $agent->request($request);	
		
	# Check the outcome of the response
	if ($response->is_success){		
		return "found";
	}elsif ($response->is_error){		
		return "not found";
	}           
}

###########################################################################
=head2 setProperties
 
	Title    	: setProperties
	Usage    	: setProperties(\%props);
	Function 	: set a group of properties into the Electric Commander
	Returns  	: none
	Args     	: named arguments:
				: -propHash => hash containing the ID and the value of the properties to be written into the Electric Commander
=cut
###########################################################################
sub setProperties($) {
	my ($propHash) = @_;
	foreach my $key (keys % $propHash) {
		my $val = $propHash->{$key};
		$ec->setProperty("/myCall/$key", $val);
	}
}

main();

