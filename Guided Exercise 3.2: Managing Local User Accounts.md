# Guided Exercise 3.2: Managing Local User Accounts

In this exercise, you will create several users on your system and set passwords for those users.

## Outcomes

You should be able to configure a Linux system with additional user accounts.

Log in to workstation as student using student as the password.

On workstation, run lab users-manage start to start the exercise. This script ensures that the environment is set up correctly.

```
[student@workstation ~]$ lab users-manage start
```

1. From workstation, open an SSH session to servera as student.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. On servera, switch to root using sudo, converting to the root user's shell environment.

```
[student@servera ~]$ sudo su -
[sudo] password for student: student
[root@servera ~]# 
```

3. Create the operator1 user and confirm that it exists in the system.

```
[root@servera ~]# useradd operator1
[root@servera ~]# tail /etc/passwd
...output omitted...
operator1:x:1002:1002::/home/operator1:/bin/bash
```

4. Set the password for operator1 to redhat.

```
[root@servera ~]# passwd operator1
Changing password for user operator1.
New password: redhat
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: redhat
passwd: all authentication tokens updated successfully.
```

5. Create the additional users called operator2 and operator3. Set their passwords to redhat.

5.1. Add the operator2 user. Set the password for operator2 to redhat.

```
[root@servera ~]# useradd operator2
[root@servera ~]# passwd operator2
Changing password for user operator2.
New password: redhat
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: redhat
passwd: all authentication tokens updated successfully.
```

5.2. Add the operator3 user. Set the password for operator3 to redhat.

```
[root@servera ~]# useradd operator3
[root@servera ~]# passwd operator3
Changing password for user operator3.
New password: redhat
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: redhat
passwd: all authentication tokens updated successfully.
```

6. Update the operator1 and operator2 user accounts to include the Operator One and Operator Two comments, respectively. Verify that the comments are successfully added.

6.1 Run usermod -c to update the comments of the operator1 user account.

```
[root@servera ~]# usermod -c "Operator One" operator1
```

6.2. Run usermod -c to update the comments of the operator2 user account.

```
[root@servera ~]# usermod -c "Operator Two" operator2
```

6.3. Confirm that the comments for each of the operator1 and operator2 users are reflected in the user records.

```
[root@servera ~]# tail /etc/passwd
...output omitted...
operator1:x:1002:1002:Operator One:/home/operator1:/bin/bash
operator2:x:1003:1003:Operator Two:/home/operator2:/bin/bash
operator3:x:1004:1004::/home/operator3:/bin/bash
```

7. Delete the operator3 user along with any personal data of the user. Confirm that the user is successfully deleted.

7.1. Remove the operator3 user from the system.

```
[root@servera ~]# userdel -r operator3
```

7.2. Confirm that operator3 is successfully deleted.

```
[root@servera ~]# tail /etc/passwd
...output omitted...
operator1:x:1002:1002:Operator One:/home/operator1:/bin/bash
operator2:x:1003:1003:Operator Two:/home/operator2:/bin/bash
```

Notice that the preceding output does not display the user account information of operator3.

7.3. Exit the root user's shell to return to the student user's shell.

```
[root@servera ~]# exit
logout
[student@servera ~]$ 
```

7.4. Log off from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab users-manage finish to complete this exercise. This script ensures that the environment is clean.

```
[student@workstation ~]$ lab users-manage finish
```

This concludes the guided exercise.
