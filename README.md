# Terraform criando VMs (IaaS) no Azure, GCP e AWS

Pré-requisitos

- az instalado e configurado
- gcloud instalado e configurado
- aws instalado e configurado
- Terraform instalado

Logar no Azure via az cli, o navegador será aberto para que o login seja feito

```sh
az login
```

Logar no GCP usando gcloud com o comando abaixo

```sh
gcloud auth login
```

Logar na AWS usando aws cli com o comando abaixo

```sh
aws configure sso
```

Gerar chave pública e privada para acessar a VM, com nome "id_rsa" na raiz do projeto

```sh
ssh-keygen -t rsa -b 4096
```

Inicializar o Terraform

```sh
terraform init
```

Executar o Terraform

```sh
terraform apply -auto-approve
```

Acessar cada máquina criando usando o comando abaixo e trocando o ip

```sh
ssh ubuntu@[IP Criado] -i id_rsa
```