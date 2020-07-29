# -*- coding: utf-8 -*-
"""
Created on Sun Apr  1 19:28:42 2018

@author: Administrator
"""

from selenium import webdriver
import time
import csv

#Simulated browser login
driver = webdriver.Chrome(executable_path='chromedriver.exe')
driver.get("https://www.investing.com/search/?q=crude%20oil&tab=news")
time.sleep(100)

csv_file = open("C:/Users/nihao/Desktop/headlines.csv","w")
writer = csv.writer(csv_file)
writer.writerow(['time','headlines'])

#2213 is the number of news
for i in range(1,2213):
    newstime = driver.find_element_by_xpath('//*[@id="fullColumn"]/div/div[4]/div[3]/div/div['+str(i)+']/div/div/time').text
    headlines = driver.find_element_by_xpath('//*[@id="fullColumn"]/div/div[4]/div[3]/div/div['+str(i)+']/div/a').text
    writer.writerow([newstime,headlines])
    if i%20 ==0:
        js="var q=document.documentElement.scrollTop=100000" 
        driver.execute_script(js)
        time.sleep(4)

csv_file.close()       
driver.close()



