# -*- coding: utf-8 -*-
"""
Created on Sat Jul 11 22:19:01 2020

@author: nihao
"""
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')  # To ignore all warnings that arise here to enhance clarity

from gensim.models.coherencemodel import CoherenceModel
from gensim.models.ldamodel import LdaModel
from gensim.corpora.dictionary import Dictionary

def get_train(path1):
    f = open(path1)
    lines = f.readlines()  #lines在这里是一个list
    return lines 

def main():
    docs = get_train('/data/wedata.txt')
    docs = [s.strip().split() for s in docs]
    
    # Create a dictionary representation of the documents.
    dictionary = Dictionary(docs)
    dictionary.filter_extremes(no_below=10, no_above=0.2)
    corpus = [dictionary.doc2bow(doc) for doc in docs]
        
    # Make a index to word dictionary.
    temp = dictionary[0]  # only to "load" the dictionary.
    id2word = dictionary.id2token
    
    PMI = []
    for i in range(2,11):   
        print(i)
        lda_model = LdaModel(corpus=corpus, id2word=id2word,
                             iterations=100, num_topics=i)
        # Print the Keyword in the 5 topics
        print(lda_model.print_topics())
        
        coherence_model_lda = CoherenceModel(model=lda_model, texts=docs, dictionary=dictionary, coherence='c_uci')
        coherence_lda = coherence_model_lda.get_coherence()
        print('\nCoherence Score: ', coherence_lda)
        del lda_model
        PMI.append(coherence_lda)
    print(PMI)

if __name__ == '__main__':
    main()
