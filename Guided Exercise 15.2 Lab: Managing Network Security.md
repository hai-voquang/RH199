# Guided Exercise 15.2 Lab: Managing Network Security

## Performance Checklist

In this lab, you will configure firewall and SELinux settings to allow access to multiple web servers running on serverb.

## Outcomes

You should be able to configure firewall and SELinux settings on a web server host.

Log in as the student user on workstation using student as the password.

From workstation, run the lab netsecurity-review start command. The command runs a start script to determine whether the serverb host is reachable on the network.
```
[student@workstation ~]$ lab netsecurity-review start
```
Your company has decided to run a new web app. This application listens on ports 80/TCP and 1001/TCP. Port 22/TCP for ssh access must also be available. All changes you make should persist across a reboot.

If prompted by sudo, use student as the password.

Important: The graphical interface used in the Red Hat Online Learning environment needs port 5900/TCP to remain available as well. This port is also known under the service name vnc-server. If you accidentally lock yourself out from your serverb, you can either attempt to recover by using ssh to your serverb machine from your workstation machine, or reset your serverb machine. If you elect to reset your serverb machine, you must run the setup scripts for this lab again. The configuration on your machines already includes a custom zone called ROL that opens these ports.

1. From workstation, test access to the default web server at http://serverb.lab.example.com and to the virtual host at http://serverb.lab.example.com:1001.

1.1. Test access to the http://serverb.lab.example.com web server. The test currently fails. Ultimately, the web server should return SERVER B.
```
[student@workstation ~]$ curl http://serverb.lab.example.com
curl: (7) Failed to connect to serverb.lab.example.com port 80: Connection refused
```
1.2. Test access to the http://serverb.lab.example.com:1001 virtual host. The test currently fails. Ultimately, the virtual host should return VHOST 1.
```
[student@workstation ~]$ curl http://serverb.lab.example.com:1001
curl: (7) Failed to connect to serverb.lab.example.com port 1001: No route to host
```

2. Log in to serverb to determine what is preventing access to the web servers.

2.1. From workstation, open an SSH session to serverb as student user. The systems are configured to use SSH keys for authentication, so a password is not required.
```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

2.2. Determine whether the httpd service is active.
```
[student@serverb ~]$ systemctl is-active httpd
inactive
```

2.3. Enable and start the httpd service. The httpd service fails to start.
```
[student@serverb ~]$ sudo systemctl enable --now httpd
[sudo] password for student: student
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
Job for httpd.service failed because the control process exited with error code.
See "systemctl status httpd.service" and "journalctl -xe" for details.
```

2.4. Investigate the reasons why the httpd.service service failed to start.
```
[student@serverb ~]$ systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Thu 2019-04-11 19:25:36 CDT; 19s ago
     Docs: man:httpd.service(8)
  Process: 9615 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
 Main PID: 9615 (code=exited, status=1/FAILURE)
   Status: "Reading configuration..."

Apr 11 19:25:36 serverb.lab.example.com systemd[1]: Starting The Apache HTTP Server...
Apr 11 19:25:36 serverb.lab.example.com httpd[9615]: (13)Permission denied: AH00072: make_sock: could not bind to address [::]:1001
Apr 11 19:25:36 serverb.lab.example.com httpd[9615]: (13)Permission denied: AH00072: make_sock: could not bind to address 0.0.0.0:1001
Apr 11 19:25:36 serverb.lab.example.com httpd[9615]: no listening sockets available, shutting down
Apr 11 19:25:36 serverb.lab.example.com httpd[9615]: AH00015: Unable to open logs
Apr 11 19:25:36 serverb.lab.example.com systemd[1]: httpd.service: Main process exited, code=exited, status=1/FAILURE
Apr 11 19:25:36 serverb.lab.example.com systemd[1]: httpd.service: Failed with result 'exit-code'.
Apr 11 19:25:36 serverb.lab.example.com systemd[1]: Failed to start The Apache HTTP Server.
```

2.5. Use the sealert command to check whether SELinux is blocking the httpd service from binding to port 1001/TCP.
```
[student@serverb ~]$ sudo sealert -a /var/log/audit/audit.log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/httpd from name_bind access on the tcp_socket port 1001.

*****  Plugin bind_ports (99.5 confidence) suggests   ************************

