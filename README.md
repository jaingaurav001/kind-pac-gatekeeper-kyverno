The project demonstrates what OPA Gatekeeper and Kyverno are, and how we can set up using KinD and use them in the Kubernetes cluster.

## Install Pre-requiste
`$ make bootstrap`

## Create the cluster
`$ make create-cluster`

## Deploy OPA Gatekeeper
`$ make deploy-gatekeeper`

## Test OPA Gatekeeper
ConstraintTemplate describes the Rego that enforces the constraint and the schema of the constraint. The schema constraint allows the author of the constraint (cluster admin) to define the contraint behavior.

In this example, the cluster admin enforce policy to validate required labels that we want to on resources (in our case Namespace resource), if required label exits then request gets approve, if not it'll get rejected.

Create the ConstraintTemplate

`$ kubectl apply -f opa-gatekeeper/k8srequiredlabels-constraint-template.yaml`

Build Constraint
The cluster admin will use the constraint to inform the OPA Gatekeeper to enforce the policy. For our example, as cluster admin we want to enforce that all the created Namespace resource should have gatekepeer label.

Create the Constraint

`$ kubectl apply -f opa-gatekeeper/k8srequiredlabels-constraint.yaml`

Verify that the CRD constraint and constrainttemplate were created

`$ kubectl get constraint
$ kubectl get constrainttemplate`

Test by creating a invalid namespace

`$ kubectl apply -f opa-gatekeeper/invalid-namespace.yaml`

The request was denied by kubernetes API, because it didn’t meet the requirement from the constraint forced by OPA Gatekeeper.

Test by creating a valid namespace

`$ kubectl apply -f opa-gatekeeper/valid-namespace.yaml`

Delete the created namespace

`$ kubectl delete -f opa-gatekeeper/valid-namespace.yaml`

## Uninstall Gatekeeper
`make uninstall-gatekeeper`


## Deploy Kyverno
`make deploy-kyverno`

List the created Custom Resource Definitions

`$ kubectl get customresourcedefinitions.apiextensions.k8s.io`

## Test Kyverno
Enforce a required label policy on Deployment resource

`$ kubectl apply -f kyverno/requirelabels-clusterpolicy.yaml`

Test it by creating a Deployment that violates the policy

`$ kubectl apply -f kyverno/invalid-deployment.yaml`

Test by creating a valid deployment

`$ kubectl apply -f kyverno/valid-deployment.yaml`

Delete the created deployment

`$ kubectl delete -f kyverno/valid-deployment.yaml`

## Uninstall Kyverno
`make uninstall-kyverno`
