# japanese-candy
Pieced together from these (and the official docs for many of these technologies):
https://itnext.io/kubernetes-monitoring-with-prometheus-in-15-minutes-8e54d1de2e13
https://github.com/coreos/prometheus-operator
https://github.com/kubernetes/charts/tree/master/stable/prometheus
https://github.com/kubernetes/charts/tree/master/stable/wordpress
https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/
### Prereqs
Have a google cloud account with billing enabled, and if you're on a free account the `IN_USE_ADDRESSES` quota needs to be raised from 8 (I set mine at 32, but you could get away with 12-15)
Have the GCloud SDK installed, have editor/owner permissions for the project you are deploying to, and be authed (either run `gcloud auth login` or have an account json set up properly.
 
### How to use
Replace the `--project` argument in the first line of `terraform/create.sh` with the ID of your project.
`./create.sh`
Profit!
