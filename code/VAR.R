library(readxl)
X202007Fulldata <- read_excel("D:/202007Fulldata_oil_senti.xlsx")
topic1 <- X202007Fulldata$topic1
topic2 <- X202007Fulldata$topic2
topic3 <- X202007Fulldata$topic3
topic4 <- X202007Fulldata$topic4
polarity <- X202007Fulldata$polarity
price <- X202007Fulldata$price

# stationary test
library(urca)
urt.topic1 <- ur.df(topic1,type = 'trend',selectlags = 'AIC')
urt.topic2 <- ur.df(topic2,type = 'trend',selectlags = 'AIC')
urt.topic3 <- ur.df(topic3,type = 'trend',selectlags = 'AIC')
urt.topic4 <- ur.df(topic4,type = 'trend',selectlags = 'AIC')
urt.polarity <- ur.df(polarity,type = 'trend',selectlags = 'AIC')
urt.price <- ur.df(price,type = 'trend',selectlags = 'AIC')
summary(urt.topic1)
summary(urt.topic2)
summary(urt.topic3)
summary(urt.topic4)
summary(urt.polarity)
summary(urt.price)
dprice <- diff(price) #one order difference
urt.dprice <- ur.df(dprice,type = 'trend',selectlags = 'AIC')
summary(urt.dprice)

topic1 <- topic1[-1]
topic2 <- topic2[-1]
topic3 <- topic3[-1]
topic4 <- topic4[-1]
polarity <- polarity[-1]

#VAR 
library(vars)
data.t1 <- data.frame(topic1,dprice)
data.t2 <- data.frame(topic2,dprice)
data.t3 <- data.frame(topic3,dprice)
data.t4 <- data.frame(topic4,dprice)
data.po <- data.frame(polarity,dprice)
VARselect(data.t1,lag.max=10,type="const")
VARselect(data.t2,lag.max=10,type="const")
VARselect(data.t3,lag.max=10,type="const")
VARselect(data.t4,lag.max=10,type="const")
VARselect(data.po,lag.max=10,type="const")
VARselect(dprice,lag.max=10,type="const")

#save table
library(writexl)
newdata <- data.frame(topic1,topic2,topic3,topic4,polarity,dprice)
write_xlsx(newdata,"D:/202007_r_fulldata_new.xlsx")
