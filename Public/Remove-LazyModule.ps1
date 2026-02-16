<#
.SYNOPSIS
  Remove the Module from the PSModulePath.
.DESCRIPTION
  Remove the Junction, if exists, from the PSModulePath with a simple command.
.NOTES
  Author: vlgndr
  Module: LazyModule
.EXAMPLE
  Remove-LazyModule AwesomePowershell -verbose
  VERBOSE: Removing Junction at $HOME\Documents\PowerShell\Modules\AwesomePowershell
#>
function Remove-LazyModule {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$Name
  )
  $PSModulePath = "$HOME\Documents\PowerShell\Modules"
  $JunctionPath = Join-Path $PSModulePath $Name
  $item = Get-Item $JunctionPath -ErrorAction SilentlyContinue

  if (-not $item) {
    Write-Error "No module link found at $JunctionPath"
    return
  } 
  if ($item.LinkType -ne "Junction") {
    Write-Error "Path exists but is not a junction: $JunctionPath"
    return
  } 

  Write-Verbose "Removing Junction at $JunctionPath"
  Remove-Item $JunctionPath -Force
}
