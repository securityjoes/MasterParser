# MasterParser v2.5
###### Stop wasting time, let MasterParser do the work!
![MasterParserBanner](https://github.com/YosfanEilay/MasterParser/assets/132997318/c6cbcc3f-e966-4329-aec0-c6fe8bc80bb2)
###### Created & Maintained by: [Eilay Yosfan](https://github.com/YosfanEilay#-eilay-yosfan)

## What is MasterParser ?
MasterParser stands as a robust Digital Forensics and Incident Response tool meticulously crafted for the analysis of Linux logs within the var/log directory.
Specifically designed to expedite the investigative process for security incidents on Linux systems, MasterParser adeptly scans supported logs, such as auth.log for example,
extract critical details including SSH logins, user creations, event names, IP addresses and much more. The tool's generated summary presents this information in a clear
and concise format, enhancing efficiency and accessibility for Incident Responders. Beyond its immediate utility for DFIR teams, MasterParser proves invaluable to
the broader InfoSec and IT community, contributing significantly to the swift and comprehensive assessment of security events on Linux platforms.

## MasterParser Training Materials
We have developed a comprehensive set of [training materials](https://github.com/securityjoes/MasterParser/tree/main/MasterParser%20Training/02%20-%20Exercises%20and%20Scenarios%20to%20investigate)
to help you get the most out of MasterParser. These resources are designed to provide practical, real-world scenarios that you might encounter, such as brute force attacks,
reconnaissance activities, and more. By training with these materials, you'll gain hands-on experience and deeper insights into how MasterParser can be utilized effectively.

In addition to practical scenarios, we have also created a comprehensive [PDF presentation](https://github.com/securityjoes/MasterParser/tree/main/MasterParser%20Training/01%20-%20MasterParser%20Presentation)
,this presentation covers everything you need to know before using MasterParser. All these resources are conveniently organized in a folder called [MasterParser Training](https://github.com/securityjoes/MasterParser/tree/main/MasterParser%20Training) within the repository. Whether you are new to MasterParser or looking to deepen your expertise, these materials will provide valuable guidance and support.

## MasterParser Wallpapers
Love MasterParser as much as we do? </br>
Dive into the fun and jazz up your screen with our exclusive MasterParser wallpapers! </br>
Click the link below and get ready to add a splash of excitement to your device! </br>
[Download Wallpaper](https://postimg.cc/gallery/70SrXcf)

## Supported Logs Format
This is the list of supported log formats within the var/log directory that MasterParser can analyze. </br>
In future updates, MasterParser will support additional log formats for analysis.
|Supported Log Formats List|
| --- |
| auth.log |

## Feature & Log Format Requests:
If you wish to propose the addition of a new feature \ log format, </br>
kindly submit your request by creating an issue </br>
[Click here to create a request](https://github.com/YosfanEilay/MasterParser/issues/new)

## How To Use ?
![howto use](https://github.com/YosfanEilay/AuthLogParser/assets/132997318/2d663c04-88a3-412b-aa5c-99ad48d45ba1)

### How To Use - Text Guide
1. From this GitHub repository press on "<> Code" and then press on "Download ZIP".
2. From "MasterParser-main.zip" export the folder "MasterParser-main" to you Desktop.
3. Open a PowerSehll terminal and navigate to the "MasterParser-main" folder.
```
# How to navigate to "MasterParser-main" folder from the PS terminal
PS C:\> cd "C:\Users\user\Desktop\MasterParser-main\"
```
4. Now you can execute the tool, for example see the tool command menu, do this:
```
# How to show MasterParser menu
PS C:\Users\user\Desktop\MasterParser-main> .\MasterParser.ps1 -O Menu
```
5. To run the tool, put all your /var/log/* logs in to the 01-Logs folder, and execute the tool like this:
```
# How to run MasterParser
PS C:\Users\user\Desktop\MasterParser-main> .\MasterParser.ps1 -O Start
```
6. That's it, enjoy the tool!

### How To Use - Video Guide
https://github.com/YosfanEilay/MasterParser/assets/132997318/d26b4b3f-7816-42c3-be7f-7ee3946a2c70

### MasterParser Social Media Publications
|Social Media Posts|
| --- |
| 1. [First Tool Post](https://www.linkedin.com/feed/update/urn:li:activity:7144214785243492352/) |
| 2. [First Tool Story Publication By Help Net Security](https://www.helpnetsecurity.com/2024/01/08/authlogparser-open-source-analyzing-linux-authentication-logs/) |
| 3. [Second Tool Story Publication By Forensic Focus](https://www.forensicfocus.com/interviews/eilay-yosfan-threat-researcher-security-joes/) |
| 4. [MasterParser featured in Help Net Security: 20 Essential Open-Source Cybersecurity Tools That Save You Time](https://www.helpnetsecurity.com/2024/03/25/essential-open-source-cybersecurity-tools/) |
| 5. [Tool Story Publication By endpointcave Newsletter](https://endpointcave.com/newsletter/newsletter-7-2024/0) |
