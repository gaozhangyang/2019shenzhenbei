import pandas as pd
data=pd.read_csv('./LogMag&Phase.txt',sep=',')
data.to_csv('./LogMag&Phase.csv')