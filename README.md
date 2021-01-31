# gm_rdnaptrans2018.sas

<p>Lees als: global macro rdnaptrans 2018 sas</br>
Het is een suite/verzameling van macros t.b.v. <strong>RD NAP</strong> <-> <strong>ETRS89</strong> <-> <strong>WGS84 datum</strong> transformaties.</p>

# Inleiding

<p>De SAS macro <b>gm_rdnaptrans2018.sas</b> is een SAS implementatie die de geografische Nederlandse <b>RD NAP</b> (<b>R</b>ijks<b>D</b>riehoeksmeting en <b>N</b>ormaal
<b>A</b>msterdam <b>P</b>eil) coördinaten omzet, transformeert, naar <b>ETRS89</b> (<b>E</b>uropean <b>T</b>errestrial <b>R</b>eference
<b>S</b>ystem 1989), of andersom. De code is gecertificeerd en mag het handelsmerk <b>RDNAPTRANS™2018</b> voeren. Dit betekent dat deze
transformaties correct zijn als er juist gebruik wordt gemaakt van <b>gm_rdnaptrans2018.sas</b>. <b>RD NAP</b> dimensie is in meters, <b>ETRS89</b> is in graden
en meters (de hoogte).</p>

<p>Tevens kan de macro transformaties aan van <b>ETRS89</b> naar
 <b>ITRS</b> (<b>I</b>nternational <b>T</b>errestrial <b>R</b>eference
<b>S</b>ystem) om <b>WGS84</b> (<b>W</b>orld <b>G</b>eodetic <b>S</b>ystem
89) coördinaten te <i>benaderen</i>. <b>WGS89</b> dimensie is in graden en meters (de
hoogte). Dit gedeelte staat los van de <b>RD NAP</b> naar <b>ETRS89</b> transformatie
en is <b><i>niet</i></b> onderdeel van het handelsmerk <b>RDNAPTRANS™2018</b>.</p>

<p>Los van alle details kan het volgende gezegd worden:
</br>Er is maar één manier om van <b>RD NAP</b> naar <b>WGS84</b> (en terug) te komen: </br>

RD NAP(1) -&gt; ETRS89(2) -&gt; ITRF2008(3) -&gt; WGS84(4)</br>
(ITFR2008 is een realisatie van ITRS. Je mag ook ITRF2014 gebruiken.)</p>
<p>Deze code gaat niet verder dan stap 3, met de aantekening, dat als je wilt projecteren op een
kaart, het stap 2 resultaat misschien wel voldoende is. Stap 3 en 4 kan een vorm van schijnnauwkeurigheid creëren.</p>

<p><b>RDNAPTRANS™2018</b> compliant code transformeert elk datum paar (binnen <strong>RD NAP</strong> en <strong>ETRS89</strong> domein) naar een ander datum paar, welke plek op aarde dan ook. Maar buiten de zogenaamde grids kan de afwijking groot zijn en klopt er niets meer van. Dat is volkomen correct gedrag. Sommige implementaties geven
dan een waarschuwing dat je transformeert met waarden die buiten de grid liggen Deze code geeft die waarschuwing (nog) niet.</p>

<p>Tot zover de inleiding. Het is ook allemaal te vinden op <a href="http://www.nsgi.nl">www.nsgi.nl</a>.</p>

# De Code

<p>De SAS code ondersteunt drie manieren, methoden, om te transformeren:</p>

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td>
  <p>V1</p>
  </td>
  <td>
   <p>Maakt <i><strong>geen</strong></i> gebruik van data sets als input/output. De <i>datasetless</i> benadering. De input/output zijn macro
  variabelen. Geschikt als je één coördinatenpaar wilt transformeren.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>V2</p>
  </td>
  <td>
  <p>Maakt gebruik van data sets als input/output. Geschikt voor bulk transformaties. Vrij rap volgens mij. Het is wel zo, dat het initialiseren van de grid als macro variabelen een paar seconden kan duren.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>V3</p>
  </td>
  <td>
   <p><strong>Geoptimaliseerde versie van V2. Er wordt geen gebruik meer gemaakt van macro variabelen om de grid in te lezen. Is sneller dan V2.</p>
  </td>
 </tr> 
</table>

<p>Er moeten twee grid files (tekst bestanden) worden ingeladen en opgeslagen worden als
dataset. Optioneel zijn het zogenaamde zelfvalidatie bestand en de twee certificatie
validatie bestanden. Handig, want hiermee toon je aan dat deze code werkt.</p>

<p>Dit, het laden van files en ze opslaan als dataset, zijn eenmalige acties. Sla ze op in
een pre-assigned, permanente, library. Bij mij heet die <b>RDNAP</b>, en klaar ben je.</p>

<p>Gebruik van de macro staat beschreven in de header. Het is geschreven in SAS studio.
Ik sla macro’s op in een SAS autocall library. Dus als je <b>gm_rdnaptrans2018.sas</b>
daar eenmaal plaatst, je de paden goed heb staan, dan moet onderstaande code werken.</p>

<p><i>
%gm_rdnaptrans2018</br>
%grid_import_rdcorr2018(/folders/myfolders/sasuser.v94/files/input/rdcorr2018.txt, RDNAP)</br>
%grid_import_nlgeo2018(/folders/myfolders/sasuser.v94/files/input/nlgeo2018.txt, RDNAP)</br>
%self_validation_import(/folders/myfolders/sasuser.v94/files/input/Z001_ETRS89andRDNAP.txt, RDNAP)</br>
%rdnaptrans2018_ini_v2</br>
%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018, RDNAP.NLGEO2018)</i></p>

<p>Je kan ook dit doen, om te verifiëren dat de transformaties werken:</br>
<i>%self_validation_ETRS89_v2(RDNAP)</br>
%self_validation_RD_v2(RDNAP)</br>
%display_self_validation_results(RDNAP)</i></br>
Dit is de zogenaamde zelfvalidatie service.</p>
