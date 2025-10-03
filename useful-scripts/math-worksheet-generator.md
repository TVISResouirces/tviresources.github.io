---
layout: default
title: Math Worksheet Generator
description: PowerShell TUI to generate printable math worksheets and convert them to BRF using liblouis (lou_translate).
---

 

An interactive PowerShell TUI that generates math worksheets (addition, subtraction, mixed, multiplication) and converts them to Braille BRF files using liblouis (`lou_translate`). The script can produce individual BRF files for each worksheet or combine them into a single BRF file.

## Description

This script produces plain-text worksheets and supports converting them to BRF using a local `lou_translate` binary and a Liblouis table (for example, `en-ueb-g2.ctb`). It is intended for educators who want quick, repeatable worksheet generation and accessible Braille output.

Key features:

- Generate batches of worksheets (configurable digits, worksheets count, problems per sheet)
- Generate addition, subtraction, mixed add/subtract, or multiplication worksheets
- Convert individual `.txt` worksheets to `.brf` using `lou_translate`
- Combine many worksheets into one BRF file with form-feed separators
- Menu-driven TUI (no arguments required)

## Setup

Requirements:

- Windows PowerShell (Windows 10/11 recommended) or PowerShell 7+
- Liblouis with `lou_translate` (for BRF conversion)
- The script expects a `lou_translate.exe` binary and a table file (for example `en-ueb-g2.ctb`).

Install liblouis on Windows:

1. Download a Windows liblouis build and unpack it to a known location, for example:

   - `C:\liblouis-<version>\bin\lou_translate.exe`
   - `C:\liblouis-<version>\share\liblouis\tables\en-ueb-g2.ctb`

2. Alternatively install liblouis via a package manager if available for your platform.

PowerShell example (run from the folder containing the script):

```powershell
powershell -ExecutionPolicy Bypass -File .\math_worksheet_tui.ps1
```

If you use a different path for `lou_translate.exe` or the table file, edit the variables at the top of the script:

```powershell
$louTranslatePath = "C:\liblouis-3.35.0-win64\bin\lou_translate.exe"
$tablePath = "C:\liblouis-3.35.0-win64\share\liblouis\tables\en-ueb-g2.ctb"
```

Make sure `lou_translate` is either on your PATH or the full path above is correct. The script will attempt to find `lou_translate.exe` on PATH as a fallback.

## Use

Run the script and use the interactive menu to:

- Generate worksheets (choose operation and parameters)
- Convert existing worksheets in the `math_worksheets` subfolder to BRF (individual or combined)
- Generate-and-convert in a single flow

Typical workflow:


1. Run the script from its directory:

```powershell
.\math_worksheet_tui.ps1
```

1. Choose an option from the menu:

   1. 1–4: generate worksheets (select digits and count)
   2. 5: convert existing `.txt` worksheets to individual `.brf` files
   3. 6: combine existing `.txt` worksheets into a single BRF file
   4. 7–8: generate + convert in one step
   5. 9: exit

1. Generated worksheets are placed in `math_worksheets` next to the script unless you move or rename the folder.

### Example: Generate 25 two-digit addition worksheets

From the menu, choose `1` (Addition), then when prompted set digits `2` and number of worksheets `25`.

### Example: Convert generated worksheets to a combined BRF

From the menu, choose `6`, accept the default combined filename or provide your own.

## Configuration

Configurable variables at the top of the script:

- `$outputFolder` — folder where `.txt` worksheets are saved (default: `math_worksheets` next to the script)
- `$louTranslatePath` — path to `lou_translate.exe` (update to your installation)
- `$tablePath` — path to the Liblouis table file to use for translation (e.g., `en-ueb-g2.ctb`)

Tip: If you install `lou_translate` and add it to your PATH, the script will detect it automatically.

## Troubleshooting

- If conversion fails with "lou_translate not found", confirm the path variables and that `lou_translate.exe` runs from a shell.
- If native Liblouis tables fail, ensure you are using a UEB table (e.g. `en-ueb-g2.ctb`) and that the version of liblouis is compatible with your platform.
- Conversion errors for specific files will be shown in the script output; re-run conversion after fixing the input files or table.

## Resource download

The link below will download a zipped file with the PowerShell script and a README.
[Download the PowerShell script](https://github.com/TVIResources/BrailleMathWorksheetGenerator/archive/refs/heads/main.zip){: .external }

## License & Citation

This script is provided under the Apache 2.0 license. Include attribution when reusing or redistributing.
