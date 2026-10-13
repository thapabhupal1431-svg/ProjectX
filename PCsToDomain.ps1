# PCsToDomain.ps1
# Author: Bhupal
# What it does: Joins the computers listed in a text file to the jackshot domain.
# How to use: Run this on the server. Before running it, put one computer name
#             on each line of C:\Computers.txt (for example Idli, chai, Dosa).
 
# ---------- Settings ----------
 
# The domain the computers will join
$domain = "jackshot.powershell.local"
 
# Domain admin login
$user = "jackshot.powershell.local\jackshot"
$password = ConvertTo-SecureString "p@33w0rd" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user, $password)
 
# Local admin login of the computers (a box will pop up to ask for it)
$localCred = Get-Credential -Message "Enter the local admin login for the computers"
 
# Read the computer names from the text file
$pcList = Get-Content -Path "C:\Computers.txt"
 
# ---------- Join each computer ----------
 
foreach ($pc in $pcList) {
 
    Write-Host "Joining $pc to $domain ..."
 
    # Join the computer to the domain (it restarts by itself)
    Add-Computer -ComputerName $pc -LocalCredential $localCred -DomainName $domain -Credential $cred -Restart
 
    # $? is True if the last command worked and False if it failed
    if ($?) {
        Write-Host "$pc joined the domain and is restarting."
    }
    else {
        Write-Host "$pc could not be joined. Check the name and the firewall."
    }
}
 
Write-Host "Finished. All computers in the list were tried."
