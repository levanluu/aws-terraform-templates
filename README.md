<p align="center">
  <a href="https://www.digitalfortress.dev/">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://okela-bucket-s3.s3.ap-southeast-1.amazonaws.com/logo/Digital+Fortress+-+Logo.png">
      <img alt="Digital Fortress logo" src="https://okela-bucket-s3.s3.ap-southeast-1.amazonaws.com/logo/Digital+Fortress+-+Logo.png">
    </picture>    
  </a>
</p>

---

# AWS Terraform Template

## Usage

Clone the repository
```
git clone https://github.com/digitalfortress-dev/aws-terraform-templates.git
cd aws-terraform-templates
```

## Initialize

Run this step if you are beginning to set up a new infrastructure

### Initialize common state storage

- Go to `phases/initializations/terraform_initialization_states_storage`

  ```
  cd phases/initializations/terraform_initialization_states_storage
  ```

- Setup common state storage

  ```
  terraform init
  terraform apply
  ```

### Initialize AWS account and state storage for each environment

- Go to `phases/initializations/initialize_environments`

  ```
  cd phases/initializations/initialize_environments
  ```

- Update environments list in `terraform.tfvars`

- Setup AWS account and state storage for each environment

  ```
  terraform init
  terraform apply
  ```

## Setup pre-commit (optional)

```
pre-commit install
```

## Setup infrastructure for project

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
