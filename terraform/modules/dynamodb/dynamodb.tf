locals {
  name  = "${var.name}_${var.environment}"
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name              = local.name
  billing_mode      = var.billing_mode
  read_capacity     = 5
  write_capacity    = 5
  hash_key          = var.hash_key
  range_key         = var.range_key

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    attribute_name = var.ttl_attribute_name
    enabled        = var.ttl_enable
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
    }
  }

  tags = {
    Name        = local.name
    Environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [tags]
  }
}