# Openshift Priorities Queues

This repository tries to collect information about how Openshift default scheduler using priority classes when pods and jobs are used. The idea is generate a set of test bundles in order to play with priority classes implementing different use cases.

Basically, a set of objects (pods or jobs) will be created and the Openshift cluster will not able to schedule all of them at the same time. Priority classes will play an important role in order to prioritize the different workloads executions after being created.

## Use Case 1 - Priorities with Pods

This test bundle creates multiple workloads at the same time, that are large enough individually to consume all resources in an Openshift cluster. For this reason, it is not possible to execute multiple pods in parallel and the Openshift scheduler has to manage this situation applying priority classes.

The execution and the respective result are included in the following procedure:

```$bash
sh priorities_pods.sh
...
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
```

## Use Case 2 - Priorities with Jobs

This test bundle creates multiple jobs that are created as pods at the same time, that are large enough individually to consume all resources in an Openshift cluster. For this reason, it is not possible to execute multiple pods in parallel and the Openshift scheduler has to manage this situation applying priority classes.

The execution and the respective result are included in the following procedure:

```$bash
sh priorities_jobs.sh
...
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
```

## Use Case 3 - Priorities with Jobs and Quotas

This test bundle creates a resource quota policy that restricts pod creation to 1 and multiple jobs that are created at the same time but can not be "promoted" as pods at the same time because of this policy. This situation delegates in the job manager the responsability to create the pods, based on the jobs created previously, and the Openshift scheduler will manage pods one by one.

The execution and the respective result are included in the following procedure:

```$bash
sh priorities_jobs_limits.sh
...
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
# RANDOM SELECTION
# ==========> START - XX - POD
# ==========> FINISH - XX - POD
# RANDOM SELECTION
# =============> START - XX - POD
# =============> FINISH - XX - POD
# RANDOM SELECTION
# ================> START - XX - POD
# ================> FINISH - XX - POD
# RANDOM SELECTION
# ===================> START - XX - POD
# ===================> FINISH - XX - POD
# RANDOM SELECTION
# ======================> START - XX - POD
# ======================> FINISH - XX - POD
```

## Author

Asier Cidon @RedHat
