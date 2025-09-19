import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random


np.random.seed(42)  
random.seed(42)


channels = [
    'Organic Search', 
    'Direct', 
    'Social', 
    'Email', 
    'Paid Search',
    'Referral',
    'Display'
]


end_date = datetime.now()
start_date = end_date - timedelta(days=90)
dates = pd.date_range(start=start_date, end=end_date, freq='D')


data = []
for date in dates:
    for channel in channels:
        
        if channel == 'Organic Search':
            users = random.randint(80, 150)
            sessions = random.randint(users, users + 40)
            engagement_rate = random.uniform(0.65, 0.80)
            avg_engagement_time = random.randint(120, 200)
            conversions = random.randint(15, 30)
            revenue = random.randint(8000, 15000)
        elif channel == 'Direct':
            users = random.randint(40, 80)
            sessions = random.randint(users, users + 20)
            engagement_rate = random.uniform(0.55, 0.70)
            avg_engagement_time = random.randint(90, 150)
            conversions = random.randint(8, 20)
            revenue = random.randint(5000, 10000)
        elif channel == 'Social':
            users = random.randint(30, 60)
            sessions = random.randint(users, users + 15)
            engagement_rate = random.uniform(0.70, 0.85)
            avg_engagement_time = random.randint(150, 220)
            conversions = random.randint(5, 15)
            revenue = random.randint(1000, 4000)
        elif channel == 'Email':
            users = random.randint(20, 40)
            sessions = random.randint(users, users + 10)
            engagement_rate = random.uniform(0.72, 0.88)
            avg_engagement_time = random.randint(160, 230)
            conversions = random.randint(10, 25)
            revenue = random.randint(3000, 6000)
        elif channel == 'Paid Search':
            users = random.randint(15, 35)
            sessions = random.randint(users, users + 8)
            engagement_rate = random.uniform(0.58, 0.75)
            avg_engagement_time = random.randint(100, 170)
            conversions = random.randint(8, 18)
            revenue = random.randint(4000, 8000)
        else:  
            users = random.randint(10, 25)
            sessions = random.randint(users, users + 5)
            engagement_rate = random.uniform(0.50, 0.68)
            avg_engagement_time = random.randint(80, 140)
            conversions = random.randint(3, 10)
            revenue = random.randint(500, 2000)
        
        data.append({
            'date': date.strftime('%Y-%m-%d'),
            'first_user_default_channel_group': channel,
            'users': users,
            'sessions': sessions,
            'engagement_rate': engagement_rate,
            'average_engagement_time_per_session': avg_engagement_time,
            'conversions': conversions,
            'total_revenue': revenue
        })


df = pd.DataFrame(data)


df.to_csv('precavida_acquisition_report.csv', index=False)


summary = df.groupby('first_user_default_channel_group').agg({
    'users': 'sum',
    'sessions': 'sum',
    'engagement_rate': 'mean',
    'average_engagement_time_per_session': 'mean',
    'conversions': 'sum',
    'total_revenue': 'sum'
}).reset_index()


summary['conversion_rate'] = summary['conversions'] / summary['sessions']
summary['revenue_per_user'] = summary['total_revenue'] / summary['users']


summary.to_csv('precavida_acquisition_summary.csv', index=False)

print("Relatórios de aquisição gerados com sucesso!")
print("\nResumo por canal:")
print(summary.to_string(index=False))