#region Script-Scoped Variables
$script:scriptRoot = $PSScriptRoot
Set-Location -Path $script:scriptRoot #Redunancy

# Load in main xaml file.
$script:RemoteProXaml = Get-Content -Path "$PSScriptRoot\Xaml\RemoteProUI.xaml" -Raw
#endregion

#region Load necessary DLLs and Assemblies
# Get all DLLs in the bin directory relative to the script root
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

} catch {
    Write-Error "An error occurred while loading dependencies: $_"
}
#endregion

#region Dot source public/private functions
$classes = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes/*.ps1') -Recurse -ErrorAction Stop)
$public  = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1')  -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1') -Recurse -ErrorAction Stop)
foreach ($import in @($classes + $public + $private)) {
    try {
        . $import.FullName
    } catch {
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
$script:configPath = Get-RPConfigPath

# Check if the configuration file exists, if not create it.
if (-not (Test-Path -Path $(Get-RpConfigPath))){
    New-RpConfigCommandJson -Type DefaultJson
}
if (-not (Get-RpControllerObject)) {
    #region Initialize RemotePro main controller object with script scope "$script:RemotePro"
    $script:RemotePro = New-RpControllerObject      #Initalize RemotePro controller object

    Set-RpEventHandlers                             #Populate EventHandlers
    Set-RpRunspaceEvents                            #Populate RunspaceEvents
    Set-RpConfigCommands                            #Populate ConfigCommands
    Set-RpDefaultConfigCommandIds                   #Populate ConfigCommandDefaultIds
}

#endregion

$script:RpOpenRunspaces = Initialize-RpOpenRunspaces
$script:RpRunspaceJobs = Initialize-RpRunspaceJobs
$script:RpRunspaceResults = Initialize-RpRunspaceResults

$script:selectedProfileName
#endregion


