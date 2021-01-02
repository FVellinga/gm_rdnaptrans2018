# gm_rdnaptrans2018.sas

<head>
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Helvetica;
	panose-1:2 11 6 4 2 2 2 2 2 4;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
@font-face
	{font-family:"Book Antiqua";
	panose-1:2 4 6 2 5 3 5 3 3 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:8.0pt;
	margin-left:0cm;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{color:#0563C1;
	text-decoration:underline;}
p.MsoNoSpacing, li.MsoNoSpacing, div.MsoNoSpacing
	{margin:0cm;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{font-family:"Calibri",sans-serif;}
.MsoPapDefault
	{margin-bottom:8.0pt;
	line-height:107%;}
@page WordSection1
	{size:595.3pt 841.9pt;
	margin:70.85pt 70.85pt 70.85pt 70.85pt;}
div.WordSection1
	{page:WordSection1;}
-->
</style>

</head>

<body lang=NL link="#0563C1" vlink="#954F72" style='word-wrap:break-word'>

<div class=WordSection1>

<p class=MsoNoSpacing><b><u><span style='font-size:16.0pt;font-family:"Book Antiqua",serif'>De
Theorie</span></u></b></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>De SAS macro
<b>gm_rdnaptrans2018.sas</b> is een SAS implementatie die de geografische Nederlandse
<b>RD NAP</b> (<b><u>R</u></b>ijks<b><u>D</u></b>riehoeksmeting en <b><u>N</u></b>ormaal
<b><u>A</u></b>msterdam <b><u>P</u></b>eil) coördinaten omzet, transformeert,
naar <b>ETRS89</b> (<b><u>E</u></b>uropean <b><u>T</u></b>errestrial <b><u>R</u></b>eference
<b><u>S</u></b>ystem 1989), of andersom. De code is gecertificeerd en mag het handelsmerk
</span><b><span style='font-family:"Book Antiqua",serif;color:#333333;
background:white'>RDNAPTRANS™2018</span></span></b><span style='font-family:
"Book Antiqua",serif;color:#333333;background:white'> voeren. Dit betekent dat deze
transformaties correct zijn als er juist gebruik wordt gemaakt van </span><b><span
style='font-family:"Book Antiqua",serif'>gm_rdnaptrans2018.sas</span></b><span
style='font-family:"Book Antiqua",serif'>.</span></p>

<p class=MsoNoSpacing><b><span style='font-family:"Book Antiqua",serif;
color:#333333;background:white'>RD NAP</span></b><span style='font-family:"Book Antiqua",serif;
color:#333333;background:white'> dimensie is een meters, <b>ETRS89</b> is in graden
en meters (de hoogte).</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif;color:#333333;
background:white'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif;color:#333333;
background:white'>Tevens kan de macro transformaties aan van <b>ETRS89</b> naar
<b>ITRS</b> (</span><b><u><span style='font-family:"Book Antiqua",serif'>I</span></u></b><span
style='font-family:"Book Antiqua",serif'>nternational Terrestrial <b><u>R</u></b>eference
<b><u>S</u></b>ystem) om <b>WGS84</b> (<b>W</b>orld <b>G</b>eodetic <b>S</b>ystem
89) coördinaten te <i>benaderen</i>. <b>WGS89</b> </span><span
style='font-family:"Book Antiqua",serif;color:#333333;background:white'>dimensie
</span><span style='font-family:"Book Antiqua",serif'>is in graden en meters (de
hoogte). Dit gedeelte staat los van de <b>RD NAP</b> naar <b>ETRS89</b> transformatie
en is <b><i><u>niet</u></i></b> onderdeel van het handelsmerk </span><b><span
style='font-family:"Book Antiqua",serif;color:#333333;background:white'>RDNAPTRANS™2018</span></span></b><span
style='font-family:"Book Antiqua",serif;color:#333333;background:white'>.</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Los van
alle details kan het volgende gezegd worden:</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Er is maar
één manier om van <b>RD NAP</b> naar <b>WGS84</b> te komen: </span></p>

<p class=MsoNoSpacing><span style='font-family:Consolas'>RD NAP</span><span
style='font-size:8.0pt;font-family:Consolas'>(1)</span><span style='font-family:
Consolas'> -&gt; ETRS89</span><span style='font-size:8.0pt;font-family:Consolas'>(2)</span><span
style='font-family:Consolas'> -&gt; ITRF2008</span><span style='font-size:8.0pt;
font-family:Consolas'>(3)</span><span style='font-family:Consolas'> -&gt; WGS84</span><span
style='font-size:8.0pt;font-family:Consolas'>(4)</span></p>

<p class=MsoNoSpacing><span style='font-size:8.0pt;font-family:Consolas'>(ITFR2008
is een realisatie van ITRS. Je mag ook ITRF2014 gebruiken.)</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Deze code gaat
niet verder dan stap 3, met de aantekening, dat als je wilt projecteren op een
kaart, het stap 2 resultaat misschien wel voldoende is. Stap 3 en 4 kan een
vorm van schijnnauwkeurigheid creëren.</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><b><span style='font-family:"Book Antiqua",serif;
color:#333333;background:white'>RDNAPTRANS™2018</span></span></b><span
style='font-family:"Book Antiqua",serif;color:#333333;background:white'> compliant
code transformeert elk datum paar naar een ander datum paar, welke plek op
aarde dan ook. Maar buiten de zogenaamde grids kan de afwijking groot zijn en klopt
er niets meer van. Dat is volkomen correct gedrag. Sommige implementaties geven
dan een waarschuwing dat je transformeert met waarden die buiten de grid liggen
Deze code geeft die waarschuwing (nog) niet.</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Tot zover de
theorie. Het is ook allemaal te vinden op <a href="http://www.nsgi.nl">www.nsgi.nl</a>.</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><b><u><span style='font-size:16.0pt;font-family:"Book Antiqua",serif'>De
Code</span></u></b></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>De SAS
code ondersteunt twee manieren, methoden om te transformeren:</span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=39 valign=top style='width:28.95pt;border:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-family:Consolas'>V1</span></p>
  </td>
  <td width=557 valign=top style='width:417.9pt;border:solid windowtext 1.0pt;
  border-left:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-family:Consolas'>Maakt geen gebruik van
  data sets als input/input. De datasetless benadering. De input/output zijn macro
  variabelen. Geschikt als je één coördinatenpaar wilt transformeren.</span></p>
  </td>
 </tr>
 <tr>
  <td width=39 valign=top style='width:28.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-family:Consolas'>V2</span></p>
  </td>
  <td width=557 valign=top style='width:417.9pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-family:Consolas'>Maakt gebruik van data
  sets als input/input. Geschikt voor bulk transformaties. Vrij rap volgens mij.</span></p>
  </td>
 </tr>
</table>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Tevens moeten
er twee grid files (tekst bestanden) worden ingeladen en opgeslagen worden als
dataset. Optioneel zijn het zogenaamde zelfvalidatie bestand en de twee certificatie
validatie bestanden. Handig, want hiermee toon je aan dat deze code werkt.</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Dit, het
laden van files en ze opslaan als dataset, zijn eenmalige acties. Sla ze op in
een pre-assigned library, bij mij heet die </span><b><span style='font-family:
Consolas'>RDNAP</span></b><span style='font-family:"Book Antiqua",serif'>, en klaar
ben je. </span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Gebruik
van de macro staat beschreven in de header. Het is geschreven binnen SAS studio.
Ik sla macro’s op in een SAS autocall library. Dus als je <b>gm_rdnaptrans2018.sas</b>
daar eenmaal plaatst, je de paden goed heb staan, dan moet onderstaande code werken.</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Misschien
handiger om eerst te beperken tot het inladen van de grids etc. en dan dit te
doen:</span></p>

<p class=MsoNoSpacing><span style='font-size:5.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%gm_rdnaptrans2018</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_ini_v2</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018,
RDNAP.NLGEO2018)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-family:"Book Antiqua",serif'>Hier staan
alle relevantie macro calls. Je hoeft trouwens niet steeds een ini call te doen.</span></p>

<p class=MsoNoSpacing><span style='font-size:5.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%gm_rdnaptrans2018</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%grid_import_rdcorr2018(/folders/myfolders/sasuser.v94/files/input/rdcorr2018.txt,
RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%grid_import_nlgeo2018(/folders/myfolders/sasuser.v94/files/input/nlgeo2018.txt,
RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%self_validation_import(/folders/myfolders/sasuser.v94/files/input/Z001_ETRS89andRDNAP.txt,
RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%certificate_validation_import(/folders/myfolders/sasuser.v94/files/input/002_ETRS89.txt                   
,/folders/myfolders/sasuser.v94/files/input/002_RDNAP.txt</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>                             
,RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>                             
</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%self_validation_ETRS89_v1(RDNAP)
%* Very slow;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%self_validation_RD_v1(RDNAP) 
   %* Very slow;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_ini_v2</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018,
RDNAP.NLGEO2018)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%self_validation_ETRS89_v2(RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%self_validation_RD_v2(RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%display_self_validation_results(RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_pseudo_validatation_v2(RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%certify_validation_ETRS89_v1(RDNAP,
/folders/myfolders/sasuser.v94/files/output/CERTIFY_ETRS89_v1.txt)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%certify_validation_RD_v1(RDNAP,
/folders/myfolders/sasuser.v94/files/output/CERTIFY_RDNAP_v1.txt)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%certify_validation_ETRS89_v2(RDNAP,
/folders/myfolders/sasuser.v94/files/output/CERTIFY_ETRS89_v2.txt)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%certify_validation_RD_v2(RDNAP,
/folders/myfolders/sasuser.v94/files/output/CERTIFY_RDNAP_v2.txt)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_ini_v1()</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(52,
5, 43)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_WGS84_v1(51.999994778222,
4.9999922685, 42.98187019)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(52,
5, 0)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_WGS84_v1(51.999994801
, 4.999992309, -0.018)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(51.999994787,
4.999992597, -0.022)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(55.878,
7.78, 45)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(54.000005178272,
7.000008038945, 12.02079392 )</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_WGS84_v1(54,
7, 12)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_ini_v1(pItrf=ITRF2014)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(52,
5, 43)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs89itrs2014wgs84_output_v1;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_WGS84_v1(51.999994814,
4.999992333, 42.9821)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%etrs_itrs_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%WGS84_to_ETRS89_v1(51.999994805,
4.999992317, 42.982, -1)</span></p>

<p class=MsoNoSpacing><span style='font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_ini_v1(RDNAP)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_RD_v1(53.199392335,6.05939747)
%* 199920.0426 - 579403.4233;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%RD_to_ETRS89_v1(199920.0426,579403.4233)
%* 53.199392335 - 6.05939747;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_RD_v1(52.763874938,4.069800843,pH=115.9049)   
%* 30010021 - 66080.2628 - 531539.0239 - 73.2384;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_RD_v1(&quot;52
9 22.178&quot;,&quot;5 23 15.500&quot;,pH=72.6882,pType=dgr)</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%ETRS89_to_RD_v1(51.728601274,4.712120126,pH=301.7981)   
%* 108360.879   415757.2745  258.0057;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>%rdnaptrans2018_output_v1</span></p>

<p class=MsoNoSpacing><span style='font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<p class=MsoNoSpacing><b><u><span style='font-size:16.0pt;font-family:"Book Antiqua",serif'>Macro
Overzicht</span></u></b></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'> </span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:"Book Antiqua",serif'>Overzicht
van de macro’s die in <b>gm_rdnaptrans2018.sas</b> zitten. </span></p>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 width=587
 style='width:440.4pt;border-collapse:collapse;border:none'>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><b><span style='font-size:12.0pt;font-family:Consolas'>#</span></b></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border:solid windowtext 1.0pt;
  border-left:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><b><span style='font-size:12.0pt;font-family:Consolas'>Linenumber</span></b></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border:solid windowtext 1.0pt;
  border-left:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><b><span style='font-size:12.0pt;font-family:Consolas'>Macro</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>240</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>gm_rdnaptrans2018</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>248</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>rdnaptrans2018_ini_v1(pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>422</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>rdnaptrans2018_output_v1</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>4</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>452</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>conv_dgr_to_dec(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>5</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>476</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>conv_dec_to_rad(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>6</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>499</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>conv_dgr_dec_rad(pD)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>7</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>520</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>RD_datum_transformation(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>8</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>656</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>RD_correction(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>9</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>801</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>RD_map_projection(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>10</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>906</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>height_transformation(pLat,
  pLon, pH, pType)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>11</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>990</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>inverse_map_projection(pX,
  pY)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>12</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1108</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>inverse_correction(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>13</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1186</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>inverse_datum_transformation(pLat,
  pLon)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>14</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1320</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>ETRS89_to_RD_v1(pLat,
  pLon, pH=-999999, pType=dec)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>15</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1375</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>RD_to_ETRS89_v1(pX,
  pY, pH=-999999)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>16</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1415</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>rdnaptrans2018_ini_v2</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>17</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1551</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>rdnaptrans2018_grid_v2(pRDgrid,
  pHgrid)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>18</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1587</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>ETRS89_to_RD_v2(pDSin,
  pDSout)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>19</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>1894</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>RD_to_ETRS89_v2(pDSin,
  pDSout)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>20</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2178</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>grid_import_rdcorr2018(pFile,
  pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>21</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2198</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>grid_import_nlgeo2018(pFile,
  pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>22</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2218</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>self_validation_import(pFile,
  pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>23</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2243</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>certificate_validation_import(pETRS89file,
  pRDfile, pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>24</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2285</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>self_validation_ETRS89_v1(pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>25</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2366</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>self_validation_RD_v1(pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>26</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2450</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>self_validation_ETRS89_v2(pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>27</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2497</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>self_validation_RD_v2(pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>28</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2555</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>certify_validation_ETRS89_v1(pLib,
  pOutputFile)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>29</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2621</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>certify_validation_RD_v1(pLib,
  pOutputFile</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>30</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2687</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>certify_validation_ETRS89_v2(pLib,
  pOutputFile)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>31</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2719</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>certify_validation_RD_v2(pLib,
  pOutputFile)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>32</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2756</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>etrs_itrs_ini_v1(pItrf=ITRF2014)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>33</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2889</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>etrs_itrs_output_v1</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>34</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2905</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>WGS84_to_ETRS89_v1(pLat,
  pLon, pHeight)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>35</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2911</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>ETRS89_to_WGS84_v1(pLat,
  pLon, pHeight)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>36</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>2917</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>lm_WGS84_to_ETRS89_v1(pLat,
  pLon, pHeight, pDirection)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>37</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3090</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>etrs_itrs_ini_v2(pItrf=ITRF2014)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>38</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3204</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>WGS84_to_ETRS89_v2(pDSin
  ,pDSout)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>39</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3209</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>ETRS89_to_WGS84_v2(pDSin,
  pDSout)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>40</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3214</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>lm_WGS84_to_ETRS89_v2(pDSin,pDSout,
  pDirection)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>41</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3374</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>WGS84_pseudo_validatation_v2(pLib)</span></p>
  </td>
 </tr>
 <tr>
  <td width=36 valign=top style='width:27.3pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>42</span></p>
  </td>
  <td width=111 valign=top style='width:83.4pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>3477</span></p>
  </td>
  <td width=440 valign=top style='width:329.7pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>display_self_validation_results(pLib)</span></p>
  </td>
 </tr>
</table>

<p class=MsoNoSpacing><span style='font-size:10.0pt;font-family:Consolas'>&nbsp;</span></p>

</div>

</body>

