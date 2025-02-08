---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Set-RpConfigCommands

## SYNOPSIS
Sets the configuration commands for the RemotePro object.

## SYNTAX

```
Set-RpConfigCommands [[-ConfigFilePath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-RpConfigCommands function initializes and sets the configuration
commands for the RemotePro object.
If the RemotePro object is not initialized,
an error is thrown.
The function imports configuration commands from a specified
file path or uses a default path if none is provided.

## EXAMPLES

### EXAMPLE 1
```
Set-RpConfigCommands -ConfigFilePath "C:\Path\To\ConfigFile.json"
This example sets the configuration commands using the specified configuration
file path.
```

### EXAMPLE 2
```
Set-RpConfigCommands
This example sets the configuration commands using the default configuration
file path.
```

## PARAMETERS

### -ConfigFilePath
The file path to the configuration file.
If not provided, a default path is used.

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
Ensure that the RemotePro object is initialized by running New-RpControllerObject
before calling this function.

## RELATED LINKS
