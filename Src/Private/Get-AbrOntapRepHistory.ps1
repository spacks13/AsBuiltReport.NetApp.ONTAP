function Get-AbrOntapRepHistory {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve NetApp ONTAP SnapMirror replication history information from the Cluster Management Network
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
        Write-PscriboMessage "Collecting ONTAP SnapMirror replication history information."
    }

    process {
        $ReplicaData = Get-NcSnapmirrorHistory
        $ReplicaObj = @()
        if ($ReplicaData) {
            foreach ($Item in $ReplicaData) {
                $inObj = [ordered] @{
                    'Source Location' = $Item.SourceLocation
                    'Destination Location' = $Item.DestinationLocation
                    'Operation Type' = $Item.OperationType
                    'Result' = $Item.Result
                    'Start' = $Item.Start
                }
                $ReplicaObj += [pscustomobject]$inobj
            }
            if ($Healthcheck.Replication.History) {
                $ReplicaObj | Where-Object { $_.'Result' -ne 'success'} | Set-Style -Style Warning -Property 'Result'
            }

            $TableParams = @{
                Name = "Replication - SnapMirror Replication History Information - $($ClusterInfo.ClusterName)"
                List = $false
                ColumnWidths = 25, 25, 15, 15, 20
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $ReplicaObj | Table @TableParams
        }
    }

    end {}

}