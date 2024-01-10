# MasterParser v2.0
#### Stop wasting time, let MasterParser do the work!
![MasterParserBanner](https://github.com/YosfanEilay/MasterParser/assets/132997318/c6cbcc3f-e966-4329-aec0-c6fe8bc80bb2)

## What is MasterParser ?
MasterParser stands as a robust Digital Forensics and Incident Response tool meticulously crafted for the analysis of Linux logs within the var/log directory.
Specifically designed to expedite the investigative process for security incidents on Linux systems, MasterParser adeptly scans supported logs, such as auth.log for example,
extract critical details including SSH logins, user creations, event names, IP addresses and much more. The tool's generated summary presents this information in a clear
and concise format, enhancing efficiency and accessibility for Incident Responders. Beyond its immediate utility for DFIR teams, MasterParser proves invaluable to
the broader InfoSec and IT community, contributing significantly to the swift and comprehensive assessment of security events on Linux platforms.

## Supported Logs Format
This is the list of supported log formats within the 'var/log' directory that MasterParser can analyze. </br>
In future updates, MasterParser will support additional log formats for analysis.
|Supported Log Formats List|
| --- |
| auth.log |

## auth.log Analysis Features
Below is a comprehensive list of features that MasterParser can analyze within the auth.log log file:
#### Summary Report features
- Hostname
- Line Count
- Log Size
- Start Time
- End Time
- Duration
#### Statistics Table
- Event Names Table
- IP Addresses Table
- Failed SSH Table
- Not Found Elements Table
#### Users Groups Activity Events
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
#### General Activity Events
- Machine Shutdown By Power Button

## Feature & Log Format Requests:
If you wish to propose the addition of a new feature, kindly submit your request by creating an issue here:
https://github.com/YosfanEilay/MasterParser/issues/new

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

### Top AuthLogParser Social Media Posts

| Social Media Posts                                                        |
| ------------------------------------------------------------------------- |
| https://www.linkedin.com/feed/update/urn:li:activity:7144214785243492352/ |
