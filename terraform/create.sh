#!/bin/bash
terraform apply -auto-approve
gcloud container clusters get-credentials japanese-candy --zone us-west1-b --project upheld-garage-204720
cd ../helm
helm init
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm package wordpress/
sleep 30
helm install wordpress-*.tgz -n japanese-candy
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install coreos/kube-prometheus --name kube-prometheus --set global.rbacEnable=true --namespace monitoring
echo "Waiting for wordpress to be ready"
sleep 60
echo "Wordpress is ready! Access at this url:"
export SERVICE_IP=$(kubectl get svc --namespace default japanese-candy-wordpress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo http://$SERVICE_IP/admin
echo Username: user
echo Password: $(kubectl get secret --namespace default japanese-candy-wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode)
kubectl expose pod prometheus-kube-prometheus-prometheus-0 -n monitoring --port 9090 --type=LoadBalancer
echo "Waiting for prometheus to be ready"
sleep 30
echo Prometheus is ready at: $(kubectl get svc --namespace monitoring prometheus-kube-prometheus-prometheus-0 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
