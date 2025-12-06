```sh
sudo systemctl start docker
tofu apply
export KUBECONFIG=$(tofu output -raw kubeconfig)
kubectl get nodes
tofu destroy
```

```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
