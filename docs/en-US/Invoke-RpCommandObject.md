---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Invoke-RpCommandObject
schema: 2.0.0
---

# Invoke-RpCommandObject

## SYNOPSIS
Executes a command object using the call operator (&) by default or
Invoke-Command if specified.

## SYNTAX

```
Invoke-RpCommandObject [-CommandObject] <PSObject> [-UseInvokeCommand] [[-ComputerName] <String[]>]
 [[-PipelineCommandObject] <PSObject>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function accepts a command object (via pipeline or parameter) and
executes it.
You can optionally specify to use Invoke-Command instead
of the default call operator.
The function also validates the command
and parameters before execution.

## EXAMPLES

### EXAMPLE 1
```
Calling Get-RpVmsItemStateCustom from the default config commands.
$commandId = (Get-RpDefaultConfigCommandDetails).'Get-RpVmsItemStateCustom'.Id
$commandObject1 = (Get-RpConfigCommands -All).'Get-RpVmsItemStateCustom' |
                  Format-RpCommandObject -CommandName "Get-RpVmsItemStateCustom" `
                                         -Parameters @{ CommandId = $commandId }
```

Calling Out-HtmlView from the default config commands.
$commandId = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
$outHtmlView = (Get-RpConfigCommands -All).'Out-HtmlView' |
               Format-RpCommandObject -CommandName "Out-HtmlView" \`
                                      -Parameters @{ CommandId = $commandId }

Invoke default config commands with piped results.
Invoke-RpCommandObject -CommandObject $commandObject1 -PipelineCommandObject $outHtmlView

### EXAMPLE 2
```
Format a command object and execute using the call operator.
$commandObject = Format-RpCommandObject -CommandName "Get-RpDataIsFun" `
                 -Parameters @{ Key = "Value" }
```

Pass it via pipeline to invoke.
$commandObject | Invoke-RpCommandObject

This example executes the command using the default call operator.

### EXAMPLE 3
```
Execute the command object on a remote system using Invoke-Command.
$commandObject = Format-RpCommandObject -CommandName "Get-RpDataIsFun" `
                 -Parameters @{ Key = "RemoteValue" }
```

$commandObject | Invoke-RpCommandObject -UseInvokeCommand \`
                 -ComputerName "RemoteServer"

This example executes the command on the specified remote system using Invoke-Command.

## PARAMETERS

### -CommandObject
The command object containing the CommandName and Parameters properties.

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
If UseInvokeCommand is specified, this parameter defines the remote
system(s)to run the command on.

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

### -PipelineCommandObject
An optional object that will be piped into the primary command as input.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Ensure that the command object includes valid CommandName and Parameters.

## RELATED LINKS

[https://www.remotepro.dev/en-US/Invoke-RpCommandObject](https://www.remotepro.dev/en-US/Invoke-RpCommandObject)

