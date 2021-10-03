# Guided Exercise 7.3: Managing Package Module Streams

In this exercise, you will list the available modules, enable a specific module stream, and install packages from that stream.

## Outcomes

You should be able to:

- List installed modules and examine information of a module.

- Enable and install a module from a stream.

- Switch to a specific module stream.

- Remove and disable a module.

Log in as the student user on workstation using student as the password.

From workstation run the lab software-module start command. The command runs a start script that determines whether the host, servera, is reachable on the network. The script also ensures that the required software repositories are available and installs the postgresql:9.6 module.

```
[student@workstation ~]$ lab software-module start
```

1. Use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Switch to root at the shell prompt.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. List available modules, streams, and installed modules. Examine the information for the python36 module.

3.1. Use the yum module list command to list available modules and streams.

```
[root@servera ~]# yum module list
Red Hat Enterprise Linux 8.2 AppStream (dvd)
Name          Stream         Profiles             Summary
...output omitted...
python27      2.7 [d]        common [d]           Python ... version 2.7
python36      3.6 [d][e]     build, common [d]    Python ... version 3.6
python38      3.8 [d]        build, common [d]    Python ... version 3.8
...output omitted...
Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

3.2. Use the yum module list --installed command to list installed modules and streams.

```
[root@servera ~]# yum module list --installed
Red Hat Enterprise Linux 8.2 AppStream (dvd)
Name         Stream    Profiles                 Summary
postgresql   9.6 [e]   client, server [d] [i]   PostgreSQL server and client ...

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

3.3. Use the yum module info command to examine details of the python36 module.

```
[root@servera ~]# yum module info python36
Name             : python36
Stream           : 3.6 [d][e][a]
Version          : 8010020190724083915
Context          : a920e634
Architecture     : x86_64
Profiles         : build, common [d]
Default profiles : common
Repo             : rhel-8.2-for-x86_64-appstream-rpms
Summary          : Python programming language, version 3.6
...output omitted...
Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled, [a]ctive]
```

4. Install the python36 module from the 3.6 stream and the common profile. Verify the current status of the module.

4.1. Use the yum module install command to install the python36 module. Use the name:stream/profile syntax to install the python36 module from the 3.6 stream and the common profile.

NOTE
You can omit /profile to use the default profile and :stream to use the default stream.

```
[root@servera ~]# yum module install python36:3.6/common
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

4.2. Examine the current status of the python36 module.

```
[root@servera ~]# yum module list python36
Red Hat Enterprise Linux 8.2 AppStream (dvd)
Name         Stream         Profiles                   Summary
python36     3.6 [d][e]     build, common [d] [i]      Python ... version 3.6

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

5. Switch the postgresql module of the server profile to use the 10 stream.

5.1. Use the yum module list command to list the postgresql module and the stream. Notice that the postgresql:9.6 module stream is currently installed.

```
[root@servera ~]# yum module list postgresql
Red Hat Enterprise Linux 8.2 AppStream (dvd)
Name         Stream    Profiles                Summary
postgresql   9.6 [e]   client, server [d] [i]  PostgreSQL server and client ...
postgresql   10 [d]    client, server [d]      PostgreSQL server and client ...
postgresql   12        client, server [d]      PostgreSQL server and client ...

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

5.2. Remove and disable the postgresql module stream along with all the packages installed by the profile.

```
[root@servera ~]# yum module remove postgresql
...output omitted...
Is this ok [y/N]: y
...output omitted...
Removed:
  postgresql-server-9.6.10-1.module+el8+2470+d1bafa0e.x86_64   libpq-10.5-1.el8.x86_64  postgresql-9.6.10-1.module+el8+2470+d1bafa0e.x86_64
Complete
```

5.3. Reset the postgresql module and its streams.

```
[root@servera ~]# yum module reset postgresql
=================================================================
 Package       Arch             Version     Repository      Size
=================================================================
Resetting modules:
postgresql

Transaction Summary
=================================================================

Is this ok [y/N]: y
Complete!
```

5.4. Use the yum module install command to switch to the postgresql:10 module stream.

```
[root@servera ~]# yum module install postgresql:10
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

5.5. Verify that the postgresql module is switched to the 10 stream.

```
[root@servera ~]# yum module list postgresql
Red Hat Enterprise Linux 8.2 AppStream (dvd)
Name         Stream    Profiles                Summary
postgresql   9.6       client, server [d]      PostgreSQL server and client ...
postgresql   10 [d][e] client, server [d] [i]  PostgreSQL server and client ...
postgresql   12        client, server [d]      PostgreSQL server and client ...

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

6. Remove and disable the postgresql module stream along with all the packages installed by the profile.

6.1. Use the yum module remove command to remove the postgresql module. The command also removes all packages installed from this module.

```
[root@servera ~]# yum module remove postgresql
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

6.2. Disable the postgresql module stream.

```
[root@servera ~]# yum module disable postgresql
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

6.3. Verify that the postgresql module stream is removed and disabled.

```
[root@servera ~]# yum module list postgresql
Red Hat Enterprise Linux 8.2 AppStream (dvd)
Name          Stream     Profiles               Summary
postgresql    9.6 [x]    client, server [d]     PostgreSQL server and client ...
postgresql    10 [d][x]  client, server [d]     PostgreSQL server and client ...
postgresql    12 [x]     client, server [d]     PostgreSQL server and client ...

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

7. Exit from servera.

```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab software-module finish script to finish this exercise. This script removes all the modules installed on servera during the exercise.

```
[student@workstation ~]$ lab software-module finish
```

This concludes the guided exercise.
