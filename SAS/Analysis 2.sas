

/*Analysis 2*/
PROC IMPORT OUT= WORK.house 
            DATAFILE= "C:\Study Files\SMU MSDS\DS 6371 Statistical Foundations for Data Science\statistical-housing-price-analysis\Resources\train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.housetest 
            DATAFILE= "C:\Study Files\SMU MSDS\DS 6371 Statistical Foundations for Data Science\statistical-housing-price-analysis\Resources\test.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data housetest;
set housetest;
SalePrice = .;
logprice = .;
;

data loghouse;
set house housetest;
logprice = log(SalePrice);
logarea = log(GrLivArea);
loglotarea = log(LotArea);
run;

proc print data = loghouse(obs=5);
run;

data logselection;
   set loghouse (keep=id logprice logarea SalePrice GrLivArea LotArea BldgType
                    Street Alley LotShape LandContour Neighborhood HouseStyle
                    OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl
                    Exterior1st Foundation BsmtQual BsmtCond TotalBsmtSF
                    Heating HeatingQC CentralAir FullBath HalfBath BedroomAbvGr
                    KitchenAbvGr TotRmsAbvGrd Fireplaces GarageType GarageCars
                    PavedDrive WoodDeckSF OpenPorchSF YrSold loglotarea
					BsmtFinSF1 BsmtFinSF2);
run;

/* Street Alley LotShape LandContour Neighborhood BldgType
	HouseStyle RoofStyle RoofMatl Exterior1st Foundation BsmtQual 
	BsmtCond Heating HeatingQC CentralAir 
GarageType PavedDrive*/

