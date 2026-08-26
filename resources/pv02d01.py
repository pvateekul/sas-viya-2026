# Import packages
import pandas as pd
pd.set_option('display.max_columns', 20)

# Create a DataFrame from the sashelp.cars table
df_raw = SAS.sd2df('sashelp.cars')

# Prepare the DataFrame using pandas
df = (df_raw
	  .drop(['Type', 'Origin','DriveTrain'], axis=1)
      .assign(MPG_Avg = df_raw[['MPG_City','MPG_Highway']].mean(axis = 1)))

# Preview the new DataFrame
print(df.head())

# Create a SAS table in the work library from the DataFrame
SAS.df2sd(df, 'work.python_cars')