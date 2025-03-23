---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpEventHandlers
schema: 2.0.0
---

# Set-RpEventHandlers

## SYNOPSIS
Initializes and populates the EventHandlers property of the RemotePro object
with predefined event handler scripts.

## SYNTAX

```
Set-RpEventHandlers [<CommonParameters>]
```

## DESCRIPTION
The Set-RpEventHandlers cmdlet sets up predefined event handlers for various
operations in the RemotePro environment.
These handlers are stored in the
EventHandlers property, which is a hashtable that allows quick lookup and
execution of event-specific scripts.

Each handler is linked to an event (such as button clicks, text changes, or
UI interactions) and defines the actions to be triggered when the event occurs.
If the EventHandlers property does not exist or is not a hashtable, it is
initialized as an empty hashtable.
Each event handler is added to this hashtable
as a key-value pair, where the key is the event name and the value is the scriptblock.

Additionally, the EventHandlers hashtable is assigned a custom type
'RemotePro.EventHandlers' for easy identification and future use.

## EXAMPLES

### EXAMPLE 1
```
Set-RpEventHandlers
```

This example initializes the EventHandlers hashtable and populates it with
predefined event handlers.
Each event is associated with a specific scriptblock
to handle UI actions.

### EXAMPLE 2
```
Set-RpEventHandlers
```

$handlers = $script:RemotePro.EventHandlers
$handlers\["OpenFile_Click"\]

This example sets up the EventHandlers property, retrieves all event handlers,
and fetches the handler for the "OpenFile_Click" event.

### EXAMPLE 3
```
Set-RpEventHandlers
```

$handler = $script:RemotePro.EventHandlers\["NewConnectionFile_Click"\]
& $handler

This example sets up the event handlers, retrieves the scriptblock for
"NewConnectionFile_Click", and executes the scriptblock.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- The EventHandlers property is part of the RemotePro object and should be
initialized with New-RpControllerObject before running this cmdlet.
- This cmdlet does not return output unless errors occur during initialization
or event handler assignment.
- Event handlers are stored as scriptblocks in the EventHandlers hashtable
and can be invoked based on user interactions.
- See **New-RpControllerObject** and **Get-RpEventHandlers**

## RELATED LINKS

[https://www.remotepro.dev/en-US/Set-RpEventHandlers](https://www.remotepro.dev/en-US/Set-RpEventHandlers)

