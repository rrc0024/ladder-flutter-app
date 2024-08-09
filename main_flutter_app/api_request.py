# import requests
from gradio_client import Client

# gradio_app_link = 'https://huggingface.co/spaces/rrc0024/ladder-gradio-app'

# input_data = {"data": ["Hello, how are you?"]}

client = Client("rrc0024/ladder-gradio-app")
result = client.predict(
    user_input = "What is 2+2",
    api_name = "/predict"
)
print(result)