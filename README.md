# Avengers: Endgame Twitter Data Analysis

This project analyzes tweets related to Avengers: Endgame, focusing on cleaning, visualizing, and analyzing sentiment around the movie. We use various R packages for data wrangling, visualization, and machine learning to gain insights into Twitter user behavior, popular hashtags, and the most engaged users.

## Project Overview
The project is divided into three main parts:
1. **Data Cleaning**:
   - Duplicate tweets were removed to clean the dataset.
   - Specific columns such as tweet text, retweet count, and favorite count were selected for further analysis.

2. **Data Visualization**:
   - Top retweeted and liked tweets were identified.
   - Visualization of tweet sources, popular hashtags, and top tweeters.

3. **Sentiment Analysis and Topic Modeling**:
   - Basic sentiment analysis using Bing and NRC lexicons.
   - Topic modeling (LDA) was performed with varying topics to identify underlying themes in the data.

## Key Insights
- **Top Hashtags**: #AvengersEndgame was the most popular hashtag.
- **Top Mentions**: Popular accounts like @MarvelStudios and @Avengers generated a lot of mentions.
- **Sentiment**: Overall sentiment towards Avengers: Endgame was highly positive.
- **Topic Modeling**: Key topics included promotions, character discussions, and movie excitement.

## Tools and Libraries Used
- **R**: For data analysis and visualization.
- **tidyverse**: Data manipulation and visualization.
- **tidytext**: Text mining and sentiment analysis.
- **kableExtra**: Displaying data in tables.
- **topicmodels**: Topic modeling using LDA.
- **ggplot2**: Data visualization.

## How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/avengers-twitter-analysis.git
