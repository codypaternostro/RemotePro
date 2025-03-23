---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Set-RpConnectionProfile

## SYNOPSIS
Sets RemotePro connection profiles based on Excel file input.

## SYNTAX

### ProcessProfiles (Default)
```
Set-RpConnectionProfile -ExcelFilePath <String> [<CommonParameters>]
```

### CreateTemplate
```
Set-RpConnectionProfile -ExcelFilePath <String> [-CreateTemplate] [<CommonParameters>]
```

## DESCRIPTION
The Set-RpConnectionProfile function manages RemotePro connection profiles.
It can process profiles from an Excel file or create a blank template for
profiles.
It uses different parameter sets to handle these tasks.
See link for MilestonePSTool's explanation of AppData usage.

## EXAMPLES

### EXAMPLE 1
```
Set-RpConnectionProfile -ExcelFilePath "path\to\file.xlsx"
```

Processes connection profiles from the specified Excel file.

### EXAMPLE 2
```
Set-RpConnectionProfile -ExcelFilePath "path\to\template.xlsx" -CreateTemplate
```

Creates a blank template at the specified path for entering connection
profiles.

## PARAMETERS

### -ExcelFilePath
Path to the Excel file.
This file contains connection profiles or is the
location where a new template will be created.
Mandatory in both
'ProcessProfiles' and 'CreateTemplate' parameter sets.

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

### -CreateTemplate
Switch to create a blank Excel template.
Includes columns necessary for
defining connection profiles.
Mandatory in 'CreateTemplate' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: CreateTemplate
Aliases:

Required: True
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
- Ensure the Excel file ends with .xlsx when creating a new template.
- Profiles are validated and saved into the system upon processing.
- Errors during the creation or processing of profiles are outputted as
PowerShell errors.

## RELATED LINKS

[https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description](https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description)

[https://www.remotepro.dev/en-US/Set-RpConnectionProfile](https://www.remotepro.dev/en-US/Set-RpConnectionProfile)

