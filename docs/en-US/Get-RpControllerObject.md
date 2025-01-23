---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RpControllerObject

## SYNOPSIS
Retrieves and optionally lists properties of the existing RemotePro
ControllerObject.

## SYNTAX

```
Get-RpControllerObject [-ListProperties] [[-Property] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-RpControllerObject cmdlet retrieves the existing RemotePro object.
It can either return the full object, list its properties, or show details
of a specific property.

## EXAMPLES

### EXAMPLE 1
```
Get-RpControllerObject
```

This example retrieves the existing RemotePro ControllerObject and returns
it.

### EXAMPLE 2
```
Get-RpControllerObject -ListProperties
```

This example lists the properties of the existing RemotePro ControllerObject.

### EXAMPLE 3
```
Get-RpControllerObject -Property EventHandlers
```

This example retrieves the value of the 'EventHandlers' property in the
RemotePro ControllerObject.

## PARAMETERS

### -ListProperties
A switch parameter that, if specified, lists the properties of the
RemotePro object.

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

### -Property
The name of a specific property to display.
If provided, the value of that
property will be returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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
