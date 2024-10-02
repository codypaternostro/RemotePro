---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version:
schema: 2.0.0
---

# Start-RpRunspaceJobStatic

## SYNOPSIS
Starts static runspace jobs and tracks them in a global collection.

## SYNTAX

```
Start-RpRunspaceJobStatic [-Jobs] <Array> [-uiElement] <TextBox>
 [-OpenRunspaces] <System.Collections.ObjectModel.ObservableCollection`1[System.Object]>
 [[-RunspaceJobs] <ArrayList>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet starts multiple static runspace jobs.
Each job is defined
with a JobName and JobDetailsVariableName, ensuring consistent and
predictable job handling.
The job details (including JobName, Runspace
ID, and Instance ID) are added to a global collection
($script:RpOpenRunspaces.Jobs) for tracking.

## EXAMPLES

### EXAMPLE 1
```
Define the jobs to run
$jobsToRun = @(
    @{
        JobName                = "VmsCameraReportJob"
        JobDetailsVariableName = "VmsCameraReportJobDetails"
        Description            = "Fetches the VMS Camera Report"
        ScriptBlock            = { Write-Host "Fetching VMS Camera Report..." }
    },
    @{
        JobName                = "ShowCameraJob"
        JobDetailsVariableName = "ShowCameraJobDetails"
        Description            = "Displays the camera feed"
        ScriptBlock            = { Write-Host "Displaying Camera Feed..." }
    }
)
```

Start the runspace jobs
$script:RpOpenRunspaces = Start-RpRunspaceJobStatic
    -Jobs $jobsToRun
    -uiElement $script:Runspace_Mutex_Log
    -OpenRunspaces $script:RpOpenRunspaces
    -RunspaceJobs $script:RunspaceJobs
    -Verbose

This will start two jobs: one to fetch a VMS camera report and
another to display the camera feed.
The job details will be stored
in $script:RpOpenRunspaces.Jobs.

## PARAMETERS

### -Jobs
An array of job definitions.
Each job definition is a hashtable with
the following keys:
- **JobName**: A string that defines the name of the job.
- **JobDetailsVariableName**: The variable name for the job details.
- **Description**: A string describing the job's purpose.
- **ScriptBlock**: The code that will be executed within the runspace.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uiElement
A \`System.Windows.Controls.TextBox\` used to pass logs from the runspace job.

```yaml
Type: TextBox
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenRunspaces
A collection (ObservableCollection) that stores the details of all
runspace jobs.

```yaml
Type: System.Collections.ObjectModel.ObservableCollection`1[System.Object]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunspaceJobs
Optional.
An ArrayList that tracks individual runspace jobs.

```yaml
Type: ArrayList
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
