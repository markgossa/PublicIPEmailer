function Get-PublicIPAddress
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $To,

        [Parameter(Mandatory = $true)]
        [String]
        $From,

        [Parameter(Mandatory = $true)]
        [String]
        $SmtpServer,

        [Parameter()]
        [Boolean]
        $OnChangeOnly = $true,

        [Parameter()]
        [String]
        $IPTextFilePath = "$env:temp\IP.txt"
    )

    # Get public IP by invoking REST method
    $IP = (Invoke-RestMethod http://ipinfo.io/json).IP

    # Store public IP in temp directory
    if (-Not (Get-Item $IPTextFilePath -ErrorAction SilentlyContinue))
    {
        Set-Content -Path $IPTextFilePath -Value $IP -Force
        Send-MailMessage -To $To -From $From -Subject "$env:ComputerName Public IP Address set" `
        -Body "The Public IP address of $env:ComputerName has been set to $IP" -SmtpServer $SmtpServer
    }
    else
    {
        if ($IP -ne (Get-Content -Path $IPTextFilePath))
        {
            Send-MailMessage -To $To -From $From -Subject "$env:ComputerName Public IP Address changed" `
            -Body "The Public IP address of $env:ComputerName has been set to $IP" -SmtpServer $SmtpServer
        }
        else
        {
            if ($OnChangeOnly -eq $false)
            {
                Send-MailMessage -To $To -From $From -Subject "$env:ComputerName Public IP Address changed" `
                -Body "The Public IP address of $env:ComputerName has been set to $IP" -SmtpServer $SmtpServer
            }
        }

    }
}

Export-ModuleMember -Function *