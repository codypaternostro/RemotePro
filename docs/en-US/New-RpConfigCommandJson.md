---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# New-RpConfigCommandJson

## SYNOPSIS
Creates a new configuration JSON file for RemotePro.

## SYNTAX

```
New-RpConfigCommandJson [-Type] <String> [[-ConfigFilePath] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-RpConfigCommandJson function creates a new configuration JSON file
based on the specified type.
It supports creating a default JSON configuration
or an empty JSON configuration.
The function also allows specifying a custom
path for the configuration file, defaulting to the application data location
if not provided.

## EXAMPLES

### EXAMPLE 1
```
New-RpConfigCommandJson -Type "DefaultJson"
```

Creates a default JSON configuration file at the default application data
location.

### EXAMPLE 2
```
New-RpConfigCommandJson -Type "EmptyJson" -ConfigFilePath "C:\Config\config.json"
```

Creates an empty JSON configuration file at the specified path.

## PARAMETERS

### -Type
Specifies the type of JSON to be created.
Valid values are "DefaultJson" and
"EmptyJson".
This parameter is mandatory.

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

### -ConfigFilePath
Specifies the path where the configuration file will be saved.
If not provided,
the default application data location is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
