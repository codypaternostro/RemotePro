---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Import-RpDefaultConfigCommandIds
schema: 2.0.0
---

# Import-RpDefaultConfigCommandIds

## SYNOPSIS
Imports default configuration command IDs from a specified JSON file.

## SYNTAX

```
Import-RpDefaultConfigCommandIds [[-ConfigFilePath] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function loads a JSON configuration file containing command IDs,
parses it, and returns a hashtable-like object where each command name
is a top-level key and contains a nested object with its Id.

## EXAMPLES

### EXAMPLE 1
```
Import-RpDefaultConfigCommandIds -ConfigFilePath $(Get-RpConfigPath -DefaultIds)
```

## PARAMETERS

### -ConfigFilePath
The path to the JSON configuration file.
If not provided, the function
attempts to retrieve the default path.

A hashtable object where each key is the CommandName and its value
is a nested object containing an Id.

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

## RELATED LINKS

[https://www.remotepro.dev/en-US/Import-RpDefaultConfigCommandIds](https://www.remotepro.dev/en-US/Import-RpDefaultConfigCommandIds)

