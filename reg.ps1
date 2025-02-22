# Definim calea către cheia de registru
$regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"

# Verificăm dacă cheia de registru există
if (Test-Path $regPath) {
    # Obținem toate valorile (numele fișierelor) din cheia de registru
    $files = Get-ItemProperty -Path $regPath | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -ne "PSPath" -and $_.Name -ne "PSParentPath" -and $_.Name -ne "PSChildName" -and $_.Name -ne "PSDrive" -and $_.Name -ne "PSProvider" }

    # Definim calea fișierului CSV de export
    $csvPath = "$env:USERPROFILE\Desktop\CompatibilityAssistant_Files.csv"

    # Creăm un array pentru a stoca numele fișierelor
    $fileList = @()

    # Parcurgem fiecare nume de fișier și îl adăugăm în array
    foreach ($file in $files) {
        $fileList += [PSCustomObject]@{
            FileName = $file.Name
        }
    }

    # Exportăm array-ul într-un fișier CSV
    $fileList | Export-Csv -Path $csvPath -NoTypeInformation

    Write-Host "Numele fișierelor au fost exportate în $csvPath" -ForegroundColor Green
} else {
    Write-Host "Cheia de registru nu a fost găsită: $regPath" -ForegroundColor Red
}
