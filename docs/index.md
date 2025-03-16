---
hide:
  - navigation
---

# Welcome to RemotePro

![Picture-RpLogo](assets\RpLogo.png){ width=350 align=right }

!!! tip "**A PowerShell Windows Presentation Framework (WPF) Graphical User Interface (GUI) for MilestonePSTools**"
    *Available on the [:material-powershell:PowerShell Gallery.](https://www.powershellgallery.com/packages/RemotePro)*

<br>
<div class="annotate" markdown align="left">
(1) :simple-keepachangelog: Please see the [ChangeLog](CHANGELOG/CHANGELOG.md) for updates.

(2) :fontawesome-solid-book-open: See [Installation](https://www.remotepro.dev/getting-started/installation/) for access to setup instructions.

(3) :fontawesome-solid-code-branch: Version 1.0.0 will be the official release of RemotePro.

(4) :fontawesome-brands-youtube: See the [YouTube Video Tutorial](usageguide/usageguide/#video-tutorial) for demonstrations of the features.

</div>
1. In addition to updates and fixes, the unreleased section may showcase current features that are being developed.
2. RemotePro is currently in beta stage. If you experience any issues please [*report the issue*](https://github.com/codypaternostro/RemotePro/issues)
3. I am currently developing this module in real-time! Version 1.0.0 will be bumped as a marker of progression.
4. This is a 15 minute video demonstrating the basic features of RemotePro.

<br><br><br>
## Inspiration

Hello! My name is [Cody Paternostro](https://www.linkedin.com/in/codypaternostro/), and this is my project, **RemotePro**. It is an intriguing module that allows anyone familiar with [MilestonePSTools](https://www.milestonepstools.com/) and [Milestone XProtect](https://www.milestonesys.com/products/software/xprotect/) to interact through a graphical user interface (GUI). The idea for RemotePro originated when [Joshua Hendricks](https://gist.github.com/joshooaj), the developer behind the MilestonePSTools project, shared an interesting [PowerShell script](https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f). This script wasn’t designed for automation; instead, it focused on user interaction by enabling the viewing of live and playback streams from a Video Management System (VMS). He utilized Windows Presentation Framework (WPF), which was new to me at the time. This journey has been a long one, providing an opportunity to create something usable by everyone with minimal effort.


## Dependencies

!!! note "Attribution"
    RemotePro utilizes existing modules and binaries, integrating them seamlessly. Input, output, and processing are facilitated by these modules. If you are interested in learning more about them, please use the project links below to explore further!

    !!! info "Project Links"
        - [ImportExcel](https://github.com/dfinke/ImportExcel)
        - [MaterialDesignInXamlToolkit](https://github.com/MaterialDesignInXAML/MaterialDesignInXamlToolkit)
        - [MilestonePSTools](https://www.milestonepstools.com/)
        - [PSWriteHTML](https://github.com/EvotecIT/PSWriteHTML)
        - [ShowMeTheXAML](https://github.com/Keboo/ShowMeTheXAML) *included -- currently not used yet.*


## Professional Module Making

RemotePro is the first module I have ever developed, as this type of programming was unfamiliar to me. Initially, the project started as what I refer to as a *mega-script*, which was a single large script file containing various functions. The Gainsville PowerShell group hosts meetups, and it just so happened that Josh did a demo on module creation using psstucco -- ["The Art & Craft of Module Development using Stucco with Josh Hendricks"](https://www.youtube.com/watch?v=gDJ3Ods1hbo&t=2055s). The timing could not have been better for the development of RemotePro, as I had just begun learning how to import functions into an active terminal session. Professional modules take projects to the next level by offering the benefits of using PowerShell data and module files while [automating documentation](https://www.youtube.com/watch?v=gDJ3Ods1hbo&t=2055s). Most importantly, the concept of a [module and script scope variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-5.1#modules) are utilized throughout a main PSCustomObject for the *RemoteProController*. This object allows quick access to all the event handlers for button clicks.

## User Interface: Graphical (GUI), Command-Line (CLI), or Both?

If what you've read so far doesn't make sense, that's fine; if you understand the concepts, that's great too. The purpose of RemotePro is to provide an attractive base template that allows users to make suggestions or developers to contribute. The idea was to create a starting point without a defined goal. I was initially hesitant to release the module because I wanted the button click functionalities to be modifiable to some extent. I will be working on publishing features and guides on how to utilize RemotePro from the command line interface (CLI) and GUI. There are three important components to this module: the [XAML](https://github.com/codypaternostro/RemotePro/blob/main/RemotePro/xaml/RemoteProUI.xaml), the [Start-RpRemotePro](https://github.com/codypaternostro/RemotePro/blob/main/RemotePro/Public/Start-RpRemotePro.ps1) command, WPF-enabled cmdlets, and, of course, Runspaces!

<br>
!!! warning "Disclaimer"
    This project's content is not affiliated with MilestonePSTools or Milestone XProtect and is released under the permissive open-source [MIT License](https://github.com/codypaternostro/RemotePro/blob/main/LICENSE).

