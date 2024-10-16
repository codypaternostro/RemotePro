---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection
schema: 2.0.0
---

# Watch-RpRunspaces

## SYNOPSIS
Monitors and manages runspaces running in the background.

## SYNTAX

```
Watch-RpRunspaces [[-LogPath] <String>] [[-uiElement] <TextBox>] [[-RunspaceJobs] <ArrayList>]
 [[-RunspaceResults] <ArrayList>] [[-OpenRunspaces] <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function iterates through the collection of runspace jobs and checks
if they have completed.
For completed jobs, it collects the results,
logs the output, updates the UI (if provided), and safely removes the
job from the global collection.

## EXAMPLES

### EXAMPLE 1
```
Watch-RpRunspaces -LogPath "C:\Logs\RunspaceLog.txt" `
    -uiElement $textBoxElement -RunspaceJobs $script:RunspaceJobs `
    -RunspaceResults $script:RunspaceResults -OpenRunspaces $script:openRunspaces
```

## PARAMETERS

### -LogPath
The path to the log file where job statuses and results are logged.
This is mandatory.

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

### -uiElement
The UI TextBox element that displays job statuses and messages.
This is optional.

```yaml
Type: TextBox
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunspaceJobs
A synchronized \`ArrayList\` that tracks runspaces currently running in the background.
This is mandatory.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunspaceResults
A synchronized \`ArrayList\` that stores the results from completed runspaces.
This is mandatory.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenRunspaces
A PSObject that holds static information about open runspaces and their jobs.
This is mandatory.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
- The function relies on the following module variables and collections:
    - Initialize-RpRunspaceJobs
        \`$script:RunspaceJobs\`: Tracks each runspace dispatched.
    - Initialize-RpRunspaceResults
        \`$script:RunspaceResults\`: Collects results from runspaces.
    - Initialize-RpOpenRunspaces
        \`$script:openRunspaces\`: Static collection of active runspaces.

- The log path is determined using the \`Get-RpLogPath\` cmdlet, which provides
    the path to the RemotePro AppData location.

- UI updates rely on a TextBox control (\`$uiElement\`), where job and status messages
    are displayed. This UI element must be bound to "Runspace_Mutex_Log" for proper updates.

## RELATED LINKS