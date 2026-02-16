Function Get-ModuleAuthor {
  # If no Author has been passed, use Git user.name otherwise use $Env:USERNAME
  if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Verbose "Getting Author from Git"
    $Author = git config user.name
  } else {
    Write-Verbose "Getting Author from `$Env:USERNAME"
    $Author = $Env:USERNAME
  }
  $Author
}