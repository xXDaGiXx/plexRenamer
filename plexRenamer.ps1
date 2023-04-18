Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-Gui {
    param (
        #
    )

    # Create form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "TV Show Information"
    $form.Size = New-Object System.Drawing.Size(450, 320)
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true
    
    # Create API Key label and text box
    $apiKeyLabel = New-Object System.Windows.Forms.Label
    $apiKeyLabel.Location = New-Object System.Drawing.Point(20, 20)
    $apiKeyLabel.Size = New-Object System.Drawing.Size(100, 23)
    $apiKeyLabel.Text = "API Key:"
    $form.Controls.Add($apiKeyLabel)
    
    $apiKeyTextBox = New-Object System.Windows.Forms.TextBox
    $apiKeyTextBox.Location = New-Object System.Drawing.Point(120, 20)
    $apiKeyTextBox.Size = New-Object System.Drawing.Size(250, 23)
    $form.Controls.Add($apiKeyTextBox)
    
    # Create Drive name label and text box
    $driveNameLabel = New-Object System.Windows.Forms.Label
    $driveNameLabel.Location = New-Object System.Drawing.Point(20, 60)
    $driveNameLabel.Size = New-Object System.Drawing.Size(100, 23)
    $driveNameLabel.Text = "Drive Name:"
    $form.Controls.Add($driveNameLabel)
    
    $driveNameTextBox = New-Object System.Windows.Forms.TextBox
    $driveNameTextBox.Location = New-Object System.Drawing.Point(120, 60)
    $driveNameTextBox.Size = New-Object System.Drawing.Size(250, 23)
    $form.Controls.Add($driveNameTextBox)
    
    # Create dir name label and text box
    $dirNameLabel = New-Object System.Windows.Forms.Label
    $dirNameLabel.Location = New-Object System.Drawing.Point(20, 100)
    $dirNameLabel.Size = New-Object System.Drawing.Size(100, 23)
    $dirNameLabel.Text = "Media folder:"
    $form.Controls.Add($dirNameLabel)
    
    $dirNameTextBox = New-Object System.Windows.Forms.TextBox
    $dirNameTextBox.Location = New-Object System.Drawing.Point(120, 100)
    $dirNameTextBox.Size = New-Object System.Drawing.Size(250, 23)
    $form.Controls.Add($dirNameTextBox)
        
    
    # Create Media name label and text box
    $mediaNameLabel = New-Object System.Windows.Forms.Label
    $mediaNameLabel.Location = New-Object System.Drawing.Point(20, 140)
    $mediaNameLabel.Size = New-Object System.Drawing.Size(100, 23)
    $mediaNameLabel.Text = "Media Name:"
    $form.Controls.Add($mediaNameLabel)
    
    $mediaNameTextBox = New-Object System.Windows.Forms.TextBox
    $mediaNameTextBox.Location = New-Object System.Drawing.Point(120, 140)
    $mediaNameTextBox.Size = New-Object System.Drawing.Size(250, 23)
    $form.Controls.Add($mediaNameTextBox)
    
    # Create Season label and text box
    $seasonLabel = New-Object System.Windows.Forms.Label
    $seasonLabel.Location = New-Object System.Drawing.Point(20, 180)
    $seasonLabel.Size = New-Object System.Drawing.Size(100, 23)
    $seasonLabel.Text = "Season:"
    $form.Controls.Add($seasonLabel)
    
    $seasonTextBox = New-Object System.Windows.Forms.TextBox
    $seasonTextBox.Location = New-Object System.Drawing.Point(120, 180)
    $seasonTextBox.Size = New-Object System.Drawing.Size(250, 23)
    $form.Controls.Add($seasonTextBox)
    
    # Create TV show checkbox
    $tvShowCheckBox = New-Object System.Windows.Forms.CheckBox
    $tvShowCheckBox.Location = New-Object System.Drawing.Point(20, 220)
    $tvShowCheckBox.Size = New-Object System.Drawing.Size(150, 23)
    $tvShowCheckBox.Text = "Is this a TV show?"
    $form.Controls.Add($tvShowCheckBox)
    
    # Create OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(180, 240)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
    
    # Create Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(270, 240)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)
    
    # Show the form
    $form.ShowDialog() | Out-Null
    
    # Retrieve input values
    $apiKey = $apiKeyTextBox.Text
    $driveName = $driveNameTextBox.Text+ ':'
    $mediaDir = $dirNameTextBox.Text
    $mediaName = $mediaNameTextBox.Text
    $season = $seasonTextBox.Text
    $isTVShow = $tvShowCheckBox.Checked

    return $apiKey, $driveName, $mediaName, $season, $isTVShow, $mediaDir
    
}

function Get-Dir {
    param (
        $drive
    )
    if (Test-Path -Path "$drive\Transfer") {
        # "PATH EXISTS"
    }
    else {
        # "PATH NOT HERE"
        mkdir "$drive\Transfer"
        mkdir "$drive\Transfer\Rename"
        mkdir "$drive\Transfer\Staging"
    }
}


