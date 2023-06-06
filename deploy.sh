#!/bin/bash

# Login nos provedores de nuvem
az login
gcloud auth login
aws configure sso

# Criar SSH Keys
ssh-keygen -t rsa -b 4096

# Acessar as máquinas usando SSH
ssh ubuntu@[IP Criado] -i id_rsa