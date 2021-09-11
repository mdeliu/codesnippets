# Paths
$hugopubliccreate = "D:\Projects\mdeliu.github.io"
$hugopublic = "D:\Projects\mdeliu.github.io\public"

# Functions

Function Hugo-Clear {
    Write-Host "changing work directory to" $hugopublic
    Set-Location -Path $hugopublic
    Write host "clearing public directory" $hugopublic
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
    cd $hugopublic
}

Function Git-Add {
    Write-Host "git add in folder" $hugopublic
    git add .
}

Function Git-Commit {
    Write-Host "git add in folder" $hugopublic
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
