#!/bin/sh
rabbit(){
	kubectl get pods --namespace="e-stack" | grep rabbit | awk '{print $1}'
}

kubectl exec -it $(rabbit) --namespace="e-stack" -- /bin/bash

