#region Script-Scoped Variables
$script:scriptRoot = $PSScriptRoot
#Set-Location -Path $script:scriptRoot #Redunancy
#endregion

#region load Assemblies and DLLs
# Get all DLLs in the bin directory relative to the scriptroot
$bin = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'bin') -Filter *.dll -Recurse -ErrorAction Stop

# Verbose output to show the DLLs found in the bin path
Write-Verbose "Found DLLs in binPath: $($bin.FullName -join ', ')"

try {
    # Load necessary assemblies from .NET Framework using Add-Type
    Write-Verbose "Loading .NET PresentationFramework assembly..."
    Write-Verbose "Loading .NET PresentationCore..."
    Write-Verbose "Loading .NET System.Windows.Forms..."
    Write-Verbose "Loading .NET WindowsBase..."
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName WindowsBase
    Add-Type -AssemblyName System.Threading

    # Load each custom assembly found in the bin directory using in-memory loading
    foreach ($dll in $bin) {
        Write-Verbose "Loading assembly from: $($dll.FullName)"

        # Read the DLL bytes into memory
        $dllBytes = [System.IO.File]::ReadAllBytes($dll.FullName)

        # Load the assembly from memory
        [System.Reflection.Assembly]::Load($dllBytes) | Out-Null

        Write-Verbose "Successfully loaded $($dll.Name) from memory"
    }

    }
    catch {
        Write-Error "An error occurred while loading dependencies: $_"
    }
#endregion

#region declare a module-scoped variable for the memory stream (empty, created once)
$script:RpIconStream = New-Object System.IO.MemoryStream
Write-Verbose "Initialized module-wide RpIconStream object."
#endregion

#region Dot source public/private functions
$classes = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes/*.ps1') -Recurse -ErrorAction Stop)
$public  = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1')  -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1') -Recurse -ErrorAction Stop)
foreach ($import in @($classes + $public + $private)) {
    try {
        . $import.FullName
    } catch {
        Write-Warning "Unable to dot source $($import.Name) due to error: $_"
        throw "Unable to dot source [$($import.FullName)]"
    }
}

Export-ModuleMember -Function $public.Basename
#endregion

#region Install required modules
Install-RpRequiredModules -Verbose
#endregion

#region set runspace log and configuration file.
$script:logPath = Get-RPLogPath
$script:configPath = Get-RpConfigPath


if (-not (Get-RpControllerObject)) {
    #region Initialize RemotePro main controller object with script scope "$script:RemotePro"
    $script:RemotePro = New-RpControllerObject      #Initalize RemotePro controller object

    # Check if the configuration file exists, if not create it.
    if (-not (Test-Path -Path $(Get-RpConfigPath))){
        New-RpConfigCommandJson -Type DefaultJson
    }

    # Check if the settings file exists, if not create it.
    if (-not (Test-Path -Path $(Get-RpSettingsJsonPath))){
        Set-RpSettingsJsonDefaults -SettingsFilePath $(Get-RpSettingsJsonPath)
    }

    Set-RpEventHandlers                             #Populate EventHandlers
    Set-RpRunspaceEvents                            #Populate RunspaceEvents
    Set-RpConfigCommands                            #Populate ConfigCommands
    Set-RpDefaultConfigCommandIds                   #Populate ConfigCommandDefaultIds
    Set-RpSettingsJson                              #Populate Settings
}
#endregion

#region Set runspace logic
$script:RpOpenRunspaces = Initialize-RpOpenRunspaces
$script:RpRunspaceJobs = Initialize-RpRunspaceJobs
$script:RpRunspaceResults = Initialize-RpRunspaceResults
#endregion

#region set desktop shortcut
switch ($script:RemotePro.Settings.DesktopShortcut) {
    $true  { New-RpShortcut }
    $false { New-RpShortcut -DeleteShortcut }
    default { Write-Warning "Unexpected value for DesktopShortcut: $($script:RemotePro.Settings.DesktopShortcut)" }
}

$script:selectedProfileName
#endregion
