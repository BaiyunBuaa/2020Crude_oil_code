new_data<-read_excel("D:/plot_r.xlsx")
length(new_data$topic1)

date <- seq.Date(from = as.Date("2011/04/04",format = "%Y/%m/%d"), by = "day", length.out = length(new_data$topic1))
library(ggplot2)
topic1 <- new_data$topic1
topic2 <- new_data$to?ic2
topic3 <- new_data$topic3
topic4 <- new_data$topic4
polarity <- new_data$polarity
dprice <- new_data$dprice
plot.t1 <- ggplot(new_data,aes(date,topic1)) + geom_line()
plot.t2 <- ggplot(new_data,aes(date,topic2)) + geom_line()
plot.t3 <- ggplot(new_data?aes(date,topic3)) + geom_line()
plot.t4 <- ggplot(new_data,aes(date,topic4)) + geom_line()
plot.polarity <- ggplot(new_data,aes(date,polarity)) + geom_line()
plot.dprice <- ggplot(new_data,aes(date,dprice)) + geom_line()

library(cowplot)
library(showtext)?
plot_grid(plot.t1, plot.t2, plot.t3, plot.t4, 
          plot.polarity, plot.dprice,
          nrow = 6, align = "v")

#LDA和seanmf对比
sea <- c(-0.0281,0.3781,0.5483,0.4497,0.5365,0.5431,0.4202,0.4774,0.4296)
lda <- c(-0.1982,0.2020,0.2681,0.2088,0.2861,0.2941,0.2211,0.2789,0.2347)
x <- c(2,3,4,5,6,7,8,9,10)
topic_data <- data.frame(x,lda,sea)

ggplot(topic_data)+
  geom_point(aes(x,lda,color="LDA"),shape=15)+
  geom_point(aes(x,sea,color="SeaNMF"),shape=16)+
  geom_line(aes(x=x,y=lda,color="LDA"))+?  geom_line(aes(x=x,y=sea,color="SeaNMF"))+
  labs(x="Number of topics(k)",y="PMI",color = 'Topic Model')+
  scale_color_manual(values = c("LDA" = "black","SeaNMF" = "blue"))


