function Get-RpSettingsJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [switch]$All
    )

    process {
        try {
            if ($All){
                (Get-RpControllerObject -Property Settings).Values
            } else {
                Get-RpControllerObject -Property Settings
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    end {}
}
