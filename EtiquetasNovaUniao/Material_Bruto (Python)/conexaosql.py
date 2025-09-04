from sqlalchemy import create_engine, text
import pandas as pd

# Configurações de conexão
server = 'LAPTOP-K4ITNL6T'  
database = 'BDNOVAUNIAO'
driver = 'ODBC Driver 18 for SQL Server' 

# String de conexão com Autenticação do Windows
connection_string = f'mssql+pyodbc://@{server}/{database}?driver={driver}&trusted_connection=yes'

# Criar engine
engine = create_engine(connection_string)

def testar_conexao():
    """Testa a conexão com o banco de dados"""
    try:
        with engine.connect() as conn:
            print("✅ Conexão bem-sucedida!")
            
            # Testar consultas básicas
            result = conn.execute(text("SELECT @@VERSION AS version"))
            version = result.scalar()
            print(f"📋 Versão do SQL Server: {version}")
            
            # Ver database atual
            result = conn.execute(text("SELECT DB_NAME() AS current_database"))
            db_name = result.scalar()
            print(f"🗄️ Database conectado: {db_name}")
            
            # Ver usuário atual
            result = conn.execute(text("SELECT SUSER_NAME() AS current_user"))
            user = result.scalar()
            print(f"👤 Usuário: {user}")
            
            return True
            
    except Exception as e:
        print(f"❌ Erro na conexão: {e}")
        return False

def listar_tabelas():
    """Lista todas as tabelas do database"""
    try:
        with engine.connect() as conn:
            query = text("""
                SELECT TABLE_NAME 
                FROM INFORMATION_SCHEMA.TABLES 
                WHERE TABLE_TYPE = 'BASE TABLE'
                ORDER BY TABLE_NAME
            """)
            result = conn.execute(query)
            tabelas = [row[0] for row in result]
            
            print("\n📊 Tabelas disponíveis:")
            for tabela in tabelas:
                print(f"  - {tabela}")
                
            return tabelas
            
    except Exception as e:
        print(f"Erro ao listar tabelas: {e}")
        return []

def consulta_exemplo():
    """Exemplo de consulta para testar"""
    try:
        with engine.connect() as conn:
            # Consulta exemplo - ajuste conforme suas tabelas
            query = text("SELECT TOP 5 * FROM INFORMATION_SCHEMA.TABLES")
            result = conn.execute(query)
            
            # Converter para DataFrame do pandas
            df = pd.DataFrame(result.fetchall(), columns=result.keys())
            
            print("\n🔍 Exemplo de consulta (primeiras 5 linhas):")
            print(df)
            
            return df
            
    except Exception as e:
        print(f"Erro na consulta: {e}")
        return None

# Executar teste de conexão
if __name__ == "__main__":
    print("🔗 Testando conexão com SQL Server...")
    print(f"📡 Servidor: {server}")
    print(f"🗃️ Database: {database}")
    print("─" * 50)
    
    if testar_conexao():
        listar_tabelas()
        consulta_exemplo()
        
        print("\n🎉 Conexão e consultas realizadas com sucesso!")
    else:
        print("\n💡 Dicas para solucionar problemas:")
        print("1. Verifique se o SQL Server está rodando")
        print("2. Confirme o nome do servidor")
        print("3. Certifique-se de ter o ODBC Driver 18 instalado")
        print("4. Verifique suas permissões no banco de dados")