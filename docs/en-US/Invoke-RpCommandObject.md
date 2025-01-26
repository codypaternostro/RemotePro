---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Invoke-RpCommandObject

## SYNOPSIS
Executes a command from a RemotePro command object.

## SYNTAX

```
Invoke-RpCommandObject [-CommandObject] <PSObject> [-UseInvokeCommand] [[-ComputerName] <String[]>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a command object, ensures the associated module is imported,
and invokes the specified command with its parameters.
It includes robust parsing
for text-based parameters and key-value pairs.

## EXAMPLES

### EXAMPLE 1
```
Invoke-RpCommandObject -CommandObject $commandObject -Id "18"
Executes the command with ID 18 from the provided command object.
```

## PARAMETERS

### -CommandObject
The command object containing details like ModuleName, CommandName, Id, and Parameters.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UseInvokeCommand
Switch to use Invoke-Command instead of the default call operator.

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

### -ComputerName
If UseInvokeCommand is specified, this parameter defines the remote system(s)
to run the command on.

```yaml
Type: String[]
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
