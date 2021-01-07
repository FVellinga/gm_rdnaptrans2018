# gm_rdnaptrans2018.sas

<p>Lees als: global macro rdnaptran2018.sas</p>

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
</br>Er is maar één manier om van <b>RD NAP</b> naar <b>WGS84</b> te komen: </br>

RD NAP(1) -&gt; ETRS89(2) -&gt; ITRF2008(3) -&gt; WGS84(4)</br>
(ITFR2008 is een realisatie van ITRS. Je mag ook ITRF2014 gebruiken.)</p>
<p>Deze code gaat niet verder dan stap 3, met de aantekening, dat als je wilt projecteren op een
kaart, het stap 2 resultaat misschien wel voldoende is. Stap 3 en 4 kan een vorm van schijnnauwkeurigheid creëren.</p>

<p><b>RDNAPTRANS™2018</b> compliant code transformeert elk datum paar naar een ander datum paar, welke plek op
aarde dan ook. Maar buiten de zogenaamde grids kan de afwijking groot zijn en klopt er niets meer van. Dat is volkomen correct gedrag. Sommige implementaties geven
dan een waarschuwing dat je transformeert met waarden die buiten de grid liggen Deze code geeft die waarschuwing (nog) niet.</p>

<p>Tot zover de inleiding. Het is ook allemaal te vinden op <a href="http://www.nsgi.nl">www.nsgi.nl</a>.</p>

# De Code

<p>De SAS code ondersteunt twee manieren, methoden om te transformeren:</p>

<table border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td>
  <p>V1</p>
  </td>
  <td>
   <p>Maakt <i><strong>geen</strong></i> gebruik van data sets als input/input. De datasetless benadering. De input/output zijn macro
  variabelen. Geschikt als je één coördinatenpaar wilt transformeren.</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>V2</p>
  </td>
  <td>
  <p>Maakt gebruik van data sets als input/input. Geschikt voor bulk transformaties. Vrij rap volgens mij.</p>
  </td>
 </tr>
</table>

<p>Tevens moeten
er twee grid files (tekst bestanden) worden ingeladen en opgeslagen worden als
dataset. Optioneel zijn het zogenaamde zelfvalidatie bestand en de twee certificatie
validatie bestanden. Handig, want hiermee toon je aan dat deze code werkt.</p>

<p>Dit, het laden van files en ze opslaan als dataset, zijn eenmalige acties. Sla ze op in
een pre-assigned library, bij mij heet die <b>RDNAP</b>, en klaar ben je.</p>

<p>Gebruik van de macro staat beschreven in de header. Het is geschreven binnen SAS studio.
Ik sla macro’s op in een SAS autocall library. Dus als je <b>gm_rdnaptrans2018.sas</b>
daar eenmaal plaatst, je de paden goed heb staan, dan moet onderstaande code werken.</p>

<p>Misschien handiger om eerst te beperken tot het inladen van de grids etc. en dan dit te doen:</br>
<i>
%gm_rdnaptrans2018</br>
%rdnaptrans2018_ini_v2</br>
%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018, RDNAP.NLGEO2018)</i></p>

<p>Nu volgen alle relevantie macro calls. Je hoeft trouwens niet steeds een ini call te doen.</p>
<p><i>%gm_rdnaptrans2018</br>
%grid_import_rdcorr2018(/folders/myfolders/sasuser.v94/files/input/rdcorr2018.txt, RDNAP)</br>
%grid_import_nlgeo2018(/folders/myfolders/sasuser.v94/files/input/nlgeo2018.txt, RDNAP)</br>
%self_validation_import(/folders/myfolders/sasuser.v94/files/input/Z001_ETRS89andRDNAP.txt, RDNAP)</br>
%certificate_validation_import(/folders/myfolders/sasuser.v94/files/input/002_ETRS89.txt, /folders/myfolders/sasuser.v94/files/input/002_RDNAP.txt, RDNAP)</i></p>

<p><i>%self_validation_ETRS89_v1(RDNAP)      %* Very slow;</br>
%self_validation_RD_v1(RDNAP)  %* Very slow;</br>
%rdnaptrans2018_grid_v2(RDNAP.RDCORR2018, RDNAP.NLGEO2018)</br>
%self_validation_ETRS89_v2(RDNAP)</br>
%self_validation_RD_v2(RDNAP)</br>
%display_self_validation_results(RDNAP)</i></p>

