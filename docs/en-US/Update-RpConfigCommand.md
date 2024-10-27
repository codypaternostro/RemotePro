---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection
schema: 2.0.0
---

# Update-RpConfigCommand

## SYNOPSIS
Modifies configuration parameters of a specified command in a PowerShell
module using a configuration JSON file or an interactive WPF-based GUI.

## SYNTAX

### ShowDialog (Default)
```
Update-RpConfigCommand -ModuleName <String> -CommandName <String> -Id <Int32> -ConfigFilePath <String>
 [-ShowDialog] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ConfigurationItems
```
Update-RpConfigCommand -ModuleName <String> -CommandName <String> -Id <Int32> [-ParameterValues <Hashtable>]
 -ConfigFilePath <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### NoDialog
```
Update-RpConfigCommand [-ParameterValues <Hashtable>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Update-RpConfigCommand\` function is used to load and modify parameters for
a specified command within a PowerShell module.
The function retrieves
configuration information from a JSON file and supports updating parameters
either by launching a GUI (if \`-ShowDialog\` is specified) or by directly
passing a hashtable of parameter values through the \`-ParameterValues\`
parameter.
The updated configuration is saved back to the JSON file,
preserving all previous configurations.

By default, the function opens a GUI for parameter editing, making it
user-friendly for interactive scenarios.
Advanced users and scripts can also
bypass the GUI and pass values directly through \`-ParameterValues\`.

## EXAMPLES

### EXAMPLE 1
```
Update-RpConfigCommand -ModuleName 'MilestonePSTools' -CommandName
'Get-VmsCameraReport' -Id 18 -ConfigFilePath $(Get-Rpconfigpath) -ShowDialog
```

This example loads the configuration for the 'Get-VmsCameraReport' command in
the 'MilestonePSTools' module and opens a GUI dialog to allow users to
interactively edit parameter values.
Once edited, the configuration is saved
back to the JSON file.

### EXAMPLE 2
```
Update-RpConfigCommand -ModuleName 'MilestonePSTools' -CommandName
'Get-VmsCameraReport' -Id 18 -ConfigFilePath $(Get-Rpconfigpath) -ParameterValues
@{ "Verbose" = $true; "Debug" = $false }
```

This example directly sets the 'Verbose' and 'Debug' parameters without
opening the GUI.
A hashtable is provided via the \`-ParameterValues\`
parameter, which updates the configuration in the JSON file with these
values.

## PARAMETERS

### -ModuleName
The name of the module containing the command to be modified.
This parameter
is mandatory and required for identifying the correct module in the
configuration.

```yaml
Type: String
Parameter Sets: ShowDialog, ConfigurationItems
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandName
The name of the specific command to be modified within the module.
This
parameter is mandatory and helps locate the command configuration within the
JSON file.

```yaml
Type: String
Parameter Sets: ShowDialog, ConfigurationItems
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
A unique integer ID identifying the command version in the configuration
file.
This ensures that specific versions of the command can be targeted
and modified.

```yaml
Type: Int32
Parameter Sets: ShowDialog, ConfigurationItems
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParameterValues
(Optional) A hashtable containing parameter names as keys and their desired
values as values.
Use this parameter to bypass the GUI and directly update
the command configuration with the specified values.

```yaml
Type: Hashtable
Parameter Sets: ConfigurationItems, NoDialog
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ConfigFilePath
The path to the configuration JSON file where command configurations are
stored.
This file is required and will be updated with any modified
parameter values.

```yaml
Type: String
Parameter Sets: ShowDialog, ConfigurationItems
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowDialog
(Optional) Displays a WPF GUI dialog for interactive parameter editing.
If
this switch is specified, any \`ParameterValues\` passed directly will be
ignored, and the GUI will allow users to make adjustments.

```yaml
Type: SwitchParameter
Parameter Sets: ShowDialog
Aliases:

Required: False
Position: Named
Default value: False
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
The configuration file must be in JSON format and already include a structure
for \`ConfigCommands\` and the specified module.
Any missing structure will
cause an error.

Note: The order of parameters in the GUI may not match the JSON file order
due to how PowerShell handles JSON deserialization.
To ensure a specific
order, consider using an \`OrderedDictionary\` or manually managing parameter
order.

Ensure that the \`PresentationFramework\`, \`PresentationCore\`, and \`WindowsBase\`
assemblies are available for WPF support to allow the GUI dialog to open.

## RELATED LINKS
