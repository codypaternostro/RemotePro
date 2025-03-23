---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpDefaultConfigCommandIds
schema: 2.0.0
---

# Set-RpDefaultConfigCommandIds

## SYNOPSIS
Sets the default configuration command IDs for RemotePro.

## SYNTAX

```
Set-RpDefaultConfigCommandIds [[-ConfigFilePath] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-RpDefaultConfigCommandIds function initializes and sets the default
configuration command IDs for the RemotePro object.
If the RemotePro object
is not initialized, an error is thrown.
The function can take an optional
ConfigFilePath parameter to specify the path to the configuration file.
If
the ConfigFilePath is not provided, it uses the default path from
Get-RpConfigPath.

## EXAMPLES

### EXAMPLE 1
```
Set-RpDefaultConfigCommandIds -ConfigFilePath "$(Get-RpConfigPath -DefaultIds)"
```

Initializes and sets the default configuration command IDs using the
specified configuration file.

### EXAMPLE 2
```
Set-RpDefaultConfigCommandIds
```

Initializes and sets the default configuration command IDs using the default
configuration file path.

## PARAMETERS

### -ConfigFilePath
Optional.
Specifies the path to the configuration file.
If not provided,
the default path is used.

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

## NOTES
Ensure that the RemotePro object is initialized by running
New-RpControllerObject before calling this function.

## RELATED LINKS

[https://www.remotepro.dev/en-US/Set-RpDefaultConfigCommandIds](https://www.remotepro.dev/en-US/Set-RpDefaultConfigCommandIds)

