locals {
  lambda_zip_outputs = "outputs/welcome.zip"
}

data "archive_file" "welcome" {
  type        = "zip"
  source_file = "welcome.py" # o que será incluido dentro do zip
  output_path = local.lambda_zip_outputs
}


resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = local.lambda_zip_outputs
  function_name = "welcome"
  role          = aws_iam_role.lambda_role.arn # vem do arquivo lambda-iam linha 10
  handler       = "welcome.hello"              # nome do arquivo e nome da função

  source_code_hash = data.archive_file.welcome.output_base64sha256

  runtime = "python3.9"

}


