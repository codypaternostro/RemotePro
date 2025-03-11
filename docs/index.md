---
hide:
  - navigation
---

# Welcome to RemotePro

*A PowerShell Windows Presentation Framework (WPF) Graphical User Interface (GUI) for MilestonePSTools.*

- *Available on the [:material-powershell:PowerShell Gallery.](https://www.powershellgallery.com/packages/RemotePro/0.2.3)*

![Picture-RpLogo](assets\RpLogo.png){ width=350 }

- Please see the [ChangeLog](CHANGELOG/CHANGELOG.md) for updates.
- See [Installation](https://www.remotepro.dev/getting-started/installation/) for access to setup instructions.
- Version 1.0.0 will be the official release of **RemotePro**.



## Inspiration

Hello! My name is [Cody Paternostro](https://www.linkedin.com/in/codypaternostro/), and this is my project, **RemotePro**. It is an intriguing module that allows anyone familiar with [MilestonePSTools](https://www.milestonepstools.com/) and [Milestone XProtect](https://www.milestonesys.com/products/software/xprotect/) to interact through a graphical user interface (GUI). The idea for RemotePro originated when [Joshua Hendricks](https://gist.github.com/joshooaj), the developer behind the MilestonePSTools project, shared an interesting [PowerShell script](https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f). This script wasn’t designed for automation; instead, it focused on user interaction by enabling the viewing of live and playback streams from a Video Management System (VMS). He utilized Windows Presentation Framework (WPF), which was new to me at the time. This journey has been a long one, providing an opportunity to create something usable by everyone with minimal effort.

## Professional Module Making

RemotePro is the first module I have ever developed, as this type of programming was unfamiliar to me. Initially, the project started as what I refer to as a *mega-script*, which was a single large script file containing various functions. The Gainsville PowerShell group hosts meetups, and it just so happened that Josh did a demo on module creation using psstucco -- ["The Art & Craft of Module Development using Stucco with Josh Hendricks"](https://www.youtube.com/watch?v=gDJ3Ods1hbo&t=2055s). The timing could not have been better for the development of RemotePro, as I had just begun learning how to import functions into an active terminal session. Professional modules take projects to the next level by offering the benefits of using PowerShell data and module files while [automating documentation](https://www.youtube.com/watch?v=gDJ3Ods1hbo&t=2055s). Most importantly, the concept of a [module and script scope variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-5.1#modules) are utilized throughout a main PSCustomObject for the *RemoteProController*. This object allows quick access to all the event handlers for button clicks.

## User Interface: Graphical (GUI), Command-Line (CLI), or Both?

If what you've read so far doesn't make sense, that's fine; if you understand the concepts, that's great too. The purpose of RemotePro is to provide an attractive base template that allows users to make suggestions or developers to contribute. The idea was to create a starting point without a defined goal. I was initially hesitant to release the module because I wanted the button click functionalities to be modifiable to some extent. I will be working on publishing features and guides on how to utilize RemotePro from the command line interface (CLI) and GUI. There are three important components to this module: the [XAML](https://github.com/codypaternostro/RemotePro/blob/main/RemotePro/xaml/RemoteProUI.xaml), the [Start-RpRemotePro](https://github.com/codypaternostro/RemotePro/blob/main/RemotePro/Public/Start-RpRemotePro.ps1) command, WPF-enabled cmdlets, and, of course, Runspaces!


!!! note "Disclaimer"
    This project's content is not affiliated with MilestonePTools or Milestone XProtect and is released under the permissive open-source [MIT License](https://github.com/codypaternostro/RemotePro/blob/main/LICENSE).
    !!! note "Dependencies"
       - [MilestonePSTools](https://www.milestonepstools.com/)
       - [PSWriteHTML](https://github.com/EvotecIT/PSWriteHTML)
       - [ImportExcel](https://github.com/dfinke/ImportExcel)
       - [MaterialDesignInXamlToolkit](https://github.com/MaterialDesignInXAML/MaterialDesignInXamlToolkit)
       - [ShowMeTheXAML](https://github.com/Keboo/ShowMeTheXAML) *included -- currently not used.*
