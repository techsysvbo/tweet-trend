#!/bin/sh
kubectl apply -f ns.yaml
kubectl apply -f secrets.yaml
kubectl apply -f deploy.yaml
kubectl apply -f svc.yaml
