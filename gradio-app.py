from openai import OpenAI
import gradio as gr
import os

key = os.getenv('OPENAI_API_KEY')


def chat_with_gpt3(user_input, chat_history=[]):
    # Combine chat history and new user input
    messages = []
    client = OpenAI(
        api_key = key
    )
    for message in chat_history:
        messages.append({"role": "user", "content": message[0]})
        messages.append({"role": "assistant", "content": message[1]})

    messages.append({"role": "user", "content": user_input})

    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=messages
    )

    return response.choices[0].message.content

# Create Gradio interface
iface = gr.Interface(
  fn=chat_with_gpt3,
  inputs="text",
  outputs="text",
  title="GPT-3.5-Turbo Chatbot",
  description="Chat with GPT-3.5-Turbo",
)

print("Launching Gradio interface")
iface.launch(server_name='192.168.1.33', server_port=7861, debug=True)
