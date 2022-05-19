enum SoftwareSource {
    GitHub
    pip
    apt
}

class SoftwareAsset {
    [string]$AssetName
    [SoftwareSource]$AssetSource
    [System.Version]$AssetVersion

    SoftwareAsset([string]$AssetName, [SoftwareSource]$AssetSource) {
        $this.AssetName = $AssetName
        $this.AssetSource = $AssetSource
    }

    static [System.Version]GetGithubReleaseVersion([string]$ProjectName) {
        Import-Module PowerhellForGitHub
        return 
    }

    [System.Version]GetVersion() {
        switch ($this.AssetSource) {
            "GitHub" { $this.AssetVersion = GetGithubReleaseVersion() }
            Default { throw [System.NotImplementedException] "The selected Asset Source $($this.AssetSource) is not yet implemented." }
        }
        return $this.AssetVersion
    }
}