import json
import boto3


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Clickcounter')

def lambda_handler(event, context):
    response = table.get_item(
        Key={
            'visits': '0'  
        }
    )
    
    visitor_count = response['Item'].get('visitor_count', 0)

    response = table.update_item(
        Key={
            'visits': '0'  
        },
        UpdateExpression='SET visitor_count = :val1',
        ExpressionAttributeValues={
            ':val1': visitor_count + 1
        },
        ReturnValues='UPDATED_NEW'
    )

    return response['Attributes']['visitor_count']
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': 'https://resume.bradleybaron.net',
            'Access-Control-Allow-Methods': 'PUT,GET,OPTIONS'
        },
    }
