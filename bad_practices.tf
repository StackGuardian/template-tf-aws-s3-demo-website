############################################
# Anti-pattern S3 buckets and null_resources
############################################

# BAD: hardcoded credentials in a local — should come from a secrets manager / env vars.
locals {
  aws_access_key = "AKIAIOSFODNN7EXAMPLE"
  aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  admin_password = "SuperSecret123!"
  hardcoded_account_id = "123456789012"
  hardcoded_region     = "us-east-1"
}

# BAD: bucket name hardcoded (collisions across envs), no encryption,
# no versioning, no logging, no public access block, public-read-write ACL,
# force_destroy on prod-style resource, no tags.
resource "aws_s3_bucket" "logs" {
  bucket        = "company-prod-logs-bucket"
  acl           = "public-read-write"
  force_destroy = true
}

# BAD: another bucket with the same problems — duplicated config, copy-paste smell.
resource "aws_s3_bucket" "backups" {
  bucket = "company-prod-backups-bucket"
  acl    = "public-read-write"
}

# BAD: wide-open bucket policy — Principal "*" with s3:* on the entire bucket.
resource "aws_s3_bucket_policy" "logs_open" {
  bucket = aws_s3_bucket.logs.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::company-prod-logs-bucket",
        "arn:aws:s3:::company-prod-logs-bucket/*"
      ]
    }
  ]
}
EOF
}

# BAD: count for a set of names — should be for_each. Renaming/reordering causes
# index churn and resource recreation.
variable "user_buckets" {
  type    = list(string)
  default = ["alpha", "beta", "gamma"]
}

resource "aws_s3_bucket" "user_buckets" {
  count  = length(var.user_buckets)
  bucket = "user-bucket-${var.user_buckets[count.index]}"
  # BAD: no tags, no encryption, no versioning, no public access block.
}

# BAD: null_resource with timestamp() trigger — runs on every apply (drift noise).
resource "null_resource" "always_runs" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'redeploying everything again...'"
  }
}

# BAD: local-exec with unescaped interpolation of a variable — command injection
# risk if the variable is ever sourced from user input or another module output.
variable "bucket_label" {
  type    = string
  default = "demo bucket"
}

resource "null_resource" "inject_label" {
  provisioner "local-exec" {
    command = "echo ${var.bucket_label} > /tmp/label.txt"
  }
}

# BAD: secret written to disk in plaintext via local-exec, and the secret is
# embedded directly in the command string (will appear in Terraform logs / state).
resource "null_resource" "leak_secret" {
  provisioner "local-exec" {
    command = "echo ${local.admin_password} > /tmp/admin_password.txt && chmod 777 /tmp/admin_password.txt"
  }

  depends_on = [aws_s3_bucket.logs]
}

# BAD: provisioner used to do work that should be a real resource (creating a
# bucket via the AWS CLI rather than aws_s3_bucket).
resource "null_resource" "create_bucket_via_cli" {
  provisioner "local-exec" {
    command = "aws s3 mb s3://shadow-bucket-${local.hardcoded_account_id} --region ${local.hardcoded_region}"
  }
}

# BAD: destroy-time provisioner that rm -rf's a path built from a variable —
# both dangerous and not idempotent.
resource "null_resource" "cleanup" {
  triggers = {
    path = var.bucket_label
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf /tmp/${self.triggers.path}/*"
  }
}

# BAD: bucket relying on a deprecated inline ACL argument, no server-side
# encryption, no versioning, no public access block, mutable tag value via
# timestamp() (causes drift on every plan).
resource "aws_s3_bucket" "legacy" {
  bucket = "legacy-${local.hardcoded_account_id}"
  acl    = "public-read"

  tags = {
    LastSeen = timestamp()
  }
}

# BAD: lifecycle prevent_destroy = false on a "critical" bucket, plus
# force_destroy = true — easy to wipe accidentally.
resource "aws_s3_bucket" "critical" {
  bucket        = "critical-data-bucket"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}
