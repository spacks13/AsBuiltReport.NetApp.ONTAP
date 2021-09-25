function Get-AbrOntapClusterLicenseUsage {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve NetApp ONTAP cluster licenses usage information from the Cluster Management Network
    .DESCRIPTION

    .NOTES
        Version:        0.4.0
        Author:         Jonathan Colon
        Twitter:        @jcolonfzenpr
        Github:         rebelinux
    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    param (
    )

    begin {
        Write-PscriboMessage "Collecting ONTAP cluster license usage information."
    }

    process {
        $LicenseFeature = Get-NcFeatureStatus
        if ($LicenseFeature) {
            $LicenseFeature = foreach ($NodeLFs in $LicenseFeature) {
                [PSCustomObject] @{
                    'Name' = $NodeLFs.FeatureName
                    'Status' = $NodeLFs.Status
                    'Notes' = Switch ($NodeLFs.Notes) {
                        "-" { 'None' }
                        default { $NodeLFs.Notes }
                    }
                }
            }
            $TableParams = @{
                Name = "License Feature Summary - $($ClusterInfo.ClusterName)"
                List = $false
                ColumnWidths = 40, 20, 40
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $LicenseFeature | Table @TableParams
        }
    }

    end {}

}