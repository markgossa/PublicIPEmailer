Import-Module -Name .\PublicIPEmailer.psm1 -Force 

Get-PublicIPAddress -To mark@gossa.co.uk -From mark@gossa.co.uk -SmtpServer svr01.gossa.co.uk -OnChangeOnly $false