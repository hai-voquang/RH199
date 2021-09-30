1. From workstation use the ssh command to log into servera as the student user.

```
[student@workstation ~]$ ssh student@servera
Web console: https://servera.lab.example.com:9090/ or https://172.25.250.10:9090/
[student@servera ~]$ 
```

2. Use the systemctl command to confirm that the cockpit service is running. Enter student as the password when prompted.

```
[student@servera ~]$ systemctl status cockpit.socket
● cockpit.socket - Cockpit Web Service Socket
   Loaded: loaded (/usr/lib/systemd/system/cockpit.socket; enabled; vendor preset: disabled)
   Active: active (listening) since Thu 2019-05-16 10:32:33 IST; 4min 37s ago
     Docs: man:cockpit-ws(8)
   Listen: [::]:9090 (Stream)
  Process: 676 ExecStartPost=/bin/ln -snf active.motd /run/cockpit/motd (code=exited, status=0/SUCCESS)
  Process: 668 ExecStartPost=/usr/share/cockpit/motd/update-motd  localhost (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 11405)
   Memory: 1.5M
   CGroup: /system.slice/cockpit.socket
...output omitted...
```

3. Log out from servera.

[student@servera ~]$ exit
[student@workstation ~]$ 

4. On workstation, open Firefox and log in to the Web Console interface running on servera.lab.example.com as the root user with redhat as the password.

4.1. Open Firefox and go to the https://servera.lab.example.com:9090 address.

4.2. If prompted, accept the self-signed certificate by adding it as an exception.

4.3. Log in as the root user with redhat as the password. You are now logged in as a privileged user, which is necessary to create a diagnostic report.

4.4. Click Diagnostic Reports in the left navigation bar. Click on Create Report. The report takes a few minutes to create.

5. When the report is ready, click on Download report. Save the file.

5.1. Click the Download report button, followed by the Save File button.

5.2. Click the Close button.

5.3. Log out from the Web Console interface.
