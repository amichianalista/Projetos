# %%
import pandas as pd
# %%
import numpy as np
# %%
df = pd.read_csv("SESRR07a_tratado.csv")
# %%
df = pd.read_csv(
    "SESRR07a_tratado.csv",
    sep=";",
    skipinitialspace=True,
    encoding="latin1",
    on_bad_lines="warn",
    engine="python"
)
# %%
print("Colunas disponíveis no DataFrame:")
for col in df.columns:
    print(f"- {col}")
# %%
df_limpo = df.dropna(how='all')
# %%
print(f"Shape original: {df.shape}")
# %%
print(f"Shape após remoção: {df_limpo.shape}")
# %%
todos_distintos = df['ID_Produto'].is_unique
print(f"Todos os valores de 'ID_Produto' são distintos? {todos_distintos}")
# %%
print("Colunas disponíveis:", df.columns.tolist())
# %%
df.columns = df.columns.str.strip()
# %%
print("Colunas após correção:", df.columns.tolist())
# %%
contagem_ids = df['ID_Produto'].value_counts()
print("IDs duplicados (ocorrências > 1):")
print(contagem_ids[contagem_ids > 1])
# %%
linhas_duplicadas = df[df.duplicated(subset=['ID_Produto'], keep=False)]
print("\nLinhas duplicadas (todas as ocorrências):")
print(linhas_duplicadas.sort_values('ID_Produto'))
# %%
pd.set_option('display.max_rows', None)  
pd.set_option('display.max_columns', None)  
pd.set_option('display.width', None)  
pd.set_option('display.max_colwidth', None)  

linhas_duplicadas = df[df.duplicated(subset=['ID_Produto'], keep=False)]
print("\nLinhas duplicadas (todas as ocorrências):")
print(linhas_duplicadas.sort_values('ID_Produto'))
# %%linhas_duplicadas = df[df.duplicated(subset=['ID_Produto'], keep=False)]
linhas_duplicadas.sort_values('ID_Produto').to_excel('duplicatas.xlsx', index=False)
print("Arquivo 'duplicatas.xlsx' criado com todas as linhas duplicadas.")

# %%
df['ID_Unico'] = df['ID_Produto'].astype(str) + '_' + df['ID_Cor'].astype(str)
# %%
print(df[['ID_Produto', 'ID_Cor', 'ID_Unico']].head())
# %%
todos_distintos = df['ID_Unico'].is_unique
print(f"Todos os valores de 'ID_Unico' são distintos? {todos_distintos}")
# %%
contagem_ids = df['ID_Unico'].value_counts()
duplicados = contagem_ids[contagem_ids > 1]
print("\nIDs duplicados (e quantas vezes aparecem):")
print(duplicados)
# %%
df['ID_Produto'] = df['ID_Produto'].astype(str).str.strip().str.replace(r'[^\w]', '', regex=True)
df['ID_Cor'] = df['ID_Cor'].astype(str).str.strip().str.replace(r'[^\w]', '', regex=True)
# %%
df['ID_Unico'] = (
    df['ID_Produto'] + '_' + 
    df['ID_Cor'] + '_' + 
    df.groupby(['ID_Produto', 'ID_Cor']).cumcount().astype(str)
)
# %%
print("\nVerificação de valores únicos:")
# %%
print(f"Total de IDs únicos: {df['ID_Unico'].nunique()}")
# %%
print(df.info())
# %%
colunas_monetarias = [
    'Custo Estoque',
    'Vr.Estoque',
    'Custo Venda',
    'Vr.Venda',
    'Venda Media',
    'Reposicao',
    'Pr.Venda'
]

# %%
def converter_monetario(valor):
    if pd.isna(valor) or valor == '':
        return np.nan
    try:
       
        if isinstance(valor, str):
            valor = valor.replace('R$', '').replace(' ', '').strip()
            
            if ',' in valor and '.' in valor:
                if valor.rfind(',') > valor.rfind('.'):
                    valor = valor.replace('.', '').replace(',', '.')
                else:
                    valor = valor.replace(',', '')
            elif ',' in valor:
                valor = valor.replace('.', '').replace(',', '.')
        return float(valor)
    except:
        return np.nan
# %%
for coluna in colunas_monetarias:
    df[coluna] = df[coluna].apply(converter_monetario)

