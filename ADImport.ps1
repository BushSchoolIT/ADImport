Import-Module ActiveDirectory

$Users = Import-Csv -Path "C:\Users\Install\Documents\ADImportTest.csv"            
foreach ($User in $Users) {  
try         
{            

 # Define the parameters using a hashtable
    $NewUserParams = @{
        Name                  = "$($User.'Firstname') $($User.'Lastname')"
        GivenName             = $User.'Firstname'
        Surname               = $User.'Lastname'
        DisplayName           = $User.'Firstname' + " " + $User.'Lastname' + " " + $User.'Suffix'
        UserPrincipalName     = $User.'Firstname' + "." + $User.'Lastname' + "@bush.edu"   
        SamAccountName       = $User.'Firstname' + "." + $User.'Lastname' 
        Path                  = "OU=" + $User.'OU' + ",OU=Students,OU=ManUsers,DC=bush,DC=edu"
        Description           = $User.'OU'
        Department            = $User.'OU'
        Company               = $User.'OU'
        Country               = "US"
        EmailAddress          = $User.'Firstname' + "." + $User.'Lastname' + "@bush.edu"   
        AccountPassword       = (ConvertTo-SecureString $User.'Password'  -AsPlainText -Force)
        Enabled               = $true
        ChangePasswordAtLogon = $false # Set the "User must change password at next logon"
    }
    Write-Output $NewUserParams

    # Check to see if the user already exists in AD
    if (Get-ADUser -Filter "UserPrincipalName -eq '$($User.'Firstname' + "." + $User.'Lastname' + "@bush.edu")'") {

        # Give a warning if user exists
        Write-Host "A user with username $($User.'User logon name') already exists in Active Directory." -ForegroundColor Yellow
    }
    else {
        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $User.OU variable read from the CSV file
        New-ADUser @NewUserParams
        Write-Host "The user $($User.'Firstname' + "." + $User.'Lastname' + "@bush.edu") is created successfully." -ForegroundColor Green
    }
    }
    catch {
    # Handle any errors that occur during account creation
    Write-Host "Failed to create user $($User.'Firstname' + "." + $User.'Lastname' + "@bush.edu") - $($_.Exception.Message)" -ForegroundColor Red
}
}