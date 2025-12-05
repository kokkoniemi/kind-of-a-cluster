```sh
sudo systemctl start docker
tofu apply
export KUBECONFIG=$(tofu output -raw kubeconfig)
kubectl get nodes
tofu destroy
```

