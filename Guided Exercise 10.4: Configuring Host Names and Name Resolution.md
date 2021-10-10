# Guided Exercise 10.4: Configuring Host Names and Name Resolution

In this exercise, you will manually configure the system’s static host name, /etc/hosts file, and DNS name resolver.

## Outcomes

You should be able to set a customized host name and configure name resolution settings.

Log in as the student user on workstation using student as the password.

From workstation, run the lab net-hostnames start command. The command runs a start script that determine if the host, servera, is reachable on the network.
```
[student@workstation ~]$ lab net-hostnames start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, so a password is not required to log in to servera.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. View the current host name settings.

2.1. Display the current host name.
```
[student@servera ~]$ hostname
servera.lab.example.com
```

2.2. Display the host name status.
```
[student@servera ~]$ hostnamectl status
   Static hostname: n/a
Transient hostname: servera.lab.example.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: f874df04639f474cb0a9881041f4f7d4
           Boot ID: 22ae5279f57049678eda547bdb39a19d
    Virtualization: kvm
  Operating System: Red Hat Enterprise Linux 8.2 (Ootpa)
       CPE OS Name: cpe:/o:redhat:enterprise_linux:8.2:GA
            Kernel: Linux 4.18.0-193.el8.x86_64
      Architecture: x86-64
```
Note the transient hostname obtained from DHCP or mDNS.

3. Set a static host name to match the current transient host name.

3.1. Change the host name and host name configuration file.
```
[student@servera ~]$ sudo hostnamectl set-hostname \
servera.lab.example.com
[sudo] password for student: student
[student@servera ~]$ 
```

3.2. View the content of the /etc/hostname file which provides the host name at network start.
```
servera.lab.example.com
```

3.3. Display the host name status.
```
[student@servera ~]$ hostnamectl status
   Static hostname: servera.lab.example.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: f874df04639f474cb0a9881041f4f7d4
           Boot ID: 22ae5279f57049678eda547bdb39a19d
    Virtualization: kvm
  Operating System: Red Hat Enterprise Linux 8.2 (Ootpa)
       CPE OS Name: cpe:/o:redhat:enterprise_linux:8.2:GA
            Kernel: Linux 4.18.0-193.el8.x86_64
      Architecture: x86-64
```

Note that the transient hostname is not shown now that a static hostname has been configured.

4. Temporarily change the host name.

4.1. Change the host name.
```
[student@servera ~]$ sudo hostname testname
```

4.2. Display the current host name.
```
[student@servera ~]$ hostname
testname
```

4.3. View the content of the /etc/hostname file which provides the host name at network start.
```
servera.lab.example.com
```

4.4. Reboot the system.
```
[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
```

4.5. From workstation log in to servera as student user.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

4.6. Display the current host name.
```
[student@servera ~]$ hostname
servera.lab.example.com
```

5. Add a local nickname for the classroom server.

5.1. Look up the IP address of the classroom.example.com.
```
[student@servera ~]$ host classroom.example.com
classroom.example.com has address 172.25.254.254
```

5.2. Modify /etc/hosts so that the additional name of class can be used to access the IP address 172.25.254.254.
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.25.254.254 classroom.example.com classroom class
172.25.254.254 content.example.com content
...content omitted...
```

5.3. Look up the IP address of class.
```
[student@servera ~]$ host class
Host class not found: 2(SERVFAIL)
[student@servera ~]$ getent hosts class
172.25.254.254    classroom.example.com class
```

5.4. Ping class.
```
[student@servera ~]$ ping -c3 class
PING classroom.example.com (172.25.254.254) 56(84) bytes of data.
64 bytes from classroom.example.com (172.25.254.254): icmp_seq=1 ttl=64 time=0.397 ms
64 bytes from classroom.example.com (172.25.254.254): icmp_seq=2 ttl=64 time=0.447 ms
64 bytes from classroom.example.com (172.25.254.254): icmp_seq=3 ttl=64 time=0.470 ms

--- classroom.example.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.397/0.438/0.470/0.030 ms
```

5.5. Exit from servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab net-hostnames finish script to finish this exercise.
```
[student@workstation ~]$ lab net-hostnames finish
```

This concludes the guided exercise.