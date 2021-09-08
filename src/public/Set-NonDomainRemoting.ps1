function Set-NonDomainRemoting {
    <#
    .SYNOPSIS
    Configures a system to allow WinRM management of non-domain-joined computers.
    
    .DESCRIPTION
    Configures a system to allow WinRM management of non-domain-joined computers.
    
    .PARAMETER TrustedHosts
    The list of hostname or IP addresses that are allowed to connect to the WinRM listener.
    
    .EXAMPLE
    Set-NonDomainRemoting -TrustedHosts "192.168.1.1,192.168.1.2"
    
    .NOTES
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String[]]
        $TrustedHosts
    )

    begin {
        if (-not (Test-WSMan)) {
            Enable-PSRemoting -Force
        }
    }

    process {
        Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
        $winrmArgs = @('set', 'winrm/config/client', "'{TrustedHosts=`"$($TrustedHosts -join ',')`"}'")
        & winrm @winrmArgs
    }
}