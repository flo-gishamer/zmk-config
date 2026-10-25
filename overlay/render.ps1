# Renders layers 0-3 of layout.html into overlay.png for sofle-overlay.ahk.
# Run again after every keymap change (after updating layout.html).
$browser = @(
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$page = "file:///" + ((Join-Path $PSScriptRoot "layout.html") -replace "\\", "/") + "#overlay"
$out = Join-Path $PSScriptRoot "overlay.png"

& $browser --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 `
    --virtual-time-budget=5000 --window-size=2400,1400 --screenshot="$out" $page | Out-Null
Write-Output "geschrieben: $out"

# Crop the empty background around the four layers
python -c "from PIL import Image, ImageChops; im = Image.open(r'$out').convert('RGB'); bg = Image.new('RGB', im.size, im.getpixel((0, 0))); x0, y0, x1, y1 = ImageChops.difference(im, bg).getbbox(); m = 40; im.crop((max(x0 - m, 0), max(y0 - m, 0), min(x1 + m, im.width), min(y1 + m, im.height))).save(r'$out')"
