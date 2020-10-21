# -*- coding: utf-8 -*-
"""
Created on Fri Apr 26 08:45:53 2019

@author: nihao
"""
import pandas as pd
import numpy as np
import math
import statsmodels.api as sm
from sklearn.preprocessing import MinMaxScaler
from matplotlib.pyplot import MultipleLocator
from sklearn.feature_selection import RFE
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor  
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
from statsmodels.tsa.arima_model import ARIMA
import statsmodels.tsa.stattools as sts
from tqdm import tqdm	
import warnings
warnings.filterwarnings('ignore')

import matplotlib.pyplot as plt

##########################data processing#############################
#Define an offset sequence function
def series_to_supervised(data,n_in=1, n_out=1,dropnan=True):
    '''
    Frame a time series as a supervised learning dataset.
    Arguments:
        data:Observation sequence
        n_in:lag order of (x) input
        n_out:Number of outputs (y)
    Returns:
        DataFrame of series
    '''
    df = pd.DataFrame(data)
    n_vars = 1 if type(data) is list else data.shape[1]
    cols,names = list(),list()
    # input sq(t-n,...,t-1)
    for i in range(n_in,0,-1):
        cols.append(df.shift(i))
        names += [('(t-%d)' % (j+1)) for j in range(n_vars)]
    # forecast sq(t,t+1,..,t+n)
    for i in range(0,n_out):
        cols.append(df.shift(-i))
        if i==0:
            names += [('(t)%d' % (j+1)) for j in range(n_vars)]
        else:
            names += [('(t+%d)' % (j+1)) for j in range(n_vars)]
    # put it all together
    agg = pd.concat(cols,axis=1)
    agg.columns = names
    # drop rows with NaN values
    if dropnan:
        agg.dropna(inplace=True)
    return agg

#Data mosaic function with different features
def concat_feature(lag_dict,wedata):
    j = 1
    frame = []
    for key in lag_dict:
        if len(lag_dict) == 1:
            j = 6
        lag = lag_dict[key]
        ts = wedata[key].tolist()
        feature = series_to_supervised(ts,lag)
        colList = feature.columns
        length = len(colList)
        feature.columns = ['var'+str(j)+'(t-%d)' %(length-1-i) for i in range(length)]
        #print(feature.columns)
        frame.append(feature)
        #print(agg1)
        j+=1
    agg1 = pd.concat(frame,axis=1)
    
    #删除当前时刻的文本特征
    for name in agg1.columns:
        if name != 'var6(t-0)':
            if '(t-0)' in name:
                agg1 = agg1.drop([name],axis=1)
    return agg1

#Function entry of data processing
def main_preprocess(dataframe,lag_dict):
    df = concat_feature(lag_dict,dataset)
    values = df.values
    # ensure all data is float
    values = values.astype('float32')
    #Filling Nan with mean
    numFeat = np.shape(values)[1]
    for i in range(numFeat):
        meanVal = np.mean(values[np.nonzero(~np.isnan(values[:,i]))[0],i]) 
        #values that are not NaN (a number)
        values[np.nonzero(np.isnan(values[:,i]))[0],i] = meanVal 
    
    # split into train and test sets
    size = int(len(values)*2/3)
#    train = values[:size, :]
#    test = values[size:, :]
    train = values[:(len(values)-971), :]
    test = values[971:, :]
    
    # split into input and outputs
    train_2X, train_y = train[:, :-1], train[:, -1]
    test_2X, test_y = test[:, :-1], test[:, -1]
    
    #Data format to be used in RFE model
    ta_X = train_2X*10
    ta_y = (train_y*10).astype('int') 
    te_X = test_2X*10
    real_y = test_y 
    return df,values,ta_X,ta_y,te_X,real_y 
    
#############################RFE feature elimination###############
#Select the most suitable feature according to the given quantity 
def ChooseFeature(num_of_feature,df,X,y):
    rfe = RFE(DecisionTreeRegressor(), num_of_feature)           
    fit = rfe.fit(X, y)
    feature_choose_list = fit.support_
    feature_list = []
    featureList = df.columns
    for i in range(len(feature_choose_list)):
        if feature_choose_list[i] == 1:
            feature_list.append(featureList[i])
    #Selected features
    return feature_choose_list

#Find the training set or test set according to the selected features
def get_data(feature_choose_list,X):
    ixList = []
    new_x = []
    for i in range(len(feature_choose_list)):
        if feature_choose_list[i] == 1:
            ixList.append(i)
            new_x.append(X[:,i])
    new_x = np.array(new_x).T
    return new_x
    
