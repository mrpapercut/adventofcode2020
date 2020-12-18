Function CRT($buses) {
    [bigint] $N = 0
    foreach ($bus in $buses) {
        if ($bus -eq 'x') {
            continue
        }

        $N = If ($N -eq 0) {[int]$bus} Else {[int]$bus * $N}
    }

    [bigint] $sum = 0
    foreach ($bus in $buses) {
        if ($bus -eq 'x' -Or $bus -eq $null) {
            continue
        }

        [int]$intbus = [convert]::ToInt64($bus)
        $busidx = $buses.IndexOf($bus)
        $bussubidx = $intbus - $busidx

        # Absolute modulo
        $a = ((($bussubidx % $intbus) + $intbus) % $intbus)
        $nU = $N / $intbus

        # Inverse
        $inverse = 1
        $b = $nU % $intbus
        for ($i = 1; $i -lt $intbus; $i++) {
            if (($b * $i) % $intbus -eq 1) {
                $inverse = $i
                break
            }
        }

        $sum = $sum + ($a * $nU * $inverse)
    }

    Write-Host "Total"
    Write-Host ($sum % $N)
}

Function ShuttleSearch {
    [CmdLetBinding()]

    param(
        [Parameter()][string]$filename
    )

    $filecontents = @()
    foreach ($line in Get-Content $filename) {
        $filecontents += $line
    }

    CRT $filecontents[1].Split(',')
}

$shuttleSearch = ShuttleSearch './day13/day13.txt'
