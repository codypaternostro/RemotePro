---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpRunspaceEvents
schema: 2.0.0
---

# Set-RpRunspaceEvents

## SYNOPSIS
Initializes and populates the RunspaceEvents property of the RemotePro
object with predefined event handlers.

## SYNTAX

```
Set-RpRunspaceEvents [<CommonParameters>]
```

## DESCRIPTION
The Set-RpRunspaceEvents cmdlet sets up event handlers for specific
operations in the RemotePro environment.
These handlers are stored in
the RunspaceEvents property, a hashtable allowing fast lookup and
execution of event-specific scripts.

Each handler is linked to an event (e.g., button clicks or UI actions)
and defines the actions triggered by the event.
If RunspaceEvents does
not exist, it is initialized as an empty hashtable.
The event handlers
are then added as key-value pairs where the key is the event name and
the value is the scriptblock.

Additionally, the hashtable is assigned a custom type
'RemotePro.RunspaceEvents' for identification and future use.

## EXAMPLES

### EXAMPLE 1
```
Set-RpRunspaceEvents
```

This example initializes the RunspaceEvents hashtable and adds event
handlers to it, associating each event with its respective scriptblock
to handle user actions.

### EXAMPLE 2
```
Set-RpRunspaceEvents
```

$events = Get-RpRunspaceEvents -All
$events\["CamReport_Click"\]

This example sets up the event handlers, retrieves all RunspaceEvents,
and fetches the handler for the "CamReport_Click" event.

### EXAMPLE 3
```
Set-RpRunspaceEvents
```

$handler = Get-RpRunspaceEvents -Name "ShowCameras_Click"
& $handler

This example sets up the event handlers, retrieves the scriptblock for
"ShowCameras_Click", and invokes the scriptblock.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- The RunspaceEvents hashtable is part of the RemotePro object and
  should be initialized with New-RpControllerObject before running
  this cmdlet.
- This cmdlet does not return output unless errors occur during
  initialization or event assignment.
- Event handlers are defined as scriptblocks and can be invoked
  based on user interactions.
- See New-RpControllerObject and Get-RpRunspaceEvents

## RELATED LINKS

[https://www.remotepro.dev/en-US/Set-RpRunspaceEvents](https://www.remotepro.dev/en-US/Set-RpRunspaceEvents)

