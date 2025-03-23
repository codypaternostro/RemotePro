---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Start-RpRunspaceJob
schema: 2.0.0
---

# Start-RpRunspaceJob

## SYNOPSIS
Starts a PowerShell job in a runspace and tracks it.

## SYNTAX

### UseExistingRunspace (Default)
```
Start-RpRunspaceJob -ScriptBlock <ScriptBlock> [-ArgumentList <Object[]>] [-Argument <Object>]
 [-UseExistingRunspaceState] [-Id] [-uiElement <TextBox>] [-RunspaceJobs <ArrayList>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### NewRunspace
```
Start-RpRunspaceJob [-ModulesToLoad <String[]>] [-AssembliesToLoad <String[]>] [-FunctionsToImport <String[]>]
 -ScriptBlock <ScriptBlock> [-ArgumentList <Object[]>] [-Argument <Object>] [-Id] [-uiElement <TextBox>]
 [-RunspaceJobs <ArrayList>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### UseNewRunspace
```
Start-RpRunspaceJob -ScriptBlock <ScriptBlock> [-ArgumentList <Object[]>] [-Argument <Object>]
 [-UseNewRunspace] [-Id] [-uiElement <TextBox>] [-RunspaceJobs <ArrayList>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function starts a PowerShell job in a runspace and tracks its status.
By default, it uses the existing session state (environment variables and
session variables), but you can create a new runspace with specific modules,
assemblies, and functions loaded.

## EXAMPLES

### EXAMPLE 1
```
Start-RpRunspaceJob -ScriptBlock { Get-Process } -RunspaceJobs $global:RunspaceJobs
```

### EXAMPLE 2
```
Start-RpRunspaceJob -ScriptBlock { Get-Process } -ModulesToLoad @('MyModule') `
```

-AssembliesToLoad @('MyAssembly') -RunspaceJobs $global:RunspaceJobs

## PARAMETERS

### -ModulesToLoad
Modules to load into the runspace environment when not using existing state.

```yaml
Type: String[]
Parameter Sets: NewRunspace
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssembliesToLoad
Assemblies to load into the runspace environment when not using existing state.

```yaml
Type: String[]
Parameter Sets: NewRunspace
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionsToImport
Functions to import into the runspace environment when not using existing state.

```yaml
Type: String[]
Parameter Sets: NewRunspace
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptBlock
The scriptblock to execute in the runspace.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArgumentList
List of arguments to pass to the scriptblock.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -Argument
Single argument to pass to the scriptblock.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseExistingRunspaceState
Uses the current session state (variables and environment) in the new runspace.

```yaml
Type: SwitchParameter
Parameter Sets: UseExistingRunspace
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseNewRunspace
Creates a completely new runspace without using the existing session state.

```yaml
Type: SwitchParameter
Parameter Sets: UseNewRunspace
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
If specified, returns the runspace job ID.

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

### -uiElement
Optional UI TextBox element to update with runspace status.

```yaml
Type: TextBox
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunspaceJobs
Collection of runspace jobs for tracking.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
This function starts a PowerShell job in a runspace and creates identifiers for tracking.
Relies on "$script:RunspaceJobs = \[System.Collections.ArrayList\]::Synchronized((New-Object System.Collections.ArrayList))"

## RELATED LINKS

[https://www.remotepro.dev/en-US/Start-RpRunspaceJob](https://www.remotepro.dev/en-US/Start-RpRunspaceJob)

