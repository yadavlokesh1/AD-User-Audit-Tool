Import-Module ActiveDirectory

$daysInactive = 90
$outputPath = "$env:USERPROFILE\Desktop\Group_Members_Report.csv"

$users = Get-ADUser -Filter * -Properties DisplayName, Enabled, LastLogonDate, PasswordLastSet, Created |
Select-Object @{
    Name = 'DisplayName'
    Expression = {$_.DisplayName}
},
SamAccountName,
Enabled,
Created,
PasswordLastSet,
LastLogonDate,
@{
    Name = 'InactiveDays'
    Expression = {
        if ($_.LastLogonDate) {
            (New-TimeSpan -Start $_.LastLogonDate -End (Get-Date)).Days
        }
        else {
            "Never Logged In"
        }
    }
}

$users | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "AD User Audit Report exported to $outputPath"
