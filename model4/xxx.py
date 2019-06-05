import requests
import numpy as np
from math import radians, cos, sin, asin, sqrt
import networkx as nx
import scipy.io as scio

#松弛变量
#距离
gama=10
#信息接入需求量
beta=0.005

#21个行政区（包括顺得区）
cities=["广州市","东莞市","惠州市","佛山市","清远市","江门市","中山市","顺德区","肇庆市","云浮市",
    "河源市","梅州市","韶关市","汕尾市","揭阳市","潮州市","汕头市","阳江市","茂名市","珠海市","深圳市"]

distMat=np.load("distMat.npy")
distMat=np.delete(distMat,7,axis=0)
distMat=np.delete(distMat,7,axis=1)
dataNew = './distmat.mat'
scio.savemat(dataNew, {'distMat':distMat})


#最后进行计算的需求量(可以是最大值+松弛变量，可以是平均值等)
needMat=np.random.uniform(10,20,size=21)
needMat[0]=0
class city:
    def __init__(self,name,need,father_id,cost,depth):
        self.name=name
        self.need=need
        self.fid=father_id
        self.cost=cost
        self.depth=depth
    def p(self):
        print(self.name,self.need,self.fid,self.cost,self.depth)
citynodes=[city(cities[0],needMat[0],[-1],0,1)]
for i in range(1,len(cities)):
    citynodes.append(city(cities[i],needMat[i],[0],-1,2))

#根据当前点到它爸爸的距离，和当前点的需求判断是否可以相连
#不可以相连，则返回负数
#可以相连，则返回边花费的钱
def match(dis,need):
    if dis>200+gama:
        return -1
    elif need<=32:
        return 1
    else:
        if dis>100+gama:
            return -2
        elif need<=48:
            return 1.25
        else:
            if dis>80+gama:
                return -3
            else:
                return 1.5


#简单的三层树结构情况下
#如果某节点不能直接与核心广州相连，则寻找其爸爸
def find_father(city_id):
    #将其他节点按照其需求从小到大排序
    arg=np.argsort([citynodes[i].need for i in range(len(cities))])
    #找出需求最小的、可以充当当前节点爸爸 的节点，使之相连
    for i in arg:
        if i!=0 and i!=city_id and citynodes[i].depth!=3:
            mic=match(distMat[i][city_id],citynodes[city_id].need) 
            m0i=match(distMat[0][i],citynodes[i].need+citynodes[city_id].need)
            #print(distMat[i][city_id],citynodes[city_id].need,"mic",mic,distMat[0][i],citynodes[i].need+citynodes[city_id].need,"m0i",m0i)
            if mic>0 and m0i>0:
                citynodes[i].need+=citynodes[city_id].need
                citynodes[i].cost=m0i
                citynodes[city_id].fid=[i]
                citynodes[city_id].depth+=1
                citynodes[city_id].cost=mic
                return 1    
    return -1

#尝试允许多个爸爸的树妆结构，企图获取最优结果，然后放弃，
#其他思路：
#1.可以尝试贪婪算法
#2.等等
'''
def calfree():
    freeMat=[]
    for i in range(len(cities)):
        if citynodes[i].cost==1:
            free=max(32-citynodes[i].need,0)
        elif citynodes[i].cost==1.25:
            free=max(48-citynodes[i].need,0)
        elif citynodes[i].cost==1.5:
            free=max(64-citynodes[i].need,0)
        else:
            free=32
        freeMat.append(free)
    return np,array(freeMat)
#除去核心广州，free<16

def find_morefa(city_id,fa_num=2):
    freeMat=calfree()
    freearg=np.argsort(-freeMat)
    flag=0
    for i in arg:
        for j in arg:
            #除去它本身和其他没有爸爸的点
            if i!=j and i!=city_id and citynodes[i].cost!=0 and j!=city_id and citynodes[j].cost!=0:
                if distMat[i][city_id]>200+gama:
                    break
                elif distMat[j][city_id]<=200+gama:
                    if freeMat[i]+freeMat[j]>=citynodes[city_id].cost:
                        citynodes[i].need+=freeMat[i]
                        citynodes[j].need+=citynodes[city_id].need-freeMat[i]
                        citynodes[city_id].fid=[i,j]
                        citynodes[city_id].depth+=1
                        citynodes[city_id].cost=[1,1]
'''


#没有找到爸爸的孤立点sadsons
sadsons=[]

#开始循环匹配
for c in range(1,len(cities)):
    print(distMat[0][c],citynodes[c].need)
    m0c=match(distMat[0][c],citynodes[c].need)
    if m0c<0:
        if find_father(c) == -1:
            sadsons.append(c)
    else:
        citynodes[c].cost=m0c

#查看结果
for i in range(len(cities)):
    print("id:",i,distMat[0][i])
    citynodes[i].p()


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
    if citynodes[i].cost>=0:
        if citynodes[i].depth==2:
            G.add_edge(citynodes[i].name,citynodes[0].name)
        if citynodes[i].depth==3:
            for j in citynodes[i].fid:
                G.add_edge(citynodes[i].name,citynodes[j].name)
nx.draw(G, with_labels=True)
plt.show()
