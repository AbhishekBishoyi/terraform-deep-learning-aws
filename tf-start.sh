#!/bin/bash
terraform init

terraform validate

terraform plan -out tf.tfplan

terraform apply tf.tfplan