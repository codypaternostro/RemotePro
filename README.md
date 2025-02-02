# RemotePro

PowerShell WPF GUI for MilestonePSTools

## Overview

This module demonstrates the utility of wrapping powershell modules
into Windows Presentation Framework tools.
It was not created or endorsed by Milestone or MilestonePSTools and is
released using standard MIT license.

This module leverages connection profiles created using MilestonePSTools
[AboutConnectionProfiles](https://www.milestonepstools.com/blog/2023/09/29/introducing-connection-profiles-and-custom-attributes/)

Modules used:
[MilestonePSTools](https://www.milestonepstools.com/)
[PSWriteHTML](https://github.com/EvotecIT/PSWriteHTML)
[ImportExcel](https://github.com/dfinke/ImportExcel)

WPF GUI theme and features:
[MaterialDesignInXamlToolkit](https://github.com/MaterialDesignInXAML/MaterialDesignInXamlToolkit)
[ShowMeTheXAML](https://github.com/Keboo/ShowMeTheXAML)

This module combines LOCALAPPDATA with a subdirectory
specific to RemotePro. It ensures or creates this directory using modified
item management techniques from MilestonePSTools.
See link for MilestonePSTool's explanation of AppData usage.
[AppDataUsage](https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description)


## Installation

Available on [PowerShell Gallery](https://www.powershellgallery.com/packages/RemotePro)
> Install-Module -Name RemotePro

## Examples
> Start-RpRemotePro



