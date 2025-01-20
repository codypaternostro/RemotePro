---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# New-RpControllerObject

## SYNOPSIS
Creates a new ControllerObject for RemotePro.

## SYNTAX

```
New-RpControllerObject [-Refresh] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-RpControllerObject cmdlet creates a new RemotePro object, which includes
properties like EventHandlers.
This object is typed as \`RemotePro\` and
can be used to manage various aspects of the RemotePro environment.

## EXAMPLES

### EXAMPLE 1
```
$remotePro = New-RpControllerObject
```

This example creates a new RemotePro ControllerObject.

## PARAMETERS

### -Refresh
Forces the creation of a new RemotePro ControllerObject even if one already exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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
