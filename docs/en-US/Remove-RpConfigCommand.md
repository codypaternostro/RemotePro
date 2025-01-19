---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Remove-RpConfigCommand

## SYNOPSIS
Removes a configuration command from the RemotePro controller object.

## SYNTAX

```
Remove-RpConfigCommand [-CommandName] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Remove-RpConfigCommand cmdlet removes a specified configuration command
from the RemotePro controller object.

## EXAMPLES

### EXAMPLE 1
```
Remove-RpConfigCommand -CommandName "TestCommand"
```

This command removes the configuration command named "TestCommand" from the
RemotePro controller object.

## PARAMETERS

### -CommandName
The name of the configuration command to remove.
This parameter is mandatory
and accepts pipeline input by property name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
