# redis
--- 
apiVersion: v1
kind: Service
metadata: 
  labels: 
    app: redis
  name: redis
spec: 
  clusterIP: None
  ports:
  - name: redis-service
    port: 6379
    targetPort: 6379
  selector: 
    app: redis
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  labels:
    app: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:alpine
        ports:
        - containerPort: 6379
          name: redis

# db
--- 
apiVersion: v1
kind: Service
metadata: 
  labels: 
    app: db
  name: db
spec: 
  clusterIP: None
  ports: 
  - name: db
    port: 5432
    targetPort: 5432
  selector: 
    app: db
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: db
  labels:
    app: db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: db
        image: postgres:9.4
        env:
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        - name: POSTGRES_USER
          value: postgres
        - name: POSTGRES_PASSWORD
          value: postgres
        ports:
        - containerPort: 5432
          name: db
        volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: db-data
        persistentVolumeClaim:
          claimName: postgres-pv-claim
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

# result
---
apiVersion: v1
kind: Service
metadata:
  name: result
  labels:
    app: result
spec:
  type: LoadBalancer
  ports:
  - port: 5001
    targetPort: 80
    name: result-service
  selector:
    app: result
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: result
  labels:
    app: result
spec:
  replicas: 1
  selector:
    matchLabels:
      app: result
  template:
    metadata:
      labels:
        app: result
    spec:
      containers:
      - name: result
        image: dockersamples/examplevotingapp_result:before
        ports:
        - containerPort: 80
          name: result

# vote
---
apiVersion: v1
kind: Service
metadata:
  name: vote
  labels:
    apps: vote
spec:
  type: LoadBalancer
  ports:
    - port: 5000
      targetPort: 80
      name: vote-service
  selector:
    app: vote
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vote
  labels:
    app: vote
spec:
  replicas: 2
  selector:
    matchLabels:
      app: vote
  template:
    metadata:
      labels:
        app: vote
    spec:
      containers:
      - name: vote
        image: dockersamples/examplevotingapp_vote:before
        ports:
        - containerPort: 80
          name: vote

# worker
--- 
apiVersion: v1
kind: Service
metadata: 
  labels: 
    apps: worker
  name: worker
spec: 
  clusterIP: None
  selector: 
    app: worker
--- 
apiVersion: apps/v1
kind: Deployment
metadata: 
  labels: 
    app: worker
  name: worker
spec: 
  replicas: 1
  selector:
    matchLabels:
      app: worker
  template: 
    metadata: 
      labels: 
        app: worker
    spec: 
      containers: 
      - image: dockersamples/examplevotingapp_worker
        name: worker


-----------------------------
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

