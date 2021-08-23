1.数据创建
library(tibble)
df <- tibble(
  "grammer" = c("Python","C","Java","GO",NA,"SQL","PHP","Python"),
  "score" = c(1,2,NA,4,5,NA,7,10)
)
2.数据提取
提取含有字符串"Python"的行
df[which(df$grammer == 'Python'),]
3.数据提取
输出df的所有列名
names(df)
4.数据修改
修改第二列列名为'popularity'
options(warn=-1)  ####R语言环境变量的设置#这个命令
                      #可以把R的整数表示能力设为10位。
                      #options(digits=10)
                      # 2. 扩展包的安装，使用下面的命令，可以联网安装扩展包。
                      # options(CRAN="http://cran.r-project.org") 
                      # install.packages("扩展包名")
                      # 4. R里的options函数进行错误信息显示（忽略）设置。
                      # #这个命令，可以忽视任何警告
                      # options(warn=-1) 
                      # #这个命令，不放过任何警告
options(warn=1)
library(dplyr)
library(tidyverse)
df <- df %>% rename(popularity = score)  #注意这里被赋予值写在前面
5.数据统计
统计grammer列中每种编程语言出现的次数·
table(df$grammer)
6.缺失值处理
将空值用上下值的平均值填充
library(Hmisc)
index <- which(is.na(df$popularity))   ##回到是的空缺值在这列的第几个，就是行号
df$popularity <- impute(df$popularity,     ##impute默认是中位数
                        (unlist(df[index-1, 2] +   #unlist函数的作用是把list类型的数据转化为vector
                                  df[index+1, 2]))/2)

      # 1.Vector
      # 所有的元素必须是同一类型。 例如下面的代码创建了2个vectors.
      # 
      # name <- c("Mike", "Lucy", "John") age <- c(20, 25, 30)
      # 2.Array & Matrix
      # Matrix是一种特殊的vector。Maxtrix是一个拥有两个额外属性的vector：行数和列数。
      # 
      # > x <- matrix(c(1,2,3,4), nrow=2, ncol=2)> x     [,1] [,2][1,]    1    3[2,]    2    4
      # 3.List
      # List能包含不同类型的元素
      # 
      # > y <- list(name="Mike", gender="M", company="ProgramCreek")
      # 4.Data Frame
      # Data Frame用于存储数据表，它是元素为vector的list，拥有相等的长度。
7.数据提取
提取popularity列中值大于3的行

df %>%
  filter(popularity > 3)
8.数据去重
按照grammer列进行去重

df[!duplicated(df$grammer),]

9.数据计算
计算popularity列平均值
df %>%
  summarise(mean = mean(popularity))

11.数据保存
将DataFrame保存为EXCEL

#R对EXCEL文件不太友好
#第一种方法：利用readr包转为csv再用EXCEL打开
#文件本质依然是csv
library(readr)
write_excel_csv(df,'filename.csv')

12.数据查看
查看数据行列数

dim(df)
13.提取数据
提取popularity列值大于3小于7的行

df %>%
  filter(popularity > 3 & popularity <7)
15.数据提取
提取popularity列最大值所在行

df %>%
  
  filter(popularity == max(popularity))
17.数据修改
删除最后一数据

df[-dim(df)[1],]
18.数据修改
添加一行数据['Perl',6.6]

row <- data.frame(
  "grammer" = c("Perl"),
  "popularity" = c(6.6)
) # 需要和列的位置对应
df <- rbind(df,row)
19.数据排序
对数据按照"popularity"列值的大小进行排序

df <- df %>%
  arrange(popularity)
20.数据统计
统计grammer列每个字符串的长度
library(Hmisc)
library(stringr)
df$grammer <- impute(df$grammer,'R')
str_length(df$grammer)
df$len_str <- str_length(df$grammer)    ###str_length()

                                #基本数据处理：21-50
21.数据读取
读取本地Excel数据

library(readr)
df <- read_csv('pandas120.csv')
23.将salary列数据转换为最大值与最小值的平均值
library(stringr)
df$salary <- df$salary %>%
  str_replace_all('k','') %>%
  str_split('-',simplify = T) %>%
  apply(2,as.numeric) %>%
  rowMeans() * 1000
df

24.将数据根据学历进行分组并计算平均薪资
library(dplyr)
library(tibble)
df %>%
  group_by(education) %>%
  summarise(mean = mean(salary))

