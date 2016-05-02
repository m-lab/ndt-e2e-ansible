# Appends a path to the machine's PATH environment variable.
#
# Usage: env_path_append.ps1 -append ";C:\foo\bar"

param (
    [Parameter(Mandatory=$true)][string]$append
)

[Environment]::SetEnvironmentVariable("Path", $env:Path + $append, [EnvironmentVariableTarget]::Machine)
