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

# Check for alias
if (-not (Get-Alias -Name 'note' -ErrorAction SilentlyContinue))
{
    # Check for np++
    if ([IO.File]::Exists("$env:ProgramFiles\Notepad++\notepad++.exe"))
    {
        New-Alias -Name 'note' -Value "$env:ProgramFiles\Notepad++\notepad++.exe"
    }
}

if (-not (Get-Alias -Name 'code' -ErrorAction SilentlyContinue))
{
    $codePath = (Get-ChildItem -Path "$env:ProgramFiles\Microsoft VS Code Insiders" -Filter "code*.exe")
    if ([IO.File]::Exists($codePath.Fullname))
    {
        New-Alias -Name 'code' -Value $codePath.FullName
    }
}

if ($IsCoreCLR)
{
    if (-not (Get-Alias -Name 'scb' -ErrorAction SilentlyContinue)) { New-Alias -Name 'scb' -Value Set-ClipboardText }
}

function Update-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}


#Shortcuts to common folders
$docs = "$([System.Environment]::GetFolderPath('mydocuments'))"
$downloads = "$HOME\Downloads"
$workspace = "$([System.Environment]::GetFolderPath('mydocuments'))\workspace"

#Get rid of backspace beep maybe Not needed now? leaving for now just commenting out
#Set-PSReadlineOption -BellStyle None 

#Set useful variables
#$WinHome = '/mnt/c/Users/worge'
#$BashHome = "C:\Users\worge\AppData\Local\lxss\home\Awakun"

#Prompt customization
function prompt
{ 
    if ($host.UI.RawUI.WindowTitle -match 'Administrator')
    { 
        Write-Host 'AS ADMIN: ' -NoNewLine -ForegroundColor Red
        $host.ui.rawui.WindowTitle = $CurrentUser.Name + ".Administrator Line: " + $host.UI.RawUI.CursorPosition.Y
    }
    else
    { 
        $host.ui.rawui.WindowTitle = $CurrentUser.Name + " Line: " + $host.UI.RawUI.CursorPosition.Y
    }
  
    Write-Host "PS $($PSVersionTable.PSVersion) " -NoNewline -ForegroundColor DarkBlue
    Write-Host "$env:UserName@ " -ForegroundColor DarkMagenta -NoNewline
    Write-Host ('{0}: ' -f $env:COMPUTERNAME) -NoNewLine -ForegroundColor Green
    Write-Host ('{0}>' -f $(Get-Item -Path .\).Name) -NoNewLine -ForeGroundColor DarkCyan
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