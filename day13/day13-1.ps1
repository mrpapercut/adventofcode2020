Function ShuttleSearch {
    [CmdLetBinding()]

    param(
        [Parameter()][string]$filename
    )

    $filecontents = @()
    foreach ($line in Get-Content $filename) {
        $filecontents += $line
    }

    $buses = @{}

    $filecontents[1].Split(",") | ForEach-Object {
        If ($_ -ne "x") {
            $mod = $filecontents[0] % $_
            $buses.Add($_, ($_ - $mod))
        }
    }

    $firstbus = ($buses.GetEnumerator() | Sort-Object -Property Value)[0]
    Write-Host ([int]$firstbus.Key * [int]$firstbus.Value)
}

$shuttleSearch = ShuttleSearch './day13/day13.txt'
