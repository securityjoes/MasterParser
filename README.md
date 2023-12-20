# AuthLogParser
#### Stop wasting time, let AuthLogParser do the work!
![Untitled design](https://github.com/YosfanEilay/AuthLogParser/assets/132997318/2121356e-d6e3-4ee8-9ebc-b54b895c0020)

## What is AuthLogParser ?
AuthLogParser is a powerful Digital Forensics and Incident Response tool designed specifically for analyzing Linux authentication logs,
commonly known as auth.log. This tool serves as an invaluable asset for Incident Responders, streamlining the process of investigating security
incidents on Linux systems. AuthLogParser meticulously scans the auth.log log file, extracting key information such as SSH logins, user creations,
event names, IP addresses, and more. The generated summary provides a clear and concise overview of the activities recorded in the authentication
logs, presenting the data in an easily readable format. By enhancing efficiency and accessibility, AuthLogParser significantly contributes to the
effectiveness of incident response efforts, enabling practitioners to quickly and comprehensively assess security events on Linux platforms.
While it proves indispensable for Incident Responders, its utility extends beyond DFIR teams, making it a valuable asset for the entire
InfoSec and IT community.

## How To Use ?
![howto use](https://github.com/YosfanEilay/AuthLogParser/assets/132997318/2d663c04-88a3-412b-aa5c-99ad48d45ba1)

### How To Use - Text Guide
1. From this GitHub repository press on "<> Code" and then press on "Download ZIP".
2. From "ALP.zip" export the folder "AuthLogParser" to you Desktop.
3. Open a PowerSehll terminal and navigate to the "AuthLogParser" folder.
```
# How to navigate to "AuthLogParser" folder from the PS terminal
PS C:\> cd "C:\Users\{UserName}\Desktop\AuthLogParser\"
```
4. From the "AuthLogParser" path, execute the tool on your Auth.Log file like this:
```
# Example without path
PS C:\Users\{UserName}\Desktop\AuthLogParser> ".\AuthLogParser.ps1 PATH\TO\YOUR\AUTH.LOG"

# Real example
PS C:\Users\EilayYosfan\Desktop\AuthLogParser> .\AuthLogParser.ps1 "C:\Users\EilayYosfan\Desktop\Auth.Logs\auth.log.10"
```
5. Thats it, enjoy the tool :]
