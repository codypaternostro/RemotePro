# Function to set a default state when no profiles are available or an error occurs
function Set-DefaultConnectionProfileBox {
    $script:ConnectionProfileListBox.ItemsSource = @([pscustomobject]@{ Name = "No Profiles Found"; ServerAddress = ""; Credential = ""; FullDetails = "" })
}
