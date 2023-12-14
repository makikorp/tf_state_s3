terraform {
  backend "s3" {
    bucket                  = "makikorp2"
    dynamodb_table          = "tf_state_s3_lock"
    key                     = "tf_state_s3"
    region                  = "us-west-2"
    shared_credentials_file = "~/.aws/credentials"
  }
}

#resource "aws_s3_bucket" "makikorp2" {
#  bucket = "makikorp2"
#}

# resource "aws_s3_bucket_ownership_controls" "makikorp2" {
#   bucket = aws_s3_bucket.makikorp2.id
#   rule {
#     object_ownership = "BucketOwnerEnforced"
#     #object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "makikorp2" {
#   depends_on = [aws_s3_bucket_ownership_controls.makikorp2]

#   bucket = aws_s3_bucket.makikorp2.id
#   acl    = "private"
# }


# resource "aws_s3_bucket" "makikorp.com" {
#   bucket = "makikorp.com"
#   acl    = "private"

#   tags = {
#     Name = "makikorp.com"
#   }
# }