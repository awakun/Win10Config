#region ModuleImports
try 
{
    Import-Module -Name posh-git -ErrorAction Stop
}
catch
{
    Write-Warning -Message 'Could not import posh-git'
}

if ($Host.Name -eq 'Visual Studio Code Host')
{
    try
    {
        if ($IsCoreCLR)
        {
            Import-WinModule -Name EditorServicesCommandSuite -ErrorAction Stop
            Import-EditorCommand -Module EditorServicesCommandSuite -ErrorAction Stop
            Write-Host 'EditorServicesCommandSuite loaded.' -ForeGroundColor Green
        }
        else
        {
            Import-Module -Name EditorServicesCommandSuite -ErrorAction Stop
            Import-EditorCommand -Module EditorServicesCommandSuite -ErrorAction Stop
            Write-Host 'EditorServicesCommandSuite loaded.' -ForeGroundColor Green
        }
    }
    catch
    {
        Write-Host 'EditorServicesCommandSuite could not be loaded!' -ForegroundColor Red
        $proError = $_
    }
}
#endregion ModuleImports

#region Aliases                                         
if (-not (Get-Command -Name 'firefox' -ErrorAction SilentlyContinue) -and -not (Get-Alias -Name 'firefox' -ErrorAction SilentlyContinue))
{
    New-Alias -Name 'firefox' -Value "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
}

if (-not (Get-Alias -Name 'code' -ErrorAction SilentlyContinue) -and -not (Get-Command -Name 'code.cmd' -ErrorAction SilentlyContinue))
{
    $codePath = (Get-ChildItem -Path "$env:LocalAppData\Programs\Microsoft VS Code Insiders\bin" -Filter "code*.cmd" -ErrorAction SilentlyContinue)
    if ([IO.File]::Exists($codePath.Fullname))
    {
        New-Alias -Name 'code' -Value $codePath.FullName
    }
}

if ($IsCoreCLR)
{
    if (-not (Get-Alias -Name 'scb' -ErrorAction SilentlyContinue)) 
    {
        New-Alias -Name 'scb' -Value Set-ClipboardText
    }
}
#endregion Aliases

#region FolderVars
if ($IsLinux)
{
    $otherHome = '/mnt/c/Users/worge'
    $docs = [System.IO.Path]::Combine($otherHome, 'OneDrive', 'Documents')
    $downloads = [System.IO.Path]::Combine($otherHome, 'Downloads')
    $workspace = [System.IO.Path]::Combine($docs, 'workspace')
}
elseif ($IsWindows -or ($PSEdition -eq 'Desktop'))
{
    # If a different distro starts being used this needs to be updated
    $ubuntuPackageName = (get-apppackage | Where-Object Name -like '*ubuntu18.04*').packagefamilyname
    # $otherHome = "$env:LocalAppData\Packages\$ubuntuPackageName\LocalState\rootfs\home\dave"
    $docs = [System.Environment]::GetFolderPath('mydocuments')
    $downloads = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('userprofile'), 'Downloads')
    $workspace = [System.IO.Path]::Combine($docs, 'workspace')
}
else
{
    Write-Warning -Message 'Could not set FolderVars, are you running on a Mac?!'
}

# Write a friendly message to console to remind me (and warn if there's a problem)
if (#[System.IO.Directory]::Exists($otherHome) -and
    [System.IO.Directory]::Exists($docs) -and
    [System.IO.Directory]::Exists($downloads) -and
    [System.IO.Directory]::Exists($workspace))
{
    Write-Host 'Variables $docs, $downloads, and $workspace loaded for your convenience.' -ForegroundColor Green
}
else
{
    Write-Host 'One or more of the variables $otherHome, $docs, $downloads, and $workspace could not be loaded, check paths!' -ForegroundColor Red
}
#endregion FolderVars

#region CustomFunctions
function Update-Path
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Update personal modules in userspace
function Update-PersonalModule
{
    $modules = Get-Module -ListAvailable | Where-Object ModuleBase -like "$docs\PowerShell\Modules\*" | Select-Object -ExpandProperty Name -Unique
    
    foreach ($m in $modules)
    {
        try
        {
            Update-Module -Name $m -ErrorAction Stop
            Write-Host "Successfully updated $m" -ForegroundColor Green
        }
        catch
        {
            $needError = $true
            
            switch -Wildcard ($_.Exception) {
                '*Install-Module*' 
                {
                    try
                    {
                        Install-Module -Name $m -Scope CurrentUser -Force -ErrorAction Stop
                        Write-Host "Successfully updated $m by installing it again." -ForegroundColor Green
                        $needError = $false
                    }
                    catch
                    {
                        Write-Host "Couldn't update $m by installing it, probably already up to date." -ForegroundColor Yellow
                        $needError = $false
                    }
                }
                Default {}
            }
        
            if ($needError)
            {
                Write-Host "Couldn't Update $m. Check output." -ForegroundColor Red
            }
        }
    }
}
#endregion CustomFunctions

#region Preferences
$ProgressPreference = 'SilentlyContinue'

# Modifies up/down functionality to work with search history
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#endregion Preferences

#region Prompt
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
    Write-VcsStatus
    return " "
}
#endregion Prompt