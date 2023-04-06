proc print data = house;
run;

data neighborhoods;
  set house;
  where Neighborhood in ("NAmes", "Edwards", "BrkSide");
run;

proc print data = neighborhoods;
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
run;

proc sgplot data = loghood;
scatter x=logarea y=logprice;
run;

proc glm data = loghood;
model logprice = logarea;
run;