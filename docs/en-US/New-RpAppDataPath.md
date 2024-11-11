---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# New-RpAppDataPath

## SYNOPSIS
Creates a directory for RemotePro app data, adapting logic from
MilestonePSTools for path handling.

## SYNTAX

```
New-RpAppDataPath [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function, New-RpAppDataPath, combines LOCALAPPDATA with a subdirectory
specific to RemotePro.
It ensures or creates this directory using modified
item management techniques from MilestonePSTools.
Returns the full path.
See link for MilestonePSTool's explanation of AppData usage.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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
## NOTES

## RELATED LINKS

[https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description](https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description)

