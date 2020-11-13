provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"

  version = "1.54.0"
}

resource "aws_cognito_user_pool" "pool" {
  name                       = "terraform-example"
  email_verification_subject = "Device Verification Code"
  email_verification_message = "Please use the following code {####}"
  sms_verification_message   = "{####} Baz"
  alias_attributes           = ["email", "preferred_username"]
  auto_verified_attributes   = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    reply_to_email_address = "foo.bar@baz"
  }

  password_policy {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  lambda_config {
    create_auth_challenge          = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"
    custom_message                 = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"
    define_auth_challenge          = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"
    post_authentication            = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"
    post_confirmation              = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"
    verify_auth_challenge_response = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"
    user_migration                 = "arn:aws:lambda:us-west-2:714391543914:function:CustomMessageTrigger"    

  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 15
    }
  }

  schema {
    attribute_data_type      = "Number"
    developer_only_attribute = true
    mutable                  = true
    name                     = "mynumber"
    required                 = false

    number_attribute_constraints {
      min_value = 2
      max_value = 6
    }
  }
}