If you want to allow /usr/sbin/httpd to bind to network port 1001
Then you need to modify the port type.
Do
# semanage port -a -t PORT_TYPE -p tcp 1001
    where PORT_TYPE is one of the following: http_cache_port_t, http_port_t, jboss_management_port_t, jboss_messaging_port_t, ntop_port_t, puppet_port_t.

*****  Plugin catchall (1.49 confidence) suggests   **************************

...output omitted...
```

3. Configure SELinux to allow the httpd service to listen on port 1001/TCP.

3.1. Use the semanage command to find the correct port type.
```
[student@serverb ~]$ sudo semanage port -l | grep 'http'
http_cache_port_t      tcp  8080, 8118, 8123, 10001-10010
http_cache_port_t      udp  3130
http_port_t            tcp  80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t    tcp  5988
pegasus_https_port_t   tcp  5989
```

3.2. Use the semanage command to bind port 1001/TCP to the http_port_t type.
```
[student@serverb ~]$ sudo semanage port -a -t http_port_t -p tcp 1001
[student@serverb ~]$ 
```

3.3. Confirm that port 1001/TCP is bound to the http_port_t port type.
```
[student@serverb ~]$ sudo semanage port -l | grep '^http_port_t'
http_port_t            tcp  1001, 80, 81, 443, 488, 8008, 8009, 8443, 9000
```

3.4. Enable and start the httpd service.
```
[student@serverb ~]$ sudo systemctl enable --now httpd
```

3.5. Verify the running state of the httpd service.
```
[student@serverb ~]$ systemctl is-active httpd; systemctl is-enabled httpd
active
enabled
```

3.6. Exit from serverb.
```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$
```

4. From workstation, test access to the default web server at http://serverb.lab.example.com and to the virtual host at http://serverb.lab.example.com:1001.

4.1. Test access to the http://serverb.lab.example.com web server. The web server should return SERVER B.
```
[student@workstation ~]$ curl http://serverb.lab.example.com
SERVER B
```

4.2. Test access to the http://serverb.lab.example.com:1001 virtual host. The test continues to fail.
```
[student@workstation ~]$ curl http://serverb.lab.example.com:1001
curl: (7) Failed to connect to serverb.lab.example.com port 1001: No route to host
```

5. Log in to serverb to determine whether the correct ports are assigned to the firewall.

5.1. From workstation, log in to serverb as the student user.
```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

5.2. Verify that the default firewall zone is set to public.
```
[student@serverb ~]$ firewall-cmd --get-default-zone
public
```

5.3. If the previous step did not return public as the default zone, correct it with the following command:
```
[student@serverb ~]$ sudo firewall-cmd --set-default-zone public
```

5.4. Determine the open ports listed in the public network zone.
```
[student@serverb ~]$ sudo firewall-cmd --permanent --zone=public --list-all
[sudo] password for student: student
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: cockpit dhcpv6-client http ssh
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

6. Add port 1001/TCP to the permanent configuration for the public network zone. Confirm your configuration.

6.1. Add port 1001/TCP to the public network zone.
```
[student@serverb ~]$ sudo firewall-cmd --permanent --zone=public \
--add-port=1001/tcp
success
```

6.2. Reload the firewall configuration.
```
[student@serverb ~]$ sudo firewall-cmd --reload
success
```

6.3. Confirm your configuration.
```
[student@serverb ~]$ sudo firewall-cmd --permanent --zone=public --list-all
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: cockpit dhcpv6-client http ssh
  ports: 1001/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

6.4. Exit from serverb.
```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$
```

7. From workstation, confirm that the default web server at serverb.lab.example.com returns SERVER B and the virtual host at serverb.lab.example.com:1001 returns VHOST 1.

7.1. Test access to the http://serverb.lab.example.com web server.
```
[student@workstation ~]$ curl http://serverb.lab.example.com
SERVER B
```

7.2. Test access to the http://serverb.lab.example.com:1001 virtual host.
```
[student@workstation ~]$ curl http://serverb.lab.example.com:1001
VHOST 1
```

## Evaluation

On workstation, run the lab netsecurity-review grade command to confirm success of this lab exercise.
```
[student@workstation ~]$ lab netsecurity-review grade
```

## Finish

On workstation, run the lab netsecurity-review finish script to complete this exercise.
```
[student@workstation ~]$ lab netsecurity-review finish
```
This concludes the lab.

