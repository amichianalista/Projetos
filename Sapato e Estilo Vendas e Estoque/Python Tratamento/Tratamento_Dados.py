# %%
import pandas as pd
# %%
import numpy as np
# %%
produtos = pd.read_csv("Stillus - Bruta.csv")
# %%
print(produtos['Produto'].sample(10))
# %% Padronizando nomes dos produtos
produtos['Produto'] = produtos['Produto'].replace(
    {'ALL STAT': 'ALL STAR', 'ALLSTAR': 'ALL STAR',
     'ANTIDERRAPANTE': 'ANTI DERRAPANTE',
     'ANTI-DERRAPANTE': 'ANTI DERRAPANTE',
     'APOIO PLANTAR GELPE': 'APOIO PLANTAR',
     'BATA EST': 'BATA EST.',
     'BLUS': 'BLUSA', 'BLUSA FEMININA,':'BLUSA FEMININA',
     'BLUSA MA NGA': 'BLUSA MANGA', 'BLUSA MANGAL': 'BLUSA MANGA',
     'BLUSA MAGAC': 'BLUSA MANGA', 'BLUSA MANGAT': 'BLUSA MANGA',
     'BOLSA FEM': 'BOLSA FEM.', 'BOLSA,' :'BOLSAS', 'BORI': 'BODY',
     'BORI C FIVELA':'BODY COM FIVELA','BORI ESTAM':'BODY STAM',
     'BORI ESTAMPADO':'BODY ESTAMPADO','BORING':'BODY','CACHAREL':'CACHARREL',
     'CACHICOL':'CACHECOL'
     },  
    regex=False)
produtos['Produto'] = produtos['Produto'].str.replace('CALA', 'CALÇA', regex=False)
produtos['Produto'] = produtos['Produto'].replace(
    {'8271076': 'SAPATO', '370': 'CALÇA','1737':'CAMISA','TENIS as': 'TENIS AS'})
# %%
valores_antigos = ['ALLSTAT', 'ALLSTAR']
print("Ocorrências dos valores antigos:")
print(produtos[produtos['Produto'].isin(valores_antigos)]['Produto'].value_counts())
# %%
print("Ocorrências de 'CALA':", produtos[produtos['Produto'] == 'CALA'].shape[0])
# %% Agrupando Produtos Iguais
produtos['ID_Agrupado'] = (
    produtos['Produto'] + '_' + 
    produtos['Grupo'] + '_' + 
    produtos['SubGrupo']
)
# %% Adicionado novo ID
produtos['Novo_ID'] = produtos.groupby('ID_Agrupado').ngroup() + 1
# %% Convertendo dados númericos
colunas_numericas = ['Qtd Ent', 'Estoque Geral', 'Custo Estoque', 'Vr.Venal', 'Qtde Ven', 
                    'Custo Venda', 'Vr.Venda', 'Margem', 'Venda Media', 'Reposicao', 'Pr.Venda']
for col in colunas_numericas:
    produtos[col] = pd.to_numeric(produtos[col].astype(str).str.replace(',', '.'), errors='coerce')

# %%
sapatoestilo_consolidado = produtos.groupby(['Produto', 'Grupo', 'SubGrupo']).agg({
    'Ultima Compra': 'max',
    'Ultima Venda': 'max',
    'Qtd Ent': 'sum',
    'Estoque Geral': 'sum',
    'Custo Estoque': 'sum',
    'Vr.Venal': 'sum',
    'Qtde Ven': 'sum',
    'Custo Venda': 'sum',
    'Vr.Venda': 'sum',
    'Margem': 'sum',
    'Venda Media': 'max',
    'Reposicao': 'mean',
    'Pr.Venda': 'mean'
}).reset_index()

# %%
sapatoestilo_consolidado.to_csv('produtos_consolidados.csv', index=False, encoding='utf-8-sig')
# %% Continuação Correções
sapatoestilo = pd.read_csv("produtos_consolidados.csv")
sapatoestilo

# %% Adicionando novos id's
sapatoestilo['ID'] = sapatoestilo.groupby(['Produto', 'Grupo', 'SubGrupo']).ngroup() + 1
# %%
sapatoestilo = sapatoestilo.rename(columns={'ID': 'ID_Produto'})
# %%
colunas_ordenadas = ['ID_Produto'] + [col for col in sapatoestilo.columns if col != 'ID_Produto']
sapatoestilo = sapatoestilo[colunas_ordenadas]
# %%
sapatoestilo

# %% Consertando tipos de dados
print(sapatoestilo.dtypes)
# %%
sapatoestilo['Ultima Compra'] = pd.to_datetime(sapatoestilo['Ultima Compra'], errors='coerce', dayfirst=True)
sapatoestilo['Ultima Venda'] = pd.to_datetime(sapatoestilo['Ultima Venda'], errors='coerce', dayfirst=True)
# %%
sapatoestilo['Qtd Ent'] = sapatoestilo['Qtd Ent'].astype(np.int64)
# %%
sapatoestilo['Estoque Geral'] = np.ceil(sapatoestilo['Estoque Geral'])
sapatoestilo['Custo Estoque'] = np.ceil(sapatoestilo['Custo Estoque'])
# %%
sapatoestilo['Estoque Geral'] = sapatoestilo['Estoque Geral'].round(2)
sapatoestilo['Custo Estoque'] = sapatoestilo['Custo Estoque'].round(2)
# %%
print(sapatoestilo.dtypes)
# %% Excluindo dados nulos ou zerados
sapatoestilo = sapatoestilo[
    (sapatoestilo['Qtd Ent'] != 0) | 
    (sapatoestilo['Qtde Ven'] != 0) | 
    (sapatoestilo['Estoque Geral'] != 0)
]
# %%
print(f"Total de linhas antes: {len(sapatoestilo)}")
# %%
condicoes_zero = (
    (sapatoestilo['Qtd Ent'] == 0) & 
    (sapatoestilo['Qtde Ven'] == 0) & 
    (sapatoestilo['Estoque Geral'] == 0)
)

sapatoestilo = sapatoestilo[~condicoes_zero]

# %%
print(f"Total de linhas depois: {len(sapatoestilo)}")
# %%
linhas_zeradas = (
    (sapatoestilo['Qtd Ent'] == 0) & 
    (sapatoestilo['Qtde Ven'] == 0) & 
    (sapatoestilo['Estoque Geral'] == 0)
).any()
# %%
print("Existem linhas totalmente zeradas?", linhas_zeradas)
# %%
sapatoestilo['Ultima Compra'] = sapatoestilo['Ultima Compra'].dt.strftime('%Y-%m-%d')
sapatoestilo['Ultima Venda'] = sapatoestilo['Ultima Venda'].dt.strftime('%Y-%m-%d')
# %%
sapatoestilo = sapatoestilo.drop_duplicates()
# %%
caminho_pasta = r"C:\Users\Hugo Amichi\Desktop\Python\Sapato & Estilo"
# %%
import os
# %%
caminho_arquivo = os.path.join(caminho_pasta, "sapatoestilo_tratados.csv")
# %%
os.makedirs(caminho_pasta, exist_ok=True)
# %%
sapatoestilo.to_csv(caminho_arquivo, index=False, encoding='utf-8-sig')
# %%
import pandas as pd

# %%
df = pd.read_csv("sapatoestilo_tratados")
# %%
