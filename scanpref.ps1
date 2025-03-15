# Setează locația Prefetch și fișierul de output
$prefetchPath = "$env:SystemRoot\Prefetch"
$outputCSV = "$env:USERPROFILE\Documents\datapcheck\Prefetch_Report.csv"

# Lista de fișiere pe care vrei să le cauți
$searchFiles = @("loader.pf", "launcher.pf", "hwid.pf", "loader.exe", "hwid.pf", "loader", "launcher", "public", "lastest")  # Adaugă fișiere aici

# Verifică dacă folderul Prefetch există
if (Test-Path $prefetchPath) {
    # Caută fișierele în Prefetch
    $foundFiles = Get-ChildItem -Path $prefetchPath -Filter "*.pf" | Where-Object {
        $fileName = $_.BaseName -replace "-[0-9A-F]+$", ""  # Elimină hash-ul Windows din nume
        $searchFiles -contains $fileName
    } | Select-Object Name, FullName, CreationTime, LastWriteTime

    # Verifică dacă a găsit fișiere
    if ($foundFiles) {
        # Creează un obiect pentru export
        $fileData = $foundFiles | ForEach-Object {
            [PSCustomObject]@{
                "Nume Fișier"     = $_.Name
                "Cale Completă"   = $_.FullName
                "Creat La"        = $_.CreationTime
                "Ultima Utilizare"= $_.LastWriteTime
            }
        }

        # Exportă rezultatele în CSV
        $fileData | Export-Csv -Path $outputCSV -NoTypeInformation -Encoding UTF8

        Write-Host "Raportul a fost salvat la: $outputCSV" -ForegroundColor Green
    } else {
        Write-Host "Nu s-au găsit fișierele specificate." -ForegroundColor Yellow
    }
} else {
    Write-Host "Folderul Prefetch nu există sau accesul este restricționat!" -ForegroundColor Red
}
