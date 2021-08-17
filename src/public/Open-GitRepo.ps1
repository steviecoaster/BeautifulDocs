Function Open-GitRepo {
    <#
    .SYNOPSIS
    Changes your $pwd to the directory of the requested repo name
    
    .DESCRIPTION
    Changes your $pwd to the directory of the requested repo name
    
    .PARAMETER Repo
    The repo to open
    
    .EXAMPLE
    Open-GitRepo -Repo SuperAwesomeProject
    #>
    [Alias("Goto")]
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                $results= Get-ChildItem "$env:HOME\Documents\git\ChocoStuff","$env:HOME\Documents\vagrantenvironments" -Directory | Select-Object -ExpandProperty Name

                If ($WordToComplete) {
                    $results.Where{ $_ -match "^$WordToComplete" }
                }

                Else {

                    $results
                }
            }
        
        )]
        [String]
        $Repo
    )

    process {

        $path = (Get-ChildItem "$env:HOME\Documents\git\ChocoStuff","$env:HOME\Documents\vagrantenvironments" -Directory | Where-Object { $_.FullName -match "$Repo" }).FullName

        Push-Location $path

    }
}