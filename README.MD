# JumpCloud Event Reporting Exercise - PowerShell

## Exercise 1 - Create a CSV report for User Group membership change events for the past 10 days

### Example Event - Removal
```pwsh
Get-JCEvent -Service:('all') -StartTime:((Get-date).AddDays(-10)) `
-SearchTermAnd @{
    "event_type" = "association_change"
    "association.op" = "remove"
    "association.connection.from.type" = "user_group"
}
```

### Example Event - Adding
```pwsh
Get-JCEvent -Service:('all') -StartTime:((Get-date).AddDays(-10)) `
-SearchTermAnd @{
    "event_type" = "association_change"
    "association.op" = "add"
    "association.connection.from.type" = "user_group"
}
```

### What attributes do you need for the report?

- initaited_by
- email
- where_country
- where_ip
- what actions 
- which group
- which user
- when
- sucess?

### Hint - you can build the attributes into a custom object like this: 
```pwsh
$customObject = "" | select initiatedBy,email,countryCode,geoip,action,actionSource,groupName,objectName,timeStamp,success
```
