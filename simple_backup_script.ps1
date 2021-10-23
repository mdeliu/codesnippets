<#

Powershell Backup Script
Source from http://gallery.technet.microsoft.com/PowerShell-Backup-Script-956f312c

This script should be runned as administrator to avoid authorization problems.

$Destination = target directory
$Versions = numbers of backups to keep
$BackupDirectorys = which folders to backup, separate with comma, 
                    e.g. $BackupDirectorys = "C:\Folder_A", "C:\Folder_B", "C:\Folder_C"

#>

# <!-- modify parameters as needed

$BackupTarged = "D:\FILES\Backups"
$Versions = "10"
$BackupDirectorys = "C:\Users\Mu\AppData\Roaming"

$BackupDirectory = $BackupTarged +"\Backup_"+ (Get-Date -format yyyy-MM-dd)+"-"+(Get-Random -Maximum 100000)+"\"
$Items=0
$Count=0

# modify parameters as needed -->


# check for admin rights
#Requires -RunAsAdministrator


# create $BackupTarged
Function Create-Backupdir {
    Write-Host "Create BackupDirectory" $BackupDirectory
    New-Item -Path $BackupDirectory -ItemType Directory | Out-Null
}

# delete old backups from $BackupTarged
Function Delete-Backupdir {
    Write-Host "Delete old Backup"
    $Delete=$Count-$Versions+1
    Get-ChildItem $BackupTarged -Directory | Sort-Object -Property $_.LastWriteTime -Descending  | Select-Object -First $Delete | Remove-Item -Recurse -Force
}

# check if $BackupDirectorys and $BackupTarged exist
function Check-Dir {
    if (!(Test-Path $BackupDirectorys)) {
        return $false
    }
    if (!(Test-Path $BackupTarged)) {
        return $false
    }
}

# create backup and subfolders named like the paths in $BackupDirectorys
Function Make-Backup {
    $Files=@()
    $SumItem=0

    foreach ($Backup in $BackupDirectorys) {
        $colItems = (Get-ChildItem $Backup -recurse | Measure-Object -property length -sum) 
        $Items=0
        $FilesCount += Get-ChildItem $Backup -Recurse | Where-Object {$_.mode -notmatch "h"}  
        Copy-Item -Path $Backup -Destination $BackupDirectory -Force -ErrorAction SilentlyContinue
        $SumItem+=$colItems.Sum.ToString()
        $SumItems+=$colItems.Count
    }

    $TotalMB="{0:N2}" -f ($SumItem / 1MB) + " MB of Files"
    Write-Host "There will be"$TotalMB "copied and there are"$filesCount.Count "files to copy"

    foreach ($Backup in $BackupDirectorys) {
        $Index=$Backup.LastIndexOf("\")
        $SplitBackup=$Backup.substring(0,$Index)
        $Files = Get-ChildItem $Backup -Recurse | Where-Object {$_.mode -notmatch "h"} 
        foreach ($File in $Files) {
            $restpath = $file.fullname.replace($SplitBackup,"")
            Copy-Item  $file.fullname $($BackupDirectory+$restpath) -Force -ErrorAction SilentlyContinue |Out-Null
            $Items += (Get-item $file.fullname).Length
            $status = "Copy file {0} of {1} and copied {3} MB of {4} MB: {2}" -f $count,$filesCount.Count,$file.Name,("{0:N2}" -f ($Items / 1MB)).ToString(),("{0:N2}" -f ($SumItem / 1MB)).ToString()
            $Text="Copy data Location {0} of {1}" -f $BackupDirectorys.Rank ,$BackupDirectorys.Count
            Write-Progress -Activity $Text $status -PercentComplete ($Items / $SumItem*100)  
            $count++
        }
    }
    $SumCount+=$Count

    Write-Host "Copied" $SumCount "files with" ("{0:N2}" -f ($Items / 1MB)).ToString()"of MB"
}

# check if $BackupDirectory needs to be cleaned and create $BackupDirectory
$Count=(Get-ChildItem $Destination -Directory).count
if ($count -lt $Versions) {
    Create-Backupdir
} else {
    Delete-Backupdir
    Create-Backupdir
}

# check if all Directorys are existing and do the backup
$CheckDir=Check-Dir
if ($CheckDir -eq $false) {
    Write-Host "One of the Directory are not available, Script has stopped"
} else {
    Make-Backup
}