# CPU Load Analyzer and Alert Generator:
10th October, 2019

# Language used and environment used:
- Bash scripting
- Linux VM


# This shell script performs two functionalities:

  - Log the CPU load averages (1 min, 5 mins and 15 mins) for the given time interval and frequency
  - Log Alerts of the CPU load averages with respect to a threshold value.
  - Generates two csv files: load_avg.csv and alerts.csv
  - The script has two flavours - 1. q5.sh takes the user input in an interactive way 2. q5_backup.sh takes the user input as arguments (q5_backup.sh 10 5 0.7 0.9)

# Usage:
  - This shell script uses the top and uptime command as needed to generate load average values for any given Linux machine.
  - User gets to decice the time interval and frequency. For example, if the time interval is 10s and the frequency is 5s, the script will generate "2" load average values at an interval of 5 seconds each.
  - The user also gets to give two threshold values "X" and "Y". If the 1 min load average exceeds the user given value X, a "High CPU Usage" alert is logged in alerts.csv, and if the 5 mins load average exceeds the user given value and if the previous 1 min value is increasing, a "Very High CPU usage" alert is logged in.
  - The generated logs are cleared every 1 hour.

# How to run the script:

- Copy the script to any desirable directory on your machine
- Use the command "bash q5_backup.sh" to run the bash script.
- The above command has the argument syntax as follows : bash q5_backup.sh <Tp> <T> <X> <Y>
- If the user does not enter anything, the default values of 10,5,0,0 are selected.
- To erase the generated log files use the command "bash erase.sh"
- This erase file has two lines, one which is a command to just remove all .csv files when it is run (The commented line), the other is
  a command to remove all the csv files in the current working directory if the file's mtime exceeds 1 hour. 
- Cronjob #1: Runs the bash script every two minutes. */2 * * * * cd /home/ece792/cpu_load; bash q5_backup.sh 20 10 -0.0 -0.1
- Cronjob #2: Runs the cleaning script every hour. 0 * * * * cd /home/ece792/cpu_load; bash erase.sh (for the commented line)

# Sample Runs:

- Flavour 1: No Arguments entered along with the script.

        ece792@t12_vm7:~$ bash load_test.sh
        Creating ./alerts.csv
        Wed Sep 18 02:12:45 UTC 2019
        Wed Sep 18
        Creating ./load_avg.csv
        Set thresholds X and Y for 'High' and 'Very High' CPU usage
        Running the load & alert function
        Scripts takes arguments from the cmd line - {Duration} {Interval} {X} {Y} (Default Values: 10, 5, 1, 1)
        You entered: Duration(Tp):, Interval(T):, Threshold X: , Threshold Y:
        Entered Duration(Tp):10 and Entered interval(T): 5
        
        ***************
        Accepted
        You will receive:2 entries on the csv
        
        
        ***************
        top - 02:12:46 up 27 days, 19:31,  2 users,  load average: 0.00, 0.00, 0.00
        1 min value : 0.00
        5 min value :  0.00
        15 min value :  0.00
        Last entry split: , ,
        Value of the current 1 min CPU Usage: 0.00
        Value of the previous 1 min CPU Usage:
        
        
        **************************************************************