data house_log_dummies;
	set logselection;
	if Street = "Pave" then StreetPave = 1; else StreetPave = 0;

	if Alley = "Pave" then AlleyPave = 1; else AlleyPave = 0;
	if Alley = "Grvl" then AlleyGrvl = 1; else AlleyGrvl = 0;

	if LotShape = "IR1" then LotShapeIR1 = 1; else LotShapeIR1 = 0;
	if LotShape = "IR2" then LotShapeIR2 = 1; else LotShapeIR2 = 0;
	if LotShape = "IR3" then LotShapeIR3 = 1; else LotShapeIR3 = 0;
		
	if	LandContour	="Low"	then	LandContourLow	=1;	else	LandContourLow	=0;
	if	LandContour	="Bnk"	then	LandContourBnk	=1;	else	LandContourBnk	=0;
	if	LandContour	="Lvl"	then	LandContourLvl	=1;	else	LandContourLvl	=0;

	if	Neighborhood	="BrkSide"	then	NeighborhoodBrkSide	=1;	else	NeighborhoodBrkSide	=0;
	if	Neighborhood	="SWISU"	then	NeighborhoodSWISU	=1;	else	NeighborhoodSWISU	=0;
	if	Neighborhood	="IDOTRR"	then	NeighborhoodIDOTRR	=1;	else	NeighborhoodIDOTRR	=0;
	if	Neighborhood	="Edwards"	then	NeighborhoodEdwards	=1;	else	NeighborhoodEdwards	=0;
	if	Neighborhood	="MeadowV"	then	NeighborhoodMeadowV	=1;	else	NeighborhoodMeadowV	=0;
	if	Neighborhood	="Sawyer"	then	NeighborhoodSawyer	=1;	else	NeighborhoodSawyer	=0;
	if	Neighborhood	="OldTown"	then	NeighborhoodOldTown	=1;	else	NeighborhoodOldTown	=0;
	if	Neighborhood	="Crawfor"	then	NeighborhoodCrawfor	=1;	else	NeighborhoodCrawfor	=0;
	if	Neighborhood	="SawyerW"	then	NeighborhoodSawyerW	=1;	else	NeighborhoodSawyerW	=0;
	if	Neighborhood	="NAmes"	then	NeighborhoodNAmes	=1;	else	NeighborhoodNAmes	=0;
	if	Neighborhood	="Mitchel"	then	NeighborhoodMitchel	=1;	else	NeighborhoodMitchel	=0;
	if	Neighborhood	="CollgCr"	then	NeighborhoodCollgCr	=1;	else	NeighborhoodCollgCr	=0;
	if	Neighborhood	="Gilbert"	then	NeighborhoodGilbert	=1;	else	NeighborhoodGilbert	=0;
	if	Neighborhood	="NPkVill"	then	NeighborhoodNPkVill	=1;	else	NeighborhoodNPkVill	=0;
	if	Neighborhood	="BrDale"	then	NeighborhoodBrDale	=1;	else	NeighborhoodBrDale	=0;
	if	Neighborhood	="ClearCr"	then	NeighborhoodClearCr	=1;	else	NeighborhoodClearCr	=0;
	if	Neighborhood	="NWAmes"	then	NeighborhoodNWAmes	=1;	else	NeighborhoodNWAmes	=0;
	if	Neighborhood	="StoneBr"	then	NeighborhoodStoneBr	=1;	else	NeighborhoodStoneBr	=0;
	if	Neighborhood	="Somerst"	then	NeighborhoodSomerst	=1;	else	NeighborhoodSomerst	=0;
	if	Neighborhood	="Timber"	then	NeighborhoodTimber	=1;	else	NeighborhoodTimber	=0;
	if	Neighborhood	="Blmngtn"	then	NeighborhoodBlmngtn	=1;	else	NeighborhoodBlmngtn	=0;
	if	Neighborhood	="Veenker"	then	NeighborhoodVeenker	=1;	else	NeighborhoodVeenker	=0;
	if	Neighborhood	="Blueste"	then	NeighborhoodBlueste	=1;	else	NeighborhoodBlueste	=0;
	if	Neighborhood	="NridgHt"	then	NeighborhoodNridgHt	=1;	else	NeighborhoodNridgHt	=0;

	if	BldgType	="1Fam"	then	BldgType1Fam	=1;	else	BldgType1Fam	=0;
	if	BldgType	="Twnhs"	then	BldgTypeTwnhs	=1;	else	BldgTypeTwnhs	=0;
	if	BldgType	="TwnhsE"	then	BldgTypeTwnhsE	=1;	else	BldgTypeTwnhsE	=0;
	if	BldgType	="2fmCon"	then	BldgType2fmCon	=1;	else	BldgType2fmCon	=0;

	if	HouseStyle	="1Story"	then	HouseStyle1Story	=1;	else	HouseStyle1Story	=0;
	if	HouseStyle	="SFoyer"	then	HouseStyleSFoyer	=1;	else	HouseStyleSFoyer	=0;
	if	HouseStyle	="1.5Fin"	then	HouseStyle15Fin	=1;	else	HouseStyle15Fin	=0;
	if	HouseStyle	="1.5Unf"	then	HouseStyle15Unf	=1;	else	HouseStyle15Unf	=0;
	if	HouseStyle	="SLvl"	then	HouseStyleSLvl	=1;	else	HouseStyleSLvl	=0;
	if	HouseStyle	="2Story"	then	HouseStyle2Story	=1;	else	HouseStyle2Story	=0;
	if	HouseStyle	="2.5Unf"	then	HouseStyle25Unf	=1;	else	HouseStyle25Unf	=0;

	if	RoofStyle	="Gable"	then	RoofStyleGable	=1;	else	RoofStyleGable	=0;
	if	RoofStyle	="Hip"	then	RoofStyleHip	=1;	else	RoofStyleHip	=0;
	if	RoofStyle	="Flat"	then	RoofStyleFlat	=1;	else	RoofStyleFlat	=0;
	if	RoofStyle	="Mansard"	then	RoofStyleMansard	=1;	else	RoofStyleMansard	=0;
	if	RoofStyle	="Gambrel"	then	RoofStyleGambrel	=1;	else	RoofStyleGambrel	=0;

	if	RoofMatl	="CompShg"	then	RoofMatlCompShg	=1;	else	RoofMatlCompShg	=0;
	if	RoofMatl	="ClyTile"	then	RoofMatlClyTile	=1;	else	RoofMatlClyTile	=0;
	if	RoofMatl	="Metal"	then	RoofMatlMetal	=1;	else	RoofMatlMetal	=0;
	if	RoofMatl	="WdShngl"	then	RoofMatlWdShngl	=1;	else	RoofMatlWdShngl	=0;
	if	RoofMatl	="Membran"	then	RoofMatlMembran	=1;	else	RoofMatlMembran	=0;
	if	RoofMatl	="WdShake"	then	RoofMatlWdShake	=1;	else	RoofMatlWdShake	=0;
	if	RoofMatl	="Roll"	then	RoofMatlRoll	=1;	else	RoofMatlRoll	=0;

	if	Exterior1st	="VinylSd"	then	Exterior1stVinylSd	=1;	else	Exterior1stVinylSd	=0;
	if	Exterior1st	="Wd Sdng"	then	Exterior1stWdSdng	=1;	else	Exterior1stWdSdng	=0;
	if	Exterior1st	="AsbShng"	then	Exterior1stAsbShng	=1;	else	Exterior1stAsbShng	=0;
	if	Exterior1st	="MetalSd"	then	Exterior1stMetalSd	=1;	else	Exterior1stMetalSd	=0;
	if	Exterior1st	="CemntBd"	then	Exterior1stCemntBd	=1;	else	Exterior1stCemntBd	=0;
	if	Exterior1st	="WdShing"	then	Exterior1stWdShing	=1;	else	Exterior1stWdShing	=0;
	if	Exterior1st	="Plywood"	then	Exterior1stPlywood	=1;	else	Exterior1stPlywood	=0;
	if	Exterior1st	="HdBoard"	then	Exterior1stHdBoard	=1;	else	Exterior1stHdBoard	=0;
	if	Exterior1st	="Stucco"	then	Exterior1stStucco	=1;	else	Exterior1stStucco	=0;
	if	Exterior1st	="BrkFace"	then	Exterior1stBrkFace	=1;	else	Exterior1stBrkFace	=0;
	if	Exterior1st	="BrkComm"	then	Exterior1stBrkComm	=1;	else	Exterior1stBrkComm	=0;
	if	Exterior1st	="CBlock"	then	Exterior1stCBlock	=1;	else	Exterior1stCBlock	=0;
	if	Exterior1st	="ImStucc"	then	Exterior1stImStucc	=1;	else	Exterior1stImStucc	=0;
	if	Exterior1st	="AsphShn"	then	Exterior1stAsphShn	=1;	else	Exterior1stAsphShn	=0;

	if	Foundation	="Slab"	then	FoundationSlab	=1;	else	FoundationSlab	=0;
	if	Foundation	="CBlock"	then	FoundationCBlock	=1;	else	FoundationCBlock	=0;
	if	Foundation	="BrkTil"	then	FoundationBrkTil	=1;	else	FoundationBrkTil	=0;
	if	Foundation	="PConc"	then	FoundationPConc	=1;	else	FoundationPConc	=0;
	if	Foundation	="Stone"	then	FoundationStone	=1;	else	FoundationStone	=0;

	if	BsmtQual	="Ex"	then	BsmtQualEx	=1;	else	BsmtQualEx	=0;
	if	BsmtQual	="TA"	then	BsmtQualTA	=1;	else	BsmtQualTA	=0;
	if	BsmtQual	="Gd"	then	BsmtQualGd	=1;	else	BsmtQualGd	=0;
	if	BsmtQual	="Fa"	then	BsmtQualFa	=1;	else	BsmtQualFa	=0;


	if	BsmtCond	="Ta"	then	BsmtCondTa	=1;	else	BsmtCondTa	=0;
	if	BsmtCond	="Fa"	then	BsmtCondFa	=1;	else	BsmtCondFa	=0;
	if	BsmtCond	="TA"	then	BsmtCondTA	=1;	else	BsmtCondTA	=0;
	if	BsmtCond	="Gd"	then	BsmtCondGd	=1;	else	BsmtCondGd	=0;

	if	Heating	="GasA"	then	HeatingGasA	=1;	else	HeatingGasA	=0;
	if	Heating	="Grav"	then	HeatingGrav	=1;	else	HeatingGrav	=0;
	if	Heating	="Floor"	then	HeatingFloor	=1;	else	HeatingFloor	=0;
	if	Heating	="GasW"	then	HeatingGasW	=1;	else	HeatingGasW	=0;
	if	Heating	="Wall"	then	HeatingWall	=1;	else	HeatingWall	=0;

	if	HeatingQC	="Fa"	then	HeatingQCFa	=1;	else	HeatingQCFa	=0;
	if	HeatingQC	="TA"	then	HeatingQCTA	=1;	else	HeatingQCTA	=0;
	if	HeatingQC	="Ex"	then	HeatingQCEx	=1;	else	HeatingQCEx	=0;
	if	HeatingQC	="Gd"	then	HeatingQCGd	=1;	else	HeatingQCGd	=0;

	if	CentralAir	="Y"	then	CentralAirY	=1;	else	CentralAirY	=0;

	if	GarageType	="2Types"	then	GarageType2Types	=1;	else	GarageType2Types	=0;
	if	GarageType	="Detchd"	then	GarageTypeDetchd	=1;	else	GarageTypeDetchd	=0;
	if	GarageType	="Attchd"	then	GarageTypeAttchd	=1;	else	GarageTypeAttchd	=0;
	if	GarageType	="CarPort"	then	GarageTypeCarPort	=1;	else	GarageTypeCarPort	=0;
	if	GarageType	="Basment"	then	GarageTypeBasment	=1;	else	GarageTypeBasment	=0;
	if	GarageType	="BuiltIn"	then	GarageTypeBuiltIn	=1;	else	GarageTypeBuiltIn	=0;

	if	PavedDrive	="P"	then	PavedDriveP	=1;	else	PavedDriveP	=0;
	if	PavedDrive	="Y"	then	PavedDriveY	=1;	else	PavedDriveY	=0;

