using namespace System.Management.Automation
using namespace System.Windows

class RpVmsConnectionChecker {
    [bool]$ShowErrorDialog

    RpVmsConnectionChecker([bool] $showErrorDialog) {
        $this.ShowErrorDialog = $showErrorDialog
    }

    [bool] CheckConnection() {
        Add-Type -AssemblyName PresentationFramework
        Import-Module -Name RemotePro -ErrorAction SilentlyContinue
        $connectionFailed = $false

        if ($null -eq (Get-VmsManagementServer -ErrorAction Ignore)) {
            Connect-ManagementServer -ErrorAction SilentlyContinue -ErrorVariable connectionFailed
        }

        if ($connectionFailed) {
            if ($this.ShowErrorDialog) {
                [MessageBox]::Show("Connection validation failed. No VMS connection available.", "Connection Error", [MessageBoxButton]::OK, [MessageBoxImage]::Error)
            }
            return $false
        }
        return $true
    }
}
