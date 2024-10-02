---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RpRunspaceEvents

## SYNOPSIS
Retrieves runspace events for the RemotePro connection profile UI.

## SYNTAX

### default (Default)
```
Get-RpRunspaceEvents [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByName
```
Get-RpRunspaceEvents [-Name] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AllHandlers
```
Get-RpRunspaceEvents [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpRunspaceEvents cmdlet returns the code for various event handlers
associated with the RemotePro connection profile UI.
It retrieves handlers
stored in the RemotePro.RunspaceEvents object.

## EXAMPLES

### EXAMPLE 1
```
Get-RpRunspaceEvents
```

This example returns all the runspace events as a custom object.

### EXAMPLE 2
```
Get-RpRunspaceEvents -Name "Hardware_Click"
```

This example retrieves the runspace event associated with the "Hardware_Click" button click event.

## PARAMETERS

### -Name
Retrieves a specific runspace event by its name.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Returns all runspace events as a custom object with a specific type.

```yaml
Type: SwitchParameter
Parameter Sets: AllHandlers
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

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
