---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/New-RpControllerObject
schema: 2.0.0
---

# New-RpControllerObject

## SYNOPSIS
Creates a new ControllerObject for RemotePro.

## SYNTAX

```
New-RpControllerObject [-Refresh] [<CommonParameters>]
```

## DESCRIPTION
The New-RpControllerObject cmdlet creates a new RemotePro object, which
includesproperties like EventHandlers.
This object is typed as \`RemotePro\`
and can be used to manage various aspects of the RemotePro environment.

## EXAMPLES

### EXAMPLE 1
```
$remotePro = New-RpControllerObject
```

This example creates a new RemotePro ControllerObject.

### EXAMPLE 2
```
$remotePro = New-RpControllerObject -Refresh
```

This example forces the creation of a new RemotePro ControllerObject even
if one already exists.

## PARAMETERS

### -Refresh
Forces the creation of a new RemotePro ControllerObject even if one already
exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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

## RELATED LINKS

[https://www.remotepro.dev/en-US/New-RpControllerObject](https://www.remotepro.dev/en-US/New-RpControllerObject)

