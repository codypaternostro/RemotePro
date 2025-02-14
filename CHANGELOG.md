# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

# Added
These commands will help manage the main settings for the RemotePro main GUI.
The XAML needs to be updated with the material theme, and all commands should be tested.
- Add-RpSettingToJson.ps1
- Find-RpSettingsJson.ps1
- Get-RpSettingsJson.ps1
- Get-RpSettingsJsonPath.ps1
- Import-RpSettingsJson.ps1
- New-RpSettingsJson.ps1
- Reset-RpSettingJson.ps1
- Set-RpSettingsJson.ps1
- Set-RpSettingsJsonDefaults.ps1
- Update-RpSettingsJson.ps1

## [0.1.5] - 2025-02-09

## Added
- Add .COMPONENT to each cmdlet's help section.
- Rename nested folders in public directory.
- CNAME for gh-pages branch

## Fixed
- Replace Home, MoveNext, and MovePrev with module related websites.
- Cleanup unused buttons and links from main GUI.
- Correct runspace log's scaling and ability to scroll to end.

## [0.1.4] - 2025-02-04

## Added
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