######################Adaboost##############
#define RMSE
# l1-true,l2-false
def RMSE(l1,l2):
    length = len(l1)
    sum = 0
    for i in range(length):
        sum = sum + np.square(l1[i]-l2[i])
    return math.sqrt(sum/length)
#define MAE
def MAE(l1,l2):
    n = len(l1)
    l1 = np.array(l1)
    l2 = np.array(l2)
    mae = sum(np.abs(l1-l2))/n
    return mae
#def MAPE
def MAPE(l1,l2):
    n = len(l1)
    l1 = np.array(l1)
    l2 = np.array(l2)
    for i in range(len(l1)):
        if l1[i] == 0:
            l1[i] = 0.01
    mape = sum(np.abs((l1-l2)/l1))/n
    return mape

def get_feature_num_arimax(values,df,ta_X,ta_y): # using decision tree for arima
    lg = DecisionTreeRegressor()
    
    rmselist = []
    maelist = []
    mapelist = []
    size = int(len(values)*(2/3))
    for i in range(2,len(df.columns)+1):
        fl = ChooseFeature(i,df,ta_X,ta_y)
        XV = get_data(fl,values)
        
        y_pred = []
        Y0 = XV[:,-1]
        result = XV[:,:-1]
        lg.fit(result[:size], Y0[:size])
        for j in tqdm(range(size, len(Y0))):                 
            y_pred.append(lg.predict(result[j, :].reshape((1, -1)))[0])
        rmse = RMSE(list(Y0[size:]),y_pred)
        rmselist.append(rmse)
        mae = MAE(list(Y0[size:]),y_pred)
        maelist.append(mae)
        mape = MAPE(list(Y0[size:]),y_pred)
        mapelist.append(mape)
        
        print('num of feature is {},rmse={},mae={},mape={}'.format(i,rmse,mae,mape))
    
    #plot   
    plt.figure(figsize=(9, 4))
    plt.grid(c='r',ls='--')
    plt.plot(range(len(rmselist)),rmselist,'b',label='rmse')
    plt.plot(range(len(maelist)),maelist,'r',label='mae')
    plt.plot(range(len(mapelist)),mapelist,'g',label='mape')
    plt.title('Evaluating index varying with the number of features')
    plt.xlabel('Num of Features')
    plt.show()  
    
    rmselist = np.array(rmselist)
    maelist = np.array(maelist)
    mapelist = np.array(mapelist)
    newlist = (rmselist+maelist+mapelist)/3
    newlist = list(newlist)
    num = newlist.index(min(newlist))+2
    return ChooseFeature(num,df,ta_X,ta_y)
    
#这里也需要调整
def Regress(model,df,values,ta_X,ta_y):
    rmselist = []
    maelist = []
    mapelist = []
    size = int(len(values)*(2/3))
    
    print('############# step = 1 #################')
    for i in range(2,len(df.columns)+1):
        fl = ChooseFeature(i,df,ta_X,ta_y)
        XV = get_data(fl,values)
        
        y_pred = []
        Y0 = XV[:,-1]
        result = XV[:,:-1]
        model.fit(result[:size], Y0[:size])
        for j in tqdm(range(size, len(Y0))):                    
            y_pred.append(model.predict(result[j, :].reshape((1, -1)))[0])
        rmse = RMSE(list(Y0[size:]),y_pred)
        rmselist.append(rmse)
        mae = MAE(list(Y0[size:]),y_pred)
        maelist.append(mae)
        mape = MAPE(list(Y0[size:]),y_pred)
        mapelist.append(mape)
        print('num of feature is {},rmse={},mae={},mape={}'.format(i,rmse,mae,mape))
    
    #plot    
    plt.figure(figsize=(9, 4))
    plt.grid(c='r',ls='--')
    plt.plot(range(len(rmselist)),rmselist,'b',label='rmse')
    plt.plot(range(len(maelist)),maelist,'r',label='mae')
    plt.plot(range(len(mapelist)),mapelist,'g',label='mape')
    plt.title('Evaluating index varying with the number of features')
    plt.xlabel('Num of Features')
    plt.show() 
    
    rmselist = np.array(rmselist)
    maelist = np.array(maelist)
    mapelist = np.array(mapelist)
    newlist = (rmselist+maelist+mapelist)/3
    newlist = list(newlist)
    index = newlist.index(min(newlist))
    num = index+2
    
    print('step = 0, the rmse, mae and mape are representively:', rmselist[index],maelist[index],mapelist[index])
    
    #save model
    fl = ChooseFeature(num,df,ta_X,ta_y)
    print(fl)
    XV = get_data(fl,values)    
    y_pred_h1, y_pred_h2, y_pred_h3 = [],[],[]   #multi-step forecasting
    Y0 = XV[:,-1]
    result = XV[:,:-1]    
    Model = model.fit(result[:size], Y0[:size])
    
    step = 1
    for j in tqdm(range(size, len(Y0))): 
