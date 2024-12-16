#Question 1: Average Price per SKU

import pandas as pd

df = pd.read_csv('MAIN DE.csv')

df['Price'] = df['Price'].astype(float) 
avg_price_per_sku = df.groupby('SKU')['Price'].mean().reset_index()
print(avg_price_per_sku)


#Question 2: Country wise Number of unique products  being sold,  descending  order of unique products

unique_products_by_country = df.groupby('Country')['product'].nunique().sort_values(ascending=False)
print(unique_products_by_country)

'''
Question 3: Convert The given CSV to parquet, with two new columns
 column 1 ::    'currency' ,  populate the currency column with an appropriate value.
 column 2 ::    'unit of measure' ,  populate column with an appropriate value.
Dtypes for  Price  column should be Float, rest all string.
'''

df['currency'] = 'USD' 
df['unit_of_measure'] = 'pcs'  

df['Price'] = df['Price'].astype(float)

df.to_parquet('/mnt/data/MAIN DE.parquet', index=False)
