default:
  tags:
  - Terraform
  - AZ
variables:
  TERRAFORM_DESTROY: "YES"

stages:
  - terraform-init
  - terraform-fmt-validate
  - terraform-plan
  - terraform-apply
  - terraform-destroy

job-check-terraform-version:
  stage: terraform-init
  rules:
    - if: $TERRAFORM_DESTROY == "NO"
  script:
  - pwd && ls -al

job-run-terraform-init:
  stage: terraform-init
  rules:
    - if: $TERRAFORM_DESTROY == "NO"
  script:
    - curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash
    - pwd
    - ls -al .secure_files
    - echo $ARM_CLIENT_ID
    - echo $ARM_CLIENT_SECRET
    - terraform init -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"

job-run-terraform-fmt-validate:
  stage: terraform-fmt-validate
  rules:
    - if: $TERRAFORM_DESTROY == "NO"
  script:
    - curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash
    - pwd
    - ls -al
    - echo $ARM_CLIENT_ID
    - echo $ARM_CLIENT_SECRET
    - terraform init -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"
    - terraform fmt && terraform validate

job-run-terraform-plan:
  stage: terraform-plan
  allow_failure: true
  rules:
    - if: $TERRAFORM_DESTROY == "NO"
  script:
    - curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash
    - pwd
    - ls -al
    - echo $ARM_CLIENT_ID
    - echo $ARM_CLIENT_SECRET
    - echo $TERRAFORM_DESTROY
    - terraform init -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"
    - terraform plan -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "tenant_id=$ARM_TENANT_ID" -var "subscription_id=$ARM_SUBSCRIPTION_ID"

job-run-terraform-apply:
  variables: {}
  stage: terraform-apply
  needs: ["job-run-terraform-plan"]
  variables:
  rules:
    - if: $TERRAFORM_DESTROY == "NO"
  script:
    - curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash
    - pwd
    - ls -al
    - echo $TERRAFORM_DESTROY
    - echo $ARM_CLIENT_ID
    - echo $ARM_CLIENT_SECRET
    - terraform init -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"
    - terraform apply -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "tenant_id=$ARM_TENANT_ID" -var "subscription_id=$ARM_SUBSCRIPTION_ID" --auto-approve


job-run-terraform-destroy:
  stage: terraform-destroy
  #needs: ["job-run-terraform-plan"]
  variables:
    JOB_VAR: "A job variable"
  rules:
    - if: $TERRAFORM_DESTROY == "YES"
  script:
    - curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash
    - pwd
    - ls -al
    - echo $ARM_CLIENT_ID
    - echo $ARM_CLIENT_SECRET
    - terraform init -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"
    - terraform destroy -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "tenant_id=$ARM_TENANT_ID" -var "subscription_id=$ARM_SUBSCRIPTION_ID" --auto-approve

