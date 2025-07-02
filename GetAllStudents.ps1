Get-ADUser -Filter * `
-SearchBase "OU=Students,OU=ManUsers,DC=Bush,DC=edu" `
-Property EmailAddress,GivenName,Surname,Description,DistinguishedName |
Where-Object { $_.DistinguishedName -match "OU=Class of \d{4}" } |
Select-Object EmailAddress,GivenName,Surname,Description |
Export-CSV "C:\Scripts\ADStudents.csv" -NoTypeInformation -Encoding UTF8
Get-Content "C:\Scripts\ADStudents.csv" | ForEach-Object { $_ -replace '"', '' } | Set-Content "C:\Scripts\ADStudents_NoQuotes.csv"
