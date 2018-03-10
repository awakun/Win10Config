#Create workspace folder
$documents = [System.Environment]::GetFolderPath('mydocuments')
if (-not (Test-Path -Path "$documents\workspace"))
{
    New-Item -Path $documents -ItemType Directory -Name 'workspace' -Force -Verbose
}

#Creates profile if not there and points it at workspace profile
if (-not (Test-Path -Path $profile))
{
    New-Item -Path $profile -Force -Verbose
    $dotSourceActualProfile = ". $documents\workspace\Win10Config\PowerShell\profile.ps1"
    Out-File -FilePath $profile -InputObject $dotSourceActualProfile -Encoding utf8
}else
{
    $dotSourceActualProfile = ". $documents\workspace\Win10Config\PowerShell\profile.ps1"
    Out-File -FilePath $profile -InputObject $dotSourceActualProfile -Append -Encoding utf8
}
