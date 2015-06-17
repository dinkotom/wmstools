#!/usr/bin/env bash

while read line
do
    echo $line
    sleep 0.2
done <$1
