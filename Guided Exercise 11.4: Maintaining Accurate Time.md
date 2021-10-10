# Guided Exercise 11.4: Maintaining Accurate Time

In this exercise, you will adjust the time zone on a server and ensure that its system clock is synchronized with an NTP time source.

## Outcomes

You should be able to:

- Change the time zone on a server.

- Configure the server to synchronize its time with an NTP time source.

Log in to workstation as student using student as the password.

On workstation, run lab log-maintain start to start the exercise. This script ensures that the time synchronization is disabled on the servera system to provide you with the opportunity to manually update the settings on the system and enable the time synchronization.
```
[student@workstation ~]$ lab log-maintain start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. For the sake of the activity, pretend that the servera system is relocated to Haiti and so you need to update the time zone appropriately. Use sudo to elevate the privileges of the student user while running the timedatectl command to update the time zone. Use student as the password if asked.

2.1. Use the tzselect command to determine the appropriate time zone for Haiti.
```
[student@servera ~]$ tzselect
Please identify a location so that time zone rules can be set correctly.
Please select a continent, ocean, "coord", or "TZ".
 1) Africa
 2) Americas
 3) Antarctica
 4) Asia
 5) Atlantic Ocean
 6) Australia
 7) Europe
 8) Indian Ocean
 9) Pacific Ocean
10) coord - I want to use geographical coordinates.
11) TZ - I want to specify the time zone using the Posix TZ format.
#? 2
Please select a country whose clocks agree with yours.
 1) Anguilla              19) Dominican Republic    37) Peru
 2) Antigua & Barbuda     20) Ecuador               38) Puerto Rico
 3) Argentina             21) El Salvador           39) St Barthelemy
 4) Aruba                 22) French Guiana         40) St Kitts & Nevis
 5) Bahamas               23) Greenland             41) St Lucia
 6) Barbados              24) Grenada               42) St Maarten (Dutch)
 7) Belize                25) Guadeloupe            43) St Martin (French)
 8) Bolivia               26) Guatemala             44) St Pierre & Miquelon
 9) Brazil                27) Guyana                45) St Vincent
10) Canada                28) Haiti                 46) Suriname
11) Caribbean NL          29) Honduras              47) Trinidad & Tobago
12) Cayman Islands        30) Jamaica               48) Turks & Caicos Is
13) Chile                 31) Martinique            49) United States
14) Colombia              32) Mexico                50) Uruguay
15) Costa Rica            33) Montserrat            51) Venezuela
16) Cuba                  34) Nicaragua             52) Virgin Islands (UK)
17) Curaçao               35) Panama                53) Virgin Islands (US)
18) Dominica              36) Paraguay
#? 28
The following information has been given:

	Haiti

Therefore TZ='America/Port-au-Prince' will be used.
Selected time is now:	Tue Feb 19 00:51:05 EST 2019.
Universal Time is now:	Tue Feb 19 05:51:05 UTC 2019.
Is the above information OK?
1) Yes
2) No
#? 1

You can make this change permanent for yourself by appending the line
	TZ='America/Port-au-Prince'; export TZ
to the file '.profile' in your home directory; then log out and log in again.

Here is that TZ value again, this time on standard output so that you
can use the /usr/bin/tzselect command in shell scripts:
America/Port-au-Prince
```
Notice that the preceding tzselect command displayed the appropriate time zone for Haiti.

2.2. Use the timedatectl command to update the time zone on servera to America/Port-au-Prince.
```
[student@servera ~]$ sudo timedatectl set-timezone \
America/Port-au-Prince
[sudo] password for student: student
```

2.3. Use the timedatectl command to verify that the time zone has been updated to America/Port-au-Prince.
```
[student@servera ~]$ timedatectl
           Local time: Tue 2019-02-19 01:16:29 EST
           Universal time: Tue 2019-02-19 06:16:29 UTC
                 RTC time: Tue 2019-02-19 06:16:29
                 Time zone: America/Port-au-Prince (EST, -0500)
System clock synchronized: no
              NTP service: inactive
          RTC in local TZ: no
```

3. Configure the chronyd service on servera to synchronize the system time with the NTP time source classroom.example.com.

3.1. Edit the /etc/chrony.conf file to specify the classroom.example.com server as the NTP time source. You may use the sudo vim /etc/chrony.conf command to edit the configuration file. The following output shows the configuration line you must add to the configuration file:
```
...output omitted...
server classroom.example.com iburst
...output omitted...
```

The preceding line in the /etc/chrony.conf configuration file includes the iburst option to speed up initial time synchronization.

3.2. Use the timedatectl command to turn on the time synchronization on servera.
```
[student@servera ~]$ sudo timedatectl set-ntp yes
```

The preceding timedatectl command activates the NTP server with the changed settings in the /etc/chrony.conf configuration file. The preceding timedatectl command may activate either the chronyd or the ntpd service, based on what is currently installed on the system.

4. Verify that the time settings on servera are currently configured to synchronize with the classroom.example.com time source in the classroom environment.

4.1. Use the timedatectl command to verify that the servera currently has the time synchronization enabled.
```
[student@servera ~]$ timedatectl
               Local time: Tue 2019-02-19 01:52:17 EST
           Universal time: Tue 2019-02-19 06:52:17 UTC
                 RTC time: Tue 2019-02-19 06:52:17
                Time zone: America/Port-au-Prince (EST, -0500)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

NOTE
If the preceding output shows that the clock is not synchronized, wait for two seconds and re-run the timedatectl command. It takes a few seconds to successfully synchronize the time settings with the time source.

4.2. Use the chronyc command to verify that the servera system is currently synchronizing its time settings with the classroom.example.com time source.
```
[student@servera ~]$ chronyc sources -v
210 Number of sources = 1

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
^* classroom.example.com         2   6   377    62   +105us[ +143us] +/-   14ms
```

Notice that the preceding output shows an asterisk (*) in the source state (S) field for the classroom.example.com NTP time source. The asterisk indicates that the local system time is currently in successful synchronization with the NTP time source.

4.3. Log out of servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab log-maintain finish to complete this exercise. This script ensures that the original time zone is restored along with all the original time settings on servera.
```
[student@workstation ~]$ lab log-maintain finish
```

This concludes the guided exercise.

