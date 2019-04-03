#!/usr/bin/env pwsh
#requires -version 6

# WinFetch - neofetch ported to PowerShell for windows 10 systems.
#
# The MIT License (MIT)
# Copyright (c) 2019 Kied Llaentenn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

$version = "0.1.0"
$e = [char]0x1B

[array]$windows_logo = @("${e}[1;34m                    ....,,:;+ccllll${e}[0m",
"${e}[1;34m      ...,,+:;  cllllllllllllllllll${e}[0m",
"${e}[1;34m,cclllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34m                                   ${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34mllllllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34m``'ccllllllllll  lllllllllllllllllll${e}[0m",
"${e}[1;34m      ``' \\*::  :ccllllllllllllllll${e}[0m",
"${e}[1;34m                       ````````''*::cll${e}[0m",
"${e}[1;34m                                 ````${e}[0m")

$color_char = "   "
$color_bar = "${e}[0;40m${color_char}${e}[0;41m${color_char}${e}[0;42m${color_char}${e}[0;43m${color_char}${e}[0;44m${color_char}${e}[0;45m${color_char}${e}[0;46m${color_char}${e}[0;47m${color_char}"

$configdir = $env:XDG_CONFIG_HOME, "$env:USERPROFILE\.config" | Select-Object -First 1
$config = "${configdir}/winfetch/config"

# ===== VARIABLES =====
$os                   = ""
$hostname             = ""
$username             = ""
$computer             = ""
$uptime               = ""
$cpu                  = ""
$gpu                  = ""
$memory               = ""
$disk                 = ""
$pwsh                 = ""

# ===== CONFIGURATION =====
$show_os              = $true
$show_hostname        = $true
$show_username        = $true
$show_computer        = $true
$show_uptime          = $true
$show_cpu             = $true
$show_gpu             = $true
$show_memory          = $true
$show_disk            = $true
$show_pwsh            = $true

if (test-path $config) {
    . "$config"
}

# ===== OS =====
if ($show_os) {
    $os = (($PSVersionTable.OS).ToString()).TrimStart("Microsoft ")
}

# ===== HOSTNAME =====
if ($show_hostname) {
    $hostname = $env:computername
}

# ===== USERNAME =====
if ($show_username) {
    $username = [System.Environment]::UserName
}

# ===== COMPUTER =====
if ($show_computer) {
    $computer_data = Get-CimInstance -ClassName Win32_ComputerSystem
    $make = $computer_data.Manufacturer
    $model = $computer_data.Model
    $computer = "$make $model"
}

# ===== UPTIME =====
if ($show_uptime) {
    $uptime_data = uptime
    
    $raw_days = $uptime_data.Days
    $raw_hours = $uptime_data.Hours
    $raw_mins = $uptime_data.Minutes
    
    write $raw_days
    write $raw_hours
    write $raw_mins
    
    $days ="${raw_days} days "
    $hours ="${raw_hours} hours "
    $mins ="${raw_mins} minutes"
    
    # remove plural if needed
    if ($raw_days -lt 2) { $days ="${raw_days} day " }
    if ($raw_hours -lt 2) { $hours ="${raw_hours} hour " }
    if ($raw_mins -lt 2) { $mins ="${raw_mins} minute" }
    
    # hide empty fields
    if ($raw_days -eq 0) { $days = "" }
    if ($raw_hours -eq 0) { $hours = "" }
    if ($raw_mins -eq 0) { $mins = "" }
    
    $uptime = "${days}${hours}${mins}"
}

# ===== CPU/GPU =====
if ($show_cpu) {
    $cpu_data = Get-CimInstance -ClassName Win32_Processor
    $cpu = $cpu_data.Name
}

if ($show_gpu) {
    $gpu_data = Get-CimInstance -ClassName Win32_VideoController
    $gpu = $gpu_data.Name
}

# ===== MEMORY =====
if ($show_memory) {
    $mem_data = Get-Ciminstance Win32_OperatingSystem
    $freemem = $mem_data.FreePhysicalMemory
    [int]$totalmem = ($mem_data.TotalVisibleMemorySize) / 1024
    [int]$usedmem = ($freemem - $totalmem) / 1024
    $memory = "${usedmem}MiB / ${totalmem}MiB"
}

# ===== DISK USAGE =====
if ($show_disk) {
    $disk_data = Get-Ciminstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freespace = $disk_data.FreeSpace
    $disk_name = $disk_data.VolumeName
    [int]$totalspace = ($disk_data.Size) / 1074000000
    [int]$usedspace = ($freespace - $totalspace) / 1074000000
    $disk = "${usedspace}GiB / ${totalspace}GiB (${disk_name})"
}

# ===== POWERSHELL VERSION =====
if ($show_pwsh) {
    $pwsh_data = ($PSVersionTable.PSVersion).ToString()
    $pwsh = "PowerShell v${pwsh_data}"
}

# reset terminal sequences and display a newline
write-host "${e}[0m`n" -nonewline

# add system info into an array
$info = New-Object 'System.Collections.Generic.List[string[]]'
$info.Add(@("OS", "$os"))
$info.Add(@("Host", "$computer"))
$info.Add(@("PowerShell", "$pwsh"))
$info.Add(@("Uptime", "$uptime"))
$info.Add(@("CPU", "$cpu"))
$info.Add(@("GPU", "$gpu"))
$info.Add(@("Memory", "$memory"))
$info.Add(@("Disk", "$disk"))
$info.Add(@("", ""))
$info.Add(@("", "$color_bar"))

# write system information in a loop
$counter = 0
while ($counter -le $info.Count+1) {
    # print line of logo
    if ($counter -le $windows_logo.Count) {
        write-host $windows_logo[$counter] -nonewline
    } else {
        write-host "                                   " -nonewline
    }
    
    if ($counter -gt 1) {
        # print item title 
        write-host "   ${e}[1;34m$(($info[$counter-2])[0])${e}[0m" -nonewline
    
        # print item, only if not empty
        if (($info[$counter-2])[1] -ne "") {
            if ("" -eq $(($info[$counter-2])[0])) {
                write-host "$(($info[$counter-2])[1])`n" -nonewline
            } else {
                write-host ": $(($info[$counter-2])[1])`n" -nonewline
            }
        }
    } else {
        # print username and dashes
        if ($counter -eq 0) {
            write-host "   ${e}[1;34m${username}${e}[0m@${e}[1;34m${hostname}${e}[0m`n" -nonewline
        } else {
            write-host "   " -nonewline
            for ($i = 0; $i -lt "${username}@${hostname}".length; $i++) {
                write-host "-" -nonewline
            }
            write-host "`n" -nonewline
        }
    }
    $counter++
}

if ($counter -lt $windows_logo.Count) {
    $octr = $counter
    while ($counter -le $windows_logo.Count) {
        write-host $windows_logo[$counter]
        $counter++
    }
}

# EOF - We're done!
