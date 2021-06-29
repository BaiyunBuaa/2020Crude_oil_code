# -*- coding: utf-8 -*-
"""
Created on Wed May  8 15:57:24 2019

@author: nihao
"""

import pandas as pd
import numpy as np
#import statsmodels.api as sm
from sklearn.preprocessing import MinMaxScaler
from matplotlib.pyplot import MultipleLocator
import matplotlib.pyplot as plt

def time_to_str(timelist):
    strlist = []
    for i in timelist:
        strlist.append(str(i)[:10])
    return strlist

#Converting H matrix of NMF to probability
def H2prob(Hmatrix,news):

    prop_df = pd.DataFrame(columns = ['date','topic1','topic2','topic3','topic4'])
    t1_l,t2_l,t3_l,t4_l,t5_l,t6_l= [],[],[],[],[],[]
    
    for line in f:
        values = str(line).split(' ')
        values = [float(i) for i in values]
        t1_l.append(values[0]/(sum(values))) ## The first entry is the word
        t2_l.append(values[1]/(sum(values)))
        t3_l.append(values[2]/(sum(values)))
        t4_l.append(values[3]/(sum(values)))
#        t5_l.append(values[4]/(sum(values)))
#        t6_l.append(values[5]/(sum(values)))

    f.close()
    prop_df['topic1'] = t1_l
    prop_df['topic2'] = t2_l
    prop_df['topic3'] = t3_l
    prop_df['topic4'] = t4_l
#    prop_df['topic5'] = t5_l
#    prop_df['topic6'] = t6_l

    prop_df['date'] = time_to_str(list(news.iloc[:,0]))
    grouped = prop_df.groupby(['date']).mean()
    grouped.reset_index()
    return grouped

#Data standardization
def mm_transform(df,name):
    mm = MinMaxScaler()
    df['date'] = time_to_str(df['date'].tolist())
    new_grouped = df[['date',name]].groupby('date').mean()
    new_grouped.reset_index()
    array_p = np.array(new_grouped[name]).reshape(-1, 1)
    new_grouped[name]  = mm.fit_transform(array_p)
    new_grouped.dropna(axis = 0)
    return new_grouped

#Make up data, then HP smoothing
def full_hp(df):
    datelist = pd.date_range(df.index[0],df.index[-1],freq='D')
    datelist = time_to_str(datelist)
    #print(len(datelist))
    new_df = pd.DataFrame(columns = df.columns)
    for j in range(len(list(df.columns))):
        fulllist = []
        dl = list(df.index)
        for k in range(len(datelist)):
            if datelist[k] in dl:
                location = dl.index(datelist[k])
                fulllist.append(list(df.iloc[:,j])[location])
            else:
                fulllist.append(0)
        #print(len(fulllist))
        for i in range(len(fulllist)):
            if fulllist[i] == 0:
                fulllist[i] = (fulllist[i-1]+fulllist[i-2]+fulllist[i-3])/3
        
#        cycle, trend = sm.tsa.filters.hpfilter(fulllist, 1600*3**4) #平滑结果是trend
        new_df[list(df.columns)[j]] = fulllist
    return new_df


#visualization
def oil_plot(df):
    plt.figure(figsize=(12, 4))
    plt.grid(ls='--')
    for j in range(len(df.columns)):
        plt.plot(df.iloc[:,j].tolist(),label=df.columns[j])
    
    plt.xlabel('Num of Date')
    plt.legend(loc = 'upper right')
    plt.show()
    

    for j in range(len(df.columns)):
        plt.subplot(6,1,1+j)
        ax=plt.gca()
        y_major_locator=MultipleLocator(1)
        ax.yaxis.set_major_locator(y_major_locator)
        plt.plot(df.iloc[:,j].tolist(),label=df.columns[j])
        plt.legend(loc=2, bbox_to_anchor=(1.0,1.0))
        plt.subplots_adjust(hspace=1.0)
    plt.show()

if __name__ == '__main__':
    root = '/data/202007/'
    f = open(root+'4H.txt','r',encoding='utf-8')
    news = pd.read_excel(root+'new_senti_headlines.xlsx')
    grouped = H2prob(f,news)
    
    oilprice = pd.read_excel(root+'origin_oil.xls')
    
    p_grouped = mm_transform(news,'polarity')
    o_grouped = mm_transform(oilprice,'price')
    
    
    #Data merging
    H = full_hp(grouped)
    P = full_hp(p_grouped)
    O = full_hp(o_grouped)
    
    
    fulldata = pd.concat([H,P,O],axis = 1)
    
    fulldata.to_excel(root+'202007Fulldata_oil_senti.xlsx',index=False)
    oil_plot(fulldata)
