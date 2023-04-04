Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#apiKey var here


function Get-Drive {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Plex Rename'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'
    
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,120)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
    
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,120)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)
    
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Enter the drive of your choice:'
    $form.Controls.Add($label)
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)
    
    $form.Topmost = $true
    
    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $drive = $textBox.Text + ':'
        return $drive
    }
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


function Get-Media {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Plex Rename'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,120)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,120)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Enter the name of the media:'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)

    $form.Topmost = $true

    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $media = $textBox.Text
        return $media
    }
}

function Get-Type {
    $wshell = New-Object -ComObject Wscript.Shell
    $answer = $wshell.Popup("Is this a season of a TV show?",0,"Alert",64+4)
    # Yes = 6
    # No = 7
    return $answer
}

function Get-Season {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Plex Rename'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'
    
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,120)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
    
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,120)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)
    
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Enter the season of the show:'
    $form.Controls.Add($label)
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)
    
    $form.Topmost = $true
    
    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $season = $textBox.Text
        return $season
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
    $apiKey = ""
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
    $apiKey = ""
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
    $apiKey = ""
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
        #hello
    )
    
}


# 1: Get the drive that will use this program, then see if the associated DIRs already exist or not. If not create the dirs
$drive = Get-Drive
Get-Dir($drive)

# 2: After checking for the dirs, get the media content name and season of show
# TODO: Need to check if movie or not. If a movie, then skip season UI prompt. If TV with season, loop to sequeintially name
$dir = "$drive\Transfer\Rename"
$dirName = Get-ChildItem $dir -Name
$media = Get-Media
$answer = Get-Type

Rename-Item -Path "$dir\$dirName" -NewName $media
$dirRename = "$drive\Transfer\Rename\$media"
$files = Get-ChildItem -Path $dirRename -File

if ($answer -eq 6) {
    $season = Get-Season
    Rename-MediaSeason -season $season -media $media -drive $drive
}
else {
    Get-ChildItem -Path $dirRename | Rename-Item -NewName $media".txt"
}



# 3: Assoisate media content with corrent naming through TMDB
# TODO: create fn to link media to TMDD
#   - Show vs movie. Diff fn or in same one with logic sepperated. Need the loop for TV show 

if ($answer -eq 6) {
    $contentID = Get-TVContentID($media)
    Get-TvContentName -contentid $contentID -season $season -drive $drive -media $media
}
else {
    #Get-MovieContentID
}



# 4: Move new media content from Rename to Staging dir 
# $dirStage = "D:\Testing\Transfer\Staging"
# Move-Item $dirRename -Destination $dirStage -Recurse









# Add Section for ext

#Todo: Add sub dir for each seaason within name of content



# Move files to staging





