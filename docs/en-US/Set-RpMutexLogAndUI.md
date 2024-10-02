---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Set-RpMutexLogAndUI

## SYNOPSIS
Logs a message and updates a UI element with the same message.

## SYNTAX

### LogAndUI (Default)
```
Set-RpMutexLogAndUI [-mutexName <String>] -logPath <String> -message <String> [-uiElement <TextBox>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### LogOnly
```
Set-RpMutexLogAndUI [-mutexName <String>] -logPath <String> -message <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function logs a message to a specified log file and updates a
UI element (TextBox) with the same message.
If the UI element is not
provided, it will only log the message.

## EXAMPLES

### EXAMPLE 1
```
Set-RpMutexLogAndUI -logPath "C:\logs\logfile.txt" -message "Task completed." `
    -uiElement $textBoxElement
```

### EXAMPLE 2
```
Set-RpMutexLogAndUI -logPath "C:\logs\logfile.txt" -message "Task completed."
```

## PARAMETERS

### -mutexName
The name of the Mutex used to ensure exclusive access.
Defaults to a GUID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [System.Guid]::NewGuid().ToString()
Accept pipeline input: False
Accept wildcard characters: False
```

### -logPath
The path to the log file where the message will be recorded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -message
The actual text that will be logged and optionally shown in the UI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uiElement
The TextBox UI element to be updated with the message.

```yaml
Type: TextBox
Parameter Sets: LogAndUI
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

## RELATED LINKS
