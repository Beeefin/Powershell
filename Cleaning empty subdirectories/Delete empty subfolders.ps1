# Function to delete empty folders recursively
function Remove-EmptyFoldersRecursively {
    param (
        [string]$Path,
        [bool]$IsRoot = $false
    )

    # Get all directories in the given path
    $directories = Get-ChildItem -Path $Path -Directory

    foreach ($directory in $directories) {
        # Recursively call the function for each subdirectory
        Remove-EmptyFoldersRecursively -Path $directory.FullName
    }

    # After processing subdirectories, check if the current directory is empty
    $items = Get-ChildItem -Path $Path

    if ($items.Count -eq 0 -and -not $IsRoot) {
        # If empty and not a root directory, delete the directory
        Remove-Item -Path $Path -Force -Recurse
        Write-Output "Deleted empty folder: $Path"
    }
}

# Array of root directory paths to check
$rootPaths = @(
    "C:\Pathto\folder",
    "C:\Pathto\folder",
    "C:\Pathto\folder"
)

# Iterate through each root path and call the function
foreach ($rootPath in $rootPaths) {
    if (Test-Path -Path $rootPath) {
        Remove-EmptyFoldersRecursively -Path $rootPath -IsRoot $true
    } else {
        Write-Output "Path does not exist: $rootPath"
    }
}
