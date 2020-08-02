# net use command for WebDAV via https/ssl
# typically <UNC>@SSL\DavWWWRoot 
# set correct parameters here
net use v: \\webdav.address.com@SSL\DavWWWRoot password /user:username

# set name for volume here
$Name="volumename"

# rename mapped drive
$ShellObject = New-Object –ComObject Shell.Application
$DriveMapping = $ShellObject.NameSpace('V:')
$DriveMapping.Self.Name = $Name

# message
Write-Host "##########################" -foreground Green
Write-Host "# successfully connected #" -foreground Green
Write-Host "##########################" -foreground Green

# don't exit
$host.enternestedprompt()

