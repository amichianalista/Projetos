import pandas as pd
import numpy as np
import chardet
from datetime import datetime


def detectar_codificacao(arquivo):
    with open(arquivo, 'rb') as f:
        resultado = chardet.detect(f.read())
    return resultado['encoding']


def limpar_linhas_em_branco(df):
    """Remove linhas completamente vazias"""
    print("Removendo linhas completamente vazias...")
    linhas_antes = len(df)
    df = df.dropna(how='all')
    linhas_depois = len(df)
    print(f"Linhas removidas: {linhas_antes - linhas_depois}")
    return df

def converter_tipos_para_sql_powerbi(df):
    """Converte tipos de dados para compatibilidade com SQL e Power BI"""
    
    conversoes = {
        'codigo': 'int64',
        'cpf': 'string',
        'nome': 'string',
        'Descricao': 'string',
        'estado-civil': 'string',
        'cep': 'string',
        'bairro': 'string',
        'cidade': 'string',
        'uf': 'string',
        'fone': 'string',
        'celular': 'string',
        'email': 'string',
        'limite': 'float64',
        'sexo': 'string',
        'Nro-Compras': 'int64',
        'Idade': 'int64'
    }
    
    
    for coluna, tipo in conversoes.items():
        if coluna in df.columns:
            try:
                if tipo == 'string':
                    df[coluna] = df[coluna].astype(str).str.strip()
                   
                    df[coluna] = df[coluna].replace(['', 'nan', 'NaN', 'None', 'none'], np.nan)
                elif tipo in ['int64', 'float64']:
                   
                    df[coluna] = pd.to_numeric(df[coluna], errors='coerce')
                print(f"✓ {coluna} -> {tipo}")
            except Exception as e:
                print(f"✗ Erro em {coluna}: {e}")
    
    return df

def tratar_datas(df):
    """Tratar colunas de data para formato SQL"""
    print("\nTratando datas...")
    
    colunas_data = ['nascimento', 'data-pri', 'data-ult']
    
    for coluna in colunas_data:
        if coluna in df.columns:
            try:
              
                df[coluna] = pd.to_datetime(df[coluna], errors='coerce', dayfirst=True)
                
                df[coluna] = df[coluna].dt.strftime('%Y-%m-%d')
                print(f"✓ {coluna} -> formato data SQL")
            except Exception as e:
                print(f"✗ Erro em {coluna}: {e}")
    
    return df

def tratar_textos(df):
    """Padronizar textos (uppercase, remover espaços)"""
    print("\nPadronizando textos...")
    
    colunas_texto = ['nome', 'Descricao', 'bairro', 'cidade', 'estado-civil']
    
    for coluna in colunas_texto:
        if coluna in df.columns:
            try:
                df[coluna] = df[coluna].astype(str).str.upper().str.strip()
                df[coluna] = df[coluna].replace(['NAN', 'NONE', 'NULO'], np.nan)
                print(f"✓ {coluna} -> padronizada")
            except Exception as e:
                print(f"✗ Erro em {coluna}: {e}")
    
    return df

def tratar_numeros(df):
    """Limpar e formatar números (CPF, CEP, telefones)"""
    print("\nFormatando números...")
    
    
    if 'cpf' in df.columns:
        df['cpf'] = df['cpf'].astype(str).str.replace(r'\D', '', regex=True)
        df['cpf'] = df['cpf'].str.zfill(11)  # Completa com zeros à esquerda
    
    
    if 'cep' in df.columns:
        df['cep'] = df['cep'].astype(str).str.replace(r'\D', '', regex=True)
        df['cep'] = df['cep'].str.zfill(8)  # Completa com zeros à esquerda
    
    
    for coluna in ['fone', 'celular']:
        if coluna in df.columns:
            df[coluna] = df[coluna].astype(str).str.replace(r'\D', '', regex=True)
    
    return df

def remover_duplicatas(df, coluna_chave='cpf'):
    """Remover registros duplicados baseado em CPF"""
    print("\nVerificando duplicatas...")
    
    if coluna_chave in df.columns:
        duplicatas = df.duplicated(subset=[coluna_chave], keep='first').sum()
        print(f"Registros duplicados por {coluna_chave}: {duplicatas}")
        
        if duplicatas > 0:
            df = df.drop_duplicates(subset=[coluna_chave], keep='first')
            print(f"Duplicatas removidas: {duplicatas}")
    
    return df


def processar_dataframe_completo(df):
    """Executa todos os tratamentos no DataFrame"""
    print("="*60)
    print("INICIANDO TRATAMENTO COMPLETO DO DATAFRAME")
    print("="*60)
    
    linhas_iniciais = len(df)
    print(f"Linhas iniciais: {linhas_iniciais}")
    
    
    df = limpar_linhas_em_branco(df)
    df = converter_tipos_para_sql_powerbi(df)
    df = tratar_datas(df)
    df = tratar_textos(df)
    df = tratar_numeros(df)
    df = remover_duplicatas(df)
    
    linhas_finais = len(df)
    print("\n" + "="*60)
    print("RESUMO DO TRATAMENTO")
    print("="*60)
    print(f"Linhas iniciais: {linhas_iniciais}")
    print(f"Linhas finais: {linhas_finais}")
    print(f"Linhas removidas: {linhas_iniciais - linhas_finais}")
    print(f"Taxa de retenção: {(linhas_finais/linhas_iniciais*100):.1f}%")
    
    return df


def main():
    caminho_arquivo = 'CLIENTES_SGA_BRUTO-CLIENTES.csv'  
    
    try:
       
        codificacao = detectar_codificacao(caminho_arquivo)
        print(f"Codificação detectada: {codificacao}")
        df = pd.read_csv(caminho_arquivo, encoding=codificacao)
        
       
        colunas_desejadas = [
            'codigo', 'cpf', 'nome', 'nascimento', 'Descricao', 
            'estado-civil', 'cep', 'bairro', 'cidade', 'uf', 
            'fone', 'celular', 'email', 'data-pri', 'data-ult', 
            'limite', 'sexo', 'Nro-Compras', 'Idade'
        ]
        
        
        colunas_existentes = [col for col in colunas_desejadas if col in df.columns]
        df_filtrado = df[colunas_existentes].copy()
        
        print(f"DataFrame inicial: {df_filtrado.shape}")
        
        
        df_tratado = processar_dataframe_completo(df_filtrado)
        
       
        print("\n" + "="*60)
        print("INFORMAÇÕES FINAIS DO DATAFRAME TRATADO")
        print("="*60)
        print(f"Shape: {df_tratado.shape}")
        print("\nTipos de dados:")
        print(df_tratado.dtypes)
        print("\nValores nulos:")
        print(df_tratado.isnull().sum())
        
       
        nome_arquivo_saida = 'clientes_tratados.csv'
        df_tratado.to_csv(nome_arquivo_saida, index=False, encoding='utf-8')
        print(f"\nArquivo salvo como: {nome_arquivo_saida}")
        
        
        print("\n" + "="*60)
        print("AMOSTRA DOS DADOS TRATADOS")
        print("="*60)
        pd.set_option('display.max_columns', None)
        print(df_tratado.head())
        
    except Exception as e:
        print(f"Erro: {e}")
        
        codificacoes = ['utf-8', 'latin-1', 'iso-8859-1', 'cp1252']
        for cod in codificacoes:
            try:
                df = pd.read_csv(caminho_arquivo, encoding=cod)
                print(f"Arquivo carregado com codificação: {cod}")
                break
            except:
                continue

if __name__ == "__main__":
    main()