rf1x <- c('no text','textblob','our method')
rf1x <- factor?rf1x,levels=c('no text','textblob','our method'))
rf1rmse <- c(0.0743,0.0614,0.0614)
rf1mae <- c(0.0553,0.0451,0.0449)
rf1mape <- c(0.1028,0.0858,0.0848)
rf1frame <- data.frame(rf1x,rf1rmse,rf1mae,rf1mape)
rf1 <- ggplot(rf1frame)+
  geom_point(aes(rf1x,rf1?mse,color="rmse"),size=2)+
  geom_point(aes(rf1x,rf1mae,color="mae"),size=2)+
  geom_point(aes(rf1x,rf1mape,color="mape"),size=2)+
  geom_line(aes(rf1x,rf1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf1x,rf1mae,color="mae",group = 1),linety?e = 2)+
  geom_line(aes(rf1x,rf1mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

rf2x <- c('no text','textblob','our method')
rf2x?<- factor(rf2x,levels=c('no text','textblob','our method'))
rf2rmse <- c(0.0731,0.0632,0.0632)
rf2mae <- c(0.0546,0.0477,0.0412)
rf2mape <- c(0.1022,0.0893,0.0887)
rf2frame <- data.frame(rf2x,rf2rmse,rf2mae,rf2mape)
rf2 <- ggplot(rf2frame)+
  geom_point(ae?(rf2x,rf2rmse,color="rmse"),size=2)+
  geom_point(aes(rf2x,rf2mae,color="mae"),size=2)+
  geom_point(aes(rf2x,rf2mape,color="mape"),size=2)+
  geom_line(aes(rf2x,rf2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf2x,rf2mae,color="mae",group =?1),linetype = 2)+
  geom_line(aes(rf2x,rf2mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

rf3x <- c('no text','textblob','our met?od')
rf3x <- factor(rf3x,levels=c('no text','textblob','our method'))
rf3rmse <- c(0.0748,0.0653,0.0641)
rf3mae <- c(0.0566,0.0492,0.0471)
rf3mape <- c(0.1053,0.0927,0.0890)
rf3frame <- data.frame(rf3x,rf3rmse,rf3mae,rf3mape)
rf3 <- ggplot(rf3frame)+
  geo?_point(aes(rf3x,rf3rmse,color="rmse"),size=2)+
  geom_point(aes(rf3x,rf3mae,color="mae"),size=2)+
  geom_point(aes(rf3x,rf3mape,color="mape"),size=2)+
  geom_line(aes(rf3x,rf3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf3x,rf3mae,color="ma?",group = 1),linetype = 2)+
  geom_line(aes(rf3x,rf3mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

svr1x <- c('svr- Li','no text?,'textblob','our method')
svr1x <- factor(svr1x,levels=c('svr- Li','no text','textblob','our method'))
svr1rmse <- c(0.1135,0.1110,0.0563,0.0564)
svr1mae <- c(0.0956,0.0999,0.0396,0.0393)
svr1mape <- c(0.2860,0.1764,0.0748,0.0744)
svr1frame <- data.frame(s?r1x,svr1rmse,svr1mae,svr1mape)
svr1 <- ggplot(svr1frame)+
  geom_point(aes(svr1x,svr1rmse,color="rmse"),size=2)+
  geom_point(aes(svr1x,svr1mae,color="mae"),size=2)+
  geom_point(aes(svr1x,svr1mape,color="mape"),size=2)+
  geom_line(aes(svr1x,svr1rmse,colo?="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr1x,svr1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr1x,svr1mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c(?rmse" = "black","mae" = "blue","mape"="red"))

svr2x <- c('svr- Li','no text','textblob','our method')
svr2x <- factor(svr2x,levels=c('svr- Li','no text','textblob','our method'))
svr2rmse <- c(0.1133,0.1111,0.0571,0.0577)
svr2mae <- c(0.0948,0.1001,0.0407?0.0416)
svr2mape <- c(0.2844,0.1765,0.0776,0.0784)
svr2frame <- data.frame(svr2x,svr2rmse,svr2mae,svr2mape)
svr2 <- ggplot(svr2frame)+
  geom_point(aes(svr2x,svr2rmse,color="rmse"),size=2)+
  geom_point(aes(svr2x,svr2mae,color="mae"),size=2)+
  geom_point(?es(svr2x,svr2mape,color="mape"),size=2)+
  geom_line(aes(svr2x,svr2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr2x,svr2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr2x,svr2mape,color="mape",group = 1),linetype = 4)+
  labs(?itle="svr  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

svr3x <- c('svr- Li','no text','textblob','our method')
svr3x <- factor(svr3x,levels=c('svr- Li','no text','textblob','our method'))?svr3rmse <- c(0.1173,0.1116,0.0581,0.0581)
svr3mae <- c(0.0974,0.1000,0.0420,0.0418)
svr3mape <- c(0.2950,0.1761,0.0792,0.0794)
svr3frame <- data.frame(svr3x,svr3rmse,svr3mae,svr3mape)
svr3 <- ggplot(svr3frame)+
  geom_point(aes(svr3x,svr3rmse,color="rmse"?,size=2)+
  geom_point(aes(svr3x,svr3mae,color="mae"),size=2)+
  geom_point(aes(svr3x,svr3mape,color="mape"),size=2)+
  geom_line(aes(svr3x,svr3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr3x,svr3mae,color="mae",group = 1),linetype = 2)+
? geom_line(aes(svr3x,svr3mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima1x <- c('no text','textblob','our method')
arima1x?<- factor(arima1x,levels=c('no text','textblob','our method'))
arima1rmse <- c(0.0565,0.0573,0.0565)
arima1mae <- c(0.0394,0.0409,0.0395)
arima1mape <- c(0.0850,0.0772,0.0750)
arima1frame <- data.frame(arima1x,arima1rmse,arima1mae,arima1mape)
arima1 <- ggp?ot(arima1frame)+
  geom_point(aes(arima1x,arima1rmse,color="rmse"),size=2)+
  geom_point(aes(arima1x,arima1mae,color="mae"),size=2)+
  geom_point(aes(arima1x,arima1mape,color="mape"),size=2)+
  geom_line(aes(arima1x,arima1rmse,color="rmse",group = 1),linet?pe = 5)+
  geom_line(aes(arima1x,arima1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(arima1x,arima1mape,color="mape",group = 1),linetype = 4)+
  labs(title="arima  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black?,"mae" = "blue","mape"="red"))

arima2x <- c('no text','textblob','our method')
arima2x <- factor(arima2x,levels=c('no text','textblob','our method'))
arima2rmse <- c(0.0565,0.0565,0.0565)
arima2mae <- c(0.0398,0.0398,0.0394)
arima2mape <- c(0.0752,0.0752,?.0751)
arima2frame <- data.frame(arima2x,arima2rmse,arima2mae,arima2mape)
arima2 <- ggplot(arima2frame)+
  geom_point(aes(arima2x,arima2rmse,color="rmse"),size=2)+
  geom_point(aes(arima2x,arima2mae,color="mae"),size=2)+
  geom_point(aes(arima2x,arima2mape?color="mape"),size=2)+
  geom_line(aes(arima2x,arima2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima2x,arima2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(arima2x,arima2mape,color="mape",group = 1),linetype = 4)+
  labs(title=?arima  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima3x <- c('no text','textblob','our method')
arima3x <- factor(arima3x,levels=c('no text','textblob','our method'))
arima3rmse <- c(0?0565,0.0566,0.0564)
arima3mae <- c(0.0394,0.0396,0.0394)
arima3mape <- c(0.0750,0.0753,0.0749)
arima3frame <- data.frame(arima3x,arima3rmse,arima3mae,arima3mape)
arima3 <- ggplot(arima3frame)+
  geom_point(aes(arima3x,arima3rmse,color="rmse"),size=2)+
  ge?m_point(aes(arima3x,arima3mae,color="mae"),size=2)+
  geom_point(aes(arima3x,arima3mape,color="mape"),size=2)+
  geom_line(aes(arima3x,arima3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima3x,arima3mae,color="mae",group = 1),linetype = 2)+?  geom_line(aes(arima3x,arima3mape,color="mape",group = 1),linetype = 4)+
  labs(title="arima  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada1x <- c('no text','textblob','our method')
ad?1x <- factor(ada1x,levels=c('no text','textblob','our method'))
ada1rmse <- c(0.0572,0.0560,0.0559)
ada1mae <- c(0.0398,0.0390,0.0389)
ada1mape <- c(0.0753,0.0737,0.0737)
ada1frame <- data.frame(ada1x,ada1rmse,ada1mae,ada1mape)
ada1 <- ggplot(ada1frame)+
 ?geom_point(aes(ada1x,ada1rmse,color="rmse"),size=2)+
  geom_point(aes(ada1x,ada1mae,color="mae"),size=2)+
  geom_point(aes(ada1x,ada1mape,color="mape"),size=2)+
  geom_line(aes(ada1x,ada1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada1x,ada?mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ada1x,ada1mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada2x <- c('?o text','textblob','our method')
ada2x <- factor(ada2x,levels=c('no text','textblob','our method'))
ada2rmse <- c(0.0566,0.0565,0.0563)
ada2mae <- c(0.0398,0.0398,0.0394)
ada2mape <- c(0.0752,0.0752,0.0751)
ada2frame <- data.frame(ada2x,ada2rmse,ada2mae,ad?2mape)
ada2 <- ggplot(ada2frame)+
  geom_point(aes(ada2x,ada2rmse,color="rmse"),size=2)+
  geom_point(aes(ada2x,ada2mae,color="mae"),size=2)+
  geom_point(aes(ada2x,ada2mape,color="mape"),size=2)+
  geom_line(aes(ada2x,ada2rmse,color="rmse",group = 1),line?ype = 5)+
  geom_line(aes(ada2x,ada2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ada2x,ada2mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" =?"blue","mape"="red"))

ada3x <- c('no text','textblob','our method')
ada3x <- factor(ada3x,levels=c('no text','textblob','our method'))
ada3rmse <- c(0.0577,0.0563,0.0565)
ada3mae <- c(0.0415,0.0395,0.0397)
ada3mape <- c(0.0785,0.0749,0.0751)
ada3frame <- ?ata.frame(ada3x,ada3rmse,ada3mae,ada3mape)
ada3 <- ggplot(ada3frame)+
  geom_point(aes(ada3x,ada3rmse,color="rmse"),size=2)+
  geom_point(aes(ada3x,ada3mae,color="mae"),size=2)+
  geom_point(aes(ada3x,ada3mape,color="mape"),size=2)+
  geom_line(aes(ada3x,a?a3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada3x,ada3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ada3x,ada3mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual?values = c("rmse" = "black","mae" = "blue","mape"="red"))

library(cowplot)
library(showtext)
plot_grid(rf1,rf2,rf3,svr1,svr2,svr3,arima1,arima2,arima3,ada1,ada2,ada3,
          nrow = 4, ncol=3, align = "v")

#天然气
rf1x <- c('no text','our method')
rf1x?<- factor(rf1x,levels=c('no text','our method'))
rf1rmse <- c(0.0642,0.0583)
rf1mae <- c(0.0407,0.0373)
rf1mape <- c(0.1236,0.1057)
rf1frame <- data.frame(rf1x,rf1rmse,rf1mae,rf1mape)
rf1 <- ggplot(rf1frame)+
  geom_point(aes(rf1x,rf1rmse,color="rmse"),siz?=2)+
  geom_point(aes(rf1x,rf1mae,color="mae"),size=2)+
  geom_point(aes(rf1x,rf1mape,color="mape"),size=2)+
  geom_line(aes(rf1x,rf1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf1x,rf1mae,color="mae",group = 1),linetype = 2)+
  geom_line(a?s(rf1x,rf1mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

rf2x <- c('no text','our method')
rf2x <- factor(rf2x,levels=c('no text?,'our method'))
rf2rmse <- c(0.0644,0.0614)
rf2mae <- c(0.0425,0.0388)
rf2mape <- c(0.1340,0.1246)
rf2frame <- data.frame(rf2x,rf2rmse,rf2mae,rf2mape)
rf2 <- ggplot(rf2frame)+
  geom_point(aes(rf2x,rf2rmse,color="rmse"),size=2)+
  geom_point(aes(rf2x,rf2ma?,color="mae"),size=2)+
  geom_point(aes(rf2x,rf2mape,color="mape"),size=2)+
  geom_line(aes(rf2x,rf2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf2x,rf2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(rf2x,rf2mape,color="mape",grou? = 1),linetype = 4)+
  labs(title="rf  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

rf3x <- c('no text','our method')
rf3x <- factor(rf3x,levels=c('no text','our method'))
rf3rmse <- c(0.0?62,0.0633)
rf3mae <- c(0.0435,0.0408)
rf3mape <- c(0.1340,0.1291)
rf3frame <- data.frame(rf3x,rf3rmse,rf3mae,rf3mape)
rf3 <- ggplot(rf3frame)+
  geom_point(aes(rf3x,rf3rmse,color="rmse"),size=2)+
  geom_point(aes(rf3x,rf3mae,color="mae"),size=2)+
  geom_po?nt(aes(rf3x,rf3mape,color="mape"),size=2)+
  geom_line(aes(rf3x,rf3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf3x,rf3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(rf3x,rf3mape,color="mape",group = 1),linetype = 4)+
  labs(titl?="rf  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

svr1x <- c('no text','our method')
svr1x <- factor(svr1x,levels=c('no text','our method'))
svr1rmse <- c(0.0581,0.0582)
svr1mae <- c(0.03?3,0.0348)
svr1mape <- c(0.1262,0.1220)
svr1frame <- data.frame(svr1x,svr1rmse,svr1mae,svr1mape)
svr1 <- ggplot(svr1frame)+
  geom_point(aes(svr1x,svr1rmse,color="rmse"),size=2)+
  geom_point(aes(svr1x,svr1mae,color="mae"),size=2)+
  geom_point(aes(svr1x,sv?1mape,color="mape"),size=2)+
  geom_line(aes(svr1x,svr1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr1x,svr1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr1x,svr1mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  ?h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

svr2x <- c('no text','our method')
svr2x <- factor(svr2x,levels=c('no text','our method'))
svr2rmse <- c(0.0584,0.0582)
svr2mae <- c(0.0352,0.03?9)
svr2mape <- c(0.1230,0.1223)
svr2frame <- data.frame(svr2x,svr2rmse,svr2mae,svr2mape)
svr2 <- ggplot(svr2frame)+
  geom_point(aes(svr2x,svr2rmse,color="rmse"),size=2)+
  geom_point(aes(svr2x,svr2mae,color="mae"),size=2)+
  geom_point(aes(svr2x,svr2mape,?olor="mape"),size=2)+
  geom_line(aes(svr2x,svr2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr2x,svr2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr2x,svr2mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=2)",?olor = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

svr3x <- c('no text','our method')
svr3x <- factor(svr3x,levels=c('no text','our method'))
svr3rmse <- c(0.0592,0.0580)
svr3mae <- c(0.0357,0.0347)
svr?mape <- c(0.1237,0.1226)
svr3frame <- data.frame(svr3x,svr3rmse,svr3mae,svr3mape)
svr3 <- ggplot(svr3frame)+
  geom_point(aes(svr3x,svr3rmse,color="rmse"),size=2)+
  geom_point(aes(svr3x,svr3mae,color="mae"),size=2)+
  geom_point(aes(svr3x,svr3mape,color="?ape"),size=2)+
  geom_line(aes(svr3x,svr3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr3x,svr3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr3x,svr3mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=3)",color =?' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima1x <- c('no text','our method')
arima1x <- factor(arima1x,levels=c('no text','our method'))
arima1rmse <- c(0.0581,0.0587)
arima1mae <- c(0.0348,0.0352)
?rima1mape <- c(0.1224,0.1238)
arima1frame <- data.frame(arima1x,arima1rmse,arima1mae,arima1mape)
arima1 <- ggplot(arima1frame)+
  geom_point(aes(arima1x,arima1rmse,color="rmse"),size=2)+
  geom_point(aes(arima1x,arima1mae,color="mae"),size=2)+
  geom_point?aes(arima1x,arima1mape,color="mape"),size=2)+
  geom_line(aes(arima1x,arima1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima1x,arima1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(arima1x,arima1mape,color="mape",group = 1),linet?pe = 4)+
  labs(title="arima  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima2x <- c('no text','our method')
arima2x <- factor(arima2x,levels=c('no text','our method'))
arima2rmse <- c(?.0581,0.0581)
arima2mae <- c(0.0348,0.0347)
arima2mape <- c(0.1223,0.1226)
arima2frame <- data.frame(arima2x,arima2rmse,arima2mae,arima2mape)
arima2 <- ggplot(arima2frame)+
  geom_point(aes(arima2x,arima2rmse,color="rmse"),size=2)+
  geom_point(aes(arima2x?arima2mae,color="mae"),size=2)+
  geom_point(aes(arima2x,arima2mape,color="mape"),size=2)+
  geom_line(aes(arima2x,arima2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima2x,arima2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ari?a2x,arima2mape,color="mape",group = 1),linetype = 4)+
  labs(title="arima  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima3x <- c('no text','our method')
arima3x <- factor(arima3x,level?=c('no text','our method'))
arima3rmse <- c(0.0581,0.0585)
arima3mae <- c(0.0348,0.0353)
arima3mape <- c(0.1223,0.1232)
arima3frame <- data.frame(arima3x,arima3rmse,arima3mae,arima3mape)
arima3 <- ggplot(arima3frame)+
  geom_point(aes(arima3x,arima3rmse,co?or="rmse"),size=2)+
  geom_point(aes(arima3x,arima3mae,color="mae"),size=2)+
  geom_point(aes(arima3x,arima3mape,color="mape"),size=2)+
  geom_line(aes(arima3x,arima3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima3x,arima3mae,color="mae",?roup = 1),linetype = 2)+
  geom_line(aes(arima3x,arima3mape,color="mape",group = 1),linetype = 4)+
  labs(title="arima  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada1x <- c('no text','o?r method')
ada1x <- factor(ada1x,levels=c('no text','our method'))
ada1rmse <- c(0.0578,0.0566)
ada1mae <- c(0.0343,0.0342)
ada1mape <- c(0.1159,0.0855)
ada1frame <- data.frame(ada1x,ada1rmse,ada1mae,ada1mape)
ada1 <- ggplot(ada1frame)+
  geom_point(aes(ad?1x,ada1rmse,color="rmse"),size=2)+
  geom_point(aes(ada1x,ada1mae,color="mae"),size=2)+
  geom_point(aes(ada1x,ada1mape,color="mape"),size=2)+
  geom_line(aes(ada1x,ada1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada1x,ada1mae,color="mae",g?oup = 1),linetype = 2)+
  geom_line(aes(ada1x,ada1mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada2x <- c('no text','our meth?d')
ada2x <- factor(ada2x,levels=c('no text','our method'))
ada2rmse <- c(0.0592,0.0583)
ada2mae <- c(0.0358,0.0349)
ada2mape <- c(0.1238,0.1220)
ada2frame <- data.frame(ada2x,ada2rmse,ada2mae,ada2mape)
ada2 <- ggplot(ada2frame)+
  geom_point(aes(ada2x,ada?rmse,color="rmse"),size=2)+
  geom_point(aes(ada2x,ada2mae,color="mae"),size=2)+
  geom_point(aes(ada2x,ada2mape,color="mape"),size=2)+
  geom_line(aes(ada2x,ada2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada2x,ada2mae,color="mae",group = ?),linetype = 2)+
  geom_line(aes(ada2x,ada2mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada3x <- c('no text','our method')
ad?3x <- factor(ada3x,levels=c('no text','our method'))
ada3rmse <- c(0.0593,0.0582)
ada3mae <- c(0.0361,0.0347)
ada3mape <- c(0.1245,0.1233)
ada3frame <- data.frame(ada3x,ada3rmse,ada3mae,ada3mape)
ada3 <- ggplot(ada3frame)+
  geom_point(aes(ada3x,ada3rmse,c?lor="rmse"),size=2)+
  geom_point(aes(ada3x,ada3mae,color="mae"),size=2)+
  geom_point(aes(ada3x,ada3mape,color="mape"),size=2)+
  geom_line(aes(ada3x,ada3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada3x,ada3mae,color="mae",group = 1),line?ype = 2)+
  geom_line(aes(ada3x,ada3mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

library(cowplot)
library(showtext)
plot_grid?rf1,rf2,rf3,svr1,svr2,svr3,arima1,arima2,arima3,ada1,ada2,ada3,
          nrow = 4, ncol=3, align = "v")

#黄金
rf1x <- c('no text','our method')
rf1x <- factor(rf1x,levels=c('no text','our method'))
rf1rmse <- c(0.0567,0.0468)
rf1mae <- c(0.0400,0.0323)
r?1mape <- c(0.0613,0.0500)
rf1frame <- data.frame(rf1x,rf1rmse,rf1mae,rf1mape)
rf1 <- ggplot(rf1frame)+
  geom_point(aes(rf1x,rf1rmse,color="rmse"),size=2)+
  geom_point(aes(rf1x,rf1mae,color="mae"),size=2)+
  geom_point(aes(rf1x,rf1mape,color="mape"),size=?)+
  geom_line(aes(rf1x,rf1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf1x,rf1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(rf1x,rf1mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=1)",color = ' ',x=' ',y=' ')+
? scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

rf2x <- c('no text','our method')
rf2x <- factor(rf2x,levels=c('no text','our method'))
rf2rmse <- c(0.0543,0.0492)
rf2mae <- c(0.0387,0.0346)
rf2mape <- c(0.0592,0.0537)
rf2fra?e <- data.frame(rf2x,rf2rmse,rf2mae,rf2mape)
rf2 <- ggplot(rf2frame)+
  geom_point(aes(rf2x,rf2rmse,color="rmse"),size=2)+
  geom_point(aes(rf2x,rf2mae,color="mae"),size=2)+
  geom_point(aes(rf2x,rf2mape,color="mape"),size=2)+
  geom_line(aes(rf2x,rf2rmse,?olor="rmse",group = 1),linetype = 5)+
  geom_line(aes(rf2x,rf2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(rf2x,rf2mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("?mse" = "black","mae" = "blue","mape"="red"))

rf3x <- c('no text','our method')
rf3x <- factor(rf3x,levels=c('no text','our method'))
rf3rmse <- c(0.0570,0.0504)
rf3mae <- c(0.0406,0.0351)
rf3mape <- c(0.0623,0.0544)
rf3frame <- data.frame(rf3x,rf3rmse,rf3?ae,rf3mape)
rf3 <- ggplot(rf3frame)+
  geom_point(aes(rf3x,rf3rmse,color="rmse"),size=2)+
  geom_point(aes(rf3x,rf3mae,color="mae"),size=2)+
  geom_point(aes(rf3x,rf3mape,color="mape"),size=2)+
  geom_line(aes(rf3x,rf3rmse,color="rmse",group = 1),linetype ? 5)+
  geom_line(aes(rf3x,rf3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(rf3x,rf3mape,color="mape",group = 1),linetype = 4)+
  labs(title="rf  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","m?pe"="red"))

svr1x <- c('no text','our method')
svr1x <- factor(svr1x,levels=c('no text','our method'))
svr1rmse <- c(0.0436,0.0432)
svr1mae <- c(0.0290,0.0282)
svr1mape <- c(0.0442,0.0435)
svr1frame <- data.frame(svr1x,svr1rmse,svr1mae,svr1mape)
svr1 <- g?plot(svr1frame)+
  geom_point(aes(svr1x,svr1rmse,color="rmse"),size=2)+
  geom_point(aes(svr1x,svr1mae,color="mae"),size=2)+
  geom_point(aes(svr1x,svr1mape,color="mape"),size=2)+
  geom_line(aes(svr1x,svr1rmse,color="rmse",group = 1),linetype = 5)+
  geom?line(aes(svr1x,svr1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr1x,svr1mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="r?d"))

svr2x <- c('no text','our method')
svr2x <- factor(svr2x,levels=c('no text','our method'))
svr2rmse <- c(0.0462,0.0452)
svr2mae <- c(0.0308,0.0296)
svr2mape <- c(0.0468,0.0456)
svr2frame <- data.frame(svr2x,svr2rmse,svr2mae,svr2mape)
svr2 <- ggplot(s?r2frame)+
  geom_point(aes(svr2x,svr2rmse,color="rmse"),size=2)+
  geom_point(aes(svr2x,svr2mae,color="mae"),size=2)+
  geom_point(aes(svr2x,svr2mape,color="mape"),size=2)+
  geom_line(aes(svr2x,svr2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(a?s(svr2x,svr2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr2x,svr2mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

?vr3x <- c('no text','our method')
svr3x <- factor(svr3x,levels=c('no text','our method'))
svr3rmse <- c(0.0470,0.0455)
svr3mae <- c(0.0318,0.0303)
svr3mape <- c(0.0484,0.0462)
svr3frame <- data.frame(svr3x,svr3rmse,svr3mae,svr3mape)
svr3 <- ggplot(svr3fram?)+
  geom_point(aes(svr3x,svr3rmse,color="rmse"),size=2)+
  geom_point(aes(svr3x,svr3mae,color="mae"),size=2)+
  geom_point(aes(svr3x,svr3mape,color="mape"),size=2)+
  geom_line(aes(svr3x,svr3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(svr3?,svr3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(svr3x,svr3mape,color="mape",group = 1),linetype = 4)+
  labs(title="svr  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima1x?<- c('no text','our method')
arima1x <- factor(arima1x,levels=c('no text','our method'))
arima1rmse <- c(0.0449,0.0452)
arima1mae <- c(0.0293,0.0298)
arima1mape <- c(0.0451,0.0457)
arima1frame <- data.frame(arima1x,arima1rmse,arima1mae,arima1mape)
arima1 <? ggplot(arima1frame)+
  geom_point(aes(arima1x,arima1rmse,color="rmse"),size=2)+
  geom_point(aes(arima1x,arima1mae,color="mae"),size=2)+
  geom_point(aes(arima1x,arima1mape,color="mape"),size=2)+
  geom_line(aes(arima1x,arima1rmse,color="rmse",group = 1),?inetype = 5)+
  geom_line(aes(arima1x,arima1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(arima1x,arima1mape,color="mape",group = 1),linetype = 4)+
  labs(title="arima  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "?lack","mae" = "blue","mape"="red"))

arima2x <- c('no text','our method')
arima2x <- factor(arima2x,levels=c('no text','our method'))
arima2rmse <- c(0.0449,0.0449)
arima2mae <- c(0.0292,0.0293)
arima2mape <- c(0.0450,0.0451)
arima2frame <- data.frame(arim?2x,arima2rmse,arima2mae,arima2mape)
arima2 <- ggplot(arima2frame)+
  geom_point(aes(arima2x,arima2rmse,color="rmse"),size=2)+
  geom_point(aes(arima2x,arima2mae,color="mae"),size=2)+
  geom_point(aes(arima2x,arima2mape,color="mape"),size=2)+
  geom_line(ae?(arima2x,arima2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima2x,arima2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(arima2x,arima2mape,color="mape",group = 1),linetype = 4)+
  labs(title="arima  (h=2)",color = ' ',x=' ',y=' '?+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

arima3x <- c('no text','our method')
arima3x <- factor(arima3x,levels=c('no text','our method'))
arima3rmse <- c(0.0449,0.0454)
arima3mae <- c(0.0293,0.0300)
arima3mape <- c(?.0451,0.0465)
arima3frame <- data.frame(arima3x,arima3rmse,arima3mae,arima3mape)
arima3 <- ggplot(arima3frame)+
  geom_point(aes(arima3x,arima3rmse,color="rmse"),size=2)+
  geom_point(aes(arima3x,arima3mae,color="mae"),size=2)+
  geom_point(aes(arima3x,ari?a3mape,color="mape"),size=2)+
  geom_line(aes(arima3x,arima3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(arima3x,arima3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(arima3x,arima3mape,color="mape",group = 1),linetype = 4)+
  labs?title="arima  (h=3)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada1x <- c('no text','our method')
ada1x <- factor(ada1x,levels=c('no text','our method'))
ada1rmse <- c(0.0440,0.0431)
ada1mae <? c(0.0287,0.0287)
ada1mape <- c(0.0443,0.0441)
ada1frame <- data.frame(ada1x,ada1rmse,ada1mae,ada1mape)
ada1 <- ggplot(ada1frame)+
  geom_point(aes(ada1x,ada1rmse,color="rmse"),size=2)+
  geom_point(aes(ada1x,ada1mae,color="mae"),size=2)+
  geom_point(aes(?da1x,ada1mape,color="mape"),size=2)+
  geom_line(aes(ada1x,ada1rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada1x,ada1mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ada1x,ada1mape,color="mape",group = 1),linetype = 4)+
  labs(titl?="ada  (h=1)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada2x <- c('no text','our method')
ada2x <- factor(ada2x,levels=c('no text','our method'))
ada2rmse <- c(0.0446,0.0446)
ada2mae <- c(0.0?93,0.0292)
ada2mape <- c(0.0450,0.0450)
ada2frame <- data.frame(ada2x,ada2rmse,ada2mae,ada2mape)
ada2 <- ggplot(ada2frame)+
  geom_point(aes(ada2x,ada2rmse,color="rmse"),size=2)+
  geom_point(aes(ada2x,ada2mae,color="mae"),size=2)+
  geom_point(aes(ada2x,a?a2mape,color="mape"),size=2)+
  geom_line(aes(ada2x,ada2rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada2x,ada2mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ada2x,ada2mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada ?(h=2)",color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

ada3x <- c('no text','our method')
ada3x <- factor(ada3x,levels=c('no text','our method'))
ada3rmse <- c(0.0456,0.0449)
ada3mae <- c(0.0297,0.0?93)
ada3mape <- c(0.0458,0.0452)
ada3frame <- data.frame(ada3x,ada3rmse,ada3mae,ada3mape)
ada3 <- ggplot(ada3frame)+
  geom_point(aes(ada3x,ada3rmse,color="rmse"),size=2)+
  geom_point(aes(ada3x,ada3mae,color="mae"),size=2)+
  geom_point(aes(ada3x,ada3mape?color="mape"),size=2)+
  geom_line(aes(ada3x,ada3rmse,color="rmse",group = 1),linetype = 5)+
  geom_line(aes(ada3x,ada3mae,color="mae",group = 1),linetype = 2)+
  geom_line(aes(ada3x,ada3mape,color="mape",group = 1),linetype = 4)+
  labs(title="ada  (h=3)"?color = ' ',x=' ',y=' ')+
  scale_color_manual(values = c("rmse" = "black","mae" = "blue","mape"="red"))

library(cowplot)
library(showtext)
plot_grid(rf1,rf2,rf3,svr1,svr2,svr3,arima1,arima2,arima3,ada1,ada2,ada3,
          nrow = 4, ncol=3, align = "v")
