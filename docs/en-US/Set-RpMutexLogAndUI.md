---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpMutexLogAndUI
schema: 2.0.0
---

# Set-RpMutexLogAndUI

## SYNOPSIS
Logs a message and updates a UI element with the same message.

## SYNTAX

### LogAndUI (Default)
```
Set-RpMutexLogAndUI [-MutexName <String>] -LogPath <String> -Message <String> [-UiElement <TextBox>]
 [<CommonParameters>]
```

### LogOnly
```
Set-RpMutexLogAndUI [-MutexName <String>] -LogPath <String> -Message <String> [<CommonParameters>]
```

## DESCRIPTION
This function logs a message to a specified log file and updates a
UI element (TextBox) with the same message.
If the UI element is not
provided, it will only log the message.

## EXAMPLES

### EXAMPLE 1
```
Set-RpMutexLogAndUI -logPath "$(Get-RpLogPath)" -message "Task completed." -uiElement $textBoxElement
```

This example logs the message "Task completed." to the log file and updates the
UI element with the same message.

### EXAMPLE 2
```
Set-RpMutexLogAndUI -logPath "$(Get-RpLogPath)"  -message "Task completed."
```

This example logs the message "Task completed." to the log file without updating
the UI.

## PARAMETERS

### -MutexName
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

### -LogPath
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

### -Message
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

### -UiElement
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Set-RpMutexLogAndUI](https://www.remotepro.dev/en-US/Set-RpMutexLogAndUI)

