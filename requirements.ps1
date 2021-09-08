<#
    .Synopsis
        Installs prerequisites for building, testing, and publishing the module
#>
[CmdletBinding()]
param()

if (-not (Get-Command gitversion -ErrorAction SilentlyContinue)) {
    # We use GitVersion to generate the version based on history in source control
    $cArgs = @('install','gitversion','-y',"--source='https://community.chocolatey.org/api/v2'",'--no-progress')
    choco @cArgs
}

if(-not (Get-Command mkdocs -ErrorAction SilentlyContinue)) {
    $cArgs = @('install','mkdocs','-y',"--source='https://community.chocolatey.org/api/v2'", '--no-progress')
    choco @cArgs
}

if (-not ($Script = (Get-Command Install-RequiredModule -ErrorAction SilentlyContinue).Source)) {
    $Install = Install-Script Install-RequiredModule -Force -PassThru
    $Script = Join-Path $Install.InstalledLocation $Install.Name
}
& $Script -Path $PSScriptRoot\RequiredModules.psd1