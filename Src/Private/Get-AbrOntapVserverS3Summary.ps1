function Get-AbrOntapVserverS3Summary {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve NetApp ONTAP Vserver S3 information from the Cluster Management Network
    .DESCRIPTION

    .NOTES
        Version:        0.6.2
        Author:         Jonathan Colon
        Twitter:        @jcolonfzenpr
        Github:         rebelinux
    .EXAMPLE

    .LINK

    #>
    param (
        [Parameter (
            Position = 0,
            Mandatory)]
            [string]
            $Vserver
    )

    begin {
        Write-PscriboMessage "Collecting ONTAP Vserver S3 information."
    }

    process {
        $VserverData = Get-NetAppOntapAPI -uri "/api/protocols/s3/services?svm=$Vserver&fields=*&return_records=true&return_timeout=15"
        $VserverObj = @()
        if ($VserverData) {
            foreach ($Item in $VserverData) {
                $inObj = [ordered] @{
                    'HTTP' = ConvertTo-TextYN $Item.is_http_enabled
                    'HTTP Port' = $Item.port
                    'HTTPS' = ConvertTo-TextYN $Item.is_https_enabled
                    'HTTPS Port' = $Item.secure_port
                    'Status' = Switch ($Item.enabled) {
                        'True' { 'UP' }
                        'False' { 'Down' }
                        default { $Item.enabled }
                    }
                }
                $VserverObj += [pscustomobject]$inobj
            }

            $TableParams = @{
                Name = "Vserver S3 Service - $($Vserver)"
                List = $false
                ColumnWidths = 20, 20, 20, 20, 20
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $VserverObj | Table @TableParams
        }
    }

    end {}

}