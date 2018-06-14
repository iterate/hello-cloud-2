# hello-cloud-2

Klon repoet. Installer [docker](https://docs.docker.com/docker-for-mac/install/) og [gcloud SDK](https://cloud.google.com/sdk/).


## Setup gcloud
```
$ gcloud components install kubectl
$ gcloud auth login 
$ gcloud auth application-default login
$ gcloud auth configure-docker 
$ gcloud config set compute/zone europe-west1-d
$ gcloud config set project hello-cloud-2
```
## Opprette nytt cluster
Logg inn på [Google cloud console](http://iter.at/hcloud). Du skal nå være på prosjektet hello-cloud-2.

Create cluster ->

    Name = cluster-<dittnavn>´´
    Machine type  = micro
    Zone = europe-west1-d

Connect -> kopier og kjør kodesnutten lokalt.


## Bygg og push docker image 

```
hello-cloud-2 $ docker build . -t gcr.io/hello-cloud-2/<dittnavn>

// Valgfritt
$ docker run -it -p 80:80 gcr.io/hello-cloud-2/<dittnavn>
$ curl localhost

$ docker push gcr.io/hello-cloud-2/<dittnavn>
```

docker push dytter app-image til [Google cloud container registry](http://iter.at/gcr2). 


## Deploy docker image i clusteret

Endre kubernetes config til å bruke ditt nye docker image. 

```
hello-cloud-2 $ kubernetes.yaml

32: image: gcr.io/hello-cloud-2/hello-cloud-2 -> 
    image: gcr.io/hello-cloud-2/<dittnavn>
```


```
$ kubectl apply -f kubernetes.yaml
$ kubectl get ingress
NAME          HOSTS     ADDRESS         PORTS     AGE
hellocloud2   *         35.186.240.49   80        4h
```
Det kan ta noen minutter før loadbalancer tildeler ip-adresse

```
$ google-chrome <address>
```
Hvis du får 404, vent litt til :)


## Manage cluster

`kubectl` er verktøyet vi bruker for å sende kommandoer til clusteret og gjøre endringer på ressurser. 

Husk at `kubernetes.yaml` danner basis-konfigurasjonen for ressursene vi jobber med og at du kan også kan gjøre endringer der og rulle disse ut med `kubectl apply -f`.

### 1. Skalering

Clusteret kjører 2 instanser (pods) av applikasjonen. Skaler dette opp til 3.

```
kubectl scale
```

### 2. Logging

Hent ut loggen for en app-instans (pod).


```
kubectl get 
kubectl logs 
```

### 3. Rulle ut ny versjon

Gjør en endring på applikasjonen, bygg og deploy til clusteret.

```
 Kubernetes vil ikke hente et siste image hvis image tag er uendret.

 $ docker build . -t gcr.io/hello-cloud-2/<dittnavn>:<tagname>

```

### 4. Namespaces
Namespaces grupperer ressurser som hører sammen og gjør det lettere å gjør operasjoner mot mange ressurser på en gang.
Du kan ha like ressurser under forskjellige namespaces, eksempelvis "production" og "development". kubectl skiller på disse med en `--namespace` eller `-n` parameter. 

Forsøk å opprette ressursene fra kubernetes.yaml i et 'development' namespace.

Hent alle podder i alle namespaces: `kubectl get pods --all-namespaces`, legg merke til hellocloud2.

Forsøk å slett alle services,deployments,ingress ressurser under 'development' namespace.

```
$ kubectl delete 
```

### 5. Environment variables

Når appen viser forsiden skriver den ut NODE_ENV som er definert i `Dockerfile` og blir satt i appens container. Du kan overstyre disse i kubernetes. Sett NODE_ENV til noe annet uten å bygge imaget på nytt.

## Minicube

Hvis du vil teste kubernetes hjemme, ta en kikk på [Minicube](http://kubernetes.io/docs/getting-started-guides/minikube/). Eller du kan prøve å sette opp et multimaskin-cluster med [Raspberry pi](https://kubecloud.io/setup-a-kubernetes-1-9-0-raspberry-pi-cluster-on-raspbian-using-kubeadm-f8b3b85bc2d1).
