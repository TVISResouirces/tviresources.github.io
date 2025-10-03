---
layout: default
title: Contributing
description: How to contribute resources to TVI Resources
---

# Contributing

To add a new resource:

1. Create a folder under the repository root with a short, hyphenated name (e.g. `my-section`).
2. Copy `template.md` into that folder and rename it to `my-resource.md`.
3. Fill out Description, Use, and Resource download sections.
4. Edit the folder's `index.md` to add a link to your new resource.
5. Commit and open a pull request.

Using the automated helper

There is a PowerShell helper script to add a resource and update the section index automatically.

Usage (copy-paste):

PowerShell (from the repository root):

```powershell
.\n+\scripts\add-resource.ps1 -Section 3dprints -ResourceName my-new-print -Title "My New Print" -DownloadUrl "https://example.com/my-print.stl"
```

Notes:

- Run the command from the repository root so the script can find `template.md` and section folders using relative paths.
- If your Title contains special characters or spaces, wrap it in double quotes as shown.
- The script will create the section folder if it doesn't exist, create the resource file from `template.md`, replace the title, replace the download link, and insert the new link as the most recent item under `## Resources` (keeps only 5 items).

After running the script verify the generated file and `index.md`, then commit the changes.

Automatically fix front matter

If some files still lack YAML front matter, you can run the helper script to add it to every markdown file (skips `template.md`):

PowerShell (from repo root):

```powershell
.\scripts\add-front-matter.ps1
```

Site styling

This site uses the Simple.css stylesheet via the official CDN (<https://simplecss.org>). A local stylesheet at `css/styles.css` is loaded after the CDN so contributors can add small, targeted overrides (colors, spacing, minor layout tweaks) in their resource pull requests. Avoid large rewrites of the base framework; prefer small, specific CSS rules scoped to the page or resource when possible.
This will insert a basic front matter block using each file's first heading or filename as the title. Review the results and commit.
