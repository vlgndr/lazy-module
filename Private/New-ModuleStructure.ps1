  Function New-ModuleStructure {
  param (
    [String]$Path,
    [String]$Name,
    [String]$Force
  )
  $ReadPrivateDirectoryCmdlet = 'Get-ChildItem "$PSScriptRoot\Private\*.ps1" | ForEach-Object {. $_.FullName}'
  $ReadPublicDirectoryCmdlet = 'Get-ChildItem "$PSScriptRoot\Public\*.ps1" | ForEach-Object {. $_.FullName}'
  $Psd1 = "$Name.psd1"
  $Psm1 = "$Name.psm1"

  # Path has not been passed, so I create the directory structure at the current path
  if (-not $Path) {
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $ModulePath = Join-Path $CurrentLocation $Name
    $Psd1Path = Join-Path $ModulePath $Psd1
  }  

  # Path has been passed, create the directory there
  else {
    $ModulePath = Join-Path $Path $Name
    $Psd1Path = Join-Path $ModulePath $Psd1
  }

  if ((Test-Path $Psd1Path) -and -not $Force ) {
    Write-Error "Module directory already exists at $Psd1Path. Use -Force to continue."
    return
  } 
  Write-Verbose "Creating $Psd1 at $ModulePath"
  New-Item -Type File -Path $Psd1Path -Force | Out-Null

  # Creating Public and Private Directory
  New-Item -ItemType Directory -Name "Public" -Path $ModulePath | Out-Null
  New-Item -ItemType Directory -Name "Private" -Path $ModulePath | Out-Null
  New-Item -ItemType File -Name $Psm1 -Path $ModulePath | Out-Null

  Write-Output $ReadPublicDirectoryCmdlet | Out-File (Join-Path $ModulePath $Psm1)
  Write-Output $ReadPrivateDirectoryCmdlet | Out-File (Join-Path $ModulePath $Psm1) -Append

  $Psd1Path
}