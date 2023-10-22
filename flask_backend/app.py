from flask import Flask, jsonify, request
from sentence_transformers import SentenceTransformer, util
from flask_cors import CORS  
import xgboost as xgb
import pandas as pd
import time
import spacy
import requests
from bs4 import BeautifulSoup

nlp = spacy.load("en_core_web_sm")

app = Flask(__name__)

CORS(app)  

encoding_model = SentenceTransformer('BAAI/bge-base-en-v1.5')
bst = xgb.Booster()
bst.load_model('XGB_Model4.bst')

chartiy_label_data = pd.read_parquet('Charity_Embeddings.parquet')
charities = chartiy_label_data['Charity'].values
charities_embeddings = chartiy_label_data['Embedding'].values

def search(query, num_results=10):
    base_url = "https://www.google.com/search"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }

    params = {
        "q": query + ' Charity to donate to',
        "count": num_results
    }

    response = requests.get(base_url, headers=headers, params=params)
    soup = BeautifulSoup(response.text, 'html.parser')

    urls = []
    for link in soup.find_all('a'):
        href = link.get('href')
        if href and href.startswith("http"):
            urls.append(href)

    filtered_urls = [url for url in urls if "google" not in url]
    filtered_urls = [url for url in filtered_urls if "facebook" not in url]
    filtered_urls = [url for url in filtered_urls if "wikipedia" not in url]

    domain_names = []
    final_list = []

    for url in filtered_urls:
        split_url = url.split('/')
        if split_url[2] not in domain_names:
            domain_names.append(split_url[2])
            final_list.append(url)
    
    final_string = 'Here are some links to charities surrounding this topic:\n'
    for strings in final_list[:3]:
        final_string += strings + '\n'
    return final_string


def extract_locations(text):
    doc = nlp(text)
    locations = [entity.text for entity in doc.ents if entity.label_ == 'GPE']  # 'GPE' represents geopolitical entity
    return locations

def find_highest_sim_charity(tweet, charities):
    highest = [0, 0]
    for i, charity in enumerate(charities):
        dotScore = util.dot_score(charity, tweet)
        if dotScore > highest[1]:
            highest = [i, dotScore]
    return highest

def get_charity(tweet):
    encoded_tweet = encoding_model.encode(tweet)
    dtest = xgb.DMatrix([encoded_tweet])
    print(bst.predict(dtest))
    isCharity = 1 if bst.predict(dtest) > 0.5 else 0 
    if isCharity == 0:
        return 'No Charity'
    sim = find_highest_sim_charity(encoded_tweet, charities_embeddings)
    highest_charity = charities[sim[0]]
    print(highest_charity)

    locations = extract_locations(tweet)
    for location in locations:
        highest_charity += " " + location
    
    result = search(highest_charity)
    return result

@app.route("/api", methods=["POST"])
def home():
    tweet = request.json.get('text', '')
    output = get_charity(tweet)
    return jsonify({"message": f"{output}"}), 200


if __name__ == '__main__':
    app.run(debug=True)

    
    




