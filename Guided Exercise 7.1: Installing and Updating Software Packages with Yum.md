# Guided Exercise 7.1: Installing and Updating Software Packages with Yum

In this exercise, you will install and remove packages and package groups.

## Outcomes

You should be able to install and remove packages with dependencies.

Log in as the student user on workstation using student as the password.

From workstation run the lab software-yum start command. The command runs a start script that determines if the host, servera, is reachable on the network.

```
[student@workstation ~]$ lab software-yum start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, so a password is not required to log in to servera.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Use the sudo -i command to switch to the root user at the shell prompt.

```
[student@servera ~]$ sudo -i
Password: student
[root@servera ~]#  
```

3. Search for a specific package.

3.1. Attempt to run the command guile. You should find that it is not installed.

```
[root@servera ~]# guile
-bash: guile: command not found 
```

3.2. Use the yum search command to search for packages that have guile as part of their name or summary.

```
[root@servera ~]# yum search guile
========================= Name Exactly Matched: guile ===============
guile.i686 : A GNU implementation of Scheme for application extensibility
guile.x86_64 : A GNU implementation of Scheme for application extensibility
```

3.3. Use the yum info command to find out more information about the guile package.

```
[root@servera ~]# yum info guile
Available Packages
Name         : guile
Epoch        : 5
Version      : 2.0.14
Release      : 7.el8
...output omitted...
```

4. Use the yum install command to install the guile package.

```
[root@servera ~]# yum install guile
...output omitted...
Dependencies resolved.
===============================================================================
 Package       Arch   Version          Repository                         Size
===============================================================================
Installing:
 guile         x86_64 5:2.0.14-7.el8   rhel-8.2-for-x86_64-appstream-rpms 3.5 M
Installing dependencies:
 gc            x86_64 7.6.4-3.el8      rhel-8.2-for-x86_64-appstream-rpms 109 k
 libatomic_ops x86_64 7.6.2-3.el8      rhel-8.2-for-x86_64-appstream-rpms  38 k
 libtool-ltdl  x86_64 2.4.6-25.el8     rhel-8.2-for-x86_64-baseos-rpms     58 k

Transaction Summary
===============================================================================
Install  4 Packages

Total download size: 3.7 M
Installed size: 12 M
Is this ok [y/N]: y
...output omitted...
Complete!
```

5. Remove packages.

5.1. Use the yum remove command to remove the guile package, but respond with no when prompted. How many packages would be removed?

```
[root@servera ~]# yum remove guile
...output omitted...
Dependencies resolved.
===============================================================================
 Package       Arch   Version         Repository                          Size
===============================================================================
Removing:
 guile         x86_64 5:2.0.14-7.el8  @rhel-8.2-for-x86_64-appstream-rpms  12 M
Removing unused dependencies:
 gc            x86_64 7.6.4-3.el8     @rhel-8.2-for-x86_64-appstream-rpms 221 k
 libatomic_ops x86_64 7.6.2-3.el8     @rhel-8.2-for-x86_64-appstream-rpms  75 k
 libtool-ltdl  x86_64 2.4.6-25.el8    @rhel-8.2-for-x86_64-baseos-rpms     69 k

Transaction Summary
===============================================================================
Remove 4 Packages

Freed space: 12 M
Is this ok [y/N]: n
Operation aborted.
```

5.2. Use the yum remove command to remove the gc package, but respond with no when prompted. How many packages would be removed?

```
[root@servera ~]# yum remove gc
...output omitted...
Dependencies resolved.
===============================================================================
 Package       Arch   Version         Repository                          Size
===============================================================================
Removing:
 gc            x86_64 7.6.4-3.el8     @rhel-8.2-for-x86_64-appstream-rpms 221 k
Removing dependent packages:
 guile         x86_64 5:2.0.14-7.el8  @rhel-8.2-for-x86_64-appstream-rpms  12 M
Removing unused dependencies:
 libatomic_ops x86_64 7.6.2-3.el8     @rhel-8.2-for-x86_64-appstream-rpms  75 k
 libtool-ltdl  x86_64 2.4.6-25.el8    @rhel-8.2-for-x86_64-baseos-rpms     69 k

