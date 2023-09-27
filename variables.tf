variable "bucket_region" {
  type        = string
  description = "AWS Region for creating Bucket."
  default     = "eu-central-1"
}

variable "mime_types" {
  type = map(string)
  default = {
    "banner.png"  = "image/png",
    "favicon.ico" = "image/vnd.microsoft.icon",
    "index.html"  = "text/html",
    "logo.png"    = "image/png",
    "logo.svg"    = "image/svg+xml",
    "main.css"    = "text/css",
    "main.js"     = "application/javascript",
  }
}