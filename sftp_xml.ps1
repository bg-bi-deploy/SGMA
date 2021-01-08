$port = "1255"

$userName = "yourUserName"
$userPassword = "yourPassword"
$remotedirectory = "/usr/home/transfer"
$localFileList = "C:\file1.txt", "C:\file2.txt", "C:\file3.txt"
$sftp = Open-SFTPServer -serverAddress $sftpHost -userName $userName -userPassword $userPassword
$sftp.Put($remotedirectory)
#Upload the local file to another folder on the SFTP server
$sftp.Put($remotedirectory, "/SomeFolder")

$sftp.Put($remotedirectory, "/downloadedFile.txt")

$sftp.Put($localFileList)

$sftp.Put($localFileList, "/SomeFolder")

#Close the SFTP connection
$sftp.Close()
