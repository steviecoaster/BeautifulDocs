function Remove-ChocoTemplateComment {
    <#
    .SYNOPSIS
    Removes code comments from a templated choco package.
    
    .DESCRIPTION
    Removes code comments from a templated choco package.
    
    .PARAMETER Script
    The script to remove comments from.
    
    .PARAMETER PackageSource
    The path to the package source. Will process all ps1 files in the package source.
    
    .EXAMPLE
    Remove-ChocoTemplateComment -Script C:\Temp\MyScript.ps1
    .EXAMPLE
    Remove-ChocoTemplateComment -PackageSource C:\Temp\MyPackage
    #>
    [CmdletBinding(DefaultParameterSetName = 'Script')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Script')]
        [ValidateScript( { Test-Path $_ })]
        [String]
        $Script,

        [Parameter(Mandatory = $true, ParameterSetName = 'PackageSource')]
        [ValidateScript( { Test-Path $_ })]
        [String]
        $PackageSource
    )
    process {
            
        Switch ($PSCmdlet.ParameterSetName) {
            'Script' {
                Get-Content $Script | Where-Object { $_ -notmatch "^\s*#" } | ForEach-Object { $_ -replace '(^.*?)\s*?[^``]#.*', '$1' } | Out-File $Script+".~" -en utf8; 
                Move-Item -Force    $Script+".~" $Script
            }
            'PackageSource' {
                $Scripts = (Get-ChildItem $PackageSource -Recurse -Filter '*.ps1').FullName

                foreach ($Script in $Scripts) {
                    Get-Content $Script | Where-Object { $_ -notmatch "^\s*#" } | ForEach-Object { $_ -replace '(^.*?)\s*?[^``]#.*', '$1' } | Out-File $Script+".~" -en utf8; 
                    Move-Item -Force    $Script+".~" $Script
                }                    
            }
        }
    }
}