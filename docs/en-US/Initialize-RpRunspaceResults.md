---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Initialize-RpRunspaceResults
schema: 2.0.0
---

# Initialize-RpRunspaceResults

## SYNOPSIS
Initializes a synchronized ArrayList to store runspace results.

## SYNTAX

```
Initialize-RpRunspaceResults [<CommonParameters>]
```

## DESCRIPTION
This cmdlet creates a synchronized ArrayList to store and manage
results from runspace jobs.
The synchronized ArrayList ensures
thread-safe operations when accessing the results from multiple
runspaces.

## EXAMPLES

### EXAMPLE 1
```
$runspaceResults = Initialize-RpRunspaceResults
```

Write-Host "Initialized Runspace Results: $runspaceResults"

This example initializes the synchronized ArrayList for runspace
results and assigns it to the module scope runspace results variable,
$script:RunspaceResults.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Initialize-RpRunspaceResults](https://www.remotepro.dev/en-US/Initialize-RpRunspaceResults)

