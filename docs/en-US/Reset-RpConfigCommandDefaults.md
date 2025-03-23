---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Reset-RpConfigCommandDefaults
schema: 2.0.0
---

# Reset-RpConfigCommandDefaults

## SYNOPSIS
Resets the RemotePro configuration to default values.

## SYNTAX

```
Reset-RpConfigCommandDefaults [<CommonParameters>]
```

## DESCRIPTION
This function removes existing configuration files and creates new
default configuration files for RemotePro.

Set-RpConfigCommands and Set-RpDefaultConfigCommandIds are called to
populate the RemotePro.ConfigCommands and RemotePro.ConfigCommandDefaultIds
properties.
In the RpControllerObject, these properties are used to store
the configuration commands and their default ids.

## EXAMPLES

### EXAMPLE 1
```
Reset-RpConfigCommandDefaults
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Reset-RpConfigCommandDefaults](https://www.remotepro.dev/en-US/Reset-RpConfigCommandDefaults)

