# General Purpose Utilities

# Function for resolving Filepaths. Avoids errors causes resolving filepaths when running scripts from different environments and contexts
function ResolveFilePath {
    param (
        $File
    )
    $fullpath = Get-ChildItem -Path C:\Users\$env:UserName -Filter $File -Recurse | %{$_.FullName}
    return $fullpath

}