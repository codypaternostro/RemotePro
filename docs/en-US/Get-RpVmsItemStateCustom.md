---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Get-RpVmsItemStateCustom
schema: 2.0.0
---

# Get-RpVmsItemStateCustom

## SYNOPSIS
Retrieves and displays the state of VMS items with optional connection
validation.

## SYNTAX

### NoConnectionCheck (Default)
```
Get-RpVmsItemStateCustom [<CommonParameters>]
```

### ConnectionCheck
```
Get-RpVmsItemStateCustom [-CheckConnection] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the state of VMS items, specifically cameras,
and displays the results in an HTML view.It also provides an optional
parameter to validate the connection before processing.

## EXAMPLES

### EXAMPLE 1
```
Get-RpVmsItemStateCustom -CheckConnection
```

This example validates the VMS connection before retrieving and displaying
the state of the items.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Get-RpVmsItemStateCustom](https://www.remotepro.dev/en-US/Get-RpVmsItemStateCustom)