Transaction Summary
===============================================================================
Remove  4 Packages 

Freed space: 12 M
Is this ok [y/N]: n
Operation aborted.
```

6. Gather information about the “Security Tools” component group and install it on servera.

6.1. Use the yum group list command to list all available component groups.

```
[root@servera ~]# yum group list
```

6.2. Use the yum group info command to find out more information about the Security Tools component group, including a list of included packages.

```
[root@servera ~]# yum group info "Security Tools"
Group: Security Tools
 Description: Security tools for integrity and trust verification.
 Default Packages:
   scap-security-guide
 Optional Packages:
   aide
   hmaccalc
   openscap
   openscap-engine-sce
   openscap-utils
   scap-security-guide-doc
   scap-workbench
   tpm-quote-tools
   tpm-tools
   tpm2-tools
   trousers
   udica
```

6.3. Use the yum group install command to install the Security Tools component group.

```
[root@servera ~]# yum group install "Security Tools"
Dependencies resolved.
===============================================================================
 Package             Arch   Version      Repository                        Size
===============================================================================
Installing group/module packages:
 scap-security-guide noarch 0.1.48-7.el8 rhel-8-for-x86_64-appstream-rpms 6.9 M
Installing dependencies:
 GConf2              x86_64 3.2.6-22.el8 rhel-8-for-x86_64-appstream-rpms 1.0 M
...output omitted...

Transaction Summary
===============================================================================
Install  6 Packages

Total download size: 12 M
Installed size: 247 M
Is this ok [y/N]: y
...output omitted...
Installed:
  GConf2-3.2.6-22.el8.x86_64               libxslt-1.1.32-4.el8.x86_64
  openscap-1.3.2-6.el8.x86_64              openscap-scanner-1.3.2-6.el8.x86_64
  scap-security-guide-0.1.48-7.el8.noarch  xml-common-0.6.3-50.el8.noarch

Complete!
```

7. Explore the history and undo options of yum.

7.1. Use the yum history command to display recent yum history.

```
[root@servera ~]# yum history
ID     | Command line             | Date and time    | Action(s)      | Altered
-------------------------------------------------------------------------------
     6 | group install Security T | 2019-02-26 17:11 | Install        |    7
     5 | install guile            | 2019-05-26 17:05 | Install        |    4
     4 | -y install @base firewal | 2019-02-04 11:27 | Install        |  127 EE
     3 | -C -y remove firewalld - | 2019-01-16 13:12 | Removed        |   11 EE
     2 | -C -y remove linux-firmw | 2019-01-16 13:12 | Removed        |    1
     1 |                          | 2019-01-16 13:05 | Install        |  447 EE
```

On your system, the history is probably different.

7.2. Use the yum history info command to confirm that the last transaction is the group installation. In the following command, replace the transaction ID by the one from the preceding step.

```
[root@servera ~]# yum history info 6
Transaction ID : 6
Begin time     : Tue 26 Feb 2019 05:11:25 PM EST
Begin rpmdb    : 563:bf48c46156982a78e290795400482694072f5ebb
End time       : Tue 26 Feb 2019 05:11:33 PM EST (8 seconds)
End rpmdb      : 623:bf25b424ccf451dd0a6e674fb48e497e66636203
User           : Student User <student>
Return-Code    : Success
Releasever     : 8
Command Line   : group install Security Tools
Packages Altered:
    Install libxslt-1.1.32-4.el8.x86_64       @rhel-8.2-for-x86_64-baseos-rpms
    Install xml-common-0.6.3-50.el8.noarch    @rhel-8.2-for-x86_64-baseos-rpms
...output omitted... 
```

7.3. Use the yum history undo command to remove the set of packages that were installed when the guile package was installed. On your system, find the correct transaction ID from the output of the yum history command, and then use that ID in the following command.

```
[root@servera ~]# yum history undo 5
```

8. Log out of the servera system.

```
[root@servera ~]# exit
logout
[student@servera ~]$ exit 
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab software-yum finish script to finish this exercise.

```
[student@workstation ~]$ lab software-yum finish
```

This concludes the guided exercise.



