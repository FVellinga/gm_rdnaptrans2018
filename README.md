# gm_rdnaptrans2018.sas

De Theorie

De SAS macro gm_rdnaptrans2018.sas is een SAS implementatie die de geografische Nederlandse RD NAP (RijksDriehoeksmeting en Normaal Amsterdam Peil) coördinaten omzet, transformeert, naar ETRS89 (European Terrestrial Reference System 1989), of andersom. De code is gecertificeerd en mag het handelsmerk RDNAPTRANS™2018 voeren. Dit betekent dat deze transformaties correct zijn als er juist gebruik wordt gemaakt van gm_rdnaptrans2018.sas.
RD NAP dimensie is een meters, ETRS89 is in graden en meters (de hoogte).

Tevens kan de macro transformaties aan van ETRS89 naar ITRS (International Terrestrial Reference System) om WGS84 (World Geodetic System 89) coördinaten te benaderen. WGS89 dimensie is in graden en meters (de hoogte). Dit gedeelte staat los van de RD NAP naar ETRS89 transformatie en is niet onderdeel van het handelsmerk RDNAPTRANS™2018.

Los van alle details kan het volgende gezegd worden:
Er is maar één manier om van RD NAP naar WGS84 te komen: 
RD NAP(1) -> ETRS89(2) -> ITRF2008(3) -> WGS84(4)
(ITFR2008 is een realisatie van ITRS. Je mag ook ITRF2014 gebruiken.)

Deze code gaat niet verder dan stap 3, met de aantekening, dat als je wilt projecteren op een kaart, het stap 2 resultaat misschien wel voldoende is. Stap 3 en 4 kan een vorm van schijnnauwkeurigheid creëren.

RDNAPTRANS™2018 compliant code transformeert elk datum paar naar een ander datum paar, welke plek op aarde dan ook. Maar buiten de zogenaamde grids kan de afwijking groot zijn en klopt er niets meer van. Dat is volkomen correct gedrag. Sommige implementaties geven dan een waarschuwing dat je transformeert met waarden die buiten de grid liggen Deze code geeft die waarschuwing (nog) niet.

Tot zover de theorie. Het is ook allemaal te vinden op www.nsgi.nl.

De Code

De SAS code ondersteunt twee manieren, methoden om te transformeren:
V1	Maakt geen gebruik van data sets als input/input. De datasetless benadering. De input/output zijn macro variabelen. Geschikt als je één coördinatenpaar wilt transformeren.
V2	Maakt gebruik van data sets als input/input. Geschikt voor bulk transformaties. Vrij rap volgens mij.

Tevens moeten er twee grid files (tekst bestanden) worden ingeladen en opgeslagen worden als dataset. Optioneel zijn het zogenaamde zelfvalidatie bestand en de twee certificatie validatie bestanden. Handig, want hiermee toon je aan dat deze code werkt.
Dit, het laden van files en ze opslaan als dataset, zijn eenmalige acties. Sla ze op in een pre-assigned library, bij mij heet die RDNAP, en klaar ben je. 

Gebruik van de macro staat beschreven in de header. Het is geschreven binnen SAS studio. Ik sla macro’s op in een SAS autocall library. Dus als je gm_rdnaptrans2018.sas daar eenmaal plaatst, je de paden goed heb staan, dan moet onderstaande code werken.

Misschien handiger om eerst te beperken tot het inladen van de grids etc. en dan dit te doen:

%gm_rdnaptrans2018
%rdnaptrans2018_ini_v2
%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018, RDNAP.NLGEO2018)

Hier staan alle relevantie macro calls. Je hoeft trouwens niet steeds een ini call te doen.

%gm_rdnaptrans2018
%grid_import_rdcorr2018(/folders/myfolders/sasuser.v94/files/input/rdcorr2018.txt, RDNAP)
%grid_import_nlgeo2018(/folders/myfolders/sasuser.v94/files/input/nlgeo2018.txt, RDNAP)
%self_validation_import(/folders/myfolders/sasuser.v94/files/input/Z001_ETRS89andRDNAP.txt, RDNAP)
%certificate_validation_import(/folders/myfolders/sasuser.v94/files/input/002_ETRS89.txt                    ,/folders/myfolders/sasuser.v94/files/input/002_RDNAP.txt
                              ,RDNAP)
                              
%self_validation_ETRS89_v1(RDNAP) %* Very slow;
%self_validation_RD_v1(RDNAP)     %* Very slow;

%rdnaptrans2018_ini_v2
%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018, RDNAP.NLGEO2018)
%self_validation_ETRS89_v2(RDNAP)
%self_validation_RD_v2(RDNAP)

%display_self_validation_results(RDNAP)

%WGS84_pseudo_validatation_v2(RDNAP)

%certify_validation_ETRS89_v1(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_ETRS89_v1.txt)
%certify_validation_RD_v1(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_RDNAP_v1.txt)
%certify_validation_ETRS89_v2(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_ETRS89_v2.txt)
%certify_validation_RD_v2(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_RDNAP_v2.txt)