run;

data drop_text_cats;
	set house_log_dummies(drop=Street Alley LotShape LandContour Neighborhood HouseStyle
	RoofStyle RoofMatl Exterior1st Foundation BsmtQual BsmtCond Heating HeatingQC 
	CentralAir GarageType PavedDrive);
run;

proc print data=drop_text_cats(obs=5);
run;

data selectionnocategories;
set logselection (drop=Street Alley LotShape LandContour Neighborhood HouseStyle
	RoofStyle RoofMatl Exterior1st Foundation BsmtQual BsmtCond Heating HeatingQC 
	CentralAir GarageType PavedDrive);
run;

proc print data=selectionnocategories(obs=5);
run;

/*
data class:
	Street Alley LotShape LandContour Neighborhood BldgType
	HouseStyle RoofStyle RoofMatl Exterior1st Foundation BsmtQual 
	BsmtCond BsmtFinSF1 BsmtFinSF2 Heating HeatingQC CentralAir 
	GarageType PavedDrive
*/

/*These trials run the model without any text class variables*/

proc glmselect data = logselection;
model logprice = logarea loglotarea OverallQual OverallCond YearBuilt YearRemodAdd 
	BsmtFinSF1 BsmtFinSF2  FullBath HalfBath BedroomAbvGr KitchenAbvGr 
	TotRmsAbvGrd Fireplaces GarageCars WoodDeckSF OpenPorchSF YrSold 
	YrSold*YearBuilt logarea*loglotarea / selection = Forward(stop = CV) cvmethod=random(5) stats = adjrsq;
