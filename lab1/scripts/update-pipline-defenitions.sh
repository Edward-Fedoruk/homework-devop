#!/usr/bin/env bash

jsonFilePath=../data/pipline.json

jq "del(.metadata)" $jsonFilePath 
jq ".version + 1" $jsonFilePath 
cat $jsonFilePath

branchName=main
read -p "enter branch name: [main] " branchName

jq --arg branchName "$branchName" '.pipeline.stages[0].actions[0].configuration.BranchName = $branchName' "$jsonFilePath" >tmp.$$.json && mv tmp.$$.json "$jsonFilePath"
