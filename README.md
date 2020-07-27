# Skaffold Django Demo
[Skaffold](https://skaffold.dev/) automates the tedious parts of developing on K8s, like rebuilding Docker images, and pushing code to the cluster.  This demo is setup for the [Django getting started tutorial](https://docs.djangoproject.com/en/3.0/intro/tutorial01/).
## Dependencies
You'll need:
* [skaffold](https://skaffold.dev/docs/install/)
* [helm](https://github.com/helm/helm/releases)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* Docker
  * docker-cli (Usually packaged by distro)
  * [docker-machine](https://docs.docker.com/machine/install-machine/)
  * OR
  * [local docker](https://www.docker.com/get-started)

## Usage
* Clone this repo down to your workstation.
* You should be able to use docker without privilege escalation.
  * If using docker-machine
```
docker-machine create dm
docker-machine start dm && eval $(docker-machine env dm)
```
* Start minikube
```
minikube start
```
* Update your /etc/hosts file:
```
echo "$(minikube ip) tutorial.local" >> /etc/hosts
```
* Generate the project and update some things in settings.py
```
django-admin startproject quickstart
```
* Update settings.py
    * ALLOWED_HOSTS: add 'tutorial.local' to the list
    * DATABASES: change the second arg for 'os.path.join' from 'db.sqlite3' to 'db/db.sqlite3'
      * This places the DB file on a K8s persistent volume to avoid losing state between redeploys.
* Start Skaffold
```
skaffold dev
```
* You should now be able to follow the tutorial in a new terminal window, Skaffold will rebuild the environment as you go.
* **Note:** There are a few things that won't align directly with the tutorial since it's running in Kubernetes instead of locally:
  * Most commands you're asked to run will need to be ran within the Django container on minikube.
    * The exception to this is any command that affects the code like adding a new app.
  * The development server is available at tutorial.local instead of localhost:8000.
  * You'll need to switch python with python3 for commands.
* **Tip:** you can open a shell on the Django container with:
```
kubectl exec -it $(kubectl get -l app.kubernetes.io/instance=django-quickstart pod -o jsonpath='{.items[0].metadata.name}') bash
kubectl exec -it $(kubectl get -l app.kubernetes.io/instance=django-quickstart pod -o jsonpath='{.items[0].metadata.name}') CMD.HERE!
alias django_cmd='kubectl exec -it $(kubectl get -l app.kubernetes.io/instance=django-quickstart pod -o jsonpath="{.items[0].metadata.name}") --'
django_cmd CMD.HERE!
```
* **Tip:** it's helpful to have a terminal that can be split using something like [Terminator](https://terminator-gtk3.readthedocs.io/en/latest/)
* **Tip:** If you're using vim you may see Skaffold reload everytime you open a file, this is due to the swap file (.swp) vim creates.  You can change where vim puts that file, or add it to the .dockerignore file.
* Skaffold removes the PVC on shutdown, which means Django's DB won't persist after Skaffold is shutdown
  * https://github.com/GoogleContainerTools/skaffold/issues/4366
