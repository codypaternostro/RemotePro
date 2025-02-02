function Install-RpRequiredModules {
    # Ensures required modules are installed.
    $requiredModules = @(
        @{ Name = 'MilestonePSTools'},
        @{ Name = 'PSWriteHTML'},
        @{ Name = 'ImportExcel'}
    )

    foreach ($module in $requiredModules) {
        Write-Verbose "Checking if $($module.Name) is installed..."

        # Check if the module is installed
        if (-not (Get-Module -ListAvailable -Name $module.Name)) {
            Write-Verbose "$($module.Name) is not installed. Attempting to install..."

            try {
                Install-Module -Name $module.Name -Scope CurrentUser -Force -Verbose -AllowClobber
                Write-Verbose "$($module.Name) installed successfully."
            } catch {
                Write-Error "Failed to install $($module.Name): $_"
            }
        } else {
            Write-Verbose "$($module.Name) is already installed."
        }
    }
}