25.将createTime列时间转换为月-日
#转化后该列属性是 字符串，R中对时间格式要求严格
df$createTime <- as.Date(df$createTime) %>%
  str_replace('2020-','')

26.查看索引、数据类型和内存信息
str(df)
# 内存查看需要用到其他的库
library(pryr)
object_size(df)


27查看数值型列的汇总统计
summary(df)

28.新增一列根据salary将数据分为三组
df <- df %>%
  mutate(categories = case_when(
    df$salary >= 0 & df$salary < 5000 ~ '低',
    df$salary >= 5000 & df$salary < 20000 ~ '低',
    TRUE ~ '高'
  ))

30.取出第33行数据
df[33,]

32.绘制薪资水平频率分布直方图
  library(ggplot2)
df %>%
  ggplot(aes(salary)) +
  geom_histogram(bins = 10) # 这个跟python的bins一致

32绘制薪资水平密度曲线
df %>%
  ggplot(aes(salary)) +
  geom_density() +
  xlim(c(0,70000))

35将df的第一列与第二列合并为新的一列
df <- df %>%
  mutate(test = paste0(df$education,df$createTime))

36将education列与salary列合并为新的一列
df <- df %>%
  mutate(test1 =
           paste0(df$salary,df$education))

37.计算salary最大值与最小值之差
df %>%
  summarise(delta = max(salary) - min(salary)) %>%
  unlist()
38.将第一行与最后一行拼接
rbind(df[1,],df[dim(df)[1],])
40.查看每列的数据类型
str(df)
41.将createTime列设置为索引
df %>%
  tibble::column_to_rownames('createTime')
42.生成一个和df长度相同的随机数dataframe
df1 <- sapply(135,function(n) {
  replicate(n,sample(1:10,1))
})
43.将上一题生成的dataframe与df合并
df <- cbind(df,df1) %>%
  rename(`0` = df1)
45.检查数据中是否含有任何缺失值
library(mice)
md.pattern(df)

46.将salary列类型转换为浮点数
as.double(df$salary)

47.计算salary大于10000的次数    ###dim()给出来是维度，几行几列的
df %>%
  filter(salary > 10000) %>%
  dim(.) %>%
  .[1]

48.查看每种学历出现的次数
table(df$education)

49.查看education列共有几种学历
length(unique(df$education))

    ######################第三期｜金融数据处理：51-80############################

df <- read_csv('600000.SH.csv')
52.查看数据前三行
head(df,3)

53.查看每列数据缺失值情况
colSums(is.na(df))

54.提取日期列含有空值的行
df[is.na(df$日期),]

55.输出每列缺失值具体行数
library(glue)
for (i in names(df)){
  if(sum(is.na(df[,'日期'])) != 0){
    res1 <- which(is.na(df[,i]))
    res2 <- paste(res1,collapse = ',')
    print(glue('列名："{i}", 第[{res2}]行有缺失值'))
  }
}

56.删除所有存在缺失值的行
df <- na.omit(df)
57.绘制收盘价的折线图
library(ggplot2)

library(tidyverse)
df <- df %>% rename(time = "日期")
df <- df %>% rename(price= "开盘价(元)")
df %>%
  ggplot(aes(time,price))+geom_line()

58.同时绘制开盘价与收盘价
df %>%
  ggplot() +
  geom_line(aes(日期,`收盘价(元)`), size=1.2, color='steelblue') +
  geom_line(aes(日期,`开盘价(元)`), size=1.2, color='orange') +
  ylab(c('价格(元)'))


61.以data的列名创建一个dataframe
temp <- as_tibble(names(df))

62.打印所有换手率不是数字的行
#换手率这一列属性为chr，需要先强转数值型
#如果转换失败会变成NA，判断即可
df[is.na(as.numeric(df$`换手率(%)`)),]

65.删除所有换手率为非数字的行
df[!is.na(as.numeric(df$`换手率(%)`)),]
# 或者根据前几题的经验，非数字就是'--'
df <- df %>%
  filter(`换手率(%)` != '--')


67.计算前一天与后一天收盘价的差值
df %>%
  summarise(delta = `收盘价(元)` - lag(`收盘价(元)`))

69.设置日期为索引
df %>%
  column_to_rownames(var='日期')

