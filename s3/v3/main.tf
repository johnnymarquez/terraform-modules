resource "aws_s3_bucket" "s3" {
    bucket                      = var.bucket
    hosted_zone_id              = var.hosted_zone_id
    object_lock_enabled         = var.object_lock_enabled
    tags                        = var.tags_all
    tags_all                    = var.tags_all

    logging {
        target_bucket = var.target_bucket
    }
     
    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = false

            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_s3_bucket_versioning" "s3" {
    bucket = aws_s3_bucket.s3.id
    versioning_configuration {
        status = var.versioning_configuration
    }
}

resource "aws_s3_bucket_request_payment_configuration" "s3" {
    bucket = aws_s3_bucket.s3.id
    payer  = "BucketOwner"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3.arn
}


resource "aws_s3_bucket_notification" "s3" {
    bucket      = aws_s3_bucket.s3.id
    eventbridge = var.eventbridge

    lambda_function {
        events              = [
            "s3:ReducedRedundancyLostObject",
            ]
        filter_prefix       = var.filter_prefix
        lambda_function_arn = var.lambda_function_arn

    }
    depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
    bucket = aws_s3_bucket.s3.id
    policy = jsonencode(
            {
            Id        = "AllowSSLRequestsOnly-${aws_s3_bucket.s3.id}"
            Statement = [
                {
                    Action    = "s3:*"
                    Condition = {
                        Bool = {
                            "aws:SecureTransport" = "false"
                        }
                    }
                    Effect    = "Deny"
                    Principal = "*"
                    Resource  = [
                        "arn:aws:s3:::${aws_s3_bucket.s3.id}",
                        "arn:aws:s3:::${aws_s3_bucket.s3.id}/*",
                        ]
                    Sid       = "AllowSSLRequestsOnly"
                    },
                ]
            Version   = "2012-10-17"
            }
    )
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "s3" {
#     bucket = aws_s3_bucket.s3.id
#     rule {
#         bucket_key_enabled = false

#         apply_server_side_encryption_by_default {
#             sse_algorithm = "AES256"
#             }
#         }
#     }

# resource "aws_s3_bucket_logging" "s3" {
#     bucket        = aws_s3_bucket.s3.id
#     target_bucket = var.target_bucket
#     target_prefix = var.target_prefix
#     }

# resource "aws_s3_bucket_lifecycle_configuration" "s3" {
#     bucket = aws_s3_bucket.s3.id
#     rule {
#         id     = "SecurityHub"
#         status = "Enabled"

#         #abort_incomplete_multipart_upload {
#         #    days_after_initiation = 30
#         #    }

#         expiration {
#             days                         = 30
#             expired_object_delete_marker = false
#             }

#         #filter {
#         #    }

#         #noncurrent_version_expiration {
#         #    noncurrent_days = 30
#         #    }
#         }
#     }