#        ada.fit(result[:j], Y0[:j])
        y_pred_h1.append(Model.predict(result[j-step, :].reshape((1, -1)))[0])
    
    rmse_h1 = RMSE(list(Y0[size:]),y_pred_h1)
    mae_h1 = MAE(list(Y0[size:]),y_pred_h1)
    mape_h1 = MAPE(list(Y0[size:]),y_pred_h1)
    print('rmse_h1 = ',rmse_h1)
    print('mae_h1 = ', mae_h1)
    print('mape_h1 = ',mape_h1)
    
    print('############# step = 2 #################')
    step = 2
    for j in tqdm(range(size, len(Y0))): 
#        ada.fit(result[:j], Y0[:j])
        y_pred_h2.append(Model.predict(result[j-step, :].reshape((1, -1)))[0])
        
    rmse_h2 = RMSE(list(Y0[size:]),y_pred_h2)
    mae_h2 = MAE(list(Y0[size:]),y_pred_h2)
    mape_h2 = MAPE(list(Y0[size:]),y_pred_h2)
    print('rmse_h2 = ',rmse_h2)
    print('mae_h2 = ', mae_h2)
    print('mape_h2 = ',mape_h2)
        
    print('############# step = 3 #################')
    step = 3
    for j in tqdm(range(size, len(Y0))): 
#        ada.fit(result[:j], Y0[:j])
        y_pred_h3.append(Model.predict(result[j-step, :].reshape((1, -1)))[0])
        
    rmse_h3 = RMSE(list(Y0[size:]),y_pred_h3)
    mae_h3 = MAE(list(Y0[size:]),y_pred_h3)
    mape_h3 = MAPE(list(Y0[size:]),y_pred_h3)
    print('rmse_h3 = ',rmse_h3)
    print('mae_h3 = ', mae_h3)
    print('mape_h3 = ',mape_h3)
        
    #Draw true and predicted values
#    new_y_pred = [None]*(len(Y0)-len(y_pred))+y_pred
#    plt.figure(figsize=(12, 4))
#    plt.grid(c='r',ls='--')
#    plt.plot(Y0,'b',label='real')
#    plt.plot(new_y_pred,'g',label='pre')
#    plt.title('Prediction results')
#    plt.xlabel('date')
#    plt.ylabel('price')
#    plt.show() 
    
    return fl,num,y_pred_h1,y_pred_h2,y_pred_h3

