import json
import urllib.request
import boto3
from datetime import datetime
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('content_history')

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def lambda_handler(event, context):
    print(f"Event: {json.dumps(event)}")
    
    http_method = event.get('requestContext', {}).get('http', {}).get('method', 'GET')
    raw_path = event.get('rawPath', '/')
    
    try:
        # HISTORY endpoint
        if raw_path == '/history' and http_method == 'GET':
            response = table.scan()
            items = response.get('Items', [])
            items.sort(key=lambda x: x.get('timestamp', ''), reverse=True)
            
            history = [{
                'userPrompt': item.get('prompt', ''),
                'aiResponse': item.get('content', ''),
                'timestamp': item.get('timestamp', '')
            } for item in items]
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'success': True,
                    'data': history
                }, default=decimal_default)
            }
        
        # GENERATE endpoint
        elif raw_path == '/generate' and http_method == 'POST':
            body = json.loads(event.get('body', '{}'))
            prompt = body.get('prompt', '').strip()
            
            if not prompt:
                return {
                    'statusCode': 400,
                    'body': json.dumps({
                        'success': False,
                        'error': 'Prompt is required'
                    })
                }
            
            # Call Gemini API
            api_key = 'AIzaSyC_RyVF2RXFEutI23hcEw12Kvp0Uk0zX8E'
            model_name = 'gemini-2.5-flash'
            url = f'https://generativelanguage.googleapis.com/v1beta/models/{model_name}:generateContent?key={api_key}'
            
            payload = json.dumps({
                'contents': [{
                    'parts': [{'text': prompt}]
                }]
            }).encode('utf-8')
            
            req = urllib.request.Request(
                url, 
                data=payload, 
                headers={'Content-Type': 'application/json'}, 
                method='POST'
            )
            
            with urllib.request.urlopen(req, timeout=30) as response:
                result = json.loads(response.read().decode('utf-8'))
                content = result['candidates'][0]['content']['parts'][0]['text']
            
            timestamp = datetime.now().isoformat()
            table.put_item(Item={
                'timestamp': timestamp,
                'prompt': prompt,
                'content': content
            })
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'success': True,
                    'data': {
                        'response': content,
                        'timestamp': timestamp
                    }
                })
            }
        
        # ROOT
        else:
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'success': True,
                    'message': 'API is running',
                    'endpoints': {
                        'generate': 'POST /generate',
                        'history': 'GET /history'
                    }
                })
            }
    
    except Exception as e:
        print(f'Error: {str(e)}')
        return {
            'statusCode': 500,
            'body': json.dumps({
                'success': False,
                'error': str(e)
            })
        }
