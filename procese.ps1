# Definim calea de export pentru fișierul CSV
$csvPath = "$env:USERPROFILE\Documents\datapcheck\Process_List.csv"

# Obținem toate procesele
$processes = Get-Process

# Creăm un array pentru a stoca datele
$processData = @()

# Parcurgem fiecare proces
foreach ($process in $processes) {
    try {
        # Obținem calea executabilului procesului
        $processPath = $process.Path

        # Obținem timpul de start al procesului
        $startTime = $process.StartTime

        # Calculăm cât timp a fost activ procesul
        $activeTime = if ($startTime) {
            (Get-Date) - $startTime
        } else {
            "N/A"
        }

        # Verificăm dacă procesul rulează cu drepturi de administrator
        $isAdmin = $false
        if ($processPath) {
            $fileOwner = (Get-Acl -Path $processPath).Owner
            if ($fileOwner -like "*Administrator*") {
                $isAdmin = $true
            }
        }

        # Adăugăm informațiile în array
        $processData += [PSCustomObject]@{
            Name        = $process.ProcessName
            ID          = $process.Id
            StartTime   = if ($startTime) { $startTime.ToString("yyyy-MM-dd HH:mm:ss") } else { "N/A" }
            ActiveTime  = if ($activeTime -ne "N/A") { "$($activeTime.Days) days, $($activeTime.Hours) hours, $($activeTime.Minutes) minutes" } else { "N/A" }
            Path        = $processPath
            IsAdmin     = $isAdmin
        }
    } catch {
        # Ignorăm erorile (de exemplu, pentru procese fără permisiuni de acces)
        continue
    }
}

# Exportăm array-ul într-un fișier CSV
$processData | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Informațiile despre procese au fost exportate în $csvPath" -ForegroundColor Green