#TODO : Need to change rename from .txt to any ext
function Rename-MediaSeason {
    param (
        [int]$season,
        $media,
        $drive
    )

    $EC = 0
    [string]$seasonStr = " S0"+$season

    if ($season -gt 9) {
        [string]$seasonStr = " S"+$season
    }

    for ($i = 0; $i -lt $files.Count; $i++) {
        if ($i+1 -ge 10) {
            $EC = ''
        }
        $newName = $media + " - " + $seasonStr + "E" + $EC + ($i+1) + ".txt"
        $files[$i] | Rename-Item -NewName $newName
    }

    $seasonDir = "$drive\Transfer\Rename\$media\Season $season"
    mkdir $seasonDir
    Get-ChildItem -Path "$drive\Transfer\Rename\$media" -File | Move-Item -Destination $seasonDir
}


function Get-TVContentID {
    param (
        $media
    )
    $apiKey = "xxxx"
    $endpointUrl = "https://api.themoviedb.org/3/search/tv?api_key=$apiKey&query=$media"
    $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
    foreach ($result in $responseJson.results) {
        # Write-Host $result.id
        return $result.id
    }
}


function Get-MovieContentID {
    param (
        $media
    )
    $apiKey = "xxxx"
    $endpointUrl = "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$media"
    $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
    foreach ($result in $responseJson.results) {
        Write-Host $result.id
        return $result.id
    }
}


function Get-TvContentName {
    param (
        $contentid,
        $season,
        $drive,
        $media
    )
    $apiKey = "xxx"
    $pattern = '[\\/:*?"<>|]'
    $replacement = ''
    $dir = "$drive\Transfer\Rename\$media\Season $season"
    $files = Get-ChildItem $dir
    $x = 1
    for ($i = 0; $i -lt $files.Count; $i++) {
        $endpointUrl = "https://api.themoviedb.org/3/tv/$contentid/season/$season/episode/$x`?api_key=$apikey"
        $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
        $fullName = $responseJson.name
        $newName = $files[$i].Name.Replace($files[$i].Extension, '') + " - " + $fullName + $files[$i].Extension
        $newName = [regex]::Replace($newName, $pattern, $replacement)
        $files[$i] | Rename-Item -NewName $newName
        $x++
    }
}


function Get-MovieContentName {
    param (
        $contentid,
        $drive,
        $media
    )
    $apiKey = "xxx"
    $endpointUrl = "https://api.themoviedb.org/3/movie/$contentid`?api_key=$apikey"
    $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
    $fullName = $responseJson.name
    Rename-Item -Path "OG ITEM NAME PATH" -NewName $fullName
    # return $fullName
}




# 1 Grab GUI an assign vars

$values = Get-Gui
$apiKey = $values[0]
$drive = $values[1]
$media = $values[2]
$season = $values[3]
$isTV = $values[4]
$mediaDir = $values[5]

# $apiKey, $driveName, $mediaName, $season, $isTVShow

# 2: Check if drive assc dirs are there.

Get-Dir($drive)


# 3: Rename sesaon sequentially and assign dir paths

$dir = "$drive\Transfer\Rename"
$dirName = Get-ChildItem $dir -Name

Rename-Item -Path "$dir\$dirName" -NewName $media
$dirRename = "$drive\Transfer\Rename\$media"
$files = Get-ChildItem -Path $dirRename -File

if ($isTV -eq 'True') {
    Rename-MediaSeason -season $season -media $media -drive $drive
}
else {
    Get-ChildItem -Path $dirRename | Rename-Item -NewName $media".txt"
}



# 4: Assoisate media content with corrent naming through TMDB
# TODO: create fn to link media to TMDB API
#   - Show vs movie. Diff fn or in same one with logic sepperated. Need the loop for TV show 

if ($isTV -eq 'True') {
    $contentID = Get-TVContentID($media)
    Get-TvContentName -contentid $contentID -season $season -drive $drive -media $media
}
else {
    $contentID = Get-MovieContentID
    Write-Host $contentID
    #Get-MovieContentName -contentid $contentID -drive $drive -media $media
}




# 5: Move new media content from Rename to Staging dir 
$dirStage = "$drive\Transfer\Staging"
# robocopy "$drive\Transfer\Rename" $dirStage /MOVE /E /COPYALL /DCOPY:T /XD "$drive\Transfer\Rename"
# Remove-Item -Path "F:\Transfer\Rename\$media\*" -Recurse
# Remove-Item "F:\Transfer\Rename\$media\*" -Recurse -Force -Exclude "F:\Transfer\Rename\$media"

# Move-Item $dirRename -Destination $dirStage -Recurse





# 5: Call plexMover
# Needs to have flag for asking if u waant push?






#Todo: Add sub dir for each seaason within name of content





