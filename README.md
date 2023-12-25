# AuthLogParser v1.0
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

## What The Tool Can Do ?
Below is a comprehensive list of features that AuthLogParser can analyze:
#### Summary Report features
- Hostname
- Log Size
- Start Time
- End Time
- Duration
#### Statistics Table
- Event Names Table
- IP Addresses Table
- Failed SSH Table
- Not Found Elements Table
#### Raw Event Categorizing
- Successful SSH Password Authentication
- Successful SSH Public key Authentication
- New User Creation Activity
- User Deletion Activity
- User Password Change Activity
- New Group Creation Activity
- Group Deletion Activity
- User Added To A Group Activity
- User Removed From A Group Activity
- Session Opened For User root
#### Feature Requests:
If you wish to propose the addition of a new feature, kindly submit your request by creating an issue here:
https://github.com/YosfanEilay/AuthLogParser/issues/new

## How To Use ?
![howto use](https://github.com/YosfanEilay/AuthLogParser/assets/132997318/2d663c04-88a3-412b-aa5c-99ad48d45ba1)

### How To Use - Text Guide
1. From this GitHub repository press on "<> Code" and then press on "Download ZIP".
2. From "AuthLogParser-main.zip" export the folder "AuthLogParser-main" to you Desktop.
3. Open a PowerSehll terminal and navigate to the "AuthLogParser-main" folder.
```
# How to navigate to "AuthLogParser-main" folder from the PS terminal
PS C:\> cd "C:\Users\{UserName}\Desktop\AuthLogParser-main\"
```
4. From the "AuthLogParser-main" path, execute the tool on your Auth.Log file like this:
```
# Example
PS C:\Users\{UserName}\Desktop\AuthLogParser-main> .\AuthLogParser.ps1 "PATH\TO\YOUR\AUTH.LOG"
```
5. Thats it, enjoy the tool!

### How To Use - Video Guide
https://github.com/YosfanEilay/AuthLogParser/assets/132997318/43649759-8f47-40c6-a340-69c74c8af536
