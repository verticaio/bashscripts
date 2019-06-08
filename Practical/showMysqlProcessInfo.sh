#!/bin/bash
while true;
	do
		clear;
		date;
		free -m;
		mysql -uroot -pPass -e "select user,state,trim(both '\r\n' from left(info,90)) query from information_schema.processlist where command<>'sleep'";
		sleep 30;
		done