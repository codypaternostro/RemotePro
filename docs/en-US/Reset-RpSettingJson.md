---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Reset-RpSettingJson

## SYNOPSIS
Resets the RemotePro settings to default values.

## SYNTAX

```
Reset-RpSettingJson [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function removes existing settings files and creates a new default
settings file for RemotePro.

\`Add-RpSettingJson\` is called to populate the RemotePro settings file with
default settings.

## EXAMPLES

### EXAMPLE 1
```
Reset-RpSettingJson
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
