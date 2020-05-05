#!/bin/sh -xe

export TF_VAR_access_key=...
export TF_VAR_secret_key=...
terraform apply

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml
sleep 3m # wait for the load balancer provisioning
kubectl apply -f . --validate=false # pathType: Prefix in ingress.yaml is not accepted. Why?

echo "## Wait until you see the FQDN appear. Then curl it"
kubectl get ingress --watch

echo "## Remember to launch `terraform destroy`"
