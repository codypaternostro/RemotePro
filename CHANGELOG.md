---
hide:
  - navigation
---
# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).


## [Unrelased]

- Online help links
- Configuration Tab

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
- Reset-RpSettingJson
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
