resource "aws_lambda_function" "func" {
    filename = data.archive_file.zip.output_path
    source_code_hash = data.archive_file.zip.output_base64sha256
    function_name = "func"
    role = aws_iam_role.RoleforLambda.arn
    handler = "func.handler"
    runtime = "python3.10"
}

resource "aws_iam_role" "RoleforLambda"{
    name = "RoleforLambda"
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid":""

    }
  ]
}
    EOF
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {
    name = "aws_iam_policy_for_terraform_resume_project_policy"
    path = "/"
    description = "AWS IAM policy for managing the resume project role"
        policy = jsonencode(
        {
            "Version" : "2012-10-17",
            "Statement" : [
                {
                    "Action" :[
                        "logs:CreateLogGroup",
                        "logs:CreateLogsStream",
                        "logs:PutLogEvents"
                    ],
                    "Resource" : "arn:aws:logs:*:*:*",
                    "Effect" : "Allow"
                },
                {
                    "Effect" : "Allow"
                    "Action" : [
                        "dynamodb:UpdateItem",
                        "dynamodb:GetItem"
                    ],
                    "Resource" : "arn:aws:dynamodb:*:*:table/Resume-Website-Table"
                },
            ]
        })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role = aws_iam_role.RoleforLambda.name
    policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
}

resource "aws_dynamodb_table" "Resume_Website_Table" {
    name = "Resume-Website-Table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "View_Count"

    attribute {
        name = "View_Count"
        type = "S" 
    }


}



data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda/"
    output_path= "${path.module}/packedllambda.zip"
}

resource "aws_lambda_function_url" "url1" {
    function_name = aws_lambda_function.func.function_name
    authorization_type = "NONE"


    cors {
        allow_credentials = true
        allow_origins = ["*"]
        allow_methods= ["*"]
        allow_headers = ["date", "keep-alive"]
        expose_headers = ["keep-alive", "date"]
        max_age = 86400
    }
}