run;

proc glmselect data = logselection;
model logprice = logarea loglotarea OverallQual OverallCond YearBuilt YearRemodAdd 
	BsmtFinSF1 BsmtFinSF2 FullBath HalfBath BedroomAbvGr KitchenAbvGr 
	TotRmsAbvGrd Fireplaces GarageCars WoodDeckSF OpenPorchSF YrSold 
	YrSold*YearBuilt logarea*loglotarea / selection = Backward(stop = CV) cvmethod=random(5) stats = adjrsq;
run;

proc glmselect data = logselection;
model logprice = logarea loglotarea OverallQual OverallCond YearBuilt YearRemodAdd 
	BsmtFinSF1 BsmtFinSF2  FullBath HalfBath BedroomAbvGr KitchenAbvGr 
	TotRmsAbvGrd Fireplaces GarageCars WoodDeckSF OpenPorchSF YrSold 
	YrSold*YearBuilt logarea*loglotarea / selection = Stepwise(stop = CV) cvmethod=random(5) stats = adjrsq;
run;

proc glm data = selectionnocategories;
	model logprice = logarea loglotarea logarea*loglotarea BedroomAbvGr	BldgType	BsmtFinSF1	BsmtFinSF2	Fireplaces	FullBath	GarageCars		HalfBath		KitchenAbvGr	LotArea	OpenPorchSF	OverallCond	OverallQual	TotRmsAbvGrd	TotalBsmtSF	WoodDeckSF	YearBuilt	YearRemodAdd	YrSold;