<p><i>%certify_validation_ETRS89_v1(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_ETRS89_v1.txt)</br>
%certify_validation_RD_v1(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_RDNAP_v1.txt)</br>
%certify_validation_ETRS89_v2(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_ETRS89_v2.txt)</br>
%certify_validation_RD_v2(RDNAP, /folders/myfolders/sasuser.v94/files/output/CERTIFY_RDNAP_v2.txt)</i></p>

<p><i>%WGS84_pseudo_validatation_v2(RDNAP)</i></p>
<p><i>%etrs_itrs_ini_v1()</br>
%WGS84_to_ETRS89_v1(52, 5, 43)</br>
%etrs_itrs_output_v1</br>
%ETRS89_to_WGS84_v1(51.999994778222, 4.9999922685, 42.98187019)</br>
%etrs_itrs_output_v1</br>
%WGS84_to_ETRS89_v1(52, 5, 0)</br>
%etrs_itrs_output_v1</p>
%ETRS89_to_WGS84_v1(51.999994801, 4.999992309, -0.018)</br>
%etrs_itrs_output_v1</p>
%WGS84_to_ETRS89_v1(51.999994787,4.999992597, -0.022)</br>
%WGS84_to_ETRS89_v1(55.878,7.78, 45)</br>
%etrs_itrs_output_v1</i></p>

<p><i>%ETRS89_to_RD_v1(52.763874938,4.069800843,pH=115.9049)   %* 30010021 - 66080.2628 - 531539.0239 - 73.2384;</br>
%rdnaptrans2018_output_v1<br>
%ETRS89_to_RD_v1(&quot;52 9 22.178&quot;,&quot;5 23 15.500&quot;,pH=72.6882,pType=dgr)</br>
%rdnaptrans2018_output_v1</br>
%ETRS89_to_RD_v1(51.728601274,4.712120126,pH=301.7981)   %* 108360.879   415757.2745  258.0057;</br>
%rdnaptrans2018_output_v1</i></p>

# Macro Overzicht

<p>Overzicht van de macro’s die in <b>gm_rdnaptrans2018.sas</b> zitten. (Regelnummering is benadering.)</p>

