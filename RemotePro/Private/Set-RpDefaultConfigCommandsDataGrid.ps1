function Set-RpDefaultConfigCommandsDataGrid {
    # https://learn.microsoft.com/en-us/archive/msdn-magazine/2008/december/advanced-basics-the-observablecollection-class
    # Fetch commands from the configuration file and import intro controller object.
    # Create a new ObservableCollection to store commands and bind it to the DataGrid.
    Set-RpConfigCommands
    $modules = Get-RpConfigCommands
    $commands = ((($modules.Values).Values).Values)

    # ObservableCollection to store commands
    $script:Commands = New-Object 'System.Collections.ObjectModel.ObservableCollection[Object]'

    # ObservableCollection to store filtered commands
    $script:FilteredCommands = New-Object 'System.Collections.ObjectModel.ObservableCollection[Object]'

    foreach ($command in $commands) {
        $script:Commands.Add([PSCustomObject]@{
            ModuleName     = $command.ModuleName
            CommandName    = $command.CommandName
            Description    = $command.Description
            Id             = $command.Id
            IsChecked      = $false  # Default unchecked
            CheckboxSelect = $false  # Default unchecked
        })
    }

    # Instead of clearing, directly update ItemsSource
    $script:Commands_DataGrid.ItemsSource = $script:Commands

    # Reset header checkbox state
    $script:AllItemsChecked = $false
    $script:Commands_HeaderChkBox.IsChecked = $false
}
