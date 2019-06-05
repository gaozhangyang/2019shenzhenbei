import requests
import numpy as np
from math import radians, cos, sin, asin, sqrt
import networkx as nx
import scipy.io as scio
#20个城市
cities=["广州市","东莞市","惠州市","佛山市","清远市","江门市","中山市","肇庆市","云浮市",
    "河源市","梅州市","韶关市","汕尾市","揭阳市","潮州市","汕头市","阳江市","茂名市","珠海市","深圳市"]

colink=scio.loadmat('colink')['colink']


#画图查看
import matplotlib.pyplot as plt
#使图中能够显示中文
plt.rcParams['font.sans-serif']=['SimHei']
plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['figure.figsize'] = (8.0, 4.0) # 设置figure_size尺寸
plt.rcParams['image.interpolation'] = 'nearest' # 设置 interpolation style
plt.rcParams['image.cmap'] = 'gray' # 设置 颜色 style
plt.rcParams['savefig.dpi'] = 100 #图片像素
plt.rcParams['figure.dpi'] = 100 #分辨率

G=nx.Graph()
G.add_nodes_from(cities)    #加点集合
for i in range(1,len(cities)):
    for j in range(0,len(cities)):
        if colink[i][j]>0:
            G.add_edge(cities[i],cities[j])

nx.draw(G, with_labels=True)
plt.show()
