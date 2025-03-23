---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Get-RpConnectionProfile
schema: 2.0.0
---

# Get-RpConnectionProfile

## SYNOPSIS
Retrieves and displays RemotePro connection profiles or the credentials XML.

## SYNTAX

### ViewProfiles (Default)
```
Get-RpConnectionProfile [-Name <String>] [-All] [<CommonParameters>]
```

### ViewXml
```
Get-RpConnectionProfile [-ViewXml] [<CommonParameters>]
```

## DESCRIPTION
The Get-RpConnectionProfile function retrieves connection profiles based on
the provided parameters.
It can either show all profiles, a specific profile
by name, or open the credentials XML file for direct viewing.

## EXAMPLES

### EXAMPLE 1
```
Get-RpConnectionProfile -All
```

Displays all available RemotePro connection profiles.

### EXAMPLE 2
```
Get-RpConnectionProfile -Name "ProfileName"
```

Retrieves and displays the connection profile named "ProfileName".

### EXAMPLE 3
```
Get-RpConnectionProfile -ViewXml
```

Opens the credentials XML file associated with RemotePro connection
profiles for direct viewing.

## PARAMETERS

### -Name
The name of the connection profile to retrieve.
Used when the user wants to
view a specific profile.
Only valid in the 'ViewProfiles' parameter set.

```yaml
Type: String
Parameter Sets: ViewProfiles
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
A switch that when specified, retrieves and displays all connection profiles.
Only valid in the 'ViewProfiles' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: ViewProfiles
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewXml
A switch to open the credentials XML file directly.
This is the only option
in the 'ViewXml' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: ViewXml
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- This function is part of the RemotePro PowerShell module and interacts
with video management systems.
- The credentials.xml file contains sensitive information; handle with care.

## RELATED LINKS

[https://www.remotepro.dev/en-US/Get-RpConnectionProfile](https://www.remotepro.dev/en-US/Get-RpConnectionProfile)

