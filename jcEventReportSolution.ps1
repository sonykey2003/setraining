# Create a report for User Group membership change events for the past 10 days

## Getting removal events
Get-JCEvent -Service:('all') -StartTime:((Get-date).AddDays(-10)) `
-SearchTermAnd @{
    "event_type" = "association_change"
    "association.op" = "remove"
    "association.connection.from.type" = "user_group"
}



## Getting adding events
Get-JCEvent -Service:('all') -StartTime:((Get-date).AddDays(-10)) `
-SearchTermAnd @{
    "event_type" = "association_change"
    "association.op" = "add"
    "association.connection.from.type" = "user_group"
}


## What attributes do you need for the report?
    <# 
        - initaited_by
        - email
        - where_country
        - where_ip
        - what actions 
        - which group
        - which user
        - when
        - sucess?

    #>
################################################################################
# Start coding below
################################################################################

# 1st, we define a few variables

# Here, we build a report container to catch our custom objects
$reportOut = @()

$tracebackDays = 10
$reportName = "eventReport" + "_"+ (Get-Date -Format "yyyyMMHHMMss") + ".csv"

# 2rd we capture all the events in scope into a container
$events = Get-JCEvent -Service:('all') -StartTime:((Get-date).AddDays(-$tracebackDays)) `
-SearchTermAnd @{
    "event_type" = "association_change"
    "association.connection.from.type" = "user_group"
}

# then, we iterate through the events to build the report
foreach ($e in $events){

    # Buiding an PS object with clean state for each event
    # Then curate, calculate, and map the attributes from the event to our new PS object

    $eventOut = "" | select initiatedBy,email,countryCode,geoip,action,actionSource,groupName,objectName,timeStamp,success
    $eventOut.initiatedBy = $e.initiated_by.type
    $eventOut.email = $e.initiated_by.email
    $eventOut.countryCode = $e.geoip.country_code
    $eventOut.geoip = $e.client_ip
    $eventOut.action = $e.association.op
    $eventOut.actionSource = $e.association.action_source
    $eventOut.groupName = $e.association.connection.from.name
    $eventOut.objectName = $e.association.connection.to.name
    $eventOut.timeStamp = $e.timestamp
    $eventOut.success = $e.success

    # use the report container to catch it 1 at a time
    $reportOut += $eventOut
}

# done, output the csv!
$reportOut | Export-Csv $reportName 