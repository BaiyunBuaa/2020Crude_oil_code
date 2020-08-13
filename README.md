# Text-based crude oil price forecasting

This project contains the Python and R codes for forecasting crude oil price based on news headlines.

![](relationship_code_data.png)

Following the above flowchart, one can complete the basic forecasting steps.
Authors
-------
-   [Yun Bai]
-   [Xixi Li](https://xixili-2.wixsite.com/personal)

Dependency packages
-----------
All codes in this project are written in Python 3.6 and R 3.6.1. Before experiment with the codes, we recommend you to install these two softwares. The dependency packages for Python are listed below:
```python
pip install numpy==1.18.5
pip install pandas==0.25.3
pip install selenium==3.14.1
pip install textblob==0.15.3
pip install scikit-learn==0.21.3
pip install nltk==3.4
pip install Keras==2.2.4
pip install statsmodels==0.11.1
```

Python and R files
---------
- `spider.py`: It is used to obtain future-related news headlines from the website investing.com.
- `Text2vector.py`: This file can transform the texts into vectors with GloVe.
- `senti.py`: It is used to calculate the sentiment intensity of the news headlines.
- `SeaNMF-master/data_preprocess.py`: It is used to preprocess texts for SeaNMF topic model.
- `SeaNMF-master/train.py`: It can train SeaNMF topic model for short texts. After this step, H matrix can be found in `seanmf_results/`.
- `SeaNMF-master/LDA_PMI.py`: This file is used to compare the results of LDA and SeaNMF with the PMI score.
- `preprocess_combine.py`: It is used to combine all the features for forecasting.
- `VAR.R`: In this file, one can judge if a time series is stationary or not, and select the lags for each time series.
- `tsforecast.py`: Feature selection, forecasting model construction, forecasting evaluation are all completed in this file.

References
----------

- Yun Bai, Xixi Li*, Hao Yu and Suling Jia. (2020). Text-based crude oil price forecasting.  [Paper on arxiv](https://arxiv.org/abs/2002.02010).



