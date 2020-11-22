variable "event_bus" {
  type = object({
    arn = string
  })
}

resource "aws_sqs_queue" "events" {
  name                       = "EventQueue"
  visibility_timeout_seconds = 120
  receive_wait_time_seconds  = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dl_events.arn
    maxReceiveCount     = 2
  })
}

resource "aws_sqs_queue" "dl_events" {
  name = "EventsDeadLetter"
}

resource "aws_sns_topic_subscription" "service_timetable_updates" {
  topic_arn            = var.event_bus.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.events.arn
  raw_message_delivery = true
}