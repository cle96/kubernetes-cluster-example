# Kubernetes small cluster example

The aim of this project was to gather understandings of the inner workings of kubernetes.
Different features have been at test, such as:
    - Liveness
    - Readiness
    - Load balancing
    - Surpassing chaos monkey
    
In order to run the cluster, one must install ``docker`` and ``kubernetes`` on their machines.
`Installations very based on the Operating system of use.`

The following features can be tested on all OS's that have the 2 technologies installed, but the process described is for those that support `shell`, `bash`.

## Run the cluster
With the technologies installed, now all we need to do is 
```
kubectl apply -f namespace.yaml
sh spray-cluster.sh
```

## Liveness
On rabbitmq there is within yaml a definition of the liveness behaviour.

```
 livenessProbe:
            exec:
              command:
              - rabbitmqctl
              - node_health_check
            initialDelaySeconds: 30
            timeoutSeconds: 15
```
Running within the rabbitmq container (via `sh exec-rabbit.sh`) the command `rabbitmqctl stop` will now impeed the liveness of our Pod and will bring it down, as it is unhealthy.

A new Pod will shortly be created in exchange of destryoing it.

## Readiness
First we need to go inside the file called *rabbit-stateful.yaml* and remove the comment marks from:

```
readinessProbe:
            exec:
              command:
              - rabbitmqctl
              - node_health_check
            initialDelaySeconds: 30
            timeoutSeconds: 15
```

After running the Pod again via ``kubectl apply -f rabbit-stateful.yaml`` we can play with the Readiness feature.
We can now hack the ReadinessProbe by having a faulty command instead.
```
   command:
              - rabbitmqctl
              - fail-now
```
Since there is not a command called ``rabbitmqctl fail-now``, the Pod will shortly be flagged unhealthy.
## Load balancing
Considering the cluster is healthy and up and running, we can start playing with some autoscallers as well.
For now, we will be doing so via kubectl and the following command 
`kubectl autoscale replicaset redis-transient --cpu-percent=50 --min=1 --max=3 --namespace="e-stack"`

In order to simply spike the CPU, we can now exec inside a running container:
`
kubectl exec -it redis-transient-* --namespace="e-stack" -- /bin/bash
`
Inside it we will just pipe the simply occupy the CPUs force with
`
yes > /dev/null &
`(x times / x=amount of cores)

## Surpassing chaos monkey (light-weight)
The file *chaos-monkey.sh* contains the bash lines of a script that kills random pods running. With it, we can mimic the attack of a chaos monkey and see how the cluster will behave and regenerate.
`
sh chaos-monkey.sh
`


