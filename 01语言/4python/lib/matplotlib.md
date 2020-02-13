## matplotlib

#### 参考资料

- [官网](https://matplotlib.org)
- [中文文档](https://www.matplotlib.org.cn/)
- [matplotlib-tutorial](https://github.com/rougier/matplotlib-tutorial)


#### 对比

|视图|	Matplotlib|	Seaborn|
|---|---|---|
|散点|	pyplot.scatter|	jointplot(x=’’,y=’’,data=,kind=‘scatter’)|
折线	|pyplot.plot(x,y)|	lineplot(x=’’,y=’’,data=)|
|直方图|	pyplot.hist(x,bin=)	|distplot(x,kde=True)|
|条形图|	pyplot.bar(x,height)|	barplot(x=’’,y=’’,data=)|
|箱线图|	pyplot.boxplot(x,labels=)|	boxplot(data=)|
|饼图|	pyplot.pie(x,labels=)	||
|热力图| |		heatmap(data)|
|蜘蛛图|	figure+add_subplot+plot+fill| |	
|二元变量分布		| |jointplot(x=’’,y=’’,data=,kind=) (散点：‘scatter’,核密度:‘kde’，Hexbin:‘hex’)|
|成对关系|		|pairplot(data)|