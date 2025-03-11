---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Get-RpConfigCommands
schema: 2.0.0
---

# Get-RpConfigCommands

## SYNOPSIS
Retrieves RemotePro configuration commands.

## SYNTAX

```
Get-RpConfigCommands [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpConfigCommands function retrieves configuration commands from
the RemotePro controller object.
If the -All switch is specified, it
returns all configuration commands; otherwise, it returns the
configuration commands as a single object.

## EXAMPLES

### EXAMPLE 1
```
Get-RpConfigCommands
```

Retrieves the configuration commands as a single object.

### EXAMPLE 2
```
Get-RpConfigCommands -All
```

Retrieves all configuration commands as an array of values.

## PARAMETERS

### -All
If specified, retrieves all configuration commands as an hashtable of values.

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

### System.Collections.Hashtable
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Get-RpConfigCommands](https://www.remotepro.dev/en-US/Get-RpConfigCommands)

