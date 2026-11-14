# Code signing policy

Free code signing provided by [SignPath.io](https://about.signpath.io), certificate by [SignPath Foundation](https://signpath.org).

## Scope

Only the files built from the source code of this repository by its GitHub Actions workflows are signed:

* `Sophia.Script.for.Windows.11.v*_WinGet.exe` — the self-extracting launcher for [WinGet](https://github.com/microsoft/winget-pkgs/tree/master/manifests/t/TeamSophia/SophiaScript). It's built from [SophiaLauncher.cs](Scripts/Launcher/SophiaLauncher.cs) and extracts the release archive to the Downloads folder.

Every file is built on a GitHub-hosted runner from the `main` branch by [Sophia.yml](.github/workflows/Sophia.yml). Every release signing request is approved manually.

## Team roles

* Committers and reviewers: [farag2](https://github.com/farag2)
* Approvers: [farag2](https://github.com/farag2)

All team members use multi-factor authentication for GitHub and SignPath.

## Privacy policy

Sophia Script doesn't collect, store, or send any personal data.

Sophia Script connects to the Internet only in these cases:

* On start, it downloads [Sophia_Script_Releases.json](Sophia_Script_Releases.json) and [Windows_Builds.json](Windows_Builds.json) from `raw.githubusercontent.com` to check for a new version and for supported Windows builds. No data is sent except a regular HTTP request.
* When the user runs a function that installs or updates a component (for example, OneDrive, Microsoft Visual C++ Redistributable, .NET, HEVC, WSL distributions, or cursors), it downloads that component and its version information from Microsoft servers, GitHub (this repository, `microsoft/WSL`, `ScoopInstaller/Extras`).

Sophia Script doesn't transfer any information to other networked systems unless specifically requested by the user or the person who runs it.