def arima_arimax(lag_dict,df,fl,step):
    lastkey = list(lag_dict.keys())[-1]
    df = df.drop(list(df.columns[-lag_dict[lastkey]-2:-1]),axis=1).dropna()
    print(df.columns)
    test_date = pd.date_range(start='3/29/2011',periods=len(df),freq='D') #日期随便写的
    df['time'] = [str(i)[:10] for i in test_date]
    df = df.set_index(['time'])
    false_list = []
    
    for i in range(len(df.columns)-1):
        if fl[i] == False:
            false_list.append(df.columns[i])
    newdf = df.drop(false_list,axis=1)
    ARIMA_Y = newdf[newdf.columns[-1]]
    newdf = newdf.drop([newdf.columns[-1]],axis=1)
    print(len(newdf))
    
    size = len(newdf)-971
    
    if step == 0:
        arima_y_train,arima_y_test = ARIMA_Y[:size-step],ARIMA_Y[size:]
        print(len(arima_y_test))
        exog_train,exog_test = newdf[:size-step],newdf[size-step:len(newdf)-step] #step=1 
        print(exog_train.shape)
        print(exog_test.shape)
        arimax_index_list,arimax_rmse,arimax_mae,arimax_mape,arima_index_list,arima_rmse,arima_mae,arima_mape = [],[],[],[],[],[],[],[]
        for i in range(1,5):
            for j in range(3):
                for k in range(1,5):
                    arimax = sm.tsa.statespace.SARIMAX(arima_y_train,order=(i,j,k),seasonal_order=(0,0,0,0),exog = exog_train,
                                                       enforce_stationarity=False, enforce_invertibility=False).fit()
                    arima = sm.tsa.statespace.SARIMAX(arima_y_train,order=(i,j,k),seasonal_order=(0,0,0,0),exog = None,
                                                      enforce_stationarity=False, enforce_invertibility=False).fit()
                    
                    arimax_pred = arimax.predict(size-step,size-step-1+971,exog = exog_test,dynamic=True)
                    arimax_index_list.append((i,j,k))
                    arimax_rmse.append(RMSE(arima_y_test,arimax_pred))
                    arimax_mae.append(MAE(arima_y_test,arimax_pred))
                    arimax_mape.append(MAPE(arima_y_test,arimax_pred))
                    
                    arima_pred = arima.predict(size-step,size-step-1+971,exog = None,dynamic=True)
                    arima_index_list.append((i,j,k))
                    arima_rmse.append(RMSE(arima_y_test,arima_pred))
                    arima_mae.append(MAE(arima_y_test,arima_pred))
                    arima_mape.append(MAPE(arima_y_test,arima_pred))
                    
                    print('ARIMAX:',(i,j,k))
        
        arimax_rmse = np.array(arimax_rmse)
        arimax_mae = np.array(arimax_mae)
        arimax_mape = np.array(arimax_mape)            
        newlistx = (arimax_rmse+arimax_mae+arimax_mape)/3 
        newlistx = list(newlistx)
        indexx = newlistx.index(min(newlistx))
        
        arima_rmse = np.array(arima_rmse)
        arima_mae = np.array(arima_mae)
        arima_mape = np.array(arima_mape)
        newlist =(arima_rmse+arima_mae+arima_mape)/3 
        newlist = list(newlist)
        index = newlist.index(min(newlist))
    
        arimax = sm.tsa.statespace.SARIMAX(arima_y_train,order=arimax_index_list[indexx],seasonal_order=(0,0,0,0),exog = exog_train,
                                           enforce_stationarity=False, enforce_invertibility=False).fit()
        arima = sm.tsa.statespace.SARIMAX(arima_y_train,order=arima_index_list[index],seasonal_order=(0,0,0,0),exog = None,
                                          enforce_stationarity=False, enforce_invertibility=False).fit()
        arimax_pred = arimax.predict(size-step,size-step-1+971,exog = exog_test,dynamic=True)
        arima_pred = arima.predict(size-step,size-step-1+971,exog = None,dynamic=True)
        
        return arimax_pred,arimax_rmse[indexx],arimax_mae[indexx],arimax_mape[indexx],arimax_index_list[indexx],arima_pred,arima_rmse[index],arima_mae[index],arima_mape[index],arima_index_list[index]
    
    else:
        arima_y_train,arima_y_test = ARIMA_Y[:size-step],ARIMA_Y[size:]
        print(len(arima_y_test))
        exog_train,exog_test = newdf[:size-step],newdf[size-step:len(newdf)-step] #step=1    
        print(exog_test.shape)
        arimax = sm.tsa.statespace.SARIMAX(arima_y_train,order=(4,1,3),seasonal_order=(0,0,0,0),exog = exog_train,
                                           enforce_stationarity=False, enforce_invertibility=False).fit()
        arima = sm.tsa.statespace.SARIMAX(arima_y_train,order=(4,0,3),seasonal_order=(0,0,0,0),exog = None,
                                          enforce_stationarity=False, enforce_invertibility=False).fit()
        arimax_pred = arimax.predict(size-step,size-step-1+971,exog = exog_test,dynamic=True)
        print(len(arimax_pred))
        arima_pred = arima.predict(size-step,size-step-1+971,exog = None,dynamic=True)
        print(len(arima_pred))
        
        arimax_rmse = RMSE(arima_y_test,arimax_pred)
        arimax_mae = MAE(arima_y_test,arimax_pred)
        arimax_mape = MAPE(arima_y_test,arimax_pred)
        
        arima_rmse = RMSE(arima_y_test,arima_pred)
        arima_mae = MAE(arima_y_test,arima_pred)
        arima_mape = MAPE(arima_y_test,arima_pred)
        
        return arimax_pred,arimax_rmse,arimax_mae,arimax_mape,arima_pred,arima_rmse,arima_mae,arima_mape
    
    
    
    
