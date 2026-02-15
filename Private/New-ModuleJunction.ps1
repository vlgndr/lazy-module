Function New-ModuleJunction {
  param(
    [String]$Name,
    [String]$Force
  )
  $PSModulePath = "$HOME\Documents\PowerShell\Modules"
  $FullPSModulePath = Join-Path $PSModulePath $Name
  $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
  $ModulePath = Join-Path $CurrentLocation $Name
  if ((Test-Path $FullPSModulePath) -and -not $Force ) {
    Write-Error "Module folder already exists at $FullPSModulePath. Use -Force to continue."
    return
  } 
  Write-Verbose "Creating Junction at $FullPSModulePath"
  New-Item -ItemType Junction -Path $FullPSModulePath -Target $ModulePath -Force | Out-Null
}