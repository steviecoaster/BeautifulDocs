[cmdletBinding()]
param(
    [Parameter()]
    [Switch]
    $Build,
    
    [Parameter()]
    [Switch]
    $WriteMdDocs,

    [Parameter()]
    [Switch]
    $MkDocsPublish,

    [Parameter()]
    [string]
    $SemVer = $(
        if (Get-Command gitversion -ErrorAction SilentlyContinue) {
            (gitversion | ConvertFrom-Json).LegacySemVerPadded
        }
    )
)
process {
    $root = Split-Path -Parent $MyInvocation.MyCommand.Definition
    
    switch ($true) {
        (-not $env:CI) {
            . $PSScriptRoot\Requirements.ps1
        }

        $Build {
            Build-Module -SemVer $SemVer
        }

        $WriteMdDocs {
            if (Test-Path $root\Output\BeautifulDocs) {
                if ($env:PSModulePath.Split(';') -notcontains "$root\Output") {
                    $env:PSModulePath = "$root\Output;$env:PSModulePath"
                }
                Import-Module BeautifulDocs -Force
                Import-Module PlatyPS -Force

                New-MarkdownHelp -Module BeautifulDocs -OutputFolder $root\docs

            }
        }

        $MkDocsPublish {
            $mkDocsRoot = Join-Path $root 'mkdocs_template'
            Push-Location $mkDocsRoot
            $mkDocsArgs = @('build')

            & mkdocs @mkDocsArgs
        }

    }
}