---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpConfigDefaults
schema: 2.0.0
---

# Set-RpConfigDefaults

## SYNOPSIS
Sets the default configuration for RemotePro.

## SYNTAX

```
Set-RpConfigDefaults [[-ConfigFilePath] <String>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet sets the default configuration values for the RemotePro
application.
It ensures that all necessary settings are initialized
with their default values.

## EXAMPLES

### EXAMPLE 1
```
Set-RpConfigDefaults -ConfigFilePath "C:\Config\RemoteProConfig.json"
```

This example sets the default configuration values in the specified configuration file.

## PARAMETERS

### -ConfigFilePath
The path to the configuration file where the default settings will
be applied.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string] The path to the configuration file where the default settings will be applied.
## OUTPUTS

### None. This cmdlet does not produce any output.
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Set-RpConfigDefaults](https://www.remotepro.dev/en-US/Set-RpConfigDefaults)

