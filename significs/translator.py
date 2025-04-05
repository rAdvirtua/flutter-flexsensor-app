import os
import google.generativeai as genai
from dotenv import load_dotenv
from gtts import gTTS
import vlc
load_dotenv()
gemkey = os.getenv('API_KEY')
genai.configure(api_key=gemkey)

# Create the model
generation_config = {
  "temperature": 1,
  "top_p": 0.95,
  "top_k": 40,
  "max_output_tokens": 8192,
  "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
  model_name="gemini-1.5-flash",
  generation_config=generation_config,
  system_instruction="you are a translator for an scientist who can only write what he wants to say in english, he wants to present to an audience who speaks bengali and hindi please translate what he writes to you in both hindi and bengali\n",
)

chat_session = model.start_chat(
  history=[
    {
      "role": "user",
      "parts": [
        "Hello I am Dr Samual Raylington\n",
      ],
    },
    {
      "role": "model",
      "parts": [
        "Bengali:  নমস্কার, আমি ডক্টর স্যামুয়েল রেলিংটন। (Nomoskar, ami Doctor  Samuel Raylington.)\n\n Hindi: नमस्कार, मैं डॉक्टर सैमुअल रेयलिंगटन हूँ। (Namaste, main Doctor Samuel Raylington hun.)\n\n\n",
      ],
    },
    {
      "role": "user",
      "parts": [
        "I am here to talk about quantum computers and hadamard gate\n",
      ],
    },
    {
      "role": "model",
      "parts": [
        "Bengali: আমি এখানে কোয়ান্টাম কম্পিউটার এবং হাডামার্ড গেট নিয়ে আলোচনা করতে এসেছি। (Ami ekhane quantum computer ebong Hadamard gate niye alochona korte eshechi.)\n\n Hindi: मैं यहाँ क्वांटम कंप्यूटर और हैडमार्ड गेट के बारे में बात करने आया हूँ। (Main yahan quantum computer aur Hadamard gate ke bare mein baat karne aaya hun.)\n",
      ],
    },
  ]
)
message=""
while message!="exit":
  message=input("enter your message :")

  response = chat_session.send_message(message)

  print(response)
  tts = gTTS(response.text,lang='en',tld='co.in')
  tts.save('hello.mp3')
  p = vlc.MediaPlayer("hello.mp3")
  p.play()