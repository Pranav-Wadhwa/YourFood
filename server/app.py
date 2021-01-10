# This script creates a Flask server that generates restaurant recommendations using
# review data from Firebase and machine learning libraries.

# Import Libraries

from flask import Flask
from flask import request

import pandas as pd
from rake_nltk import Rake
import re

from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer

from firebase import Firebase
import firebase_admin
from firebase_admin import db
from firebase_admin import credentials

cred = credentials.Certificate(
    "restaurants0-firebase-adminsdk-8jxti-649fc9edb2.json")
firebase_admin.initialize_app(
    cred, {'databaseURL': 'https://restaurants0.firebaseio.com'})

app = Flask(__name__)


def get_data(data_id):
    """
    Retrieves data from Firebase and organizes it into Pandas DataFrames.

    Arguments:
    data_id - the data_id that was passed into the URL as a parameter

    Returns:
    Tuple of DataFrames of local restaurants and visited (favorited) restaurants
    """

    # Retrieves data from Firebase
    ref = db.reference().child(data_id)
    fb_data = ref.get()

    # Creates a dictionary of restaurant IDs and reviews using the string that has
    # restaurants separated by | and individual reviews separated by ;
    local_restaurants = fb_data['local'].split('|')
    local_data = {
        'id': [],
        'review': []
    }
    for restaurant in local_restaurants:
        if not ';' in restaurant:
            local_restaurants.remove(restaurant)
        values = restaurant.split(';')
        local_data['id'].append(values[0])
        if len(values) > 1:
            local_data['review'].append(values[1])
        else:
            local_data['review'].append('')

    # Performs the same action to visited_restaurants
    visited_restaurants = fb_data['visited'].split('|')
    visited_data = {
        'id': [],
        'review': []
    }
    for restaurant in visited_restaurants:
        if not ';' in restaurant:
            visited_restaurants.remove(restaurant)
        values = restaurant.split(';')
        visited_data['id'].append("v" + values[0])
        if len(values) > 1:
            visited_data['review'].append(values[1])
        else:
            visited_data['review'].append('')

    local = pd.DataFrame(local_data)
    visited = pd.DataFrame(visited_data)

    return local, visited


@app.route('/')
def home():
    """
    Defines the home endpoint of the Flask server. Generates recommendations.
    """

    # Use get_data to pull and organize data from Firebase
    local, visited = get_data(request.args.get('dataid'))

    # Combine restaurant data and prepare for RAKE
    restaurant_data = local.append(visited)
    restaurant_data = restaurant_data.reset_index(drop=True)
    restaurant_data['keyWords'] = ""

    # Loop through reviews and add the most popular phrases to the 'keyWords' column
    for index, row in restaurant_data.iterrows():
        reviews = row['review']
        r = Rake()
        r.extract_keywords_from_text(reviews)
        ranked_phrases = r.get_ranked_phrases()

        # Remove phrases that don't contain words
        for phrase in ranked_phrases:
            if re.search('[a-zA-Z]', phrase) == None:
                ranked_phrases.remove(phrase)
        
        # Combine ranked phrases
        restaurant_data.loc[index, 'keyWords'] = " ".join(ranked_phrases)

    # Remove the old reviews column
    restaurant_data.drop(columns=['review'], inplace=True)

    # Text vectorization of keyWords column
    count = CountVectorizer()
    count_matrix = count.fit_transform(restaurant_data['keyWords'])

    # Perform cosine similarity analysis on the count matrix
    cosine_sim = cosine_similarity(count_matrix, count_matrix)

    # Create a dictionary of the local restaurants and their scores
    restaurant_scores = dict()
    for i, row in local.iterrows():
        restaurant_scores[row['id']] = 0

    indices = pd.Series(restaurant_data.index)

    # Loop through the visited restaurants and compare their cosine 
    # similarity results with the local restaurants
    for _, r in visited.iterrows():
        curr_i = -1
        for i in indices:
            if restaurant_data.iloc[i]['id'] == r['id']:
                curr_i = i
                break
        score_series = pd.Series(cosine_sim[curr_i]).sort_values(
            ascending=False).to_dict()
        for score_index in score_series:
            recommended_res_id = restaurant_data.iloc[score_index]['id']
            if recommended_res_id in restaurant_scores:
                restaurant_scores[recommended_res_id] += score_series[score_index]

    # Return the dictionary of scores to the endpoint
    return restaurant_scores


if __name__ == '__main__':
    app.run()
