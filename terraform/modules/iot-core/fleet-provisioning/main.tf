data "aws_iam_policy_document" "iot_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["iot.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iot_thing_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "iot:Connect"
    ]
    effect    = "Allow"
    resources = ["arn:aws:iot:${var.aws_region}:${var.account_id}:client/*"]
  }
  statement {
    actions = [
      "iot:Publish",
      "iot:Receive"
    ]
    effect    = "Allow"
    resources = ["arn:aws:iot:${var.aws_region}:${var.account_id}:topic/*"]
  }
  statement {
    actions = [
      "iot:Subscribe"
    ]
    effect    = "Allow"
    resources = ["arn:aws:iot:${var.aws_region}:${var.account_id}:topicfilter/*"]
  }
}

data "aws_iam_policy_document" "claim_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "iot:Connect"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "iot:Publish",
      "iot:Receive"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iot:${var.aws_region}:${var.account_id}:topic/$aws/certificates/create-from-csr/*",
      "arn:aws:iot:${var.aws_region}:${var.account_id}:topic/$aws/provisioning-templates/${aws_iot_provisioning_template.fleet.name}/provision/*",
    ]
  }
  statement {
    actions = [
      "iot:Subscribe"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:iot:${var.aws_region}:${var.account_id}:topicfilter/$aws/certificates/create-from-csr/*",
      "arn:aws:iot:${var.aws_region}:${var.account_id}:topicfilter/$aws/provisioning-templates/${aws_iot_provisioning_template.fleet.name}/provision/*"
    ]
  }
}

resource "aws_iam_role" "role_fleet_provisioning" {
  name               = "${local.base_name}-IoTProvisioningServiceRole"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.iot_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_fleet_provisioning_registration" {
  role       = aws_iam_role.role_fleet_provisioning.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSIoTThingsRegistration"
}

resource "aws_iam_role_policy_attachment" "policy_fleet_provisioning_lambdas" {
  role       = aws_iam_role.role_fleet_provisioning.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iot_policy" "thing_policy" {
  name   = "${local.base_name}-FleetProvisioningThingPolicy"
  policy = data.aws_iam_policy_document.iot_thing_policy.json
}

### Create IOT provisioning template
resource "aws_iot_provisioning_template" "fleet" {
  name                  = "${local.workspace}FleetProvisioningTemplate"
  description           = "My fleet provisioning template"
  provisioning_role_arn = aws_iam_role.role_fleet_provisioning.arn
  enabled               = true
  pre_provisioning_hook {
    target_arn = var.lambda_function_arn
  }
  template_body = jsonencode({
    Parameters = {
      PhotoframeId = { Type = "String" }
    }

    Resources = {
      certificate = {
        Properties = {
          CertificateId = { Ref = "AWS::IoT::Certificate::Id" }
          Status        = "Active"
        }
        Type = "AWS::IoT::Certificate"
      }
      thing = {
        Type = "AWS::IoT::Thing"
        Properties = {
          ThingName = { "Fn::Join" = ["", ["${local.base_name}-", { "Ref" : "PhotoframeId" }]] }
        },
        OverrideSettings = {
          AttributePayload = "MERGE"
          ThingTypeName    = "REPLACE"
          ThingGroups      = "DO_NOTHING"
        }
      }
      policy = {
        Properties = {
          PolicyName = aws_iot_policy.thing_policy.name
        }
        Type = "AWS::IoT::Policy"
      }
    }
  })
}

resource "aws_iot_certificate" "claim_cert" {
  active = true
}

resource "aws_iot_policy" "claim_policy" {
  name   = "${local.base_name}-FleetProvisioningClaimPolicy"
  policy = data.aws_iam_policy_document.claim_policy.json
}

resource "aws_iot_policy_attachment" "att_claim_policy" {
  policy = aws_iot_policy.claim_policy.name
  target = aws_iot_certificate.claim_cert.arn
}

### Create file local
# resource "local_file" "cert_claim" {
#   filename = "certificate_pem.cert"
#   content  = aws_iot_certificate.claim_cert.certificate_pem
# }

# resource "local_file" "cert_private_key" {
#   filename = "cert_private_key.key"
#   content  = aws_iot_certificate.claim_cert.private_key
# }

# resource "local_file" "cert_public_key" {
#   filename = "cert_public_key.key"
#   content  = aws_iot_certificate.claim_cert.public_key
# }

data "aws_iot_registration_code" "reg_code" {}
