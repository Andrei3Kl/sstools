# Definim calea către cheia de registru
$regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"

# Verificăm dacă cheia de registru există
if (Test-Path $regPath) {
    # Obținem toate valorile din cheia de registru
    $regValues = Get-ItemProperty -Path $regPath

    # Definim calea fișierului CSV de export
    $csvPath = "$env:USERPROFILE\Desktop\CompatibilityAssistant_SIGN_MEDIA_Files.csv"

    # Creăm un array pentru a stoca numele fișierelor care conțin "SIGN.MEDIA="
    $fileList = @()

    # Parcurgem fiecare valoare din cheia de registru
    foreach ($property in $regValues.PSObject.Properties) {
        # Verificăm dacă numele proprietății conține "SIGN.MEDIA="
        if ($property.Name -like "*SIGN.MEDIA=*") {
            # Adăugăm numele fișierului în array
            $fileList += [PSCustomObject]@{
                FileName = $property.Name
            }
        }
    }

    # Exportăm array-ul într-un fișier CSV
    $fileList | Export-Csv -Path $csvPath -NoTypeInformation

    Write-Host "Numele fișierelor care conțin 'SIGN.MEDIA=' au fost exportate în $csvPath" -ForegroundColor Green
} else {
    Write-Host "Cheia de registru nu a fost găsită: $regPath" -ForegroundColor Red
}