- Flavour 2: User enters the arguments while executing the script

        ece792@t12_vm7:~$ bash load_test.sh 20 5 -1 -1
        ./alerts.csv already exists
        
        Will check if ./load_avg.csv is present now
        
        Wed Sep 18 02:14:02 UTC 2019
        Wed Sep 18
        ./load_avg.csv already exists
        Running the load & alert function
        Scripts takes arguments from the cmd line - {Duration} {Interval} {X} {Y} (Default Values: 10, 5, 1, 1)
        You entered: Duration(Tp):20, Interval(T):5, Threshold X: -1, Threshold Y: -1
        Entered Duration(Tp):20 and Entered interval(T): 5
        
        ***************
        Accepted
        You will receive:4 entries on the csv
        
        
        ***************
        top - 02:14:02 up 27 days, 19:33,  2 users,  load average: 0.00, 0.00, 0.00
        1 min value : 0.00
        5 min value :  0.00
        15 min value :  0.00
        High CPU Usage!!
        Value of X (Threshold):-1
        Value of the 1 min CPU usage:0.00
        
        Last entry split: 0.00,  0.00,  0.00
        VERY High CPU Usage!!
        Value of Y (Threshold):-1
        Value of the 5 min CPU usage: 0.00
        
        Value of the current 1 min CPU Usage: 0.00
        Value of the previous 1 min CPU Usage: 0.00
        
        
        **************************************************************
        
        
        top - 02:14:07 up 27 days, 19:33,  2 users,  load average: 0.00, 0.00, 0.00
        1 min value : 0.00
        5 min value :  0.00
        15 min value :  0.00
        High CPU Usage!!
        Value of X (Threshold):-1
        Value of the 1 min CPU usage:0.00
        
        Last entry split: 0.00,  0.00,  0.00
        VERY High CPU Usage!!
        Value of Y (Threshold):-1
        Value of the 5 min CPU usage: 0.00
        
        Value of the current 1 min CPU Usage: 0.00
        Value of the previous 1 min CPU Usage: 0.00
        
        
        **************************************************************
        
        
        top - 02:14:12 up 27 days, 19:33,  2 users,  load average: 0.00, 0.00, 0.00
        1 min value : 0.00
        5 min value :  0.00
        15 min value :  0.00
        High CPU Usage!!
        Value of X (Threshold):-1
        Value of the 1 min CPU usage:0.00
        
        Last entry split: 0.00,  0.00,  0.00
        VERY High CPU Usage!!
        Value of Y (Threshold):-1
        Value of the 5 min CPU usage: 0.00
        
        Value of the current 1 min CPU Usage: 0.00
        Value of the previous 1 min CPU Usage: 0.00
        
        
        **************************************************************
        
        
        top - 02:14:17 up 27 days, 19:33,  2 users,  load average: 0.00, 0.00, 0.00
        1 min value : 0.00
        5 min value :  0.00
        15 min value :  0.00
        High CPU Usage!!
        Value of X (Threshold):-1
        Value of the 1 min CPU usage:0.00
        
        Last entry split: 0.00,  0.00,  0.00
        VERY High CPU Usage!!
        Value of Y (Threshold):-1
        Value of the 5 min CPU usage: 0.00
        
        Value of the current 1 min CPU Usage: 0.00
        Value of the previous 1 min CPU Usage: 0.00
        
        
        **************************************************************

# load_avg.csv sample data:
        ece792@t12_vm7:~$ cat load_avg.csv
        TimeStamp,1 min, 5 mins, 15 mins
        Wed Sep 18 02:12:46,0.00, 0.00, 0.00
        Wed Sep 18 02:12:51,0.00, 0.00, 0.00
        Wed Sep 18 02:14:02,0.00, 0.00, 0.00
        Wed Sep 18 02:14:07,0.00, 0.00, 0.00
        Wed Sep 18 02:14:12,0.00, 0.00, 0.00
        Wed Sep 18 02:14:17,0.00, 0.00, 0.00

# alerts.csv sample data:
        ece792@t12_vm7:~/cpu_load$ cat alerts.csv
        TimeStamp, Alert Message, 1 min, 5 mins, 15 mins
        Wed Sep 18,'High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18 02:53:28,'Very High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18,'High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18 02:53:32,'Very High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18,'High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18 02:53:36,'Very High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18,'High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18 02:53:40,'Very High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18,'High CPU Usage',0.00, 0.00, 0.00
        Wed Sep 18 02:53:44,'Very High CPU Usage',0.00, 0.00, 0.00

# Version:
 - stable_1.0

Authors
----
Dhanraj Vedanth Raghunathan, Ananya Nunna

# License

  - All rights reserved by the owner and NC State University.
  - Usage of the script can be done post approval from the above.