%etrs_itrs_ini_v1()
%WGS84_to_ETRS89_v1(52, 5, 43)
%etrs_itrs_output_v1
%ETRS89_to_WGS84_v1(51.999994778222, 4.9999922685, 42.98187019)
%etrs_itrs_output_v1

%WGS84_to_ETRS89_v1(52, 5, 0)
%etrs_itrs_output_v1
%ETRS89_to_WGS84_v1(51.999994801 , 4.999992309, -0.018)
%etrs_itrs_output_v1

%WGS84_to_ETRS89_v1(51.999994787, 4.999992597, -0.022)
%WGS84_to_ETRS89_v1(55.878, 7.78, 45)
%etrs_itrs_output_v1


%WGS84_to_ETRS89_v1(54.000005178272, 7.000008038945, 12.02079392 )
%etrs_itrs_output_v1
%ETRS89_to_WGS84_v1(54, 7, 12)
%etrs_itrs_output_v1

%etrs_itrs_ini_v1(pItrf=ITRF2014)
%WGS84_to_ETRS89_v1(52, 5, 43)
%etrs89itrs2014wgs84_output_v1;

%ETRS89_to_WGS84_v1(51.999994814, 4.999992333, 42.9821)
%etrs_itrs_output_v1
%WGS84_to_ETRS89_v1(51.999994805, 4.999992317, 42.982, -1)

%rdnaptrans2018_ini_v1(RDNAP)
%ETRS89_to_RD_v1(53.199392335,6.05939747) %* 199920.0426 - 579403.4233;
%rdnaptrans2018_output_v1
%RD_to_ETRS89_v1(199920.0426,579403.4233) %* 53.199392335 - 6.05939747;
%rdnaptrans2018_output_v1

%ETRS89_to_RD_v1(52.763874938,4.069800843,pH=115.9049)    %* 30010021 - 66080.2628 - 531539.0239 - 73.2384;
%rdnaptrans2018_output_v1
%ETRS89_to_RD_v1("52 9 22.178","5 23 15.500",pH=72.6882,pType=dgr)
%rdnaptrans2018_output_v1
%ETRS89_to_RD_v1(51.728601274,4.712120126,pH=301.7981)    %* 108360.879   415757.2745  258.0057;
%rdnaptrans2018_output_v1


Macro Overzicht
 
Overzicht van de macro’s die in gm_rdnaptrans2018.sas zitten. 

#	Linenumber	Macro
1	240	gm_rdnaptrans2018
2	248	rdnaptrans2018_ini_v1(pLib)
3	422	rdnaptrans2018_output_v1
4	452	conv_dgr_to_dec(pLat, pLon)
5	476	conv_dec_to_rad(pLat, pLon)
6	499	conv_dgr_dec_rad(pD)
7	520	RD_datum_transformation(pLat, pLon)
8	656	RD_correction(pLat, pLon)
9	801	RD_map_projection(pLat, pLon)
10	906	height_transformation(pLat, pLon, pH, pType)
11	990	inverse_map_projection(pX, pY)
12	1108	inverse_correction(pLat, pLon)
13	1186	inverse_datum_transformation(pLat, pLon)
14	1320	ETRS89_to_RD_v1(pLat, pLon, pH=-999999, pType=dec)
15	1375	RD_to_ETRS89_v1(pX, pY, pH=-999999)
16	1415	rdnaptrans2018_ini_v2
17	1551	rdnaptrans2018_grid_v2(pRDgrid, pHgrid)
18	1587	ETRS89_to_RD_v2(pDSin, pDSout)
19	1894	RD_to_ETRS89_v2(pDSin, pDSout)
20	2178	grid_import_rdcorr2018(pFile, pLib)
21	2198	grid_import_nlgeo2018(pFile, pLib)
22	2218	self_validation_import(pFile, pLib)
23	2243	certificate_validation_import(pETRS89file, pRDfile, pLib)
24	2285	self_validation_ETRS89_v1(pLib)
25	2366	self_validation_RD_v1(pLib)
26	2450	self_validation_ETRS89_v2(pLib)
27	2497	self_validation_RD_v2(pLib)
28	2555	certify_validation_ETRS89_v1(pLib, pOutputFile)
29	2621	certify_validation_RD_v1(pLib, pOutputFile
30	2687	certify_validation_ETRS89_v2(pLib, pOutputFile)
31	2719	certify_validation_RD_v2(pLib, pOutputFile)
32	2756	etrs_itrs_ini_v1(pItrf=ITRF2014)
33	2889	etrs_itrs_output_v1
34	2905	WGS84_to_ETRS89_v1(pLat, pLon, pHeight)
35	2911	ETRS89_to_WGS84_v1(pLat, pLon, pHeight)
36	2917	lm_WGS84_to_ETRS89_v1(pLat, pLon, pHeight, pDirection)
37	3090	etrs_itrs_ini_v2(pItrf=ITRF2014)
38	3204	WGS84_to_ETRS89_v2(pDSin ,pDSout)
39	3209	ETRS89_to_WGS84_v2(pDSin, pDSout)
40	3214	lm_WGS84_to_ETRS89_v2(pDSin,pDSout, pDirection)
41	3374	WGS84_pseudo_validatation_v2(pLib)
42	3477	display_self_validation_results(pLib)

