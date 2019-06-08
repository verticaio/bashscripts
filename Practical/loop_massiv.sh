CLUSTER_IP=10.9.8.10
NODES=(node1 node2 node3)
IPS=(10.9.8.11 10.9.8.12 10.9.8.13)
POD_SUBNET="192.168.0.0/16"

for i in "${!NODES[@]}"; do
  HOST=${IPS[$i]}
  NAME=${NODES[$i]}
  INITIAL_CLUSTER=$(
    for j in "${!NODES[@]}"; do
      echo "${NODES[$j]}=https://${IPS[$j]}:2380"
    done | xargs | tr ' ' ,
  )

cat > kubeadm-config-${NODES[$i]}.yaml <<EOT
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: stable
apiServer:
  certSANs:
  - "${CLUSTER_IP}"
controlPlaneEndpoint: "${CLUSTER_IP}:6443"
etcd:
  local:
    extraArgs:
      initial-cluster: "${INITIAL_CLUSTER}"
      initial-cluster-state: new
      name: ${NODES[$i]}
      listen-peer-urls: "https://${IPS[$i]}:2380"
      listen-client-urls: "https://127.0.0.1:2379,https://${IPS[$i]}:2379"
      advertise-client-urls: "https://${IPS[$i]}:2379"
      initial-advertise-peer-urls: "https://${IPS[$i]}:2380"
    serverCertSANs:
      - "${NODES[$i]}"
      - "${IPS[$i]}"
    peerCertSANs:
      - "${NODES[$i]}"
      - "${IPS[$i]}"
networking:
    podSubnet: "${POD_SUBNET}"
EOT
done