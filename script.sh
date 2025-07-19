#!/bin/bash

eval $(minikube docker-env)

echo "Criando as imagens...."
podman build -t victorlqueiroz/projeto-backend:1.0 backend/.
podman build -t victorlqueiroz/projeto-database:1.0 database/.

echo "Realizando o push das imagens...."S
podman push victorlqueiroz/projeto-backend:1.0
podman push victorlqueiroz/projeto-database:1.0

echo "Criando servicos no cluster kubernetes...."
kubectl apply -f ./services.yml --validate=false

echo "Criando os deployments...."
kubectl apply -f ./deployment.yml --validate=false
