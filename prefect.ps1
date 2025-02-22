# Definim calea către folderul Prefetch
$prefetchPath = "$env:SystemRoot\Prefetch"

# Definim calea de export pentru fișierul CSV
$csvPath = "$env:USERPROFILE\Documents\datapcheck\Prefetch_Files.csv"

# Verificăm dacă folderul Prefetch există
if (Test-Path $prefetchPath) {
    # Obținem toate fișierele din folderul Prefetch
    $files = Get-ChildItem -Path $prefetchPath -File

    # Creăm un array pentru a stoca datele
    $prefetchData = @()

    # Parcurgem fiecare fișier
    foreach ($file in $files) {
        $prefetchData += [PSCustomObject]@{
            FileName      = $file.Name
            FullPath      = $file.FullName
            CreationTime  = $file.CreationTime
            LastWriteTime = $file.LastWriteTime
            LastAccessTime = $file.LastAccessTime
            SizeKB        = [math]::Round($file.Length / 1KB, 2)
        }
    }

    # Exportăm array-ul într-un fișier CSV
    $prefetchData | Export-Csv -Path $csvPath -NoTypeInformation

    Write-Host "Informațiile despre fișierele din Prefetch au fost exportate în $csvPath" -ForegroundColor Green
} else {
    Write-Host "Folderul Prefetch nu a fost găsit: $prefetchPath" -ForegroundColor Red
}
