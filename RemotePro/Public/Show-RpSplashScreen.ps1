function Show-RpSplashScreen {
    <#
    .SYNOPSIS
    Displays a centered splash screen with RemotePro icon and text while the main window loads.

    .DESCRIPTION
    This function displays a minimal WPF splash screen with transparency, centered on
    screen. It sets the icon via Set-RpWindowIcon and returns the splash window object
    so the caller can close or update it after the main window is ready.

    .OUTPUTS
    System.Windows.Window - Splash window reference for later closing or manipulation.

    .EXAMPLE
    $splash = Show-RpSplashScreen
    Start-Sleep -Seconds 5
    $splash.Close()

    .LINK
    https://www.remotepro.dev/en-US/Show-RpSplashScreen
    #>
    [CmdletBinding()]
    param ()

    process {
        try {
            $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="RemotePro Loading..."
        Height="320" Width="320"
        WindowStartupLocation="CenterScreen"
        WindowStyle="None"
        ResizeMode="NoResize"
        ShowInTaskbar="False"
        Topmost="True"
        Background="Transparent"
        AllowsTransparency="True">
    <Grid>
        <Border CornerRadius="16" Background="White" Padding="20">
            <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
                <Image x:Name="SplashIcon" Width="160" Height="160" Margin="0,0,0,10"/>
                <TextBlock Text="Loading RemotePro..." FontSize="18" FontWeight="SemiBold" HorizontalAlignment="Center"/>
            </StackPanel>
        </Border>
    </Grid>
</Window>
"@

            $reader = New-Object System.Xml.XmlTextReader([System.IO.StringReader]::new($xaml))
            $splashWindow = [Windows.Markup.XamlReader]::Load($reader)

            # Set icon (optional)
            Set-RpWindowIcon -Window $splashWindow

            # Show non-blocking
            $null = $splashWindow.Show()

            # Return the splash window so the caller can close or manipulate it
            return $splashWindow
        } catch {
            Write-Warning "Failed to show splash screen: $_"
            return $null
        }
    }
}