# %%
def safe_int_converter(x):
    if pd.isna(x) or x == '':
        return np.nan
    try:
       
        x_clean = ''.join(filter(str.isdigit, str(x)))
        return int(x_clean) if x_clean else np.nan
    except:
        return np.nan
# %%
df['Estoque Geral'] = df['Estoque Geral'].apply(safe_int_converter)
# %%
try:
    df['Estoque Geral'] = df['Estoque Geral'].astype('Int64')  # Note o 'I' maiúsculo (tipo pandas que aceita nulos)
except Exception as e:
    print(f"\nErro na conversão final: {e}")
    print("\nValores problemáticos restantes:")
    problematicos = df[df['Estoque Geral'].isna()]
    print(problematicos[['ID_Produto', 'Estoque Geral']].head())
# %%
def converter_tipos_dados(df):     colunas_monetarias = [
        'Custo Estoque',
        'Vr.Estoque',
        'Custo Venda',
        'Vr.Venda',
        'Venda Media',
        'Reposicao',
        'Pr.Venda'
    ]
# %%
def converter_monetario(valor):
        if pd.isna(valor) or str(valor).strip() == '':
            return np.nan
        try:
            # Remove R$, espaços e pontos de milhar
            valor_limpo = str(valor).replace('R$', '').replace(' ', '').replace('.', '')
            # Substitui vírgula decimal por ponto
            valor_limpo = valor_limpo.replace(',', '.')
            return float(valor_limpo)
        except:
            return np.nan
# %%
def safe_int_converter(x):
        if pd.isna(x) or str(x).strip() == '':
            return np.nan
        try:
            # Remove todos os caracteres não numéricos
            x_clean = ''.join(filter(str.isdigit, str(x)))
            return int(x_clean) if x_clean else np.nan
        except:
            return np.nan
# %%
for coluna in colunas_monetarias:
        df[coluna] = df[coluna].apply(converter_monetario)
# %%
df = df.astype({
        'ID_Cor': 'int64',
        'Estoque Geral': 'Int64',  # Tipo inteiro que aceita NaN
        **{col: 'float64' for col in colunas_monetarias}
    })
# %%
print(df.dtypes)
# %%
df.to_csv(
    'bd_stillus.csv',  
    index=False,       
    sep=';',          
    decimal='.',      
    encoding='utf-8-sig'  
)
# %%
import pandas as pd
# %%
import numpy as np
# %%
df = pd.read_csv("bd_stillus.csv", sep=";")
# %%
df['Ultima Compra'] = df['Ultima Compra'].str.strip()
df['Ultima Venda'] = df['Ultima Venda'].str.strip()

# %%
contagem_compra = (df['Ultima Compra'] == '00/00/00').sum()
# %%
contagem_venda = (df['Ultima Venda'] == '00/00/00').sum()
# %%
print(f"Registros com '00/00/00' em Ultima Compra: {contagem_compra}")
print(f"Registros com '00/00/00' em Ultima Venda: {contagem_venda}")
# %%
df['Ultima Compra'] = df['Ultima Compra'].replace('00/00/00', '01/01/2019')
# %%
print(f"Registros com '00/00/00' em Ultima Compra: {contagem_compra}")
# %%
df['Ultima Compra'] = df['Ultima Compra'].replace('00/00/00', '01/01/2019')
# %%
print("Registros alterados:")
print(df[df['Ultima Compra'] == '01/01/2019']['Ultima Compra'].count())
# %%
df['Ultima Venda'] = df['Ultima Venda'].replace('00/00/00', pd.NA)
# %%
nao_vendidos = df['Ultima Venda'].isna().sum()
print(f"Produtos não vendidos: {nao_vendidos}")
# %%
df['Ultima Compra'] = pd.to_datetime(df['Ultima Compra'], 
                                    dayfirst=True, 
                                    errors='coerce')

# %%
df['Ultima Venda'] = pd.to_datetime(df['Ultima Venda'], 
                                  dayfirst=True, 
                                  errors='coerce')
# %%
print("\nTipos das colunas após conversão:")
print(df[['Ultima Compra', 'Ultima Venda']].dtypes)
# %%
df.to_csv('bd_stillus.csv', index=False, date_format='%d/%m/%Y')
# %%
df = pd.read_csv("bd_stillus.csv", sep=";")
# %%
print(df.dtypes)
# %%
