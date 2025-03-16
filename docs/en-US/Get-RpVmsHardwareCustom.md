---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Get-RpVmsHardwareCustom
schema: 2.0.0
---

# Get-RpVmsHardwareCustom

## SYNOPSIS
Retrieves and displays the hardware settings of VMS items with optional
connection validation.

## SYNTAX

### NoConnectionCheck (Default)
```
Get-RpVmsHardwareCustom [-IncludeCredentials] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ConnectionCheck
```
Get-RpVmsHardwareCustom [-CheckConnection] [-IncludeCredentials] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the hardware settings of VMS items and displays the
results in an HTML view.
It also provides an optional parameter to validate the connection before
processing.

## EXAMPLES

### EXAMPLE 1
```
Get-RpVmsHardwareCustom -CheckConnection
```

This example validates the VMS connection before retrieving and
displaying the hardware settings of the items.

## PARAMETERS

### -CheckConnection
Validates the VMS connection before processing the items.
If the connection is not valid, the function will display an error message
and exit early.

```yaml
Type: SwitchParameter
Parameter Sets: ConnectionCheck
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeCredentials
Includes the username and password in the output for each hardware item.

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

[https://www.remotepro.dev/en-US/Get-RpVmsHardwareCustom](https://www.remotepro.dev/en-US/Get-RpVmsHardwareCustom)

