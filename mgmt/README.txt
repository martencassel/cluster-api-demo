Generating cluster configurations files

clusterctl generate cluster capi-quickstart --flavor development \
  --kubernetes-version v1.25.3 \
  --control-plane-machine-count=1 \
  --worker-machine-count=1 \
  > c1-quickstart.yaml
