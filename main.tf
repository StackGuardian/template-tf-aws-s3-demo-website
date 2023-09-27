resource "random_pet" "random" {
  length = 2
}

locals {
  bucket_name = "stackguardian-${random_pet.random.id}"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = local.bucket_name
  force_destroy = true
  tags = {
    "Name"        = "aws_s3_bucket.s3_bucket.id"
    "Description" = "Demo Bucket for hosting the static website"
    "CreatedBy"   = "StackGuardian"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket     = aws_s3_bucket.s3_bucket.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.publicaccess]
}

resource "aws_iam_user" "s3_bucket" {
  name = local.bucket_name
}

resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        ]
      },
      {
        Sid       = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        ]
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.publicaccess]
}

resource "aws_s3_object" "copy_content" {
  for_each = fileset(path.module, "content/**")
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = basename(each.value)  # Set key to the base name of the file
  source   = "${each.value}" # Set source to the local path of the file
  # Determines the content type (MIME type) of the uploaded file.
# Uses var.mime_types to look up the content type based on the file's base name.
# If no match is found, defaults to "application/octet-stream".
  content_type = coalesce(
    lookup(var.mime_types, basename(each.value), null),
    "application/octet-stream"
  )
  depends_on = [ aws_s3_bucket.s3_bucket ]
}
