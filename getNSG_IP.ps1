$azSubs = Get-AzSubscription

foreach ( $azSub in $azSubs ) {
    Set-AzContext -Subscription $azSub | Out-Null

    $azNsgs = Get-AzNetworkSecurityGroup 
    
    foreach ( $azNsg in $azNsgs ) {
        Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg | Where-Object { $_.SourceAddressPrefix -eq '172.18.0.0/17' } | `
            Select-Object @{label = 'NSG Name'; expression = { $azNsg.Name } }, 
                          @{label = 'Rule Name'; expression = { $_.Name } },
                          @{label = 'Source IP'; expression = { $_.SourceAddressPrefix } },
                          @{label = 'Port Range'; expression = { $_.DestinationPortRange } }, Access, Priority, Direction, `
                          @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } } | Export-Csv -Path "$($home)\nsg-UNFCCC-ENT-updated.csv" -NoTypeInformation -Append -force
      
    }    
}