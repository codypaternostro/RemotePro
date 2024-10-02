---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RpEventHandlers

## SYNOPSIS
Retrieves event handlers for the RemotePro connection profile UI.

## SYNTAX

### default (Default)
```
Get-RpEventHandlers [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByName
```
Get-RpEventHandlers [-Name] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AllHandlers
```
Get-RpEventHandlers [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpEventHandlers cmdlet returns the code for various event
handlers associated with the RemotePro connection profile UI.
It retrieves handlers stored in the \`RemotePro.EventHandlers\` object.

## EXAMPLES

### EXAMPLE 1
```
Get-RpEventHandlers
```

This example returns all the event handlers defined in the script.

### EXAMPLE 2
```
Get-RpEventHandlers -Name "NewConnectionFile_Click"
```

This example retrieves the event handler associated with the
"New Connection File (.xlsx)" button click event.

### EXAMPLE 3
```
Get-RpEventHandlers -All
```

This example returns all the event handlers defined in the script.

## PARAMETERS

### -Name
The name of the specific event handler to retrieve.
This parameter is
mutually exclusive with the All parameter.

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
A switch parameter that, when specified, returns all event handlers.
This parameter is mutually exclusive with the Name parameter.

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
