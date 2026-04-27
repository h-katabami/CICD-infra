output "connections" {
  value = {
    for key, conn in aws_codeconnections_connection.this :
    key => {
      arn    = conn.arn
      id     = conn.id
      status = conn.connection_status
    }
  }
}
