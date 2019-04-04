<h3 align="center"><img src="https://lptstr.github.io/lptstr-images/proj/winfetch/logo.png" alt="logo" height="100px"></h3>
<p align="center">A command-line system information utility for Windows</p>

<p align="center">
<img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/lptstr/winfetch.svg">
<img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/lptstr/winfetch/total.svg">
<img alt="GitHub" src="https://img.shields.io/github/license/lptstr/winfetch.svg">
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/lptstr/winfetch.svg">
<a href="https://www.codacy.com/app/lptstr/winfetch?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=lptstr/winfetch&amp;utm_campaign=Badge_Grade"><img src="https://api.codacy.com/project/badge/Grade/cc3ea20a9c4e4ec8a441e84dd9baa241"/></a>
</p>

<img src="https://lptstr.github.io/lptstr-images/screenshots/projects/winfetch/computant.png" alt="neofetch" align="right" height="240px">

WinFetch is a command-line system information utility written in PowerShell 6+ for Windows. WinFetch displays information about your operating system, software and hardware in an way similar to Neofetch and Screenfetch. 

WinFetch curently supports Windows 10; Windows 7 and Windows 8 have not yet been tested. **It is highly recommended to use WinFetch with PowerShell 6+**; errors may appear if any other version is used.

While WinFetch does work in the majority of cases, things may break occasionally. Please report all such bugs [here](https://github.com/lptstr/winfetch/issues/new).

## Features
Why you should use WinFetch:
1. **You don't have any other choices.**
2. **WinFetch is tiny.** The whole thing is ~9.5KB and 280 lines of pure PowerShell, counting comments. Compare that to Neofetch, which is about 280KB and 7500 lines of code.
3. **No need for the WSL.** While you need to install the WSL (Windows Subsystem for Linux) to run Neofetch, all you need to use WinFetch is PowerShell 6 (or later), which you probably already have installed.

## Installation
Installation with [Scoop](https://scoop.sh/) coming soon!

For now, find the latest version from the `releases` section. Download the `.zip` archive, extract, and add `./src/winfetch.ps1` to your `$PATH`.
