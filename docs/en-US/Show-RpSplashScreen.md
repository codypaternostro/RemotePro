---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Show-RpSplashScreen
schema: 2.0.0
---

# Show-RpSplashScreen

## SYNOPSIS
Displays a centered splash screen with RemotePro icon and text while the main window loads.

## SYNTAX

```
Show-RpSplashScreen [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function displays a minimal WPF splash screen with transparency, centered on
screen.
It sets the icon via Set-RpWindowIcon and returns the splash window object
so the caller can close or update it after the main window is ready.

## EXAMPLES

### EXAMPLE 1
```
$splash = Show-RpSplashScreen
```

Start-Sleep -Seconds 5
$splash.Close()

## PARAMETERS

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

### System.Windows.Window - Splash window reference for later closing or manipulation.
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Show-RpSplashScreen](https://www.remotepro.dev/en-US/Show-RpSplashScreen)

