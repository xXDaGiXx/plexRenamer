
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory
    $folder = ""

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}


function Get-Gui {

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
    
    # Create media dir button
    $dirNameLabel = New-Object System.Windows.Forms.Label
    $dirNameLabel.Location = New-Object System.Drawing.Point(20, 100)
    $dirNameLabel.Size = New-Object System.Drawing.Size(100, 23)
    $dirNameLabel.Text = "Media folder:"
    $form.Controls.Add($dirNameLabel)
    
    $mediaDir = New-Object System.Windows.Forms.Button
    $mediaDir.Location = New-Object System.Drawing.Point(120, 100)
    $mediaDir.Size = New-Object System.Drawing.Size(75, 23)
    $mediaDir.Text = "Get Folder"
    $mediaDir.Add_Click({$mediaDir.Tag = Get-Folder})
    $form.Controls.Add($mediaDir)
    
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
    $mediaDir = $mediaDir.Tag  
    $mediaName = $mediaNameTextBox.Text
    $season = $seasonTextBox.Text
    $isTVShow = $tvShowCheckBox.Checked


    # Write-Host "YAAHAAHA" + $mediaDir

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

#Creaate parent dir for TV, as there caan be multiple seasaon within one show
function Set-MediaStagingDir {
    param (
        $media,
        $drive
    )
    $stagingDir = "$drive\Transfer\Staging\$media"
    if (Test-Path -Path $stagingDir) {
        # "PATH EXISTS"
    }
    else {
        # "PATH NOT HERE"
        mkdir $stagingDir
    }
}


function Get-TVContentID {
    param (
        $media
    )
    $apiKey = "8009f614f903931c9397046df0762127"
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
    $apiKey = "8009f614f903931c9397046df0762127"
    $endpointUrl = "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$media"
    $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
    foreach ($result in $responseJson.results) {
        Write-Host $result.id
        return $result.id
    }
}

# Need tp grab date and add it to name of show
function Get-TvContentName {
    param (
        $contentid,
        $season,
        $drive,
        $media
    )
    $apiKey = "8009f614f903931c9397046df0762127"
    $pattern = '[\\/:*?"<>|]'
    $replacement = ''
    $dir = "$drive\Transfer\Rename\$media\Season $season"
    $files = Get-ChildItem $dir
    $x = 1
    $endpointUrl = "https://api.themoviedb.org/3/tv/$contentid/season/$season/episode/$x`?api_key=$apikey"
    $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
    $year = $responseJson.air_date
    $year = $year.Substring(0,4)
    for ($i = 0; $i -lt $files.Count; $i++) {
        $endpointUrl = "https://api.themoviedb.org/3/tv/$contentid/season/$season/episode/$x`?api_key=$apikey"
        $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
        $fullName = $responseJson.name
        # The brackets r palce holders to insert r -f vars into. String interpolation
        # {2:D2}E{3:D2} -- This means that D2 is its a 2 digit num
        $newName = "{0} ({1}) - S{2:D2}E{3:D2} - {4}{5}" -f $media, $year, $season, $x, $fullName, $files[$i].Extension
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
    $apiKey = "8009f614f903931c9397046df0762127"
    $endpointUrl = "https://api.themoviedb.org/3/movie/$contentid`?api_key=$apikey"
    $responseJson = Invoke-RestMethod -Method Get -Uri $endpointUrl
    $fullName = $responseJson.name
    Rename-Item -Path "$drive\Transfer\Rename\$media\$media.txt" -NewName $fullName
    # return $fullName
}


# 1 : Iniitalize GUI and grab + assings user input vars
$values = Get-Gui
$apiKey = $values[0]
$drive = $values[1]
$media = $values[2]
$season = $values[3]
$isTV = $values[4]
$mediaDir = $values[5]


# 2 : Check if selected drive has correct dirs
Get-Dir($drive)

# 3 : Check if TV or not. If TV, rename sequentially.

Rename-Item -Path $mediaDir -NewName $media
$dirRename = "$drive\Transfer\Rename\$media"
$files = Get-ChildItem -Path $dirRename -File

# Check for TV, if tv, renaame sequenitally, then create new dir in staging if it doesnt exist. This will be parent dir for all content in the TV show.
# If movie, then rename movie parent dir, and subsueqnt child itme.
# TODO : Need to add in logic in GUi and here for if the movie is just a singluar file, and not just in a dir
if ($isTV -eq 'True') {
    Rename-MediaSeason -season $season -media $media -drive $drive
    Set-MediaStagingDir -media $media -drive $drive
}
else {
    # This is commented out ebcuase I dont have GUI logic yet to handle for files and folders. This was if u just hada a singular movie file and not a parent dir. Will need to update logic to handle for that.
    # Will make it so it create a parent dir named after the media to store movie in.
    # Get-ChildItem -Path $mediaDir | Rename-Item -NewName $media".txt"
    Get-ChildItem -Path $dirRename | Rename-Item -NewName $media".txt" #Need to handle for all video format extentions
}



# 4: Assoisate media content with corrent naming through TMDB
# TODO: create fn to link media to TMDB API
#   - Show vs movie. Diff fn or in same one with logic sepperated. Need the loop for TV show 

if ($isTV -eq 'True') {
    $contentID = Get-TVContentID($media)
    Get-TvContentName -contentid $contentID -season $season -drive $drive -media $media
}
else {
    $contentID = Get-MovieContentID($media)
    Write-Host $contentID
    Get-MovieContentName -contentid $contentID -drive $drive -media $media
}



# 5 : Move to staging dir
Robocopy.exe "$drive\Transfer\Rename\$media" "F:\Transfer\Staging\$media" /E /COPYALL
if ($LASTEXITCODE -in 1) {
    Write-Host "robocopy completed successfully."
    Remove-Item -Path "$drive\Transfer\Rename\$media\Season $season" -Recurse -Force -Confirm:$false
} else {
    Write-Host "robocopy failed with exit code $LASTEXITCODE."
}


# 6 : Prompt user if they wish to run NSSM service to push code to remote host, or quit application
# TODO :  Make NSSM an option. Can run on a schedule, with user chosen time that will automitcally move files, or one thaat runs right as a file is moved to staaging / script ends/
#    - Or just make a push that happens with POSH manualy




