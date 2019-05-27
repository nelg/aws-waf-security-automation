output "stage_name" {
  value = aws_api_gateway_deployment.ApiGatewayBadBotStage.stage_name
}

output "api_id" {
  value = aws_api_gateway_rest_api.ApiGatewayBadBot.id
}

output "honeypot" {
  description = "API Gateway endpoint for honeypoint"
  value = "Embed a link to: ${aws_api_gateway_deployment.ApiGatewayBadBotStage.invoke_url} in your app"
}

