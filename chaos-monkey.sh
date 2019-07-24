#!/bin/bash

for i in {1..10}; do
	pods(){
	 kubectl get pods --namespace="e-stack" -o 'jsonpath={.items[*].metadata.name}' | tr " " "\n" | shuf
	}

	for pname in $(pods); do
	   kubectl --namespace="e-stack" delete pod ${pname}; 
	   break;
	done
#	sleep  $(($RANDOM %10 + 5))
	sleep 3
done
