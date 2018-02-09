<#
       _____      _              _ _                     
      / ____|    | |       /\   | (_)                    
     | (___   ___| |_     /  \  | |_  __ _ ___  ___  ___ 
      \___ \ / _ \ __|   / /\ \ | | |/ _` / __|/ _ \/ __|
      ____) |  __/ |_   / ____ \| | | (_| \__ \  __/\__ \
     |_____/ \___|\__| /_/    \_\_|_|\__,_|___/\___||___/
#>                                             
#This is for the chrome alias since chrome can be in 3 different default locations, so check if it's needed first.
if (-not (Get-Alias -Name 'chrome' -ErrorAction SilentlyContinue))
{
    #Find chrome, prioritize canary > 64bit > 32bit
    $potentialChromePaths = @($env:LOCALAPPDATA, $env:ProgramFiles, ${env:ProgramFiles(x86)})
    foreach ($path in $potentialChromePaths)
    {
        $chromePath = (Get-ChildItem -Path $path -Filter 'chrome.exe' -Recurse -ErrorAction SilentlyContinue).FullName
        if ($chromePath) 
        {
            New-Alias -name 'chrome' -Value $chromePath
            break
        }
    }
}

if (-not (Get-Alias -Name 'note' -ErrorAction SilentlyContinue))
{
    if (Test-Path -Path "$env:ProgramFiles\Notepad++\notepad++.exe")
    {
        New-Alias -Name 'note' -Value "$env:ProgramFiles\Notepad++\notepad++.exe"
    }
}

if (-not (Get-Alias -Name 'code' -ErrorAction SilentlyContinue))
{
    #Logic is here in case I switch back to non-insiders at some point, this should get me the correct exe for alias.
    $codePath = (Get-ChildItem -Path $env:ProgramFiles -Filter "code*.exe" -Recurse -Exclude 'CodeHelper.exe' | Where-Object {$_.FullName -notmatch 'Git'}).FullName
    if (Test-Path -Path $codePath)
    {
        New-Alias -Name 'code' -Value $codePath
    }
}

#Shortcuts to common folders
$docs = "$([System.Environment]::GetFolderPath('mydocuments'))"
$downloads = "$HOME\Downloads"
$workspace = "$([System.Environment]::GetFolderPath('mydocuments'))\workspace"

#Get rid of backspace beep
Set-PSReadlineOption -BellStyle None

#Set useful variables
#$WinHome = '/mnt/c/Users/worge'
#$BashHome = "C:\Users\worge\AppData\Local\lxss\home\Awakun"

#Prompt customization
function prompt
{
    $global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $h, $User = $global:CurrentUser.Name -split '\\'
    $principal = New-Object System.Security.Principal.WindowsPrincipal($global:CurrentUser)
  
    if ($principal.IsInRole("Administrator"))
    { 
        $host.ui.rawui.WindowTitle = $CurrentUser.Name + ".Administrator Line: " + $host.UI.RawUI.CursorPosition.Y
    }
    else
    { 
        $host.ui.rawui.WindowTitle = $CurrentUser.Name + " Line: " + $host.UI.RawUI.CursorPosition.Y
    }
  
    $promptstring = "PS $User@" + $(Get-Item -Path .\).Name + ">"
    Write-Host $promptstring -NoNewline -ForegroundColor Cyan
    return " "
}

# Start a transcript
#
if (!(Test-Path "$Env:USERPROFILE\Documents\WindowsPowerShell\Transcripts"))
{
    if (!(Test-Path "$Env:USERPROFILE\Documents\WindowsPowerShell"))
    {
        $rc = New-Item -Path "$Env:USERPROFILE\Documents\WindowsPowerShell" -ItemType directory
    }
    $rc = New-Item -Path "$Env:USERPROFILE\Documents\WindowsPowerShell\Transcripts" -ItemType directory
}
$curdate = $(get-date -Format "yyyyMMddhhmmss")
Start-Transcript -Path "$Env:USERPROFILE\Documents\WindowsPowerShell\Transcripts\PowerShell_transcript.$curdate.txt"