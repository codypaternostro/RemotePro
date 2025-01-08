---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Import-RpConfig

## SYNOPSIS
Imports and processes a configuration JSON file for RemotePro.

## SYNTAX

```
Import-RpConfig [[-ConfigFilePath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-RpConfig function reads a JSON configuration file, converts it into
a PowerShell object, and processes each module and command defined in the
configuration.
It creates a hashtable of modules, each containing a collection
of commands with their details and parameters.
Each command object includes an
InvokeCommand method to execute the command with its parameters.

## EXAMPLES

### EXAMPLE 1
```
Import-RpConfig -ConfigFilePath "C:\Path\To\Config.json"
Imports and processes the configuration from the specified JSON file.
```

### EXAMPLE 2
```
Import-RpConfig
Imports and processes the configuration using the default path.
```

## PARAMETERS

### -ConfigFilePath
Specifies the path to the configuration JSON file.
If not provided, the
function will use a default path obtained from Get-RPConfigPath.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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
The function adds custom type names to the objects for better identification
and processing.
It also includes verbose logging for detailed execution
information.

The following propeties are added to the command object:
ModuleName, CommandName, Id, Description, and Parameters.

The following methods are added to the command object:
InvokeCommand: A method to execute the command with its parameters.

## RELATED LINKS
