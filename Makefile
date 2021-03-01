KIND_VERSION ?= 0.8.1
# note: k8s version pinned since KIND image availability lags k8s releases
KUBERNETES_VERSION ?= v1.19.0
KUSTOMIZE_VERSION ?= 3.7.0
CLUSTER_NAME ?= pac-testing
GATEKEEPER_VERSION ?= release-3.1
KYVERNO_VERSION ?= v1.3.3

bootstrap:
	# Download and install kind
	curl -L https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64 --output /usr/local/bin/kind && chmod +x /usr/local/bin/kind
	# Download and install kubectl
	curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
	# Download and install kustomize
	curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -o kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && tar -zxvf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && chmod +x kustomize && mv kustomize ${GITHUB_WORKSPACE}/bin/kustomize

create-cluster:
	# Check for existing kind cluster
	if [ $$(kind get clusters | grep ${CLUSTER_NAME}) ]; then kind delete clusters ${CLUSTER_NAME}; fi
	# Create a new kind cluster
	TERM=dumb kind create cluster --name ${CLUSTER_NAME} --image kindest/node:${KUBERNETES_VERSION} --config=resources/kind_config.yaml

deploy-gatekeeper:
	kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/${GATEKEEPER_VERSION}/deploy/gatekeeper.yaml

uninstall-gatekeeper:
	kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/${GATEKEEPER_VERSION}/deploy/gatekeeper.yaml

deploy-kyverno:
	kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/${KYVERNO_VERSION}/definitions/release/install.yaml

uninstall-kyverno:
	kubectl delete -f https://raw.githubusercontent.com/kyverno/kyverno/${KYVERNO_VERSION}/definitions/release/install.yaml
