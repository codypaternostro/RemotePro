---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Initialize-RpRunspaceJobs
schema: 2.0.0
---

# Initialize-RpRunspaceJobs

## SYNOPSIS
Initializes a synchronized ArrayList to manage runspace jobs.

## SYNTAX

```
Initialize-RpRunspaceJobs [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet creates a synchronized ArrayList to store and manage
runspace jobs safely across multiple threads.
It ensures thread-
safe management of runspace jobs using the Synchronized method.

## EXAMPLES

### EXAMPLE 1
```
$runspaceJobs = Initialize-RpRunspaceJobs
Write-Host "Initialized Runspace Jobs: $runspaceJobs"
```

This example initializes the synchronized ArrayList for runspace
jobs and assigns it to the module scope runspace jobs variable,
$script:RunspaceJobs.

## PARAMETERS

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Initialize-RpRunspaceJobs](https://www.remotepro.dev/en-US/Initialize-RpRunspaceJobs)

