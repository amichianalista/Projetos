import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

np.random.seed(42)
random.seed(42)

# Lista completa de páginas para cruzar com o SQL Server
pages = [
    '/',
    '/precatorios',
    '/precatorios/como-receber',
    '/precatorios/tipos',
    '/precatorios/calculadora',
    '/blog',
    '/blog/o-que-sao-precatorios',
    '/blog/direitos-precatórios',
    '/blog/leis-precatorias',
    '/contato',
    '/sobre',
    '/servicos',
    '/servicos/consultoria',
    '/servicos/advocacia',
    '/casos-de-sucesso',
    '/duvidas-frequentes'
]

keywords = [
    'precatórios',
    'o que são precatórios',
    'como receber precatórios',
    'precatórios união',
    'precatórios estaduais',
    'precatórios municipais',
    'direitos precatórios',
    'leis precatórias',
    'calculadora precatórios',
    'consultoria precatórios',
    'advogado precatórios',
    'precatórios como funciona',
    'precatórios tempo recebimento',
    'precatórios valor',
    'precatórios tributários',
    'precatórios alimentares',
    'precavida precatórios',
    'precatórios dívida pública',
    'precatórios precavida',
    'simular precatórios'
]

end_date = datetime.now()
start_date = end_date - timedelta(days=90)
dates = pd.date_range(start=start_date, end=end_date, freq='D')

data = []
for date in dates:
    for page in pages:
        # Seleciona 5 keywords aleatórias para cada página por dia
        for keyword in random.sample(keywords, 5):  
            # Define base de impressões baseada no tipo de página
            if page == '/':
                impressions_base = random.randint(800, 1200)
            elif '/precatorios' in page:
                impressions_base = random.randint(300, 600)
            elif '/blog' in page:
                impressions_base = random.randint(200, 400)
            else:
                impressions_base = random.randint(100, 250)
            
            # Ajusta impressões baseadas na keyword
            if 'precatório' in keyword.lower() or 'precavida' in keyword.lower():
                impressions = int(impressions_base * random.uniform(1.2, 1.5))
            else:
                impressions = int(impressions_base * random.uniform(0.7, 1.0))
            
            # Define posição e CTR baseados na keyword
            if 'precatório' in keyword.lower():
                position = random.uniform(2.5, 5.0)
                ctr = random.uniform(0.08, 0.15)
            elif 'precavida' in keyword.lower():
                position = random.uniform(1.5, 3.5)
                ctr = random.uniform(0.12, 0.20)
            else:
                position = random.uniform(5.0, 8.0)
                ctr = random.uniform(0.03, 0.08)
            
            clicks = int(impressions * ctr)
            
            data.append({
                'date': date.strftime('%Y-%m-%d'),
                'query': keyword,
                'page': f'https://precavida.com.br{page}',
                'impressions': impressions,
                'clicks': clicks,
                'ctr': ctr,
                'position': round(position, 1)
            })

df_search_console = pd.DataFrame(data)

# Salva o CSV
df_search_console.to_csv('precavida_search_console_report.csv', index=False)

print("Relatório do Search Console gerado com sucesso!")
print(f"Arquivo salvo: precavida_search_console_report.csv")
print(f"Total de linhas: {len(df_search_console)}")
print(f"Período: {start_date.strftime('%Y-%m-%d')} até {end_date.strftime('%Y-%m-%d')}")
print(f"Páginas incluídas: {len(pages)}")
print(f"Keywords incluídas: {len(keywords)}")
print(f"Média de keywords por página por dia: 5")
print("\n📋 Páginas incluídas no relatório:")
for i, page in enumerate(pages, 1):
    print(f"  {i}. {page}")