116.提取industryField列以'数据'开头的行
df[grep("^数据", df$industryField),]

120.计算并提取平均薪资最高的区
df %>%
  group_by(district) %>%
  summarise(avg = mean(salary)) %>%
  arrange(desc(avg)) %>%
  filter(row_number() == 1)



filter里面可以用%in%来筛选该列里在一个list有匹配的所有行，eg data %>% filter(Province %in% province)

drop_na()可以把所有行里面有na的值都删掉，eg data2 <- data1 %>% drop_na()


separate()可以把unite的一列变成两列，eg data %>% separate("time_hos",c("time","hos"),"_")，需要分开的列，分开后两列的名称，分隔符号
unite(adatalong,"time_hos",period,Hospital) 数据，合并后的新的列名，需要合并的两列


                                  #####apply 家族函数######
###通过使用apply函数，我们可以实现对数据的循环、分组、过滤、类型控制等操作
#####很多R语言新手，写了很多的for循环代码，也不愿意多花点时间把apply函数的使用方法了解清楚，最后把R代码写的跟C似得，我严重鄙视只会写for的R程序员。

##apply函数本身就是解决数据循环处理的问题，为了面向不同的数据类型，不同的返回值，apply函数组成了一个函数族，包括了8个功能类似的函数。
##这其中有些函数很相似，有些也不是太一样的。

##分组计算的有 #1 tapply 参数vector，返回值vector
               #2 apply 参数list，dataframe，array，返回值vector，matrix
##多参数计算  #mapply 参数vector，不限个数， 返回值 vector，matrix

##循环迭代 lapply 参数list，dataframe，返回值list ----简化版 sapply 参数list，df，返回值vector，matrix ——————————可设置返回值 vapply，参数list，df，返回值vector，matrix
                                                # ----递归版 rapply 参数list，返回值list

##环境空间遍历 eapply 参数environment，返回值list

# apply函数
# apply函数是最常用的代替for循环的函数。apply函数可以对矩阵、数据框、数组(二维、多维)，按行或列进行循环计算，对子元素进行迭代，并把子元素以参数传递的形式给自定义的FUN函数中，并以返回计算结果。
# 
# 函数定义：
# 
# apply(X, MARGIN, FUN, ...)
# 参数列表：
# 
# X:数组、矩阵、数据框
# MARGIN: 按行计算或按按列计算，1表示按行，2表示按列
# FUN: 自定义的调用函数
# …: 更多参数，可选
  # eg：
# 比如，对一个矩阵的每一行求和，下面就要用到apply做循环了。
# 
# 
# > x<-matrix(1:12,ncol=3)
# > apply(x,1,sum)
# [1] 15 18 21 24

 #eg：
# 下面计算一个稍微复杂点的例子，按行循环，让数据框的x1列加1，并计算出x1,x2列的均值。
# # 生成data.frame
# > x <- cbind(x1 = 3, x2 = c(4:1, 2:5)); x
# x1 x2
# [1,]  3  4
# [2,]  3  3
# [3,]  3  2
# [4,]  3  1
# [5,]  3  2
# [6,]  3  3
# [7,]  3  4
# [8,]  3  5
# 自定义函数myFUN，第一个参数x为数据
# 第二、三个参数为自定义参数，可以通过apply的'...'进行传入。
# > myFUN<- function(x, c1, c2) {
#   +   c(sum(x[c1],1), mean(x[c2])) 
#   + }
# # 把数据框按行做循环，每行分别传递给myFUN函数，设置c1,c2对应myFUN的第二、三个参数
# > apply(x,1,myFUN,c1='x1',c2=c('x1','x2'))
# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
# [1,]  4.0    4  4.0    4  4.0    4  4.0    4
# [2,]  3.5    3  2.5    2  2.5    3  3.5    4
###########lapply函数
# lapply函数是一个最基础循环操作函数之一，用来对list、data.frame数据集进行循环，并返回和X长度同样的list结构作为结果集，通过lapply的开头的第一个字母’l’就可以判断返回结果集的类型。
# 
# 函数定义：
# 
# lapply(X, FUN, ...)
# 参数列表：
# 
# X:list、data.frame数据
# FUN: 自定义的调用函数
# …: 更多参数，可选
# 比如，计算list中的每个KEY对应该的数据的分位数。

#####！！！！！！注意 <<- global 标记！！



























