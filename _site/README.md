# tviresources.github.io
Website with instructional resources for teachers of Visually Impared/Blind Students

Go to [https://tviresources.github.io](https://tviresources.github.io) to see more

## Styling

This site uses the Simple.css framework via CDN for base styles:

- CDN: <https://cdn.simplecss.org/simple.css>

The repository also includes a local `css/styles.css` file for project-specific overrides. Local styles are loaded after the CDN so you can customize colors, spacing, and small layout changes without modifying the CDN file.

## Building locally (Windows)

If you want to build the site locally on Windows (run `bundle install` and `bundle exec jekyll build`), the recommended approaches are:

- Use WSL (Windows Subsystem for Linux) and install Ruby there (preferred for parity with CI).
- Or install Ruby + MSYS2 on native Windows. With recent Windows versions you can install Ruby + MSYS2 quickly using `winget` as shown below.

PowerShell (run as Administrator):

```powershell
# Install Ruby with MSYS2 runtime via RubyInstaller using winget
winget install --id=RubyInstaller.Ruby.3.1 --source=winget

# After install, open a new PowerShell or MSYS2 terminal and install bundler
gem install bundler

# From the repository root
bundle install
bundle exec jekyll build --destination _site
```

Notes:

- The RubyInstaller distribution includes MSYS2 which is required for building native gem extensions on Windows.
- If you see errors during `bundle install` about missing build tools, run the MSYS2 installer that comes with RubyInstaller (it will prompt on first run) or follow the RubyInstaller MSYS2 setup instructions.
- WSL (Ubuntu) is often simpler: install Ruby there and run the same `bundle` / `jekyll` commands; it behaves more like the Ubuntu CI runner used in GitHub Actions.

