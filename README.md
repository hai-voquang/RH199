# RH199

1. From workstation, open an SSH session to serverb as student.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

2. Use the su command to switch to the operator1 user on serverb. Use redhat as the password of operator1.

```
[student@serverb ~]$ su - operator1
Password: redhat
[operator1@serverb ~]$ 
```

3. Use the ssh-keygen command to generate SSH keys. Do not enter a passphrase.

```
[operator1@serverb ~]$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/operator1/.ssh/id_rsa): Enter
Created directory '/home/operator1/.ssh'.
Enter passphrase (empty for no passphrase): Enter
Enter same passphrase again: Enter
Your identification has been saved in /home/operator1/.ssh/id_rsa.
Your public key has been saved in /home/operator1/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:JainiQdnRosC+xXhOqsJQQLzBNUldb+jJbyrCZQBERI operator1@serverb.lab.example.com
The key's randomart image is:
+---[RSA 2048]----+
|E+*+ooo .        |
|.= o.o o .       |
|o.. = . . o      |
|+. + * . o .     |
|+ = X . S +      |
| + @ +   = .     |
|. + =   o        |
|.o . . . .       |
|o     o..        |
+----[SHA256]-----+
```

4. Use the ssh-copy-id command to send the public key of the SSH key pair to operator1 on servera. Use redhat as the password of operator1 on servera.

```
[operator1@serverb ~]$ ssh-copy-id operator1@servera
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/operator1/.ssh/id_rsa.pub"
The authenticity of host 'servera (172.25.250.10)' can't be established.
ECDSA key fingerprint is SHA256:ERTdjooOIrIwVSZQnqD5or+JbXfidg0udb3DXBuHWzA.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
operator1@servera's password: redhat
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'operator1@servera'"
and check to make sure that only the key(s) you wanted were added.
```

5. Execute the hostname command on servera remotely using SSH without accessing the remote interactive shell.

```
[operator1@serverb ~]$ ssh operator1@servera hostname
servera.lab.example.com
```

Notice that the preceding ssh command did not prompt you for a password because it used the passphrase-less private key against the exported public key to authenticate as operator1 on servera. This approach is not secure, because anyone who has access to the private key file can log in to servera as operator1. The secure alternative is to protect the private key with a passphrase, which is the next step.

6. Use the ssh-keygen command to generate another set of SSH keys with passphrase-protection. Save the key as /home/operator1/.ssh/key2. Use redhatpass as the passphrase of the private key.

```
[operator1@serverb ~]$ ssh-keygen -f .ssh/key2
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): redhatpass
Enter same passphrase again: redhatpass
Your identification has been saved in .ssh/key2.
Your public key has been saved in .ssh/key2.pub.
The key fingerprint is:
SHA256:OCtCjfPm5QrbPBgqbEIWCcw5AI4oSlMEbgLrBQ1HWKI operator1@serverb.lab.example.com
The key's randomart image is:
+---[RSA 2048]----+
|O=X*             |
|OB=.             |
|E*o.             |
|Booo   .         |
|..= . o S        |
| +.o   o         |
|+.oo+ o          |
|+o.O.+           |
|+ . =o.          |
+----[SHA256]-----+
```

7. Use the ssh-copy-id command to send the public key of the passphrase-protected key pair to operator1 on servera.

```
[operator1@serverb ~]$ ssh-copy-id -i .ssh/key2.pub operator1@servera
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/key2.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'operator1@servera'"
and check to make sure that only the key(s) you wanted were added.
```

Notice that the preceding ssh-copy-id command did not prompt you for a password because it used the public key of the passphrase-less private key that you exported to servera in the preceding step.


8. Execute the hostname command on servera remotely with SSH without accessing the remote interactive shell. Use /home/operator1/.ssh/key2 as the identity file. Specify redhatpass as the passphrase, which you set for the private key in the preceding step.

```
[operator1@serverb ~]$ ssh -i .ssh/key2 operator1@servera hostname
Enter passphrase for key '.ssh/key2': redhatpass
servera.lab.example.com
```

9. Run ssh-agent in your Bash shell and add the passphrase-protected private key (/home/operator1/.ssh/key2) of the SSH key pair to the shell session.

```
[operator1@serverb ~]$ eval $(ssh-agent)
Agent pid 21032
[operator1@serverb ~]$ ssh-add .ssh/key2
Enter passphrase for .ssh/key2: redhatpass
Identity added: .ssh/key2 (operator1@serverb.lab.example.com)
The preceding eval command started ssh-agent and configured this shell session to use it. You then used ssh-add to provide the unlocked private key to ssh-agent.
```

10. Execute the hostname command on servera remotely without accessing a remote interactive shell. Use /home/operator1/.ssh/key2 as the identity file.

```
[operator1@serverb ~]$ ssh -i .ssh/key2 operator1@servera hostname
servera.lab.example.com
```

Notice that the preceding ssh command did not prompt you to enter the passphrase interactively.

11. Open another terminal on workstation and open an SSH session to serverb as student.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

12. On serverb, use the su command to switch to operator1 and invoke an SSH connection to servera. Use /home/operator1/.ssh/key2 as the identity file to authenticate using the SSH keys.

12.1. Use the su command to switch to operator1. Use redhat as the password of operator1.

```
[student@serverb ~]$ su - operator1
Password: redhat
[operator1@serverb ~]$ 
```

12.2. Open an SSH session to servera as operator1.

```
[operator1@serverb ~]$ ssh -i .ssh/key2 operator1@servera
Enter passphrase for key '.ssh/key2': redhatpass
...output omitted...
[operator1@servera ~]$ 
```

Notice that the preceding ssh command prompted you to enter the passphrase interactively because you did not invoke the SSH connection from the shell that you used to start ssh-agent.

13. Exit all the shells you are using in the second terminal.

13.1. Log out of servera.

```
[operator1@servera ~]$ exit
logout
Connection to servera closed.
[operator1@serverb ~]$ 
```

13.2. Exit the operator1 and student shells on serverb to return to the student user's shell on workstation.

```
[operator1@serverb ~]$ exit
logout
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
```

13.3. Close the second terminal on workstation.

```
[student@workstation ~]$ exit
```

14. Log out of serverb on the first terminal and conclude this exercise.

14.1 From the first terminal, exit the operator1 user's shell on serverb.

```
[operator1@serverb ~]$ exit
logout
[student@serverb ~]$ 
```

14.2. The exit command caused you to exit the operator1 user's shell, terminating the shell session where ssh-agent was active, and return to the student user's shell on serverb.

Exit the student user's shell on serverb to return to the student user's shell on workstation.

```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
```



