import pandas as pd
import pyodbc
from sqlalchemy import create_engine, types
import urllib.parse
import numpy as np

# 1. CONFIGURAÇÃO DA CONEXÃO COM SQL SERVER
print("Configurando conexão com SQL Server...")

# Configurações de conexão
server = 'LAPTOP-K4ITNL6T'
database = 'DB_PRECAVIDA'
username = 'Hugo Amichi'
password = ''

# String de conexão para autenticação do Windows
connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;'

try:
    conn = pyodbc.connect(connection_string)
    print("✅ Conexão com SQL Server bem-sucedida!")
    conn.close()
except Exception as e:
    print(f"❌ Erro na conexão: {e}")
    exit()

# 2. CARREGAR OS ARQUIVOS CSV
print("\nCarregando arquivos CSV...")

try:
    acquisition_df = pd.read_csv('precavida_acquisition_report.csv')
    print(f"✅ Acquisition data: {acquisition_df.shape[0]} linhas, {acquisition_df.shape[1]} colunas")
except FileNotFoundError:
    print("❌ Arquivo precavida_acquisition_report.csv não encontrado")
    acquisition_df = None

try:
    engagement_df = pd.read_csv('precavida_engagement_organic_report.csv')
    print(f"✅ Engagement organic data: {engagement_df.shape[0]} linhas, {engagement_df.shape[1]} colunas")
except FileNotFoundError:
    print("❌ Arquivo precavida_engagement_organic_report.csv não encontrado")
    engagement_df = None

# NOVO: Carregar dados do Search Console
try:
    search_console_df = pd.read_csv('precavida_search_console_report.csv')
    print(f"✅ Search Console data: {search_console_df.shape[0]} linhas, {search_console_df.shape[1]} colunas")
except FileNotFoundError:
    print("❌ Arquivo precavida_search_console_report.csv não encontrado")
    search_console_df = None

# 3. PREPARAR DADOS PARA IMPORTação
def prepare_dataframe(df, table_name):
    """Prepara o dataframe para importação no SQL Server"""
    if df is None:
        return None
    
    # Remove colunas com problemas
    df = df.loc[:, ~df.columns.str.contains('^Unnamed')]
    
    # Converte tipos de dados e trata valores NaN
    for col in df.columns:
        if df[col].dtype == 'object':
            df[col] = df[col].fillna('')
        elif 'date' in col.lower():
            df[col] = pd.to_datetime(df[col], errors='coerce')
        elif df[col].dtype in ['float64', 'int64']:
            df[col] = df[col].fillna(0)
    
    print(f"📊 {table_name}: {len(df)} registros preparados")
    return df

if acquisition_df is not None:
    acquisition_df = prepare_dataframe(acquisition_df, 'Acquisition Report')
if engagement_df is not None:
    engagement_df = prepare_dataframe(engagement_df, 'Engagement Organic Report')
if search_console_df is not None:
    search_console_df = prepare_dataframe(search_console_df, 'Search Console Report')

# 4. CONEXÃO COM SQLALCHEMY
print("\nConectando ao banco de dados para importação...")
params = urllib.parse.quote_plus(connection_string)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# 5. FUNÇÃO DE IMPORTação MELHORADA
def import_to_sql_chunked(df, table_name, engine, chunksize=100):
    """Importa dataframe para SQL Server em chunks menores"""
    try:
        if df is None or df.empty:
            return False
        
        total_rows = len(df)
        chunks = range(0, total_rows, chunksize)
        
        print(f"📦 Importando {total_rows} registros em chunks de {chunksize}...")
        
        for i, start in enumerate(chunks):
            end = min(start + chunksize, total_rows)
            chunk_df = df.iloc[start:end]
            
            # Converte NaN para None (SQL NULL)
            chunk_df = chunk_df.replace({np.nan: None})
            
            chunk_df.to_sql(
                name=table_name,
                con=engine,
                if_exists='append' if i > 0 else 'replace',
                index=False,
                method=None  # Usa método padrão, não multi
            )
            
            print(f"   ✅ Chunk {i+1}: registros {start+1}-{end} importados")
        
        print(f"🎉 {table_name} importado com sucesso!")
        return True
        
    except Exception as e:
        print(f"❌ Erro ao importar {table_name}: {str(e)[:200]}...")
        return False

# 6. IMPORTAR DADOS
print("\nIniciando importação para SQL Server...")

success_acquisition = False
success_engagement = False
success_search_console = False  # NOVA variável para Search Console

if acquisition_df is not None:
    print("\n📊 IMPORTANDO ACQUISITION REPORT...")
    success_acquisition = import_to_sql_chunked(acquisition_df, 'GA4_Acquisition_Report', engine, chunksize=50)

if engagement_df is not None:
    print("\n📊 IMPORTANDO ENGAGEMENT ORGANIC REPORT...")
    success_engagement = import_to_sql_chunked(engagement_df, 'GA4_Engagement_Organic_Report', engine, chunksize=100)

# NOVO: Importar dados do Search Console
if search_console_df is not None:
    print("\n📊 IMPORTANDO SEARCH CONSOLE REPORT...")
    success_search_console = import_to_sql_chunked(search_console_df, 'Search_Console_Report', engine, chunksize=150)

# 7. RELATÓRIO FINAL
print("\n" + "="*50)
print("RELATÓRIO DE IMPORTação")
print("="*50)

if success_acquisition or success_engagement or success_search_console:
    print("✅ Importação concluída com sucesso!")
    
    try:
        conn = pyodbc.connect(connection_string)
        cursor = conn.cursor()
        
        if success_acquisition:
            cursor.execute("SELECT COUNT(*) FROM GA4_Acquisition_Report")
            count_acq = cursor.fetchone()[0]
            print(f"📊 GA4_Acquisition_Report: {count_acq} registros")
        
        if success_engagement:
            cursor.execute("SELECT COUNT(*) FROM GA4_Engagement_Organic_Report")
            count_engagement = cursor.fetchone()[0]
            print(f"📊 GA4_Engagement_Organic_Report: {count_engagement} registros")
        
        # NOVO: Verificar contagem do Search Console
        if success_search_console:
            cursor.execute("SELECT COUNT(*) FROM Search_Console_Report")
            count_search_console = cursor.fetchone()[0]
            print(f"📊 Search_Console_Report: {count_search_console} registros")
            
        conn.close()
        
    except Exception as e:
        print(f"ℹ️ Não foi possível verificar contagens: {e}")
        
else:
    print("❌ Importação falhou para todos os arquivos")

print("\n🐛 PARA DEBUG: Verifique se as tabelas foram criadas no SQL Server Management Studio")
print("💡 DICA: Execute 'SELECT TOP 5 * FROM GA4_Acquisition_Report' para testar")
print("💡 DICA: Execute 'SELECT TOP 5 * FROM GA4_Engagement_Organic_Report' para testar")
print("💡 DICA: Execute 'SELECT TOP 5 * FROM Search_Console_Report' para testar o relatório do Search Console")  # NOVA dica
print("\n🔗 PARA CRUZAMENTO: Use a coluna 'page' para cruzar com outras tabelas")