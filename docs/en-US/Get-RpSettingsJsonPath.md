---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RpSettingsJsonPath

## SYNOPSIS
Retrieves the file path for the RemotePro settings JSON file.

## SYNTAX

```
Get-RpSettingsJsonPath [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpSettingsJsonPath function constructs and returns the file path for the
RemoteProSettings.json file located in the 'Settings' directory within the
application data path.
If the 'Settings' directory does not exist, it is created.

## EXAMPLES

### EXAMPLE 1
```
Get-RpSettingsJsonPath
C:\Users\<User>\AppData\Local\RemotePro\Settings\RemoteProSettings.json
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

### System.String
### The file path to the RemoteProSettings.json file.
## NOTES

## RELATED LINKS
