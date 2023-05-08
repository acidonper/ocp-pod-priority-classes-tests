#!/bin/bash
##
# Script to launch and test priorities
##

# > Created 20 sec LOW
# > START - 20 sec LOW
# => Created 35 sec LOW
# ==> Created 35 sec MED
# ==> Created 20 sec MED
# ===> Created 20 sec HIGH
# ===> Created 35 sec HIGH
# =======> FINISH - 20 sec LOW
# =======> START - 20 sec HIGH
# ==============> FINISH - 20 sec HIGH
# ==============> START - 35 sec HIGH
# =============================================> FINISH - 35 sec HIGH
# =============================================> START - 35 sec MED
# ======================================================================================> FINISH - 35 sec MED
# ======================================================================================> START - 20 sec MED
# ==================================================================================================> FINISH - 20 sec MED
# ==================================================================================================> START - 35 sec LOW
# ===========================================================================================================================> FINISH - 35 sec LOW

PROJECT="test1"

oc new-project ${PROJECT}

oc delete -f config/ResourceQuota.yaml -n ${PROJECT}

oc delete -f config/PriorityClass.yaml -n ${PROJECT}
oc create -f config/PriorityClass.yaml -n ${PROJECT}

oc apply -f pods/Pod_low_20sec.yaml -n ${PROJECT}
sleep 1
oc apply -f pods/Pod_low_35sec.yaml -n ${PROJECT} 
sleep 1
oc apply -f pods/Pod_med_35sec.yaml -n ${PROJECT}
sleep 1
oc apply -f pods/Pod_med_20sec.yaml -n ${PROJECT}
sleep 1
oc apply -f pods/Pod_high_20sec.yaml -n ${PROJECT} 
sleep 1
oc apply -f pods/Pod_high_35sec.yaml -n ${PROJECT} 

sleep 300

oc get pod -n ${PROJECT} | grep -v NAME | awk '{ print "oc delete pod "$1" --force --grace-period 0" }' | sh
