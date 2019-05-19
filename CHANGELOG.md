# Changelog
- `[+]` = added feature
- `[-]` = removed feature
- `[*]` = fixed issue
- `[!]` = something changed

### \[Unreleased\]
- `[!]` Minor internal changes
- `[!]` Winfetch no longer outputs terminal version (fix #)
- `[+]` Short command options

### \[v1.2.0\]
- `[+]` Add support for PowerShell 5
- `[!]` Rewrite internals, Winfetch is now faster
- `[+]` Make Winfetch output redirectable
- `[+]` Add contributing guide
- `[!]` Add support for new configuration style ([**@TheIncorrigible1**](https://github.com/TheIncorrigible1))
- `[!]` Cleaned logic and added consistent style ([**@TheIncorrigible1**](https://github.com/TheIncorrigible1))
- `[!]` Dependencies `curl` and PowerShell 6 no longer needed
- `[!]` Added `get-help` page to Winfetch

### \[v1.1.0\]
- `[*]` Fixed issue #2: color bar color does not reset in Cmder/ConEmu
- `[+]` Added field for current terminal emulator
- `[+]` Added ability to enable/disable title and dashes in config
- `[!]` Normalized order of information fields (like Neofetch)
- `[+]` **Added support for custom ASCII image in the terminal!** Yay!
- `[+]` Added -noimage flag to not display any image or logo
- `[+]` Added `-help` flag to Winfetch that displays a help message
- `[!]` Merged package managers/packages installed fields into one field

### \[v1.0.0\]
- `[*]` Fixed issue #1: uptime does not display properly
- `[!]` Change configuration file to `config.ps1` from `config`
- `[+]` Add support for custom configuration
- `[!]` Change internal method of getting uptime
- `[+]` Add field for package manager
- `[+]` Add field for packages installed count
