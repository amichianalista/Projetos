import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random


np.random.seed(42)
random.seed(42)


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


end_date = datetime.now()
start_date = end_date - timedelta(days=90)
dates = pd.date_range(start=start_date, end=end_date, freq='D')


data = []
for date in dates:
    for page in pages:
       
        if page == '/':
            views = random.randint(500, 800)
            sessions = random.randint(450, 750)
            engaged_sessions = int(sessions * random.uniform(0.55, 0.70))
            avg_time = random.randint(45, 90)
            conversions = random.randint(8, 15)
        elif 'precatorios' in page:
            views = random.randint(200, 400)
            sessions = random.randint(180, 350)
            engaged_sessions = int(sessions * random.uniform(0.65, 0.80))
            avg_time = random.randint(120, 240)
            conversions = random.randint(12, 25)
        elif 'blog' in page:
            views = random.randint(100, 300)
            sessions = random.randint(90, 280)
            engaged_sessions = int(sessions * random.uniform(0.70, 0.85))
            avg_time = random.randint(150, 300)
            conversions = random.randint(5, 15)
        elif page in ['/contato', '/servicos']:
            views = random.randint(80, 150)
            sessions = random.randint(70, 140)
            engaged_sessions = int(sessions * random.uniform(0.75, 0.90))
            avg_time = random.randint(180, 350)
            conversions = random.randint(15, 30)
        else:
            views = random.randint(50, 120)
            sessions = random.randint(45, 110)
            engaged_sessions = int(sessions * random.uniform(0.60, 0.75))
            avg_time = random.randint(60, 150)
            conversions = random.randint(3, 10)
        
       
        engagement_rate = engaged_sessions / sessions if sessions > 0 else 0
        
        data.append({
            'date': date.strftime('%Y-%m-%d'),
            'page_path_and_screen_class': page,
            'views': views,
            'sessions': sessions,
            'engaged_sessions': engaged_sessions,
            'engagement_rate': engagement_rate,
            'average_engagement_time_per_session': avg_time,
            'conversions': conversions
        })


df_engagement = pd.DataFrame(data)


df_engagement_organic = df_engagement.copy()
for index, row in df_engagement_organic.iterrows():
    organic_ratio = random.uniform(0.4, 0.6)
    df_engagement_organic.at[index, 'sessions'] = int(row['sessions'] * organic_ratio)
    df_engagement_organic.at[index, 'engaged_sessions'] = int(row['engaged_sessions'] * organic_ratio)
    df_engagement_organic.at[index, 'views'] = int(row['views'] * organic_ratio)
    df_engagement_organic.at[index, 'conversions'] = int(row['conversions'] * organic_ratio)


df_engagement_organic['engagement_rate'] = df_engagement_organic['engaged_sessions'] / df_engagement_organic['sessions']
df_engagement_organic['engagement_rate'] = df_engagement_organic['engagement_rate'].fillna(0)


df_engagement_organic.to_csv('precavida_engagement_organic_report.csv', index=False)

print("Relatório de engajamento (tráfego orgânico) gerado com sucesso!")
print(f"Arquivo salvo: precavida_engagement_organic_report.csv")
print(f"Total de linhas: {len(df_engagement_organic)}")
print(f"Período: {start_date.strftime('%Y-%m-%d')} até {end_date.strftime('%Y-%m-%d')}")
print(f"Páginas incluídas: {len(pages)}")