PROC IMPORT OUT= WORK.house 
            DATAFILE= "C:\Study Files\SMU MSDS\DS 6371 Statistical Found
ations for Data Science\statistical-housing-price-analysis\Resources\tra
in.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
