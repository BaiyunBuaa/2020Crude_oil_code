# -*- coding: utf-8 -*-
"""
Created on Sat May  4 15:57:58 2019

@author: nihao
"""
import pandas as pd
from textblob import TextBlob
import math


#Create two new lists to store polarity scores and subjective scores
polarity_list = []
subject_list = []
raw_data = pd.read_excel('/senti_headlines.xlsx')
for sen in raw_data['headlines']:
    testimonial = TextBlob(sen)
    polarity_list.append(testimonial.sentiment.polarity)
    subject_list.append(testimonial.sentiment.subjectivity)

grouped = raw_data.groupby(['date']).mean()

for i in range(len(raw_data)):
    date = str(raw_data['date'][i])[:10]
    polarity_list[i] = grouped.loc[date,'polarity']
    
cucum_senti = []
for i in range(len(polarity_list)):
    senti = 0
    for j in range(i+1):
        senti += polarity_list[j] * math.exp(-(i-j)/7)
    cucum_senti.append(senti)
        
#Save two scores in Excel
raw_data['polarity'] = cucum_senti

raw_data.to_excel('/new_senti_headlines.xlsx',index = False)
    
