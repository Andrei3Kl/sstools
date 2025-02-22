$ip = (Invoke-WebRequest ifconfig.me/ip).Content ; (Invoke-WebRequest "https://proxycheck.io/v2/$ip\?vpn=1&asn=1").content >> $env:temp\proxy.json ; (Get-Content $env:temp\proxy.json) -match 'proxy'
