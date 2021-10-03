# Guided Exercise 7.4 Lab: Installing and Updating Software Packages

## Performance Checklist

In this lab, you will manage software repositories and module streams, and install and upgrade packages from those repositories and streams.

## Outcomes

You should be able to:

- Manage software repositories and module streams.

- Install and upgrade packages from repositories and streams.

- Install an RPM package.

Log in to workstation as student using student as the password.

On workstation, run the lab software-review start command. This script ensures that serverb is available. It also downloads any packages required for the lab exercise.

```
[student@workstation ~]$ lab software-review start
```

1. On serverb configure a software repository to obtain updates. Name the repository as errata and configure the repository in the /etc/yum.repos.d/errata.repo file. It should access http://content.example.com/rhel8.2/x86_64/rhcsa-practice/errata. Do not check GPG signatures.

1.1. From workstation use the ssh command to log in to serverb as the student user.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

1.2. Use the sudo -i command to switch to the root user.

```
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]#  
```

1.3. Create the file /etc/yum.repos.d/errata.repo with the following content:

```
[errata]
name=Red Hat Updates
baseurl=http://content.example.com/rhel8.2/x86_64/rhcsa-practice/errata
enabled=1
gpgcheck=0
```

2. On serverb, install new package xsane-gimp and the Apache HTTP Server module from the 2.4 stream and the common profile.

2.1. Use the yum list command to list the available packages for xsane-gimp.

```
[root@serverb ~]# yum list xsane-gimp
Last metadata expiration check: 0:24:30 ago on Thu 07 Mar 2019 03:50:55 PM CET.
Available Packages
xsane-gimp.x86_64     0.999-30.el8    rhel-8.2-for-x86_64-appstream-rpms
```

2.2. Install the latest version of the xsane-gimp package using the yum install command.

```
[root@serverb ~]# yum install xsane-gimp
...output omitted...
Install  59 Packages

Total download size: 53 M
Installed size: 217 M
Is this ok [y/N]: y
...output omitted...
Complete!
[root@serverb ~]# 
```

2.3. List available modules and streams. Look for the httpd module. Use the yum install command to install the httpd module with the 2.4 stream and the common profile.

```
[student@serverb ~]$ yum module list
Name       Stream      Profiles                      Summary
...output omitted...
httpd      2.4 [d]     common [d], devel, minimal    Apache HTTP Server
...output omitted...
[root@serverb ~]# yum module install httpd:2.4/common
Install  10 Packages

Total download size: 2.1 M
Installed size: 5.7 M
Is this ok [y/N]: y
...output omitted...
Complete!
[root@serverb ~]# 
```

3. For security reasons, serverb should not be able to send anything to print. Achieve this by removing the cups package. Exit from the root account.

3.1. Use the yum list command to list the installed cups package.

```
[root@serverb ~]# yum list cups
Installed Packages
cups.x86_64          1:2.2.6-33.el8         @rhel-8.2-for-x86_64-appstream-rpms
[root@serverb ~]# 
```

3.2. Use the yum remove command to remove the cups package.

```
[root@serverb ~]# yum remove cups.x86_64
...output omitted...
Remove  9 Packages

Freed space: 11 M
Is this ok [y/N]: y
...output omitted...
Complete!
```

3.3. Exit from the root account.

```
[root@serverb ~]# exit
[student@serverb ~]$ 
```

4. The start script downloads the rhcsa-script-1.0.0-1.noarch.rpm package in the /home/student directory on serverb.

Confirm that the package rhcsa-script-1.0.0-1.noarch.rpm is available on serverb. Install the package. You will need to gain superuser privileges to install the package. Verify that the package is installed. Exit from serverb.

4.1. Use the rpm command to confirm that the rhcsa-script-1.0.0-1.noarch.rpm package is available on serverb by viewing the package information.

```
[student@serverb ~]$ rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -i
Name        : rhcsa-script
Version     : 1.0.0
Release     : 1
Architecture: noarch
Install Date: (not installed)
Group       : System
Size        : 1056
License     : GPL
Signature   : (none)
Source RPM  : rhcsa-script-1.0.0-1.src.rpm
Build Date  : Wed 06 Mar 2019 11:29:46 AM CET
Build Host  : foundation0.ilt.example.com
Relocations : (not relocatable)
Packager    : Snehangshu Karmakar
URL         : http://example.com
Summary     : RHCSA Practice Script
Description :
A RHCSA practice script.
The package changes the motd.
```

4.2. Use the sudo yum localinstall command to install the rhcsa-script-1.0.0-1.noarch.rpm package. The password is student.

```
[student@serverb ~]$ sudo yum localinstall \
rhcsa-script-1.0.0-1.noarch.rpm
[sudo] password for student: student
Last metadata expiration check: 1:31:22 ago on Thu 07 Mar 2019 03:50:55 PM CET.
Dependencies resolved.
===================================================================
 Package             Arch    Version    Repository         Size
===================================================================
Installing:
 rhcsa-script       noarch  1.0.0-1    @commandline       7.6 k

Transaction Summary
===================================================================
Install  1 Package

Total size: 7.6 k
Installed size: 1.0 k
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                          1/1
  Running scriptlet: rhcsa-script-1.0.0-1.noarch              1/1
  Installing       : rhcsa-script-1.0.0-1.noarch              1/1
  Running scriptlet: rhcsa-script-1.0.0-1.noarch              1/1
  Verifying        : rhcsa-script-1.0.0-1.noarch              1/1

Installed:
  rhcsa-script-1.0.0-1.noarch

Complete!
```

4.3. Use the rpm command to verify that the package is installed.

```
[student@serverb ~]$ rpm -q rhcsa-script
rhcsa-script-1.0.0-1.noarch
[student@serverb ~]$ 
```

4.4. Exit from serverb

```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
```

## Evaluation

On workstation, run the lab software-review grade script to confirm success on this lab.

```
[student@workstation ~]$ lab software-review grade
```

## Finish

On workstation, run the lab software-review finish script to complete this exercise. This script removes the repository and packages created during this exercise.

```
[student@workstation ~]$ lab software-review finish
```

This concludes the lab.
