resource "aws_iam_user" "ops1" {
    name = "ops1"

    tags = {
        creator = "ops1"
    }
}

#create access key ID and secret key 
resource "aws_iam_access_key" "ops1_access_key" {
  user = aws_iam_user.ops1.name
}

output "access_key_id" {
  value = aws_iam_access_key.ops1_access_key.id
  sensitive = true
}

output "secret_access_key" {
  value = aws_iam_access_key.ops1_access_key.secret
  sensitive = true
}

locals {
  ops1_keys_csv = "access_key,secret_key\n${aws_iam_access_key.ops1_access_key.id},${aws_iam_access_key.ops1_access_key.secret}"
}

resource "local_file" "ops1_keys" {
  content  = local.ops1_keys_csv
  filename = "ops1-keys.csv"
}

resource "aws_iam_group" "operations" {
  name = "operations"
}

resource "aws_iam_group_membership" "operations_membership" {
  name = aws_iam_user.ops1.name
  users = [aws_iam_user.ops1.name]
  group = aws_iam_group.operations.name
}