run;

/*Typical R2 is around 0.87*/





	


proc glmselect data = drop_text_cats;
    model logprice = logarea loglotarea OverallQual OverallCond YearBuilt YearRemodAdd 
	BsmtFinSF1 BsmtFinSF2 GrLivArea FullBath HalfBath BedroomAbvGr KitchenAbvGr 
	TotRmsAbvGrd Fireplaces GarageCars WoodDeckSF OpenPorchSF YrSold 
	YrSold*YearBuilt logarea*loglotarea
	StreetPave	AlleyPave	AlleyGrvl	LotShapeIR1	LotShapeIR2	LotShapeIR3	LandContourLow	
	LandContourBnk	LandContourLvl	NeighborhoodBrkSide	NeighborhoodSWISU	NeighborhoodIDOTRR	
	NeighborhoodEdwards	NeighborhoodMeadowV	NeighborhoodSawyer	NeighborhoodOldTown	
	NeighborhoodCrawfor	NeighborhoodSawyerW	NeighborhoodNAmes	NeighborhoodMitchel	
	NeighborhoodCollgCr	NeighborhoodGilbert	NeighborhoodNPkVill	NeighborhoodBrDale	
	NeighborhoodClearCr	NeighborhoodNWAmes	NeighborhoodStoneBr	NeighborhoodSomerst	
	NeighborhoodTimber	NeighborhoodBlmngtn	NeighborhoodVeenker	NeighborhoodBlueste	
	NeighborhoodNridgHt	BldgType1Fam	BldgTypeTwnhs	BldgTypeTwnhsE	BldgType2fmCon	
	HouseStyle1Story	HouseStyleSFoyer	HouseStyle15Fin	HouseStyle15Unf	HouseStyleSLvl	
	HouseStyle2Story	HouseStyle25Unf	RoofStyleGable	RoofStyleHip	RoofStyleFlat	
	RoofStyleMansard	RoofStyleGambrel	RoofMatlCompShg	RoofMatlClyTile	RoofMatlMetal	
	RoofMatlWdShngl	RoofMatlMembran	RoofMatlWdShake	RoofMatlRoll	Exterior1stVinylSd	
	Exterior1stWdSdng	Exterior1stAsbShng	Exterior1stMetalSd	Exterior1stCemntBd	
	Exterior1stWdShing	Exterior1stPlywood	Exterior1stHdBoard	Exterior1stStucco	
	Exterior1stBrkFace	Exterior1stBrkComm	Exterior1stCBlock	Exterior1stImStucc	
	Exterior1stAsphShn	FoundationSlab	FoundationCBlock	FoundationBrkTil	
	FoundationPConc	FoundationStone	BsmtQualEx	BsmtQualTA	BsmtQualGd	BsmtQualFa	
	BsmtCondTa	BsmtCondFa	BsmtCondTA	BsmtCondGd	HeatingGasA	HeatingGrav	HeatingFloor	
	HeatingGasW	HeatingWall	HeatingQCFa	HeatingQCTA	HeatingQCEx	HeatingQCGd	CentralAirY	
	GarageType2Types	GarageTypeDetchd	GarageTypeAttchd	GarageTypeCarPort	
	GarageTypeBasment	GarageTypeBuiltIn	PavedDriveP	PavedDriveY
/ selection = Backward(stop = CV) cvmethod=random(5) stats = adjrsq;
output out = results p = Predict;
run;

