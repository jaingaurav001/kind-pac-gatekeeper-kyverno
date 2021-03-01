The project demonstrates what OPA Gatekeeper and Kyverno are, and how we can set up using KinD and use them in the Kubernetes cluster.

## Install Pre-requiste:
`$ make bootstrap`

## Create the cluster
`$ make create-cluster`

## Deploy OPA Gatekeeper:
`$ make deploy-gatekeeper`

## Test Gatekeeper:
Create K8sRequiredLabels Custom Resource
`$ kubectl apply -f opa-gatekeeper/k8srequiredlabels-constraint-template.yaml`

Verify that the K8sRequiredLabels CR is created
`$ kubectl get customresourcedefinitions.apiextensions.k8s.io`

Using K8sRequiredLabels CR, define policy context i.e. which resources we want to apply the policy on
`$ kubectl apply -f opa-gatekeeper/k8srequiredlabels-constraint.yaml`

Test by creating a invalid namespace:
`$ kubectl apply -f opa-gatekeeper/invalid-namespace.yaml`

Test by creating a valid namespace:
`$ kubectl apply -f opa-gatekeeper/valid-namespace.yaml`

Delete the created namespace
`$ kubectl delete -f opa-gatekeeper/valid-namespace.yaml`

## Uninstall Gatekeeper:
`make uninstall-gatekeeper`


## Deploy Kyverno:
`make deploy-kyverno`

List the created Custom Resource Definitions
`$ kubectl get customresourcedefinitions.apiextensions.k8s.io`

Enforce a required label policy on Pod resource
`$ kubectl apply -f kyverno/requirelabels-clusterpolicy.yaml`

Test it by creating a Deployment that violates the policy
`$ kubectl apply -f kyverno/invalid-deployment.yaml`

Test by creating a valid deployment
`$ kubectl apply -f kyverno/valid-deployment.yaml`

Delete the created deployment
`$ kubectl delete -f kyverno/valid-deployment.yaml`

## Uninstall Gatekeeper:
`make uninstall-kyverno`
