# Installation

## Overview

This module leverages connection profiles created using MilestonePSTools
[AboutConnectionProfiles](https://www.milestonepstools.com/blog/2023/09/29/introducing-connection-profiles-and-custom-attributes/).

This module combines LOCALAPPDATA with a subdirectory
specific to RemotePro. It ensures or creates this directory using modified
item management techniques from MilestonePSTools.
See the following link for MilestonePSTool's explanation of
[AppDataUsage](https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description).

## Install Module

Available on [PowerShell Gallery](https://www.powershellgallery.com/packages/RemotePro).

If the RemotePro module is not installed, use the command below.
    ```powershell
    Install-Module -Name RemotePro
    ```

## Launch GUI

Enter command in Powershell terminal to load the main window.
    ```powershell
    Start-RpRemotePro
    ```

## Next Steps

Continue to [Configuration](configuration.md) to learn how to connect to a XProtect VMS Management Server.
