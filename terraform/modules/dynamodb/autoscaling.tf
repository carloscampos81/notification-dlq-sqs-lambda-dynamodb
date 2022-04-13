resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
    max_capacity       = var.autoscale_max_read_capacity
    min_capacity       = var.autoscale_min_read_capacity
    resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
    name               = "dynamodb-read-capacity-utilization-${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
    policy_type        = "TargetTrackingScaling"
    resource_id        = "${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
    scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension}"
    service_namespace  = "${aws_appautoscaling_target.dynamodb_table_read_target.service_namespace}"

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "DynamoDBReadCapacityUtilization"
        }
        target_value = 90
    }
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
    max_capacity       = var.autoscale_max_write_capacity
    min_capacity       = var.autoscale_min_write_capacity
    resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
    name               = "dynamodb-write-capacity-utilization-${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
    policy_type        = "TargetTrackingScaling"
    resource_id        = "${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
    scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension}"
    service_namespace  = "${aws_appautoscaling_target.dynamodb_table_write_target.service_namespace}"

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "DynamoDBWriteCapacityUtilization"
        }
        target_value = 90
    }
}