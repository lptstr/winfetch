#!/usr/bin/env pwsh

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

$windows_logo = "${e}[1;34m",
"                    ....,,:;+ccllll",
"      ...,,+:;  cllllllllllllllllll",
",cclllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"                                   ",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"llllllllllllll  lllllllllllllllllll",
"`'ccllllllllll  lllllllllllllllllll",
"      `' \\*::  :ccllllllllllllllll",
"                       ````''*::cll",
"                                 ``"

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
$days ="$($seconds / 60 / 60 / 24) days "
$hours ="$($seconds / 60 / 60 % 24) hours "
$mins ="$($seconds / 60 % 60) minutes"

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
$totalmem = $mem_data.TotalVisibleMemorySize
$usedmem = $freemem - $totalmem

$memory = "$([int]($usedmem/1024))MiB / $([int]($totalmem/1024))MiB"

# reset terminal sequences
write-host "${e}[0m" -nonewline

# add system info into an array
$info = @()
$info[0]                = @("OS", "$os")
$info[1]                = @("Host", "$os")
$info[2]                = @("Uptime", "$os")
$info[3]                = @("CPU", "$os")
$info[4]                = @("GPU", "$os")
$info[5]                = @("Memory", "$os")

$counter = 0
foreach ($item in $info) {
    # print line of logo
    if ($counter -le $windows_logo.Count) {
        write-host $windows_logo[$counter] -nonewline
    } else {
        write-host "                                   " -nonewline
    }
    
    # print item title 
    write-host "$($info[$counter][0])" -nonewline
    
    # print item
    write-host "$($info[$counter][1])`n" -nonewline
}

# EOF - We're done!
