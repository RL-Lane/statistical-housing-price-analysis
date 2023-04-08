PROC IMPORT OUT= WORK.house 
            DATAFILE= "C:\Study Files\SMU MSDS\DS 6371 Statistical Foundations for Data Science\statistical-housing-price-analysis\Resources\train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


proc print data = house;
run;

/*Select only the 3 neighborhoods of interest*/
data neighborhoods;
  set house;
  where Neighborhood in ("NAmes", "Edwards", "BrkSide");
run;

/*Check for linearity and multivariate normality*/
proc sgscatter data = neighborhoods;
matrix SalePrice  GrLivArea / diagonal=(histogram kernel);
run;


proc print data = neighborhoods;
run;

proc sgscatter data = loghood;
matrix logprice logarea / diagonal=(histogram kernel);
run;

proc glm data = neighborhoods;
model SalePrice = GrLivArea;
run;

proc sgplot data = neighborhoods;
scatter x=GrLivArea y=SalePrice;
run;

data loghood;
set neighborhoods;
logprice = log(SalePrice);
logarea = log(GrLivArea);
BrkSide = (Neighborhood = "BrkSide");
NAmes = (Neighborhood = "NAmes");
run;

proc print data = loghood;
run;

proc sgplot data = loghood;
scatter x=logarea y=logprice;
run;

proc glm data = loghood;
model logprice = logarea;
run;

proc sgscatter data = loghood;
matrix logprice logarea / diagonal=(histogram kernel);
run;

/*Residual Analysis*/
proc reg data = loghood
		plots = (DiagnosticsPanel ResidualPlot(smooth));
	model logprice = logarea BrkSide NAmes;
quit;

/*
Durbin-Watson test for autocorrelation
http://documentation.sas.com/doc/en/pgmsascdc/9.4_3.4/statug/statug_reg_details33.htm
*/
proc reg data = loghood;
	model logprice = logarea BrkSide NAmes / dwProb;
run;

/*
Include info on high-leverage nad outlier values
https://blogs.sas.com/content/iml/2021/03/29/influential-obs-regression.html
*/
proc reg data = loghood plots(only label) = (CooksD RStudentByLeverage);
	model logprice = logarea BrkSide NAmes;
run;

/*View specific observations*/
data temp;
    set loghood;
    if _n_ in (339, 186, 136);
	keep SalePrice  GrLivArea logprice logarea BrkSide NAmes;
run;

proc print data=temp;
run;


data loghood2;
	set loghood;
	if _n_ in (339, 136) then delete;
run;


proc glm data=loghood2;
	class BrkSide NAmes;
	model logprice = logarea BrkSide NAmes logarea*BrkSide logarea*NAmes / solution;
	means BrkSide NAmes / hovtest=0;
	output out=glm_out p=pred r=resid student=rstudent;
	output out=diagnostics residual=residual;
run;
