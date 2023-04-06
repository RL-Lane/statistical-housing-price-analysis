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
