from urllib import request
import boto3


def test_api_updates_dynamodb():
    # Create a DynamoDB resource
    dynamodb = boto3.resource('dynamodb')

    # Retrieve the Clickcounter table
    table = dynamodb.Table('Clickcounter')

    # Retrieve the initial visitor count from DynamoDB
    response = table.get_item(
        Key={
            'visits': '0'
        }
    )
    visitor_count = response['Item'].get('visitor_count', 0)

    # Make a request to update the API
    response = request.put(
        "https://27rxdqluda.execute-api.us-east-1.amazonaws.com/test/")

    # Check if the request was successful (HTTP status code 200)
    if response.status_code == 200:
        # Retrieve the updated visitor count from DynamoDB
        response = table.get_item(
            Key={
                'visits': '0'
            }
        )
        updated_visitor_count = response['Item'].get('visitor_count', 0)

        # Check if the visitor count was successfully updated
        if updated_visitor_count == visitor_count + 1:
            print("API successfully updated DynamoDB")
        else:
            print("API did not update DynamoDB")
    else:
        print("API request failed")


if __name__ == "__main__":
    test_api_updates_dynamodb()
