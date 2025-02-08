---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f
schema: 2.0.0
---

# Start-RpRunspaceMonitor

## SYNOPSIS
Experienced issues calling this command.
The function is not used in the
module yet.
Starts a monitor for runspaces with a specified interval.

## SYNTAX

```
Start-RpRunspaceMonitor [-LogPath] <String> [-uiElement] <TextBox> [-RunspaceJobs] <ArrayList>
 [-RunspaceResults] <ArrayList> [[-OpenRunspaces] <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Experienced issues calling this command.
The function is not used in the
module yet.
The Start-RpRunspaceMonitor function initializes and starts a timer that
periodically checks the status of runspaces.
It uses the Watch-RpRunspaces
function to perform the monitoring tasks.
The timer interval is set to 2
seconds.

## EXAMPLES

### EXAMPLE 1
```
$timer = Start-RpRunspaceMonitor -LogPath "C:\Logs\runspace.log" `
    -uiElement $textBox -RunspaceJobs $jobs -RunspaceResults $results
```

This example starts the runspace monitor with the specified log path, UI
element, runspace jobs, and runspace results.
The timer object is stored
in the $timer variable.

## PARAMETERS

### -LogPath
Specifies the path to the log file where runspace monitoring information
will be recorded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uiElement
Specifies the UI element (TextBox) where runspace monitoring information
will be displayed.

```yaml
Type: TextBox
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunspaceJobs
Specifies the collection of runspace jobs to be monitored.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunspaceResults
Specifies the collection of runspace results to be monitored.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenRunspaces
Specifies the collection of open runspaces.
This parameter is optional.

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
Experienced issues calling this command.
The function is not used in the
module yet.

## RELATED LINKS
