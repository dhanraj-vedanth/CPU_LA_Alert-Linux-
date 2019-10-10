# Authors: Dhanraj Vedanth Raghunathan, Ananya Nunna
#!/bin/bash

#Function: Returns #1 if the file exists and returns #2 if the file does not exist
check_csv(){
	load_avg_file="$PWD/load_avg.csv"
	if [ -f "$load_avg_file" ]; then
		return 1 
	else
		return 2 
	fi
	}
#Function: Returns #1 if the file exists and returns #2 if the file does not exist
check_alert(){
        alert_file="$PWD/alerts.csv"
        if [ -f "$alert_file" ]; then
                return 1
        else
                return 2
        fi
        }

collect_metrics(){	
	echo "Scripts takes arguments from the cmd line - {Duration} {Interval} {X} {Y} (Default Values: 10, 5, 1, 1)"
	echo "You entered: Duration(Tp):${temp1}, Interval(T):${temp2}, Threshold X: ${temp3}, Threshold Y: ${temp4}"
	duration=${temp1:-10}

	interval=${temp2:-5}
	
	echo -e "Entered Duration(Tp):${duration} and Entered interval(T): ${interval}\n" 
	
#Basic test to see make sure that the duration is not lesser than the interval asked for
	if [ "$duration" -ge "$interval" ]
	then
	echo "***************"
	echo "Accepted"
	iterator_calc=$((${duration}/${interval}))
	echo -e "You will receive:"${iterator_calc}" entries on the csv\n\n"
	echo "***************"
	else
	echo -e "Duration needs to be greater that the time interval \n"
	collect_metrics
	fi
 	
#Command to extract the required load averages
	raw_output="$(top -b -n${iterator_calc} -d${interval} | grep 'average')"
	
#Regex to match the 'timestamp' from the output we get from the above command - timestamp_re
#Regex to match the 'load averages' from the output we get from the above command - needed
#The 'line' variable on the while loop below consists of lines of data
	while read -r line; do
    	re="(average:\ ([0-9]+\.[0-9]+\,\ [0-9]+\.[0-9]+\,\ [0-9]+\.[0-9]+))"
	timestamp_re="(([0-9]+\:[0-9]+\:[0-9]+))"

#The variable "needed" is an array, contains the matched load averages
    	if [[ $line =~ $re ]]; then
    	needed=${BASH_REMATCH[2]};
    	fi
    	echo "${line}"

#The variable  'var' contains the matched date from the top command
	if [[ $line =~ $timestamp_re ]];then
	var=${BASH_REMATCH[2]};
	fi

#The Regex 're_last' matches the load averages from the last entry of the load_avg.csv file
	IFS=','
	last_line="$(tail -n1 $PWD/load_avg.csv)"
        re_last="((([0-9]+\.[0-9]+\,\ [0-9]+\.[0-9]+\,\ [0-9]+\.[0-9]+)))"
        if [[ $last_line =~ $re_last ]]; then
        last_match=${BASH_REMATCH[2]};
        fi
        read -a new <<< "$last_match"
	
#	echo "${date}"
    	echo "${date_match} ${var},${needed}" >> "$PWD/load_avg.csv"

        read -a strarr <<< "$needed"

	echo "1 min value : ${strarr[0]}"
        echo "5 min value : ${strarr[1]}"
        echo "15 min value : ${strarr[2]}"

	if (( $(echo "${strarr[0]} > ${X}" |bc -l) )); then
	echo -e "High CPU Usage!!\nValue of X (Threshold):${X}\nValue of the 1 min CPU usage:${strarr[0]}\n"
	echo "${date_match},'High CPU Usage',${needed}" >> "$PWD/alerts.csv"
	fi

	echo "Last entry split: ${new[0]}, ${new[1]}, ${new[2]}"

	if (( $(echo "${strarr[1]} > ${Y}" |bc -l) )); then
		if (( $(echo "${strarr[0]} >= ${new[0]}" |bc -l) )); then
        echo -e "VERY High CPU Usage!!\nValue of Y (Threshold):${Y}\nValue of the 5 min CPU usage:${strarr[1]}\n"
	echo "${date_match} ${var},'Very High CPU Usage',${needed}" >>"$PWD/alerts.csv"
	fi
	fi
	echo -e "Value of the current 1 min CPU Usage: ${strarr[0]}"
	echo -e "Value of the previous 1 min CPU Usage: ${new[0]}\n\n"
	echo -e "**************************************************************\n\n"
	done <<< "$raw_output"
}

#MAIN:
temp1=${1}
temp2=${2}
temp3=${3}
temp4=${4}

check_csv
ret_val=$?
check_alert
ret_alert=$?

if [ "${ret_alert}" -eq 1 ];then
echo -e "./alerts.csv already exists \n"
echo -e "Will check if ./load_avg.csv is present now \n"
else
echo -e "Creating ./alerts.csv"
touch alerts.csv
echo "TimeStamp, Alert Message, 1 min, 5 mins, 15 mins" >> alerts.csv
fi

#The variable 'date_match' matches the current date from the date command
#IFS = ' '
timestamp="$(date)"
echo "$timestamp"
re_get_date="((^[a-zA-Z]+\ [a-zA-Z]+\ [0-9]+))"
if [[ $timestamp =~ $re_get_date ]]; then
date_match=${BASH_REMATCH[1]};
echo "${date_match}"
fi
#read -a date <<< "$date_match"

if [ "$ret_val" -eq 1 ]; then
    echo "./load_avg.csv already exists"
    X=${temp3:-0.7}
    Y=${temp4:-0.9}
    echo "Running the load & alert function"
    collect_metrics
else
    echo "Creating ./load_avg.csv"
    touch load_avg.csv
    echo  "TimeStamp,1 min, 5 mins, 15 mins" >>load_avg.csv
    echo "Set thresholds X and Y for 'High' and 'Very High' CPU usage"
    X=${3:-0.7}
    Y=${4:-0.9}
    echo "Running the load & alert function"
    collect_metrics
fi

