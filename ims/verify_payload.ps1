$ErrorActionPreference = "Stop"

$expected = [ordered]@{
    "proprietary/priv-app/imsservice/imsservice.apk" = "490E600FA7A8B111DE83DA6D20D87607F8DB68B8447C98CACD2313055FD47F91"
    "proprietary/framework/imsmanager.jar" = "BA88F7111EA5C678D597DCB0498EE9FC42611FD4F6AF12B6312FAD05495DE78B"
    "proprietary/bin/imsd" = "29AC01503989FBA9CC9551A45D65D06AD31A3935E2B303FE7B575916362CEBED"
    "proprietary/lib/arm/libsec-ims.so" = "9F629903D4F7B0C5558F8E60AFE6A93F403170124930E1DA85CF51B909892CB2"
    "proprietary/lib/arm/libaresdns.so" = "BE52A5741A05097ECF0E262EFB49A3D86787A6E3DEA28F20CFBB6CD7B1C974FA"
    "proprietary/lib/arm/libcurl2.so" = "62D23C365A0AC4EAD65BF12B5FB981CEC029E8524A81D39BA8301BC32B894945"
    "proprietary/lib/arm/libext2_uuid.so" = "4C03C8CF9AF3647FA48DD45406D0BD8FB1A77E1858C48F3AF90B2307157FE217"
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$failed = $false
foreach ($entry in $expected.GetEnumerator()) {
    $path = Join-Path $root $entry.Key
    if (-not (Test-Path -LiteralPath $path)) {
        Write-Error "MISSING: $($entry.Key)"
        $failed = $true
        continue
    }
    $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
    if ($actual -ne $entry.Value) {
        Write-Error "HASH MISMATCH: $($entry.Key) expected=$($entry.Value) actual=$actual"
        $failed = $true
    } else {
        Write-Output "PASS $($entry.Key) $actual"
    }
}

if ($failed) {
    exit 1
}
