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


# ===== VARIABLES =====
$os                   = ""
$hostname             = ""
$username             = ""
$computer             = ""
$uptime               = ""
$cpu                  = ""
$gpu                  = ""
$memory               = ""

# ===== OS =====
$os = (($PSVersionTable.OS).ToString()).TrimStart("Microsoft ")

# ===== HOSTNAME =====
$hostname = $env:computername

# ===== USERNAME =====
$username = [System.Environment]::UserName

# ===== COMPUTER =====
$computer_data = Get-CimInstance -ClassName Win32_ComputerSystem
$make = $computer_data.Manufacturer
$model = $computer_data.Model
$computer = "$make $model"

# ===== UPTIME =====
$uptime_data = uptime
$seconds = $uptime_data.TotalSeconds

[int]$raw_days ="$($seconds / 60 / 60 / 24)"
[int]$raw_hours ="$($seconds / 60 / 60 % 24)"
[int]$raw_mins ="$($seconds / 60 % 60)"

$days ="${raw_days} days "
$hours ="${raw_hours} hours "
$mins ="${raw_minutes} minutes"

# hide empty fields
if (($seconds / 60 / 60 / 24) -le 0) { $days = "" }
if (($seconds / 60 / 60 % 24) -le 0) { $hours = "" }
if (($seconds / 60 % 60) -le 0) { $minutes = "" }

# remove plural if needed
if (($seconds / 60 / 60 / 24) -lt 2) { $days = "$($days.TrimEnd(" days ")) day " }
if (($seconds / 60 / 60 % 24) -lt 2) { $hours = "$($days.TrimEnd(" hours ")) hour " }
if (($seconds / 60 % 60) -lt 2) { $hours = "$($days.TrimEnd(" minutes ")) minute " }

$uptime = "${days}${hours}${minutes}"

# ===== CPU/GPU =====
$cpu_data = Get-CimInstance -ClassName Win32_Processor
$cpu = $cpu_data.Name

$gpu_data = Get-CimInstance -ClassName Win32_VideoController
$gpu = $gpu_data.Name

# ===== MEMORY =====
$mem_data = Get-Ciminstance Win32_OperatingSystem
$freemem = $mem_data.FreePhysicalMemory
[int]$totalmem = ($mem_data.TotalVisibleMemorySize) / 1024
[int]$usedmem = ($freemem - $totalmem) / 1024

$memory = "${usedmem}MiB / ${totalmem}MiB"

# reset terminal sequences and display a newline
write-host "${e}[0m`n" -nonewline

# add system info into an array
$info = New-Object 'System.Collections.Generic.List[string[]]'
$info.Add(@("OS", "$os"))
$info.Add(@("Host", "$computer"))
$info.Add(@("Uptime", "$uptime"))
$info.Add(@("CPU", "$cpu"))
$info.Add(@("GPU", "$gpu"))
$info.Add(@("Memory", "$memory"))
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
    
        # print item
        if ("" -eq $(($info[$counter-2])[0])) {
            write-host "$(($info[$counter-2])[1])`n" -nonewline
        } else {
            write-host ": $(($info[$counter-2])[1])`n" -nonewline
        }
    } else {
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
