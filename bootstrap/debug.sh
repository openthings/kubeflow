#!/usr/bin/env bash
#
# this will deploy bootstrapper and setup port-forward in the remote container,
# When the remote container starts, bootstrapper will be run under the golang debugger "dlv"
# and wait for a connection which can be done using goland's remote go configuration.
# See the [developer_guide.md](./developer_guide.md) for additional details.
#

cleanup() {
  if [[ -n $portforwardcommand ]]; then
    echo killing $portforwardcommand
    pkill -f $portforwardcommand
  fi
}
trap cleanup EXIT

portforward() {
  local pod=$1 namespace=$2 from_port=$3 to_port=$4 cmd
  cmd='kubectl port-forward $pod ${from_port}:${to_port} --namespace=$namespace 2>&1>/dev/null &'
  portforwardcommand="${cmd% 2>&1>/dev/null &}"
  eval $cmd
}

waitforpod() {
  local cmd="kubectl get pods --no-headers -oname --selector=app=kubeflow-bootstrapper --field-selector=status.phase=Running --namespace=kubeflow-admin | sed 's/^pod.*\///'" found=$(eval "$cmd")
  while [[ -z $found ]]; do
    sleep 1
    found=$(eval "$cmd")
  done
  echo $found
}

waitforever() {
  which gsleep >/dev/null
  if [[ $? == 1 ]]; then
    while true; do
      sleep 1
    done
  else
    gsleep infinity
  fi
}

if [[ $# < 3 ]]; then
  echo "usage: $0 <image> <tag> <port>"
  exit 1
fi
image=$1
tag=$2
port=$3
namespace=kubeflow-admin
cat <<EOF | kubectl create -f -
# Namespace for bootstrapper
apiVersion: v1
kind: Namespace
metadata:
  name: kubeflow-admin
---
# Store ksonnet apps
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kubeflow-ksonnet-pvc
  namespace: kubeflow-admin
  labels:
    app: kubeflow-ksonnet
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
---
apiVersion: apps/v1beta2
kind: StatefulSet
metadata:
  name: kubeflow-bootstrapper
  namespace: kubeflow-admin
spec:
  selector:
    matchLabels:
      app: kubeflow-bootstrapper
  serviceName: kubeflow-bootstrapper
  template:
    metadata:
      name: kubeflow-bootstrapper
      labels:
        app: kubeflow-bootstrapper
    spec:
      containers:
      - name: kubeflow-bootstrapper
        image: ${image}:${tag}
        workingDir: /opt/bootstrap
        command: ["/opt/kubeflow/dlv.sh"]
        ports:
        - containerPort: $port
        securityContext:
          privileged: true
        volumeMounts:
        - name: kubeflow-ksonnet-pvc
          mountPath: /opt/bootstrap
      volumes:
      - name: kubeflow-ksonnet-pvc
        persistentVolumeClaim:
          claimName: kubeflow-ksonnet-pvc
EOF
echo "Waiting for pod's status == Running ..."
pod=$(waitforpod)
echo "Pod $pod is running. Setting up port-forward"
portforward $pod $namespace $port $port
echo "Type Ctrl^C to end debug session"
waitforever
