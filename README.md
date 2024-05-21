<p align="center">
  <a href="https://www.digitalfortress.dev/">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://okela-bucket-s3.s3.ap-southeast-1.amazonaws.com/logo/Digital+Fortress+-+Logo.png">
      <img alt="Digital Fortress logo" src="https://okela-bucket-s3.s3.ap-southeast-1.amazonaws.com/logo/Digital+Fortress+-+Logo.png">
    </picture>    
  </a>
</p>

---

# Terraform Template

## Usage

Clone the repository

```
git clone https://github.com/digitalfortress-dev/terraform-templates.git
cd terraform-templates
```

## initialize project

Select develop workspace

```
terraform workspace select dev
```

Create Backend state

```
cd terraform/functionality/terraform_initialization_states_storage
```

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

Set up environment

```
cd terraform/functionality/initialize_environments
```

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

## Build infrastructure

Init

```
terraform init
```

Review change

```
terraform plan --var-file="dev.tfvars"
```

Apply

```
terraform apply --var-file="dev.tfvars"
```

## Project tree

```
aws-terraform-templates
├─ .github
│  └─ workflows
│     ├─ cd-dev-example.yml
│     └─ ci-dev-example.yml
├─ .gitignore
├─ .pre-commit-config.yaml
├─ LICENSE
├─ README.md
└─ terraform
   ├─ application-resources
   ├─ functionality
   │  ├─ example
   ├─ initializations
   │  ├─ initialize_environments
   │  │  ├─ lambda
   │  │  │  └─ monitoring-billing
   │  └─ terraform_initialization_states_storage
   ├─ modules
   │  ├─ acm_certificate
   │  ├─ ecr
   │  ├─ iam_role
   │  ├─ iot-core
   │  │  └─ fleet-provisioning
   │  ├─ load_balancers
   │  ├─ rds
   │  ├─ security_group
   │  ├─ sqs
   │  └─ vpc-subnet-internet_gateway
   ├─ main.tf
   ├─ dev.tfvars
   ├─ prod.tfvars
   ├─ state.tf
   └─ variables.tf
```

## License

This project is Copyright (c) 2023 and onwards Digital Fortress. It is free software and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

<a href="https://www.digitalfortress.dev/">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://okela-bucket-s3.s3.ap-southeast-1.amazonaws.com/logo/Digital+Fortress+-+Logo.png">
    <img alt="Digital Fortress logo" src="https://okela-bucket-s3.s3.ap-southeast-1.amazonaws.com/logo/Digital+Fortress+-+Logo.png" width="160">
  </picture>
</a>

This project is made and maintained by Digital Fortress.

We are an experienced team in R&D, software, hardware, cross-platform mobile and DevOps.

See more of [our projects][projects] or do you need to complete one?

-> [Let’s connect with us][website]

[projects]: https://github.com/digitalfortress-dev
[website]: https://www.digitalfortress.dev