if __name__ =='__main__':
    
    dataset = pd.read_excel('D:/ByResearch/基于文本的原油油价预测/202007data/oil_r_fulldata.xlsx')
    
    mm = MinMaxScaler()
#    dataset['dDJI']  = mm.fit_transform(np.array(dataset['dDJI']).reshape(-1,1))
#    dataset['dUSDX']  = mm.fit_transform(np.array(dataset['dUSDX']).reshape(-1,1))
#    dataset['dWTI']  = mm.fit_transform(np.array(dataset['dWTI']).reshape(-1,1))
    dataset['dprice']  = mm.fit_transform(np.array(dataset['dprice']).reshape(-1,1))
#    dataset.to_excel('D:/plot_r.xlsx',index=False)
    lag_dict = {'topic1':7,'topic2':7,'topic3':7,'topic4':7,'polarity':7,'dprice':3} 
#    lag_dict = {'dDJI':3,'dUSDX':3,'dWTI':4,'t0pol':3,'t0su':3,'t0pz':3,
#                't0po':3,'t1pol':7,'t1su':7,'t1pz':3,'t1po':3,'dprice':3} 
#    lag_dict = {'dprice': 4}  
    df,values,ta_X,ta_y,te_X,real_y = main_preprocess(dataset,lag_dict)
    
    rfc = RandomForestRegressor()
    svr = SVR(kernel='sigmoid',max_iter=100)
    ada = AdaBoostRegressor(base_estimator = DecisionTreeRegressor(splitter="random",
                                                                   max_depth=1,
                                                                   min_samples_split=3),
                            n_estimators=30,learning_rate=0.01)

    model_list = [ada]

    pre_result = pd.DataFrame()
  
    for model in model_list:
        fl,num,y_pred_h1,y_pred_h2,y_pred_h3 = Regress(model,df,values,ta_X,ta_y) 
        pre_result[str(model)[:3]+'-h1'] = y_pred_h1
        pre_result[str(model)[:3]+'-h2'] = y_pred_h2
        pre_result[str(model)[:3]+'-h3'] = y_pred_h3
        print('feature selected :',fl)
        print('num of feature is {}, features are {}'.format(num, fl))

# for ARIMA
    fl = get_feature_num_arimax(values,df,ta_X,ta_y)
    
    num = 0
    for i in fl:
        if i == True:
            num += 1
    print(num)
##    
    arimax_pred,arimax_rmse,arimax_mae,arimax_mape,arima_pred,arima_rmse,arima_mae,arima_mape = arima_arimax(lag_dict,df,fl,step=1)       
#    arimax_pred,x_rmse,x_mae,x_mape,x_index,arima_pred,rmse,mae,mape,_index = arima_arimax(lag_dict,df,fl,step=1)
    pre_result['arimax_h1'],pre_result['arima_h1'] = list(arimax_pred),list(arima_pred)
#    
#    arimax_pred,arimax_rmse,arimax_mae,arimax_mape,arima_pred,arima_rmse,arima_mae,arima_mape = arima_arimax(lag_dict,df,fl,step=2)
#    pre_result['arimax_h2'],pre_result['arima_h2'] = list(arimax_pred),list(arima_pred)
##    
#    arimax_pred,arimax_rmse,arimax_mae,arimax_mape,arima_pred,arima_rmse,arima_mae,arima_mape = arima_arimax(lag_dict,df,fl,step=3)
#    pre_result['arimax_h3'],pre_result['arima_h3'] = list(arimax_pred),list(arima_pred)
#    
#    pre_result.to_excel('D:/ByResearch/基于文本的原油油价预测/20201019results/gold_result_no_text.xlsx',index=False)
##
##save training data and test data
#train_X = pd.DataFrame(ta_X,columns=df.columns[:-1])  
#train_Y = pd.DataFrame(ta_y,columns=['var6(t-0)'])
#test_X = pd.DataFrame(te_X,columns=df.columns[:-1]) 
#test_Y = pd.DataFrame(real_y,columns=['var6(t-0)'])
#
#train_X.to_excel('D:/train_X.xlsx',index=False)
#train_Y.to_excel('D:/train_Y.xlsx',index=False)
#test_X.to_excel('D:/test_X.xlsx',index=False)
#test_Y.to_excel('D:/test_Y.xlsx',index=False)














