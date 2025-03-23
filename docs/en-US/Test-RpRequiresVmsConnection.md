---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://remotepro.dev/en-US/Test-RpRequiresVmsConnection
schema: 2.0.0
---

# Test-RpRequiresVmsConnection

## SYNOPSIS
Tests if a VMS connection is required and attempts to assert the connection.

## SYNTAX

```
Test-RpRequiresVmsConnection [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Test-RequiresVmsConnection function checks if a VMS connection is
required using the Assert-VmsRequirementsMet cmdlet.
If the connection
requirements are not met, it displays a warning message box and exits.

## EXAMPLES

### EXAMPLE 1
```
Test-RequiresVmsConnection
```

This command checks if a VMS connection is required and asserts the
connection.

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
For more information, visit:
https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection

## RELATED LINKS

[https://remotepro.dev/en-US/Test-RpRequiresVmsConnection](https://remotepro.dev/en-US/Test-RpRequiresVmsConnection)

