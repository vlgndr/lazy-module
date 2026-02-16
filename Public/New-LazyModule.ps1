<#
.SYNOPSIS
  Quickly scaffold a PowerShell Module.
.DESCRIPTION
  Create a PowerShell Module that includes psd1, psm1, Public and Private directories and a Junction to the PSModulePath pointing to the current project.
  Junction is useful if you want to keep your module separate, in a specific directory (like a Project directory), maybe with Git, and having the same Module linked to the PSModulePath. By doing so, you can always work in you preferred directory, without worrying about the PSModulePath at all.
.NOTES
  Author: vlgndr
  Module: LazyModule
.EXAMPLE
  Create the DemoModule Module in the Projects directory, create a Junction in the PSModulePath and show verbosity
  New-LazyModule DemoModule -Path $HOME\Projects -Verbose
  VERBOSE: Creating DemoModule.psd1 at $HOME\Projects\DemoModule
  VERBOSE: Getting Author from Git
  VERBOSE: Creating Junction at $HOME\Documents\PowerShell\Modules\DemoModule

.EXAMPLE
  Create the DemoModule Module in the current directory, do not create a Junction and show verbosity
  New-LazyModule DemoModule -NoJunction -Verbose
  VERBOSE: Creating DemoModule.psd1 at $HOME\DemoModule
  VERBOSE: Getting Author from Git
#>
function New-LazyModule {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$Name,
    [String]$Path,
    [String]$Author,
    [String]$Description,
    [Switch]$NoJunction,
    [Switch]$Force
  )
  $Psm1 = "$Name.psm1"
  $Psd1Path = New-ModuleStructure -Path $Path -Name $Name -Force $Force

  if (-not $Author) {
    $Author = Get-ModuleAuthor 
  } 

  if (-not $NoJunction) {
    New-ModuleJunction -Name $Name -Path $Path -Force $Force
  }

  New-ModuleManifest -path $Psd1Path -RootModule $Psm1 -Author $Author -Description $Description
}