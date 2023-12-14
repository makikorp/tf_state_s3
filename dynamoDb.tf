resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "tf_state_s3_lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}