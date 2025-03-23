---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Get-RpConfigPath
schema: 2.0.0
---

# Get-RpConfigPath

## SYNOPSIS
Retrieves the path for RemotePro configuration file by using adapted logic from
MilestonePSTools.

## SYNTAX

```
Get-RpConfigPath [-DefaultIds] [<CommonParameters>]
```

## DESCRIPTION
This function, Get-RpConfigurationPath, calls New-RpAppDataPath to get the
app data directory and then appends 'RemoteProParamConfig.json'.
It
showcases path handling adaptations from MilestonePSTools, tailored for log
file retrieval in RemotePro.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DefaultIds
If specified, retrieves the path for the default IDs configuration file.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Get-RpConfigPath](https://www.remotepro.dev/en-US/Get-RpConfigPath)

