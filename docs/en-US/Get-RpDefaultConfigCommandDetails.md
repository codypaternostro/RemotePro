---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RpDefaultConfigCommandDetails

## SYNOPSIS
Retrieves the default configuration commands from the RemotePro controller
object.

## SYNTAX

```
Get-RpDefaultConfigCommandDetails [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpDefaultConfigCommands function is used to retrieve the default
configuration commands from the RemotePro controller object.
It utilizes the
Get-RpControllerObject cmdlet to fetch the property ConfigCommandDefaultIds.

## EXAMPLES

### EXAMPLE 1
```
Get-RpDefaultConfigCommands
```

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

## RELATED LINKS
