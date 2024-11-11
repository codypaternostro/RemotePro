---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection
schema: 2.0.0
---

# Test-RpVmsConnection

## SYNOPSIS
Tests the connection to the VMS management server.

## SYNTAX

```
Test-RpVmsConnection [-ShowErrorDialog <Boolean>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function tests whether a connection to the VMS management server is
available.
By default, it displays an error dialog if the connection fails.
The user can optionally suppress the error dialog.

## EXAMPLES

### EXAMPLE 1
```
Test-RpVmsConnection
```

### EXAMPLE 2
```
Test-RpVmsConnection -ShowErrorDialog $false
```

## PARAMETERS

### -ShowErrorDialog
Determines if an error dialog should be shown when the connection fails.
Default is $true (the error dialog will be shown).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
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

[https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection](https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection)

