function Get-SATGithubRelease {
    [CmdletBinding()]
    param (
        # Name of the Github repository
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectName,

        # Name of the Github Project owner
        [Parameter(Mandatory = $true)]
        [string]
        $OwnerName,

        # Github Access Token
        [Parameter(Mandatory = $false)]
        [securestring]
        $GithubAccessToken = ($env:GITHUB_TOKEN | ConvertTo-SecureString -AsPlainText -Force -ErrorAction SilentlyContinue)
    )

    begin {
        if (!(Get-Module PowerShellForGitHub)) {
            try {
                Import-Module PowerhellForGitHub -ErrorAction Stop
            }
            catch [System.IO.FileNotFoundException] {
                throw [System.NotSupportedException] "Please install the PowerhellForGitHub module"
            }
        }

        if ($GithubAccessToken) {
            Write-Verbose "Setting Github Access Token"
            $cred = New-Object System.Management.Automation.PSCredential "username is ignored", $GithubAccessToken
            $null = Set-GitHubConfiguration -SuppressTelemetryReminder
            $null = Set-GitHubConfiguration -DisableTelemetry
            $null = Set-GitHubAuthentication -Credential $cred
        }
        else {
            Write-Warning "No Github Access Token found...Query Limit will be reached at 60/hour"
        }
    }

    process {
        $releaseArr = [System.Collections.ArrayList]::new()
        $release = Get-GitHubRelease -OwnerName $OwnerName -RepositoryName $ProjectName -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($release) {
            Write-Verbose "Found Latest Release for $($release.Name)"
            $null = $releaseArr.Add($release)
        }
        else {
            Write-Warning "No release found for $($ProjectName)"
        }
    }

    end {
        return $releaseArr
    }
}