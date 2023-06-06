#!/bin/bash

az login
aws iam create-access-key --user-name Administrator
gcloud auth application-default login

ssh-keygen -t rsa -b 4096
