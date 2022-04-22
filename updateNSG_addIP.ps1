#Update the target Network Security Groups
$requiredIp=("172.18.0.0/17")
$newIP=("172.21.0.0/17")

$ngs=Get-AzNetworkSecurityGroup

foreach($ng in $ngs){
    $nsgrule=$ng.SecurityRules

foreach( $item in $nsgrule) {
    $ruleip=$item| Select-Object -Property Name,SourceAddressPrefix,Protocol,Access,Direction,DestinationAddressPrefix,SourcePortRange,DestinationPortRange,Priority

foreach( $ip in $ruleip)
    {
        if( $ip.SourceAddressPrefix -eq $requiredIp){

        $rec=Get-AzNetworkSecurityGroup -Name $ng.Name

        Set-AzNetworkSecurityRuleConfig `
            -Name $ip.Name `
            -NetworkSecurityGroup $rec `
            -SourceAddressPrefix ( @($item.SourceAddressPrefix) + $newIP ) `
            -Protocol $item.Protocol `
            -Access $item.Access `
            -Direction $item.Direction `
            -DestinationAddressPrefix $item.DestinationAddressPrefix `
            -SourcePortRange $item.SourcePortRange `
            -DestinationPortRange $item.DestinationPortRange `
            -Priority $item.Priority
        Set-AzNetworkSecurityGroup -NetworkSecurityGroup $rec   | Export-Csv -Path "C:\Users\TAASODA6\OneDrive - Swisscom\PROJECTS\UNFCCC\updateNSG_addIP.txt"
    }
   }
}
}
