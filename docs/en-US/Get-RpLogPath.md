---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RpLogPath

## SYNOPSIS
Retrieves the path for RemotePro log file by using adapted logic from
MilestonePSTools.

## SYNTAX

```
Get-RpLogPath [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function, Get-RpLog, calls New-RpAppDataPath to get the app data
directory and then appends 'RemoteProLog.txt'.
It showcases path handling
adaptations from MilestonePSTools, tailored for log file retrieval in
RemotePro.

## EXAMPLES

### EXAMPLE 1
```
Get-RpLogPath
```

This example retrieves the path for the RemotePro log file.

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

[https://www.remotepro.dev/en-US/Get-RpLogPath](https://www.remotepro.dev/en-US/Get-RpLogPath)

