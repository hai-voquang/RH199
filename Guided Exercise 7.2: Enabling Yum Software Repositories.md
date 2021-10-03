# Guided Exercise 7.2: Enabling Yum Software Repositories

In this exercise, you will configure your server to get packages from a remote Yum repository, then update or install a package from that repository.

## Outcomes

You should be able to configure a system to obtain software updates from a classroom server and update the system to use latest packages.

Log in as the student user on workstation using student as the password.

From workstation run the lab software-repo start command. The command runs a start script that determines whether the host servera is reachable on the network. The script also ensures that the yum package is installed.

```
[student@workstation ~]$ lab software-repo start
```

1. Use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Use the sudo -i command to switch to root at the shell prompt.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Configure software repositories on servera to obtain custom packages and updates from the following URL:

- Custom packages provided at http://content.example.com/rhel8.2/x86_64/rhcsa-practice/rht

- Updates of the custom packages provided at http://content.example.com/rhel8.2/x86_64/rhcsa-practice/errata

3.1. Use yum config-manager to add the custom packages repository.

```
[root@servera ~]# yum config-manager \
--add-repo "http://content.example.com/rhel8.2/x86_64/rhcsa-practice/rht"
Adding repo from: http://content.example.com/rhel8.2/x86_64/rhcsa-practice/rht
```

3.2. Examine the software repository file created by the previous command in the /etc/yum.repos.d directory. Use the vim command to edit the file and add the gpgcheck=0 parameter to disable the GPG key check for the repository.

```
[root@servera ~]# vim \
/etc/yum.repos.d/content.example.com_rhel8.2_x86_64_rhcsa-practice_rht.repo
[content.example.com_rhel8.2_x86_64_rhcsa-practice_rht]
name=created by dnf config-manager from http://content.example.com/rhel8.2/x86_64/rhcsa-practice/rht
baseurl=http://content.example.com/rhel8.2/x86_64/rhcsa-practice/rht
enabled=1
gpgcheck=0
```

3.3. Create the /etc/yum.repos.d/errata.repo file to enable the updates repository with the following content:

```
[rht-updates]
name=rht updates
baseurl=http://content.example.com/rhel8.2/x86_64/rhcsa-practice/errata
enabled=1
gpgcheck=0
```

3.4. Use the yum repolist all command to list all repositories on the system:

```
[root@servera ~]# yum repolist all
repo id                                                repo name       status
content.example.com_rhel8.2_x86_64_rhcsa-practice_rht  created by .... enabled
rht-updates                                            rht updates     enabled
...output omitted...
```

4. Disable the rht-updates software repository and install the rht-system package.

4.1. Use yum config-manager --disable to disable the rht-updates repository.

```
[root@servera ~]# yum config-manager --disable rht-updates
```

4.2. List, and then install, the rht-system package:

```
[root@servera ~]# yum list rht-system
Available Packages
rht-system.noarch  1.0.0-1 content.example.com_rhel8.2_x86_64_rhcsa-practice_rht
[root@servera ~]# yum install rht-system
Dependencies resolved.
================================================================================
 Package            Arch           Version                Repository       Size
================================================================================
Installing:
 rht-system         noarch         1.0.0-1               content..._rht   3.7 k
...output omitted...
Is this ok [y/N]: y
...output omitted...
Installed:
  rht-system-1.0.0-1.noarch
Complete!
```

4.3. Verify that the rht-system package is installed, and note the version number of the package.

```
[root@servera ~]# yum list rht-system
Installed Packages
rht-system.noarch  1.0.0-1 @content.example.com_rhel8.2_x86_64_rhcsa-practice_rht
```

5. Enable the rht-updates software repository and update all relevant software packages.

5.1 Use yum config-manager --enable to enable the rht-updates repository.

```
[root@servera ~]# yum config-manager --enable rht-updates
```

5.2. Use the yum update command to update all software packages on servera.

```
[root@servera ~]# yum update
Dependencies resolved.
================================================================================
 Package            Arch           Version                Repository       Size
================================================================================
Upgrading:
 rht-system         x86_64         1.0.0-2.el7            rht-updates      3.9 k
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

5.3. Verify that the rht-system package is upgraded, and note the version number of the package.

```
[root@servera ~]# yum list rht-system
Installed Packages
rht-system.noarch      1.0.0-2.el7         @rht-updates
```

6. Exit from servera.

```
[root@servera ~]# exit  
logout
[student@servera ~]$ exit 
logout
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab software-repo finish script to finish this exercise. This script removes all the software repositories and packages installed on servera during the exercise.

```
[student@workstation ~]$ lab software-repo finish
```

This concludes the guided exercise.
