#!/bin/bash
##
# Script to launch and test priorities
##

# > Created 20 sec LOW - JOB
# > Created 20 sec LOW - POD (*by job manager)
# > START - 20 sec LOW - POD
# => Created 35 sec LOW - JOB
# => Created 35 sec LOW - POD (*by job manager)
# ==> Created 35 sec MED - JOB
# ==> Created 35 sec MED - POD (*by job manager)
# ==> Created 20 sec MED - JOB
# ==> Created 20 sec MED - POD (*by job manager)
# ===> Created 20 sec HIGH - JOB
# ===> Created 20 sec HIGH - POD (*by job manager)
# ===> Created 35 sec HIGH - JOB
# ===> Created 35 sec HIGH - POD (*by job manager)
# =======> FINISH - 20 sec LOW - POD
# =======> START - 20 sec HIGH - POD
# ==============> FINISH - 20 sec HIGH - POD
# ==============> START - 35 sec HIGH - POD
# =============================================> FINISH - 35 sec HIGH - POD
# =============================================> START - 35 sec MED - POD
# ======================================================================================> FINISH - 35 sec MED - POD
# ======================================================================================> START - 20 sec MED - POD
# ==================================================================================================> FINISH - 20 sec MED - POD
# ==================================================================================================> START - 35 sec LOW - POD
# ===========================================================================================================================> FINISH - 35 sec LOW - POD

PROJECT="test1"

oc new-project ${PROJECT}

oc delete -f config/ResourceQuota.yaml -n ${PROJECT}

oc delete -f config/PriorityClass.yaml -n ${PROJECT}
oc create -f config/PriorityClass.yaml -n ${PROJECT}

oc apply -f jobs/Job_low_20sec.yaml -n ${PROJECT}
sleep 1
oc apply -f jobs/Job_low_35sec.yaml -n ${PROJECT} 
sleep 1
oc apply -f jobs/Job_med_35sec.yaml -n ${PROJECT}
sleep 1
oc apply -f jobs/Job_med_20sec.yaml -n ${PROJECT}
sleep 1
oc apply -f jobs/Job_high_20sec.yaml -n ${PROJECT} 
sleep 1
oc apply -f jobs/Job_high_35sec.yaml -n ${PROJECT} 

sleep 300

oc get job -n ${PROJECT} | grep -v NAME | awk '{ print "oc delete job "$1" --force --grace-period 0" }' | sh
