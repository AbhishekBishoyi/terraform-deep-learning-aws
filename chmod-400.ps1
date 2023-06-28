# generate key: ssh-keygen -t rsa -b 2048 
# To run: .\chmod-400.ps1 .\aws-key-filepath
$path = "$($args[0])"
# Reset to remove explict permissions
icacls.exe $path /reset
# Give current user explicit read-permission
icacls.exe $path /GRANT:R "$($env:USERNAME):(R)"
# Disable inheritance and remove inherited permissions
icacls.exe $path /inheritance:r