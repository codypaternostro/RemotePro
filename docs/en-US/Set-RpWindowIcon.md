---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpWindowIcon
schema: 2.0.0
---

# Set-RpWindowIcon

## SYNOPSIS
Sets the icon for a specified WPF window and its taskbar item.

## SYNTAX

```
Set-RpWindowIcon [-Window] <Window> [[-MemoryStream] <MemoryStream>] [[-IconPath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This function sets the icon for a WPF window using either a file path or a memory stream.
It prioritizes the provided MemoryStream and falls back to IconPath if needed.
If both are missing, it attempts to use a module-scoped MemoryStream @ $script:RpIconStream.

## EXAMPLES

### EXAMPLE 1
```
Set-RpWindowIcon -window $mainWindow -IconPath (Get-RpIconPath)
```

Uses the provided icon file path.

### EXAMPLE 2
```
Set-RpWindowIcon -window $mainWindow -MemoryStream $iconStream
```

Uses the provided memory stream.

### EXAMPLE 3
```
Set-RpWindowIcon -window $mainWindow
```

Uses the default module-scoped memory stream $script:RpIconStream.

## PARAMETERS

### -Window
The WPF window object for which the icon will be set.

```yaml
Type: Window
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemoryStream
The memory stream containing the icon image.

```yaml
Type: MemoryStream
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconPath
The file path to the icon image.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

[https://www.remotepro.dev/en-US/Set-RpWindowIcon](https://www.remotepro.dev/en-US/Set-RpWindowIcon)

