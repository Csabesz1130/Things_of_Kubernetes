#!/bin/bash

# Set the namespace and label selector for the Carddeck-webapp pods
NAMESPACE="default"
LABEL_SELECTOR="app=carddeck-webapp"

# Get the list of pods for the Carddeck-webapp deployment
PODS=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through the list of pods and check the most important parameters
for POD in $PODS; do
  # Get the CPU and memory utilization for the pod
  CPU_UTIL=$(kubectl top pod $POD -n $NAMESPACE | awk '{print $2}')
  MEM_UTIL=$(kubectl top pod $POD -n $NAMESPACE | awk '{print $3}')
  
  # Check if the pod is running and ready
  STATUS=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.status.phase}')
  READY=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.status.containerStatuses[0].ready}')
  
  # Generate a diagnostic summary for the pod
  echo "Pod: $POD"
  echo "Status: $STATUS"
  echo "Ready: $READY"
  echo "CPU utilization: $CPU_UTIL"
  echo "Memory utilization: $MEM_UTIL"
  echo "----------------------------------------------"
done
