---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Get-RpSettings
schema: 2.0.0
---

# Get-RpSettings

## SYNOPSIS
Retrieves RemotePro settings.

## SYNTAX

```
Get-RpSettings [-All] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpSettings function retrieves the settings from the RemotePro
controller object.
If the -All switch is specified, it returns all
settings values; otherwise, it returns the settings object.

## EXAMPLES

### EXAMPLE 1
```
Get-RpSettings
```

Retrieves the settings object from the RemotePro controller.

### EXAMPLE 2
```
Get-RpSettings -All
```

Retrieves all settings values from the RemotePro controller.

## PARAMETERS

### -All
If specified, returns all settings values.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Get-RpSettings](https://www.remotepro.dev/en-US/Get-RpSettings)

