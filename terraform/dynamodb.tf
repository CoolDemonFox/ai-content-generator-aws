resource "aws_dynamodb_table" "history" {
  name           = "${var.project_name}-${var.table_name}-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"  # Free tier friendly
  hash_key       = "promptID"
  range_key      = "timestamp"

  attribute {
    name = "promptID"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  # GSI for querying by timestamp
  global_secondary_index {
    name            = "timestamp-index"
    hash_key        = "timestamp"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "expirationTime"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = false  # Free tier
  }

  tags = {
    Name = "${var.project_name}-history-table"
  }
}
