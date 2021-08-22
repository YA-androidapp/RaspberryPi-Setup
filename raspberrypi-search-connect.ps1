$privateipaddr = [system.net.dns]::GetHostAddresses((hostname)) | Where-Object {
    $_.AddressFamily -eq "InterNetwork"
} | select -ExpandProperty IPAddressToString
$p1, $p2, $p3, $p4 = $privateipaddr.Split(".")

for ($i = 0; $i -lt 256; $i++) {
    $targetipaddr = "{0}.{1}.{2}.{3}" -f $p1, $p2, $p3, $i
    ping -n 1 $targetipaddr
}

arp -a | Select-String "b8-27-eb-" | ForEach-Object {
    [RegEx]::Matches($_, "[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+") | ForEach-Object {
        $raspiipaddr = $_.Value
        start ssh "pi@$raspiipaddr"
    }
}
arp -a | Select-String "dc-a6-32-" | ForEach-Object {
    [RegEx]::Matches($_, "[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+") | ForEach-Object {
        $raspiipaddr = $_.Value
        start ssh "pi@$raspiipaddr"
    }
}
arp -a | Select-String "e4-5f-01-" | ForEach-Object {
    [RegEx]::Matches($_, "[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+") | ForEach-Object {
        $raspiipaddr = $_.Value
        start ssh "pi@$raspiipaddr"
    }
}
