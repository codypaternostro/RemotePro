# Helper function for updating textbox
function Set-RpLoadingMessageTextBox {
    # Update connection status for text box
    $script:Connection_Status_Box.Text = "Loading connection properties..."
}