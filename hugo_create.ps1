<# 
Requirements
- installed chocolatey via Powershell
- installed Hugo via chocolatey
- created Hugo site under the $hugopubliccreate directory
- init git under $hugopublic
#>

# Paths
$hugopubliccreate = "D:\IT Projects\mdeliu.github.io"   # path to Hugo site
$hugopublic = "D:\IT Projects\mdeliu.github.io\public"  # path to Hugo public site

# Functions

Function Hugo-Clear {
    Write-Host "changing work directory to" $hugopublic
    Set-Location -Path $hugopublic
    Write-host "clearing public directory" $hugopublic
    Remove-Item -recurse $hugopublic\* -exclude $hugopublic\.git
}

Function Hugo-Create {
    Write-Host "changing work directory to" $hugopubliccreate
    Set-Location -Path $hugopubliccreate
    Write-Host "creating blog under" $hugopublic
    hugo
}

Function Change-Hugo {
    Write-Host "changing work directory to" $hugopublic
    Set-Location -Path $hugopublic
}

Function Git-Add {
    Write-Host "git add in folder" $hugopublic
    git add .
}

Function Git-Commit {
    Write-Host "git commit in folder" $hugopublic
    git commit -m "update"
}

Function Git-Push {
    Write-Host "git push to main"
    git push origin main
}

# Start
Hugo-Clear
Hugo-Create
Change-Hugo
Git-Add
Git-Commit
Git-Push

# Finish
Write-Host "done..."