/*
Intercept + logarea + loglotarea + OverallQual + OverallCond + YearBuilt + YearRemodAdd + BsmtFinSF1 + BsmtFinSF2 + GrLivArea + FullBath + HalfBath + BedroomAbvGr + KitchenAbvGr + TotRmsAbvGrd + Fireplaces + GarageCars + WoodDeckSF + OpenPorchSF + YrSold + logarea*loglotarea + StreetPave + LotShapeIR1 + LotShapeIR2 + LotShapeIR3 + LandContourLow + LandContourBnk + LandContourLvl + NeighborhoodBrkSide + NeighborhoodSWISU + NeighborhoodIDOTRR + NeighborhoodEdwards + NeighborhoodMeadowV + NeighborhoodSawyer + NeighborhoodOldTown + NeighborhoodCrawfor + NeighborhoodSawyerW + NeighborhoodNAmes + NeighborhoodMitchel + NeighborhoodCollgCr + NeighborhoodGilbert + NeighborhoodNPkVill + NeighborhoodBrDale + NeighborhoodClearCr + NeighborhoodNWAmes + NeighborhoodStoneBr + NeighborhoodSomerst + NeighborhoodTimber + NeighborhoodBlmngtn + NeighborhoodVeenker + NeighborhoodBlueste + NeighborhoodNridgHt + BldgType1Fam + BldgTypeTwnhs + BldgTypeTwnhsE + BldgType2fmCon + HouseStyle1Story + HouseStyleSFoyer + HouseStyle15Fin + HouseStyle15Unf + HouseStyleSLvl + HouseStyle2Story + HouseStyle25Unf + RoofStyleFlat + RoofMatlCompShg + RoofMatlClyTile + RoofMatlMetal + RoofMatlWdShngl + RoofMatlMembran + RoofMatlWdShake + Exterior1stVinylSd + Exterior1stWdSdng + Exterior1stAsbShng + Exterior1stMetalSd + Exterior1stCemntBd + Exterior1stWdShing + Exterior1stPlywood + Exterior1stHdBoard + Exterior1stStucco + Exterior1stBrkFace + Exterior1stBrkComm + Exterior1stCBlock + FoundationSlab + FoundationCBlock + FoundationBrkTil + FoundationPConc + FoundationStone + BsmtQualEx + BsmtQualTA + BsmtQualGd + BsmtQualFa + BsmtCondTa + BsmtCondGd + HeatingGasA + HeatingGrav + HeatingGasW + HeatingWall + HeatingQCFa + HeatingQCTA + HeatingQCEx + HeatingQCGd + CentralAirY + GarageType2Types + GarageTypeDetchd + GarageTypeAttchd + GarageTypeCarPort + GarageTypeBasment + PavedDriveP + PavedDriveY


Intercept + logarea + OverallQual + OverallCond + YearBuilt + YearRemodAdd + BsmtFinSF1 + BsmtFinSF2 + KitchenAbvGr + Fireplaces + GarageCars + logarea*loglotarea + NeighborhoodIDOTRR + NeighborhoodEdwards + NeighborhoodOldTown + NeighborhoodCrawfor + NeighborhoodStoneBr + NeighborhoodSomerst + NeighborhoodNridgHt + HouseStyle2Story + RoofMatlClyTile + RoofMatlWdShngl + Exterior1stBrkFace + FoundationPConc + BsmtQualEx + HeatingGrav + HeatingQCEx

*/


/*output the model to a file*/
data results2;
set results;
logprice = Predict;
if Predict >0 then logprice = Predict;
if Predict <= 0 then logprice = 9.21034;
keep id SalePrice logprice;
where id > 1460;

proc print data=results2(obs=5);
run;

data results3;
set results2;
if exp(logprice) > 0 then SalePrice = exp(logprice);
if exp(logprice)<= 0 then SalePrice = 10000;
keep id SalePrice;
where id > 1460;
;

proc print data = results3(obs=5);
run;

PROC EXPORT DATA= WORK.RESULTS3 
            OUTFILE= "C:\Study Files\SMU MSDS\DS 6371 Statistical Foundations for Data Science\statistical-housing-price-analysis\test-model.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
/*Success!!!*/
