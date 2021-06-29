# -*- coding: utf-8 -*-
"""
Created on Thu Jan 16 22:45:20 2020

@author: nihao
"""
import pandas as pd
import numpy as np
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences


def text_preprocession(Corpus):
    TEXT = Corpus.iloc[:,1]
    # Step - a : Remove blank rows if any.
    TEXT.dropna(inplace=True)
    # Step - b : Change all the text to lower case. This is required as python interprets 'dog' and 'DOG' differently
    TEXT = [entry.lower() for entry in TEXT]
    # Step - c : Tokenization : In this each entry in the corpus will be broken into set of words
    TEXT = [word_tokenize(entry) for entry in TEXT]
    CorpusList = []
    # for entry in enumerate(TEXT):
    for entry in TEXT:
        # Declaring Empty List to store the words that follow the rules for this step
        Final_words = ''
        for word in entry:
            if word not in stopwords.words('english'):
                Final_words = Final_words + word + ' '
        CorpusList.append(Final_words)
    return CorpusList

embeddings_index = {}
f = open('/glove.6B.50d.txt',encoding = 'utf-8')
for line in f:
    values = line.split(' ')
    word = values[0] ## The first entry is the word
    coefs = np.asarray(values[1:], dtype='float32') ## These are the vecotrs representing the embedding for the word
    embeddings_index[word] = coefs
f.close()

print('GloVe data loaded')

dataset = pd.read_excel('/senti_headlines.xlsx')
news_list = text_preprocession(dataset)

MAX_NUM_WORDS = 2000
MAX_SEQUENCE_LENGTH = 50
tokenizer = Tokenizer(num_words=MAX_NUM_WORDS)
tokenizer.fit_on_texts(news_list)
sequences = tokenizer.texts_to_sequences(news_list)

word_index = tokenizer.word_index
print('Found %s unique tokens.' % len(word_index))

data = pad_sequences(sequences, maxlen=MAX_SEQUENCE_LENGTH)

new_data = []
for l in data:
    l = list(l)
    while True:
        l.remove(0)
        if 0 not in l:
            break
    new_data.append(l)

with open('/wedata.txt','w',encoding='utf-8') as f:
    for i in range(len(news_list)):
        f.write(news_list[i]+'\n')
        
with open('/wedoc_term_mat.txt','w',encoding='utf-8') as f:
    for i in range(len(new_data)):
        l = str(new_data[i]).strip('[')
        r = l.strip(']')
        f.write(r+'\n')
