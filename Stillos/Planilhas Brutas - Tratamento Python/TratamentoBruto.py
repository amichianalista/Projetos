# %%
import pandas as pd
# %%
import numpy as np
# %%
import chardet
# %%
with open('SESRR07a.csv', 'rb') as f:
    rawdata = f.read(10000)

# %%
result = chardet.detect(rawdata)
# %%
result = chardet.detect(rawdata)
encoding = result['encoding']
confidence = result['confidence']
# %%
print(f"Codificação detectada: {encoding} (confiança: {confidence:.2%})")
# %%
df = pd.read_csv('SESRR07a.csv', encoding='latin1')
# %%
print(df.head())
# %%
linhas, colunas = df.shape
# %%
print(f"O DataFrame tem {linhas} linhas e {colunas} colunas.")
# %%
print(f"Linhas: {len(df)}, Colunas: {len(df.columns)}")
# %%
print("Colunas:", df.columns.tolist())
# %%
with open("SESRR07a.csv", "r", encoding="latin1") as f:
    print(f.readlines()[:3])
# %%
df = pd.read_csv(
    "SESRR07a.csv",
    sep=";",                
    skipinitialspace=True,  
    encoding="latin1",      
    on_bad_lines="warn",   
    engine="python"       
)
# %%
df = df.dropna(axis=1, how="all")
# %%
print(f"Shape após remoção: {df.shape}")
# %%
print(f"Colunas restantes: {df.columns.tolist()}")
# %%
df.to_csv(
    "SESRR07a_tratado.csv",
    index=False,
    sep=";",
    encoding="latin1"
)
# %%
