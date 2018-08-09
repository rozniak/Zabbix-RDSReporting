<#
    .SYNOPSIS
    This script is used for reading user session counts.

    .DESCRIPTION
    This script calls into the standard 'query user' command in Windows to retrieve
    the session information, then parses it to properly count sessions in the state
    specified in the parameter.

    .PARAMETER SessionState
    The state to filter by in 'query user'. (Choices: *,
                                                      Active,
                                                      Disc)

    .EXAMPLE
    Get-SessionCount.ps1 -SessionState Disc

    .NOTES
    Author: Rory Fewell
    GitHub: https://github.com/rozniak
    Website: https://oddmatics.uk
#>

Param (
    [Parameter(Position=0, Mandatory=$TRUE)]
    [String]
    $SessionState
)

$filteredCount = 0

# Get RDS Sessions
#
$queryOutput = & "query" ("user")
$queryResults = ($queryOutput.Split([Environment]::NewLine))

for ($i = 1; $i -lt $queryResults.Length; $i++)
{
    $queryResult = ($queryResults[$i].Trim() -Split "\s+")
    $sessState = $NULL

    if ($queryResult.Length -eq 7) # SESSION NAME PRESENT
    {
        $sessState = $queryResult[3]
    }
    elseif ($queryResult.Length -eq 6) # SESSION NAME BLANK
    {
        $sessState = $queryResult[2]
    }

    # Apply the filter
    #
    if ($SessionState -eq "*" -or $sessState -eq $SessionState)
    {
        $filteredCount++
    }
}

return $filteredCount