#!/bin/bash

#rm ./*.csv

find $PWD/*.csv -type f -mmin +60 -exec rm {} \;
