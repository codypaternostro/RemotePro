---
hide:
  - navigation
---
# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unrelased]

- Heartbeat window for checking status of cameras on current connection.
- VAPIX command pass through to reboot AXIS cameras.
- Parameter selection for camera reports.


## [0.3.1] - 2025-03-28

# Added

- New-RpShortcut
- Desktop shortcut is now enabled by default for Start-RpRemotePro. However, it can be disabled by changing the **True** value to **False**.

# Fixed

- Removed default output while creating ControllerObject. This will now only be shown when Start-RpRemotePro is called with the -Verbose switch. Previously, this would spam the terminal everytime Start-RpRemotePro is called.

## [0.3.0] - 2025-03-23

### Added

- Improved Update-RpConfigCommand Get-Help online button.
- Integrated XAML from MaterialDesignXamlToolkit into *Themes* to assist in troubleshooting dependency issues related to nested assembly usage. The resource dictionary is still being referenced from *ResourceDictionary.MergedDictionaries* within the XAML. Ultimately, finding a workaround to eliminate any resources from the XAML would be ideal; however, these will remain for now as they support the development of a robust *System.Windows.Application* base for WPF in PowerShell.
- Included dependencies in the PowerShell Data File (.psd1).
- Introduced the *$env:REMOTE_PRO_SESSION* variable to work in conjunction with the WPF application singleton check. This resolves a long-standing issue regarding the handling of nested runspaces. By adopting this approach, the main window for RemotePro is now more closely monitored, and it will initiate a new session when the *$env:REMOTE_PRO_SESSION* variable is flagged.
- Modified the behavior of *Start-RpRemotePro* to hide the terminal by default. The *-Show-Terminal* parameter can be used to display the terminal as usual. This provides a quick and easy method for troubleshooting the main window in combination with verbose output (e.g., *Start-RpRemotePro -ShowTerminal -Verbose*).
- Added the *Show-RpSplashScreen* function to display the logo while loading the main window.

### Fixed

- Corrected the parameters for *Get-RpTicketBlock*. This command now functions as expected for retrieving camera information.
- Resolved a .NET error related to *System.Windows.Forms.Timer* by transitioning to *System.Windows.Threading.DispatcherTimer*. This change prevents .NET runtime errors that occur if *Start-RpRemotePro*'s main window is closed while nested runspaces from that session are still in use. The command initializes a timer to check the runspace status and effectively delegates the cleanup of runspaces.
- Fixed an improper build that was using the 7.5 core version terminal. Switching to Windows PowerShell has rectified an issue where progress actions were included in cmdlet documentation for common parameters. This was also causing problems when adding modules to the .psd1 file.

## [0.2.4] - 2025-03-16

### Added

- Show Hardware button by default would display credentials for hardware.
This no longer occurs, to see credentials in the hardware
reports there is a parameter that needs to be enabled, **IncludeCredentials**.
Navigate the tabs to *Configuration* > *ConfigCommands* and check the box in
the left column for Get-RpVmsHardwareCustom. Then click the penicl icon
(:material-pencil:) to change the value to *true* for
the **IncludeCredentials** parameter. Finally, click *Submit* to save the changes.
This will update the RemoteProParamConfig.json to store the modification.

### Fixed

- Get-RpVmsHardwareCustom was still using a hardcoded call to Out-HtmlView.
This would result in opening two tabs when click on the *Show Hardware* button.

## [0.2.3] - 2025-03-05

### Fixed

- Build error.

## [0.2.2] - 2025-03-05

### Added

- Main Settings Tab
- ConfigCommands Tab - Datagrid for interacting with button mapped commands.
- Module Paths Tab


### Fixed

- Adjusted logic to have nested runspace call open runspace for processing
the camera report
- NewConnectionFile_Click no longer prodocues error if the file exists.
It is now possible to overwrite file if one exists.


## [0.2.1] - 2025-02-23

### Added

- RemotePro512.ico added to all windows for cmdlets using ShowDialog parameter.
- Improved various examples for help comments.

### Fixed

- Added correct link for issues button.
- Help comments for cmdlets by seperating text and code.

## [0.2.0] - 2025-02-22

### Added

- Online help links for Get-Help switch parameter
- Module scope MemoryStream for reading icon file. This is used
by Set-RpWindowIcon if the stream object is not provided.
Set-RpWindowIcon will also use Get-RpIconPath by default if a path
is not provided.

### Fixed

- Get-RpIconPath had incorrect path, correct to use module scope scriptroot


## [0.1.9] - 2025-02-20

### Fixed

- Commented out icon link
- Remove verbose switch from Set-RpWindowIcon

## [0.1.8] - 2025-02-20

### Added

- Added RpLogo512.ico to Start-RpRemotePro

## [0.1.7] - 2025-02-19

### Added

- Logo for docs site

## [0.1.6] - 2025-02-16

### Added

These commands will help manage the main settings for the RemotePro main GUI.
They will work under the configuration tab. Get-RemoteProController will now have
Settings that can be accessed.

- Add-RpSettingToJson
- Find-RpSettingsJson
- Get-RpSettings
- Get-RpSettingsJsonPath
- Import-RpSettingsFromJson
- New-RpSettingsJson
- Remove-RpSettingFromJson
- Reset-RpSettingsJson
- Set-RpSettingsJson
- Set-RpSettingsJsonDefaults
- Update-RpSettingsJson

> Add-RpSettingToJson, Remove-RpSettingFromJson, Update-RpSettingsJson have built-in dialogs.

## [0.1.5] - 2025-02-09

### Added

- Add .COMPONENT to each cmdlet's help section.
- Rename nested folders in public directory.
- CNAME for gh-pages branch

### Fixed

- Replace Home, MoveNext, and MovePrev with module related websites.
- Cleanup unused buttons and links from main GUI.
- Correct runspace log's scaling and ability to scroll to end.

## [0.1.4] - 2025-02-04

### Added

- Started adding Github-Pages mkdocs resources to project.

## [0.1.3] - 2025-02-02

### Fixed

- GitHub environment variable added to publish.yml


## [0.1.2] - 2025-02-02

### Fixed

- Publish workflow for github actions.

## [0.1.1] - 2025-02-02

### Fixed

- Changed local module reference to use installed module.
- Modified pester tests for help documentation.

### Added

- Notes to README file


## [0.1.0] Initial Release for testing
