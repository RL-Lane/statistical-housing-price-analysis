PROC EXPORT DATA= WORK.RESULTS2 
            OUTFILE= "C:\Study Files\SMU MSDS\DS 6371 Statistical Founda
tions for Data Science\statistical-housing-price-analysis\test-model.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