<table>
 <tr>
  <td>
  <p><b>#</b></p>
  </td>
  <td>
  <p><b>Regelnummer</b></p>
  </td>
  <td>
  <p><b>Macro</b></p>
  </td>
 </tr>
 <tr>
  <td>
  <p>1</p>
  </td>
  <td>
  <p>240</p>
  </td>
  <td >
  <p>gm_rdnaptrans2018</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>2</p>
  </td>
  <td>
  <p>248</p>
  </td>
  <td >
  <p>rdnaptrans2018_ini_v1(pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>3</p>
  </td>
  <td>
  <p>422</p>
  </td>
  <td >
  <p>rdnaptrans2018_output_v1</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>4</p>
  </td>
  <td>
  <p>452</p>
  </td>
  <td >
  <p>conv_dgr_to_dec(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>5</p>
  </td>
  <td>
  <p>476</p>
  </td>
  <td >
  <p>conv_dec_to_rad(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>6</p>
  </td>
  <td>
  <p>499</p>
  </td>
  <td >
  <p>conv_dgr_dec_rad(pD)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>7</p>
  </td>
  <td>
  <p>520</p>
  </td>
  <td >
  <p>RD_datum_transformation(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>8</p>
  </td>
  <td>
  <p>656</p>
  </td>
  <td >
  <p>RD_correction(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>9</p>
  </td>
  <td>
  <p>801</p>
  </td>
  <td >
  <p>RD_map_projection(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>10</p>
  </td>
  <td>
  <p>906</p>
  </td>
  <td >
  <p>height_transformation(pLat, pLon, pH, pType)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>11</p>
  </td>
  <td>
  <p>990</p>
  </td>
  <td >
  <p>inverse_map_projection(pX, pY)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>12</p>
  </td>
  <td>
  <p>1108</p>
  </td>
  <td >
  <p>inverse_correction(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>13</p>
  </td>
  <td>
  <p>1186</p>
  </td>
  <td >
  <p>inverse_datum_transformation(pLat, pLon)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>14</p>
  </td>
  <td>
  <p>1320</p>
  </td>
  <td >
  <p>ETRS89_to_RD_v1(pLat, pLon, pH=-999999, pType=dec)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>15</p>
  </td>
  <td>
  <p>1375</p>
  </td>
  <td >
  <p>RD_to_ETRS89_v1(pX, pY, pH=-999999)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>16</p>
  </td>
  <td>
  <p>1415</p>
  </td>
  <td >
  <p>rdnaptrans2018_ini_v2</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>17</p>
  </td>
  <td>
  <p>1551</p>
  </td>
  <td >
  <p>rdnaptrans2018_grid_v2(pRDgrid, pHgrid)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>18</p>
  </td>
  <td>
  <p>1587</p>
  </td>
  <td >
  <p>ETRS89_to_RD_v2(pDSin, pDSout, pSuppress=1)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>19</p>
  </td>
  <td>
  <p>1894</p>
  </td>
  <td >
  <p>RD_to_ETRS89_v2(pDSin, pDSout, pSuppress=1)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>20</p>
  </td>
  <td>
  <p>2178</p>
  </td>
  <td >
  <p>grid_import_rdcorr2018(pFile, pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>21</p>
  </td>
  <td>
  <p>2198</p>
  </td>
  <td >
  <p>grid_import_nlgeo2018(pFile, pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>22</p>
  </td>
  <td>
  <p>2218</p>
  </td>
  <td >
  <p>self_validation_import(pFile, pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>23</p>
  </td>
  <td>
  <p>2243</p>
  </td>
  <td >
  <p>certificate_validation_import(pETRS89file, pRDfile, pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>24</p>
  </td>
  <td>
  <p>2285</p>
  </td>
  <td >
  <p>self_validation_ETRS89_v1(pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>25</p>
  </td>
  <td>
  <p>2366</p>
  </td>
  <td >
  <p>self_validation_RD_v1(pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>26</p>
  </td>
  <td>
  <p>2450</p>
  </td>
  <td >
  <p>self_validation_ETRS89_v2(pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>27</p>
  </td>
  <td>
  <p>2497</p>
  </td>
  <td >
  <p>self_validation_RD_v2(pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>28</p>
  </td>
  <td>
  <p>2555</p>
  </td>
  <td >
  <p>certify_validation_ETRS89_v1(pLib, pOutputFile)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>29</p>
  </td>
  <td>
  <p>2621</p>
  </td>
  <td >
  <p>certify_validation_RD_v1(pLib, pOutputFile</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>30</p>
  </td>
  <td>
  <p>2687</p>
  </td>
  <td >
  <p>certify_validation_ETRS89_v2(pLib, pOutputFile)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>31</p>
  </td>
  <td>
  <p>2719</p>
  </td>
  <td >
  <p>certify_validation_RD_v2(pLib, pOutputFile)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>32</p>
  </td>
  <td>
  <p>2756</p>
  </td>
  <td >
  <p>etrs_itrs_ini_v1(pItrf=ITRF2014)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>33</p>
  </td>
  <td>
  <p>2889</p>
  </td>
  <td >
  <p>etrs_itrs_output_v1</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>34</p>
  </td>
  <td>
  <p>2905</p>
  </td>
  <td >
  <p>WGS84_to_ETRS89_v1(pLat, pLon, pHeight)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>35</p>
  </td>
  <td>
  <p>2911</p>
  </td>
  <td >
  <p>ETRS89_to_WGS84_v1(pLat, pLon, pHeight)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>36</p>
  </td>
  <td>
  <p>2917</p>
  </td>
  <td >
  <p>lm_WGS84_to_ETRS89_v1(pLat, pLon, pHeight, pDirection)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>37</p>
  </td>
  <td>
  <p>3090</p>
  </td>
  <td >
  <p>etrs_itrs_ini_v2(pItrf=ITRF2014)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>38</p>
  </td>
  <td>
  <p>3204</p>
  </td>
  <td >
  <p>WGS84_to_ETRS89_v2(pDSin, pDSout, pSuppress=1)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>39</p>
  </td>
  <td>
  <p>3209</p>
  </td>
  <td >
  <p>ETRS89_to_WGS84_v2(pDSin, pDSout, pSuppress=1)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>40</p>
  </td>
  <td>
  <p>3214</p>
  </td>
  <td >
  <p>lm_WGS84_to_ETRS89_v2(pDSin, pDSout, pDirection, pSuppress)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>41</p>
  </td>
  <td>
  <p>3374</p>
  </td>
  <td >
  <p>WGS84_pseudo_validatation_v2(pLib)</p>
  </td>
 </tr>
 <tr>
  <td>
  <p>42</p>
  </td>
  <td>
  <p>3477</p>
  </td>
  <td >
  <p>display_self_validation_results(pLib)</p>
  </td>
 </tr>
</table>
