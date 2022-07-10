$gitmodulesraw = Get-Content -Path .\.gitmodules -raw
$gitmodules = $gitmodulesraw -split '\['
$submodule = @{}

foreach ($gitmodule in $gitmodules) {
    $module = @{}
    $lines = $gitmodule -split '\r?\n'
    $modname = $lines[0] -replace '.*?"([^"]*).*', '$1'
    for ($i = 1; $i -lt $lines.length; $i++) {
        $prop = $lines[$i] -split ' = '
        $propname = $prop[0].trim()
        if ($propname.Length -gt 0) {
            "Add property $propname with value $($prop[1])"
            $module.Add($propname, $prop[1])
        }
    }
    if ($modname.length -gt 0) {
        "Add module $modname"
        $submodule.Add($modname, $module)
    }
}

$submodule

# store path and url in seperate arrays
$list_of_paths = @()
$list_of_urls = @()
foreach ($line in Get-Content ./gitmodules.txt) {
    if ($line -match "path = .*$") {
        $result = $matches[0].Split('=')[-1]
        $list_of_paths += $result
    }
    if ($line -match "url = .*$") {
        $result = $matches[0].Split('=')[-1]
        $list_of_urls += $result
    }
} 

# loop thro all elements in both of arrays(both have the same length)
for ($i = 0; $i -lt $list_of_paths.Count; $i++) {
    # Write-Host $list_of_paths[$i]
    # Write-Host $list_of_urls[$i]
    git rm -rf .git/modules/$list_of_paths[$i]
    git rm -rf .git/modules/$list_of_urls[$i]
}