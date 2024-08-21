Import-Module ActiveDirectory

# Import the CSV file containing the user information. Set the path to the location of the CSV file
$Users = Import-Csv -Path "C:\Users\Install\Documents\ADImportTest.csv"            
foreach ($User in $Users) {  
try         
{            

 # Define the parameters using a hashtable
    $NewUserParams = @{
        Name                  = "$($User.'Firstname') $($User.'Lastname') $($User.'Suffix')"
        GivenName             = $User.'Firstname'
        Surname               = $User.'Lastname'
        DisplayName           = $User.'Firstname' + " " + $User.'Lastname' + " " + $User.'Suffix'
        UserPrincipalName     = $User.'Firstname' + "." + $User.'Lastname' + "@bush.edu"
        # SamAccountName is limited to 20 characters. If the name is longer than 20 characters, you will need to manually create the account
        SamAccountName        = $User.'Firstname' + "." + $User.'Lastname' 
        Path                  = "OU=" + $User.'OU' + ",OU=Students,OU=ManUsers,DC=bush,DC=edu"
        Description           = $User.'OU'
        Department            = $User.'OU'
        Company               = $User.'OU'
        EmailAddress          = $User.'Firstname' + "." + $User.'Lastname' + "@bush.edu"   
        AccountPassword       = (ConvertTo-SecureString $User.'Password'  -AsPlainText -Force)
        Enabled               = $true
        ChangePasswordAtLogon = $false
        PasswordNeverExpires  = $true
        Title                 = "Student"
    }
    Write-Output $NewUserParams

    # Check to see if the user already exists in AD
    if (Get-ADUser -Filter "UserPrincipalName -eq '$($User.'Firstname' + "." + $User.'Lastname' + "@bush.edu")'") {

        # Give a warning if user exists
        Write-Output "A user with username $($User.'User logon name') already exists in Active Directory."
	    Write-Output " "
    }
    else {
        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $User.OU variable read from the CSV file
        New-ADUser @NewUserParams
        # Set the country code and proxy address for the new user
        Set-ADUser -Identity $($User.'Firstname' + "." + $User.'Lastname') -Replace @{c="US";co="United States";countrycode=840}
        Set-ADUser -Identity $($User.'Firstname' + "." + $User.'Lastname') -add @{ProxyAddresses="SMTP:" + $User.'Firstname' + "." + $User.'Lastname' + "@bush.edu"}
        Write-Output "The user $($User.'Firstname' + "." + $User.'Lastname' + "@bush.edu") is created successfully."
	    Write-Output " "
    }
    }
    catch {
    # Handle any errors that occur during account creation
    Write-Output "Failed to create user $($User.'Firstname' + "." + $User.'Lastname' + "@bush.edu") - $($_.Exception.Message)"
    Write-Output " "
}
}
