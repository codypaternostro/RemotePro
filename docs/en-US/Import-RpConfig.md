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
This function reads a JSON configuration file, converts it into a PowerShell
object, and processes each module and command defined in the file.
It returns a
hashtable where each key represents a module, and the value is another hashtable
containing the module's commands.
Each command object includes properties like
CommandName, Id, Description, and Parameters, as well as a method
FormatCommandObject\` to prepare the command for execution.

The command object can be accessed using dot notation for easy navigation, and
the FormatCommandObject method allows you to add or modify parameters before
execution.

Using Invoke-RpCommandObject, you can execute the formatted command locally where
as remotely is experimental...

## EXAMPLES

### EXAMPLE 1
```
Import configuration from a specified file
$modules = Import-RpConfig -ConfigFilePath $(Get-RpConfigPath)
```

### EXAMPLE 2
```
Import configuration using the default path
$modules = Import-RpConfig
```

### EXAMPLE 3
```
Access and format a specific command object
$commandObject = $modules.RemotePro.'Get-RpVmsHardwareCustom'.'1234-5678'
```

### EXAMPLE 4
```
Execute the formatted command locally using the call operator
& $preparedCommand.CommandName @($preparedCommand.Parameters)
```

### EXAMPLE 5
```
Calling Get-RpVmsItemStateCustom from the default config commands.
$commandId = (Get-RpDefaultConfigCommandDetails).'Get-RpVmsItemStateCustom'.Id
$preparedCommand1 = (Get-RpConfigCommands -All).'Get-RpVmsItemStateCustom'.$commandId.FormatCommandObject($commandId)
```

Calling Out-HtmlView from the default config commands.
$commandId = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
$preparedCommand2 = (Get-RpConfigCommands -All).'Out-HtmlView'.$commandId.FormatCommandObject($commandId)

Invoke default config commands.
Invoke-RpCommandObject -CommandObject $preparedCommand1 | Invoke-RpCommandObject  -CommandObject $preparedCommand2

### EXAMPLE 6
```
Use Invoke-RpCommandObject for execution
$preparedCommand | Invoke-RpCommandObject
```

### EXAMPLE 7
```
Use Invoke-RpCommandObject for remote execution
$preparedCommand | Invoke-RpCommandObject -UseInvokeCommand -ComputerName "RemoteServer"
```

## PARAMETERS

### -ConfigFilePath
The path to the configuration JSON file.
If not provided, the function uses the
default path returned by the \`Get-RpConfigPath\` function.

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

### Hashtable
### Returns a hashtable of modules, where each module contains commands as nested
### objects.
## NOTES
- Modules and commands are structured as nested hashtables for easy navigation.
- The FormatCommandObject method dynamically adds or modifies parameters.
- Ensure the configuration JSON file follows the required schema for modules and
  commands.
- Use dot notation to navigate the resulting $modules hashtable.

## RELATED LINKS
