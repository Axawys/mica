#!/usr/bin/env python3
"""Prepare the Mica platform icons from assets/mica.svg and assets/mica.png.

Requires Pillow and rsvg-convert. Run this script, then run
`dart run flutter_launcher_icons` from android/ to update its launcher resources.
"""

from io import BytesIO
from pathlib import Path
from shutil import copyfile
import subprocess
import xml.etree.ElementTree as ET

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / 'assets'
SVG_ICON = ASSETS / 'mica.svg'
ANDROID_ASSETS = ROOT / 'android/assets'
LINUX_ICONS = ROOT / 'linux/linux/icons'
WINDOWS_ICON = ROOT / 'windows/windows/runner/resources/app_icon.ico'
SVG_NAMESPACE = 'http://www.w3.org/2000/svg'
ICON_SIZES = (16, 24, 32, 48, 64, 128, 256)


def adaptive_foreground() -> Image.Image:
    """Render the SVG crystal layers without the rounded background."""
    ET.register_namespace('', SVG_NAMESPACE)
    svg = ET.parse(SVG_ICON).getroot()
    svg.remove(svg.find(f'{{{SVG_NAMESPACE}}}rect'))
    rendered = subprocess.run(
        ['rsvg-convert'], input=ET.tostring(svg), capture_output=True, check=True,
    )
    artwork = Image.open(BytesIO(rendered.stdout)).convert('RGBA')
    artwork = artwork.crop(artwork.getbbox())

    # At xxxhdpi the adaptive drawable is 108 dp * 4. A 57 dp crystal mark
    # fits inside the central 66 dp circle and keeps the tips clear of masks.
    artwork.thumbnail((228, 228), Image.Resampling.LANCZOS)
    canvas = Image.new('RGBA', (432, 432))
    canvas.paste(artwork, ((canvas.width - artwork.width) // 2,
                           (canvas.height - artwork.height) // 2))
    return canvas


def main() -> None:
    with Image.open(ASSETS / 'mica.png') as master:
        master.save(ANDROID_ASSETS / 'icon_legacy.png')
        master.save(WINDOWS_ICON, sizes=[(size, size) for size in ICON_SIZES])

        LINUX_ICONS.mkdir(exist_ok=True)
        copyfile(SVG_ICON, LINUX_ICONS / SVG_ICON.name)
        for size in ICON_SIZES:
            icon = master.resize((size, size), Image.Resampling.LANCZOS)
            icon.save(LINUX_ICONS / f'{size}.png')

    adaptive_foreground().save(ANDROID_ASSETS / 'icon_foreground.png')


if __name__ == '__main__':
    main()
