---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Initialize-RpOpenRunspaces

## SYNOPSIS
Initializes an object to manage open runspaces using a static
observable collection.

## SYNTAX

```
Initialize-RpOpenRunspaces [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet creates a PSObject with an observable collection to
track jobs in static runspaces.
The open runspaces object is
initialized once and shared across the session.

## EXAMPLES

### EXAMPLE 1
```
$runspaces = Initialize-RpOpenRunspaces
Write-Host "Initialized Open Runspaces: $runspaces"
```

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
