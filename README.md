# YourFood

## ML-Powered recommendations for restaurants.

### About YourFood

I created YourFood for my senior research project at Thomas Jefferson HSST. After seeing the power of machine learning recommendation engines, I aspired to create my own recommendation system for restaurants. YourFood consists of a backend server that creates the recommendations and an iOS companion app that interacts with the user. It works by asking users of restaurants they've enjoyed eating at in the past, pulling reviews for those restaurants as well as local restaurants, and comparing these reviews to predict which of the local restaurants the user might like.

<div align="center">
  <img src="https://pranavwadhwa.com/img/yourfood.43457464.png" width="700px;"/>
</div>

### ML-Powered Server

###### See /server/app.py

The web server is built using Python and Flask as well as Python libraries such as Pandas, scikit-learn, and [rake-nltk](https://pypi.org/project/rake-nltk/). RAKE (Rapid Automatic Keyword Extraction) is a crucial aspect to this as it filters the restaurant reviews of filler words and finds the most important parts of the review. After pulling the review data from Firebase, RAKE processes reviews such as this one:

> This is a good choice for lunch. I had the tortuga sandwich. With roasted pork, smothered with house-made mole, mashed avocado, and cotija cheese. Sure to pair up nicely with their great beer selection. I'll stop by again when I'm in the area. Plus bottled beer to-go is always 40% off... [4 more lines]

The library can extract the most important phrases:

> offering gourmet deli sandwiches plus bottled beer great beer selection expensive beer good selection tortuga sandwich spread campbell roasted pork mashed avocado made mole good choice fairly new cotija cheese always 40 ... picnictime sandwiches wines sure stop smothered pick pair oh nicely meades lunch house

This process makes the comparisons much easier. However, a computer cannot compare text directly. Instead, the review text must be put into a numerical format using text vectorization, which creates a vector for words based on their characteristics (see Machine Learning Text Vectorization in the research paper). 

The final part of the machine learning involves comparing the reviews using a cosine similarity analysis. Once the reviews are converted into a numerical vector, the cosine similarity analysis checks how similar the reviews of one restaurant are to another. Afterwards, the results are compared to see which restaurants are most similar, and those results are returned via the server.

### iOS app

##### See /ios/RestaurantApp/RestaurantApp.xcworkspace

The SwiftUI-based iOS app is used to allow users to pick their favorite restaurants in the past and select the parameters of their search. The app uses the Zomato API, Alamofire, and SwiftyJSON to pull information about restaurants and their reviews (`/Models/ZRestaurants.swift`). It uses the same libraries to make requests to the PythonAnywhere server as well as Firebase to upload data to the server. In addition, the user's favorite restaurants are stored locally using Core Data (`/Views/AddFavView.swift`). Finally, the results are displayed using SwiftUI Lists in `/Views/RecDisplayView.swift`.
