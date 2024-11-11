function Initialize-RpDependencies {
    [CmdletBinding()]
    param ()

    # Manually set the bin path to avoid issues with PSScriptRoot
    $scriptRoot = Split-Path $PSScriptRoot -Parent
    $binPath = Join-Path $scriptRoot "bin"

    # Verbose output to show the constructed bin path
    Write-Verbose "Constructed binPath: $binPath"

    try {
        # Load necessary assemblies from .NET Framework
        Write-Verbose "Loading .NET PresentationFramework assembly..."
        [System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | Out-Null

        # Load the custom assemblies from the bin folder using reflection
        $assemblies = @(
            "MaterialDesignThemes.Wpf.dll",
            "MaterialDesignColors.dll"
        )

        foreach ($assembly in $assemblies) {
            $assemblyPath = Join-Path $binPath $assembly
            Write-Verbose "Looking for assembly at: $assemblyPath"

            if (Test-Path $assemblyPath) {
                [System.Reflection.Assembly]::LoadFrom($assemblyPath) | Out-Null
                Write-Verbose "Successfully loaded $assembly from $assemblyPath"
            } else {
                Write-Error "Assembly $assembly could not be found in $binPath."
                return $false
            }
        }

    } catch {
        Write-Error "An error occurred while loading dependencies: $_"
        return $false
    }

    return $true
}
