push (@::gMatchers,
    #Permission denied
    {
        id =>        "Permissiondenied",
        pattern =>          q{Permission denied},
        action =>        q{&addSimpleError("Permission denied", "error");},
    },
    #Access denied
    {
        id =>       "Accessdenied",
        pattern =>          q{Access denied},
        action =>        q{&addSimpleError("Access denied", "error");},
    },
    #server status
    {
        id =>       "status",
        pattern =>          q{Active:\s(.*)\s\((.*)\)},
        action =>        q{&addSimpleError("Status is $1 ($2)", "success");},
    },
    #Success
    {
        id =>       "success",
        pattern =>          q{has stopped},
        action =>        q{&addSimpleError("The Apache2.2 service has stopped.", "success");},
    },
    #SuccessRestart
    {
        id =>       "success",
        pattern =>          q{has restarted},
        action =>        q{&addSimpleError("The Apache2.2 service has restarted.", "success");},
    },
    #running
    {
        id =>       "running",
        pattern =>          q{service is running},
        action =>        q{&addSimpleError("Apache2.2 service is running", "success");},
    },
    #notRunning
    {
        id =>       "notRunning",
        pattern =>          q{service is not running},
        action =>        q{&addSimpleError("Apache2.2 service is not running", "error");},
    },
    #not found
    {
        id =>       "notFoundedToStart",
        pattern =>          q{URL not found for start},
        action =>        q{&addSimpleError("Warning: URL not found. Can not verify if the Apache server is running with the entered URL parameter", "warning");},
    },
    #not found for restart
    {
        id =>       "notFoundedToRestart",
        pattern =>          q{URL not found for restart},
        action =>        q{&addSimpleError("Error: URL not found. Can not restart the Apache server with the entered URL parameter", "error");},
    },
    #not found for restart in check
    {
        id =>       "checkRestart",
        pattern =>          q{URL to check not found for restart},
        action =>        q{&addSimpleError("Warning: URL not found. Can not restart the Apache server with the entered URL parameter", "warning");},
    },
    #not found for stop
    {
        id =>       "notFoundedToStop",
        pattern =>          q{URL not found for stop},
        action =>        q{&addSimpleError("Error: URL not found. Can not stop the Apache server with the entered URL parameter", "error");},
    },
    #not found for stop in checlk
    {
        id =>       "checkStop",
        pattern =>          q{URL to check not found for stop},
        action =>        q{&addSimpleError("Warning: URL not found. Can not stop the Apache server with the entered URL parameter", "warning");},
    },
);

sub addSimpleError {
    my ($customError, $type) = @_;	
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);
	
	setProperty("summary", $customError);
	if ($type eq "success") {
		$ec->setProperty("/myJobStep/outcome", 'success');
	} elsif ($type eq "error") {
		$ec->setProperty("/myJobStep/outcome", 'error');
	} else {
		$ec->setProperty("/myJobStep/outcome", 'warning');
	}
}