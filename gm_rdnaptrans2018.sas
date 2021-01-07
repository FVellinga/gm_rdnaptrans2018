/*
GM_RDNAPTRANS2018 (pronounce as global macro RDNAPTRANS2018)
This program is officially validated and may carry the following trademark: RDNAPTRANS™2018

Coordinate transformation to and from Stelsel van de Rijksdriehoeksmeting and Normaal Amsterdams Peil.
- Transformation from ETRS89 to RD.
- Transformation form RD to ETRS89 (called the inverse transformation).

This implementation follows the flow as described in the RDNAPTRANS2018 document found at www.nsgi.nl
All formulas and variables are explained there.

Two different SAS implementations exists:
V1  Datasetless solution: Input coordinates are supplied as macro parameters, output is returned as global macro variables.
    Recommended for single transformation. Not suitable for bulk transformations.
V2  Dataset driven solution: Input dataset contains the coordinates that must be transformed. Output dataset is the input dataset
    enriched with the transformed coordinates. Use this method for bulk transformations.
- The V1 version needs no data preparation. The V2 version needs data preparation to get working.
- A one time setup effort is needed to get the correction grids stored in a SAS library.

Example version 1:
  %rdnaptrans2018_ini_v1(RDNAP)
  %ETRS89_to_RD_v1("52 9 22.178","5 23 15.500",pH=72.6882,pType=dgr)
  %ETRS89_to_RD_v1(53.199392335,6.05939747) %* 199920.0426 - 579403.4233;
  %RD_to_ETRS89_v1(199920.0426,579403.4233) %* 53.199392335 - 6.05939747;
  %rdnaptrans2018_output_v1
  
Example version 2:
  %rdnaptrans2018_ini_v2
  %rdnaptrans2018_grid_v2(RDcorrectionDataset, HeightCorrectionDataSet)
  %ETRS89_to_RD_v2(DataSetIn, DataSetOut)
  
Version:
1.0 - 20191008: Fred Vellinga, Initial version. V1 version.
                (This version is certified.)
1.1 - 20191019: Fred Vellinga, version 2 solution added.
                (This version is also certified.)
1.2 - 20191027: Fred Vellinga, ETRS to ITRS transformation added. ITRF2008/ITRF2014 can regarded as equal to WGS84.
                ITRF2008≈WGS84-G1762. Please note this has nothing to do with the RDNAPTRANS™2018 trademark.
                That trademark only applies to the RD to ETRS89 (both ways) transformation.
1.3 - 20210102: Fred Vellinga, Self-validation and certification functionality added. The user can verify if the code
                still meets the certification criteria.
1.4 - 20210107: Fred Vellinga, Suppress parameter added. Suppresses all intermediate variables in the output. Default on.
                Height value is now an optional column in the input dataset. When not exists, it is automatically set
                to -999999 (ETRS89<->RD) or 0 (ETRS89<->WGS84). Applies only to the V2 method.
                
USAGE EXPLANATION:
------------------
1. This macro, gm_rdnaptrans2018.sas itself, must also be stored somewhere. There are a number of techniques. When you do 
   not use the Stored Compiled Macro Facility, you have to run macro gm_rdnaptrans2018.sas at least once.
   Then the inside macros becomes available. Consider the SAS macro autocall facility.
2. Goto www.nsgi.nl and goto the RDNAPTRANS section.
3. Request to download RDNAPTRANS2018. You have to fill in a form and then you will get a ZIP file. (Situation as oktober 2020)
4. Open the ZIP file and locate directory Variant1 and save the grid filed rdcorr2018.txt and nlgeo2018.txt locally.
5. Then copy or import the text file to the SAS server. SAS installation dependent. 
6. Then save the text files as a dataset (rdcorr2018 and nlgeo2018) in a permanent library. Examples (using the SAS macro autocall)
   are given below. RDNAP is the libname where the datasets are stored. The column 'i' is mandatory.
   
   %gm_rdnaptrans2018
   %rdnaptrans2018_ini_v2
   %grid_import_rdcorr2018(/folders/myfolders/sasuser.v94/files/input/rdcorr2018.txt, RDNAP)
   %grid_import_nlgeo2018(/folders/myfolders/sasuser.v94/files/input/nlgeo2018.txt, RDNAP)
   
7. By now you have the grid correction datasets saved. A onetime effort. V1 and V2 makes use of it.

Additional: A few macros exist to support the self-validation and certification validation. Use the self-validation to check
if the transformation code is ok. Use the certification validation to certify this application, which already has been done.
But you can always feed the certify dataset to the certification website to verify if the transformation is still correct. 
For both steps you have to download a few files.

Self-Validation:
----------------
1. Goto https://www.nsgi.nl/geodetische-infrastructuur/producten/programma-rdnaptrans/zelfvalidatie and download
   the ASCII file and store is locally. The file is called: Z001_ETRS89andRDNAP.txt. One file is used for both
   transformation directions.
2. Then copy or import the text file to the SAS server. SAS installation dependent.    
3. Then save the text files as a dataset (Z001_ETRS89andRDNAP) in a permanent library. Example (using the SAS macro autocall) 
   is given below. RDNAP is the libname where the dataset is stored. The column 'i' is mandatory.
   
   %self_validation_import(/folders/myfolders/sasuser.v94/files/input/Z001_ETRS89andRDNAP.txt, RDNAP)

4. To run the self-validation you can use the following macros:
   %self_validation_ETRS89_v1(RDNAP)    -> ETRS89 to RD using V1 method.  -> Output: SELF_ETRS89_V1
   %self_validation_RD_v1(RDNAP)        -> RD to ETRS89 using V1 method.  -> Output: SELF_RDNAP_V1
   %self_validation_ETRS89_v2(RDNAP)    -> ETRS89 to RD using V2 method.  -> Output: SELF_ETRS89_V2
   %self_validation_RD_v2(RDNAP)        -> RD to ETRS89 using V2 method.  -> Output: SELF_RDNAP_V2  
5. The RD to ETRS89 transformation does not give a 100% score here. That is correct.

Certification Validation:
-------------------------
1. Goto https://www.nsgi.nl/geodetische-infrastructuur/producten/programma-rdnaptrans/validatieservice#etrsresult and download
   the two ASCII files and store them locally. The files are called 002_ETRS89.txt and 002_RDNAP.txt.
2. Then copy or import the text files to the SAS server. SAS installation dependent.    
3. Then save the text files as datasets (002_ETRS89 and Z002_RDNAP) in a permanent library. Examples (using the SAS macro autocall) 
   is given below. RDNAP is the libname where the datasets are stored. The column 'i' is mandatory.
   
   %certificate_validation_import(/folders/myfolders/sasuser.v94/files/input/002_ETRS89.txt
                                 ,/folders/myfolders/sasuser.v94/files/input/002_RD.txt
                                 ,RDNAP)
                                 
4. To run the self-validation you can use the following macros:
   %certify_validation_ETRS89_v1(RDNAP, fileName)   -> ETRS89 to RD using V1 method.  -> Output: CERTIFY_ETRS89_V1 and filename
   %certify_validation_RD_v1(RDNAP,fileName)        -> RD to ETRS89 using V1 method.  -> Output: CERTIFY_RDNAP_V1 and filename
   %certify_validation_ETRS89_v2(RDNAP,fileName)    -> ETRS89 to RD using V2 method.  -> Output: CERTIFY_ETRS89_V2 and filename
   %certify_validation_RD_v2(RDNAP,fileName)        -> RD to ETRS89 using V2 method.  -> Output: CERTIFY_RDNAP_V2 and filename
   
5. Then feed the output text file to certification validation service.
   https://www.nsgi.nl/geodetische-infrastructuur/producten/programma-rdnaptrans/validatieservice#etrsresult
   You should see a 100% score for both transformations.


V1 usage:
---------
  First you initialize the global macro variables and transformation parameters.
  A libname, where the grid datasets are stored, is required as input. 
  %rdnaptrans2018_ini_v1(RDNAP)
  
  Then you can perform the transformation you want. Two required parameters, two optional.
  pH   : Specify the height you want to transform. When not defined, no height transformation is done.
  pType: lat/lon can be specified as decimal degrees, default, D M S notation. This parameter does not
         exists for the RD to ETRS89 transformation. 
  %ETRS89_to_RD_v1("52 9 22.178", "5 23 15.500", pH=72.6882, pType=dgr)
  %ETRS89_to_RD_v1(53.199392335, 6.05939747)                          %* 199920.0426 - 579403.4233;
  %RD_to_ETRS89_v1(199920.0426, 579403.4233)                          %* 53.199392335 - 6.05939747;
  
  To display all global macro variables use this macro: 
  %rdnaptrans2018_output_v1
  
  The global macro variables that contains the begin/end result:
  - gmv_ETRS89_lat_dec: ETRS89 latitude in decimal degrees. 
  - gmv_ETRS89_lon_dec: ETRS89 longitude in decimal degrees.
  - gmv_ETRS89_height : ETRS89 height in meter.
  - gmv_RD_x_lon      : RD x coordinate in meter.
  - gmv_RD_y_lat      : RD y coordinate in meter.
  - gmv_NAP_height    : NAP height in meter.
  
  When you want to use V1 for bulk transformation you have to put %ETRS89_to_RD_v1/%RD_to_ETRS89 in a loop.
  That makes it very slow. Not recommended.
  
V2 usage:
---------
  First you initialize a few helper global macro variables and transformation parameters.
  %rdnaptrans2018_ini_v2
  
  Then you load the two grid datasets into memory. 340k global macro variables are created. This may take a few seconds.
  %rdnaptrans2018_grid_v2(RDNAP.RDCORR2018, RDNAP.NLGEO2018)

  Then you prepare the input dataset that contains the coordinates that must be transformed. The following columns are mandatory:
  ETRS89 - > RD | RD -> ETRS89
  --------------+-------------
        lat     |       x
        lon     |       y
          h     |       H
  A lot of columns (more than 100) are added to the output dataset. The following columns contains the end result:
  ETRS89 - > RD | RD -> ETRS89
  --------------+-------------
        RD_x    |   ETRS89_lat
        RD_y    |   ETRS89_lon
        RD_H    |   ETRS89_h
  Wen you do not want to do height transformation, set h or H to -999999. That is then also the return value. 
  The value -999999 is also the return value when the height transformation cannot be done. That occurs when you transform
  outside the height grid that RDNAPTRAN2018 support. That is a valid result.

  %ETRS89_to_RD_v2(EtrsDataSetIn, RdDataSetOut)
  %RD_to_ETRS89_v2(RdDataSetIn, EtrsDataSetOut
  
Note: H and h have different meaning. H is the height in RD NAP (Normaal Amsterdam Peil) and is not perpendicular on x, y. 
      h is the ETRS89 height and is perpendicular on lat, lon. The dimension is in both case the same, meters.
      (Because SAS is case insensitive, the variables h and H are the same.)
Note: H or h are not mandatory in the input dataset. When not specified, H or h is added and set to -999999.
  
RD to WGS84 transformation:
---------------------------
The route to transform RD coordinates to WGS84 is as follows:
1. RD datum transformation to ETRS89 (meters)
2. ETRS89 datum transformation to ITRF2008 or ITRF2014 (meters)
3. ITRF datum transformation to WGS84 (meters)
4. WGS84 conversion to decimal degrees.

The steps 3 and 4 are not done here, because it is a sub-optimalisation. Step2 results in 0.01 cm accuracy.
Also WGS84 is a USA military thing. Because it is used by GPS, Google etc. it is very popular, and there for a
transformation solution is provided here. Please  note it has nothing to do whith the official RDNAPTRANS2018 transformation.
The formulas etc. where provided by Jochem Lesparre from the Netherlands Kadaster/NSGI.
Results were verified using https://www.epncb.oma.be/_productsservices/coord_trans

In this code we regard ITRF2008≈WGS84-G1762. (ITRF2008 almost equal to WGS84-G1762). It also safe to state 
that ITRF2014≈WGS84-G1762. There for both datum transformations will be provided. The default is ITRF2014.
Also a V1 and V2 approach is provided. The following six global macro variables are relevant for the V1 approach:
ITRS_lat    = WGS84_lat
ITRS_lon    = WGS84_lat
ITRS_height = WGS84_height

The ETRS89 to ITRS datum transformation (both ways) can be done standalone.

V1 example:
-----------
%etrs_itrs_ini_v1()
%WGS84_to_ETRS89_v1(52, 5, 43)
%etrs_itrs_output_v1
%ETRS89_to_WGS84_v1(51.999994778222, 4.9999922685, 42.98187019)
%etrs_itrs_output_v1

V2 example:
-----------
%etrs_itrs_ini_v2
%ETRS89_to_WGS84_v2(ETRS89dataset in, WGS84dataset out);

The input dataset must always have the variables lat, lon and h. They respresent the from cooordinate.
A height value is mandatory. Set to zero when there is no height.

Input | to ETRS89 output | to WGS84 output
------+------------------+----------------
 lat  |    ETRS89_lat    | WGS84_lat   
 lon  |    ETRS89_lon    | WGS84_lon
   h  |    ETRS89_h      | WGS84_h

Note: h is not mandatory in the input dataset. When not specified, h is added and set to -999999.

A sort of pseudo validation is provided:   
%WGS84_pseudo_validatation(library)
It takes dataset CERTIFY_RDNAP_V2 as input. There you have ETRS89 coordinates. They are transformed to WGS84 and
then back to ETRS89. Then compared to CERTIFY_RDNAP_V2. The coordinates should be equal.


RDNAPTRANS Architecture. The libname is RDNAP. Regular users should have read-access only.
------------------------------------------------------------------------------------------
 
    +----------------+            +----------------+     +-------------------------+       +------------------+
    | rdcorr2018.txt |            | nlgeo2018.txt  |     | Z001_ETRS89andRDNAP.txt |       | Z002_TRS89.txt   |
    | header   : yes |            | header   : yes |     | header   : no           |       | Z002_RNAP.txt    |
    | delimiter: tab |            | delimiter: tab |     | delimiter: tab          |       | header   : yes   |
    +--------+-------+            +-------+--------+     +------------+------------+       | delimiter: space |
             |                            |                           |                    +--------+---------+  
             |                            |                           |                             |
             v                            v                           v                             V
+-------------------------+  +------------------------+  +-------------------------+  +------------------------------+
| %grid_import_rdcorr2018 |  | %grid_import_nlgeo2018 |  | %self_validation_import |  | %certificate_validate_import |
+------------+------------+  +------------------------+  +-------------------------+  +------------------------------+
             |                            |                           |                             |
             |                            |                           |                             V
             v                            v                           v                      +-------------+
       +------------+               +-----------+          +---------------------+           | Z002_ETRS89 | 
       | RDCORR2018 |               | NLGEO2018 |          | Z001_ETRS89andRDNAP |           | Z001_aRDNAP |
       +------------+               +-----------+          +---------------------+           +-------------+
*/

%macro gm_rdnaptrans2018;
  %* Needed for the autocall;
%mend gm_rdnaptrans2018;

%**********************************;
%* BEGIN: version 1 (ETRS89 to RD) ;
%**********************************;

%macro rdnaptrans2018_ini_v1(pLib /* The library where the RD correction grid dataset is stored */);
  /* Initializes all RDNAPTRANS2018 transformation parameters and global macro variables */
  %global gmv_rdnap_lib;                    %* the library were the RD correction dataset is stored;
  %let gmv_rdnap_lib = &pLib;

  %global gmv_ETRS89_lat_dgr;               %* the lat/lon pair in minutes, second degrees: ellipsoidal geographic ETRS89 coordinates;
  %global gmv_ETRS89_lon_dgr;
  %global gmv_ETRS89_lat_dec;               %* the lat/lon pair in decimal degrees: ellipsoidal geographic ETRS89 coordinates;
  %global gmv_ETRS89_lon_dec;
  %global gmv_ETRS89_lat_rad;               %* the lat/lon pair in radian: ellipsoidal geographic ETRS89 coordinates;
  %global gmv_ETRS89_lon_rad;
  %global gmv_ETRS89_height;                %* the height in ETRS89 meter;

  %global gmv_geoc_cart_ETRS89_X;           %* the lat/lon pair in geocentric cartesian ETRS89 coordinates (meter);
  %global gmv_geoc_cart_ETRS89_Y;
  %global gmv_geoc_cart_ETRS89_Z;

  %global gmv_geoc_cart_RD_Bessel_X;        %* the lat/lon pair in geocentric cartesian RD datum coordinates (meter);
  %global gmv_geoc_cart_RD_Bessel_Y;
  %global gmv_geoc_cart_RD_Bessel_Z;

  %global gmv_geog_ellips_psdo_Bessel_lat;  %* the lat/lon pair in ellipsoidal geographic pseudo Bessel coordinates (radian);
  %global gmv_geog_ellips_psdo_Bessel_lon;

  %global gmv_geog_ellips_real_Bessel_lat;  %* the lat/lon pair in ellipsoidal geographic real Bessel coordinates (degrees);
  %global gmv_geog_ellips_real_Bessel_lon;

  %global gmv_geog_sphere_real_Bessel_lat;  %* the lat/lon pair in sphere geographic real Bessel coordinates (radian);
  %global gmv_geog_sphere_real_Bessel_lon;

  %global gmv_RD_x_lon;                     %* the lat/lon pair in RD meter;
  %global gmv_RD_y_lat;
  %global gmv_NAP_height;                   %* the height in RD meter;

  %global gmv_D_dec;                        %* helper: degree in decimal notation;
  %global gmv_D_rad;                        %* helper: degree in radian;

  /*
  Three parameters for the conversion from ellipsoidal geographic ETRS89 coordinates to geocentric Cartesian ETRS89 coordinates;
  - First two: parameters of GRS80 ellipsoid.
  - Third one: parameter for fixed ellipsoidal ETRS89 height.
  */
  %global gmv_GRS80_a;        %* half major (equator) axis of GRS80 ellipsoid in meter;
  %global gmv_GRS80_f;        %* flattening of GRS80 ellipsoid (dimensionless);
  %global gmv_ETRS89_h0;      %* ellipsoidal ETRS89 height approximately corresponding to 0 m in NAP (m);
  %let gmv_GRS80_a   = 6378137;
  %let gmv_GRS80_f   = %sysevalf(1/298.257222101);
  %let gmv_ETRS89_h0 = 43;
  %put &=gmv_GRS80_a meter;
  %put &=gmv_GRS80_f;
  %put &=gmv_ETRS89_h0 meter;

  /* Used for inverse transformation; RD to ETRS89 */
  %global gmv_epsilon_GRS80_threshold;            %* 𝜀 = precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_epsilon_GRS80_threshold = %sysevalf(0.00000000002); 
  %put &=gmv_epsilon_GRS80_threshold radian;

  /* Seven parameters for the 3D similarity transformation from ETRS89 to RD. */
  %global gmv_tX;       %* translation in direction of X axis meter;
  %global gmv_tY;       %* translation in direction of Y axis meter;
  %global gmv_tZ;       %* translation in direction of Z axis meter;
  %global gmv_alpha;    %* rotation angle around X axis (−1.91513*10−6 rad);
  %global gmv_beta;     %* rotation angle around Y axis (+1.60365*10−6 rad);
  %global gmv_gamma;    %* rotation angle around Z axis (−9.09546*10−6 rad);
  %global gmv_delta;    %* scale difference (dimensionless, −4.07242*10−6);
  %let gmv_tX = %sysevalf(-565.7346);
  %let gmv_tY = %sysevalf(-50.4058);
  %let gmv_tZ = %sysevalf(-465.2895);
  %conv_dgr_dec_rad("0 0 -0.395023")
  %let gmv_alpha = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 0.330776")
  %let gmv_beta = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 -1.876073")
  %let gmv_gamma = &gmv_D_rad;
  %let gmv_delta = %sysevalf(-0.00000407242);
  %put &=gmv_tX meter;
  %put &=gmv_tY meter;
  %put &=gmv_tZ meter;
  %put &=gmv_alpha radian;
  %put &=gmv_beta radian;
  %put &=gmv_gamma radian;
  %put &=gmv_delta (dimensionless);

  /* Seven parameters for the 3D similarity transformation from RD to ETRS89. The suffix inv means inverse */
  %global gmv_tX_inv;       %* translation in direction of X axis meter;
  %global gmv_tY_inv;       %* translation in direction of Y axis meter;
  %global gmv_tZ_inv;       %* translation in direction of Z axis meter;
  %global gmv_alpha_inv;    %* rotation angle around X axis (−1.91513 ∙ 10−6 rad);
  %global gmv_beta_inv;     %* rotation angle around Y axis (+1.60365 ∙ 10−6 rad);
  %global gmv_gamma_inv;    %* rotation angle around Z axis (−9.09546 ∙ 10−6 rad);
  %global gmv_delta_inv;    %* scale difference (dimensionless, −4.07242 ∙ 10−6);
  %let gmv_tX_inv = %sysevalf(565.7381);
  %let gmv_tY_inv = %sysevalf(50.4018);
  %let gmv_tZ_inv = %sysevalf(465.2904);
  %conv_dgr_dec_rad("0 0 0.395026")
  %let gmv_alpha_inv = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 -0.330772")
  %let gmv_beta_inv = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 1.876074")
  %let gmv_gamma_inv = &gmv_D_rad;
  %let gmv_delta_inv = %sysevalf(0.00000407244);
  %put &=gmv_tX_inv meter;
  %put &=gmv_tY_inv meter;
  %put &=gmv_tZ_inv meter;
  %put &=gmv_alpha_inv radian;
  %put &=gmv_beta_inv radian;
  %put &=gmv_gamma_inv radian;
  %put &=gmv_delta_inv (dimensionless);

  /* Two parameters of Bessel 1841 ellipsoid in the conversion to ellipsoidal geographic pseudo Bessel coordinates */
  %global gmv_B1841_a;                    %* half major (equator) axis of Bessel 1841 ellipsoid in meter;
  %global gmv_B1841_f;                    %* flattening of Bessel 1841 ellipsoid (dimensionless);
  %global gmv_epsilon_B1841_threshold;    %* 𝜀 = precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_B1841_a = %sysevalf(6377397.155);
  %let gmv_B1841_f = %sysevalf(1/299.1528128);
  %let gmv_epsilon_B1841_threshold = %sysevalf(0.00000000002);
  %put &=gmv_B1841_a meter;
  %put &=gmv_B1841_f;
  %put &=gmv_epsilon_B1841_threshold radian; 

  /* RD to ETRS9: Fixed ellipsoidal height used in the conversion to geocentric Cartesian Bessel */
  %global gmv_RD_Bessel_h0;          %* ellipsoidal RD Bessel height approximately corresponding to 0 m in NAP (m) ;
  %let gmv_RD_Bessel_h0 = 0;
  %put &=gmv_RD_Bessel_h0 meter;

  /*
  Parameters used for coordinate correction in conjunction with the tab-separated value ASCII text correction grid file rdcorr2018.txt.
  The values are in degrees, because they are also in degrees in the correction file. No need to convert to radian because at this step
  we are not using Trigonometry functions.
  */
  %global gmv_phi_min;               %* 𝜑𝑚𝑖𝑛 = 50° latitude of southern bound of correction grid;
  %global gmv_phi_max;               %* 𝜑𝑚𝑎𝑥 = 56° latitude of northern bound of correction grid;
  %global gmv_labda_min;             %* 𝜆𝑚𝑖𝑛 = 2° longitude of western bound of correction grid;
  %global gmv_labda_max;             %* 𝜆𝑚𝑎𝑥 = 8° longitude of eastern bound of correction grid;
  %global gmv_phi_delta;             %* Δ𝜑= 0.0125° = 45″ latitude spacing of correction grid, corresponding to about 1.4 km;
  %global gmv_labda_delta;           %* Δ𝜆 = 0.02° = 72″ longitude spacing of correction grid, corresponding to about 1.4 km;
  %global gmv_c0;                    %* 𝑐0 = 0.0000 m correction value outside bounds of correction grid;
  %global gmv_epsilon_RD_threshold;  %* 𝜀 = 0.000 000 001° precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_phi_min = 50;
  %let gmv_phi_max = 56;
  %let gmv_labda_min = 2;
  %let gmv_labda_max = 8;
  %let gmv_phi_delta = %sysevalf(0.0125);
  %let gmv_labda_delta = %sysevalf(0.02);
  %let gmv_c0 = 0;
  %let gmv_epsilon_RD_threshold = %sysevalf(0.000000001);
  %put &=gmv_phi_min degrees;
  %put &=gmv_phi_max degrees;
  %put &=gmv_labda_min degrees;
  %put &=gmv_labda_max degrees;
  %put &=gmv_phi_delta degrees;
  %put &=gmv_labda_delta degrees;
  %put &=gmv_c0 meter;
  %put &=gmv_epsilon_RD_threshold degrees; 

  %global gmv_phi0_amersfoort;                  %* latitude of central point Amersfoort on Bessel ellipsoid;
  %global gmv_labda0_amersfoort;                %* longitude of central point Amersfoort on Bessel ellipsoidl;
  %global gmv_k_amersfoort;                     %* scale factor (dimensionless);
  %global gmv_x0_amersfoort;                    %* false Easting;
  %global gmv_y0_amersfoort;                    %* false Northing;
  %let gmv_k_amersfoort = %sysevalf(0.9999079);
  %let gmv_x0_amersfoort = 155000;
  %let gmv_y0_amersfoort = 463000;
  %conv_dgr_dec_rad("52 9 22.178")
  %let gmv_phi0_amersfoort = &gmv_D_rad;        %* 52.156160556;
  %conv_dgr_dec_rad("5 23 15.500");
  %let gmv_labda0_amersfoort =  &gmv_D_rad;     %*  5.387638889;
  %put &=gmv_phi0_amersfoort radian;
  %put &=gmv_labda0_amersfoort radian;
  %put &=gmv_k_amersfoort (dimensionless);
  %put &=gmv_x0_amersfoort meter;
  %put &=gmv_y0_amersfoort meter;
%mend rdnaptrans2018_ini_v1;

%macro rdnaptrans2018_output_v1;
  %put &=gmv_ETRS89_lat_dec degrees;
  %put &=gmv_ETRS89_lon_dec degrees;
  %put &=gmv_ETRS89_height meter;

  %put &=gmv_geoc_cart_ETRS89_X;
  %put &=gmv_geoc_cart_ETRS89_Y;
  %put &=gmv_geoc_cart_ETRS89_Z;

  %put &=gmv_geoc_cart_RD_Bessel_X;
  %put &=gmv_geoc_cart_RD_Bessel_Y;
  %put &=gmv_geoc_cart_RD_Bessel_Z;

  %put &=gmv_geog_ellips_psdo_Bessel_lat;
  %put &=gmv_geog_ellips_psdo_Bessel_lon;

  %put &=gmv_geog_ellips_real_Bessel_lat;
  %put &=gmv_geog_ellips_real_Bessel_lon;

  %put &=gmv_geog_sphere_real_Bessel_lat; 
  %put &=gmv_geog_sphere_real_Bessel_lon;

  %put &=gmv_ETRS89_lat_dec degrees;
  %put &=gmv_ETRS89_lon_dec degrees;
  %put &=gmv_ETRS89_height meter;
  %put &=gmv_RD_x_lon meter;
  %put &=gmv_RD_y_lat meter;
  %put &=gmv_NAP_height meter;
%mend rdnaptrans2018_output_v1;

%macro conv_dgr_to_dec(pLat /* Latitude in D M S notation. A string. Example: 52 9 22.178 */
                      ,pLon /* Longitude in D M S notation. A string Example: 5 23 15.500 */);
  /*
  Convert the latitude and longitude coordinate pair from degree minutes second notation to decimal degree notation. 
  Input:
  - pLat: The latitude in D M S degrees.
  - pLon: The longitude in D M S degrees.
  Output:
  - gmv_ETRS89_lat_dec: The latitude in decimal degrees.
  - gmv_ETRS89_lon_dec: The longitude in decimal degrees.
  */
  data _null_;
    length lat lon $32.;
    format lat_dec lon_dec BEST32.;

    lat = strip(&pLat);
    lon = strip(&pLon);
    lat_dec = input(scan(lat,1,' '),8.) + (input(scan(lat,2,' '),8.)/60)+ (input(scan(lat,3,' '),16.)/3600);
    lon_dec = input(scan(lon,1,' '),8.) + (input(scan(lon,2,' '),8.)/60)+ (input(scan(lon,3,' '),16.)/3600);
    call symputx('gmv_ETRS89_lat_dec',strip(put(lat_dec,BEST32.)));
    call symputx('gmv_ETRS89_lon_dec',strip(put(lon_dec,BEST32.)));
  run;
%mend conv_dgr_to_dec;

%macro conv_dec_to_rad(pLat /* Latitude in decimal notation. A float. Example: 53.155951112 */
                      ,pLon /* Longitude in decimal notation. A float. Example: 3.439678554 */);
  /*
  Convert the the latitude and longitude coordinate pair from from decimal degree notation to radian notation.
  Input:
  - pLat: The latitude in decimal degrees.
  - pLon: The longitude in decimal degrees.
  Output:
  - gmv_ETRS89_lat_rad: The latitude in radian.
  - gmv_ETRS89_lon_rad: The longitude in radian.
  */
  data _null_;
    format lat lon lat_rad lon_rad BEST32.;

    lat = &pLat;
    lon = &pLon;
    lat_rad = lat * constant('pi')/180;
    lon_rad = lon * constant('pi')/180;
    call symputx('gmv_ETRS89_lat_rad',strip(put(lat_rad,BEST32.)));
    call symputx('gmv_ETRS89_lon_rad',strip(put(lon_rad,BEST32.)));
  run;
%mend conv_dec_to_rad;

%macro conv_dgr_dec_rad(pD /* Degree in D M S notation. A string. Example: 52 9 22.178 */);
  /*
  Convert a degree value in minutes second notation to decimal degree notation and radian.
  Input:
  - pD: The degree value in D M S degree notation.
  Output:
  - gmv_D_dec: The degree value in decimal degrees.
  - gmv_D_rad: The degree value in radian degrees.
  */
  data _null_;
    length D $32.;
    format D_dec D_rad BEST32.;

    D = strip(&pD);
    D_dec = input(scan(D,1,' '),8.) + (input(scan(D,2,' '),8.)/60)+ (input(scan(D,3,' '),16.)/3600);
    D_rad = D_dec * constant('pi')/180;
    call symputx('gmv_D_dec',strip(put(D_dec,BEST32.)));
    call symputx('gmv_D_rad',strip(put(D_rad,BEST32.)));
  run;
%mend conv_dgr_dec_rad;

%macro RD_datum_transformation(pLat /* Latitude in radian notation. A float. Example: 0.155951112 */
                              ,pLon /* Longitude in radian notation. A float. Example: 0.439678554 */);
  /*
  Three steps:  
  - Conversion from ellipsoidal geographic ETRS89 coordinates to geocentric Cartesian ETRS89 coordinates to 
    be able to apply a 3D similarity transformation.
  - The 3D similarity transformation itself.
  - Conversion from geocentric Cartesian Bessel coordinates to ellipsoidal geographic Bessel coordinates, also called
    pseudo Bessel coordinates.
  Note: Some variables are re-used. The output of a step is used as input for the next step.

  Input:
  - pLat: The latitude in radian.
  - pLon: The Longitude in radian.
  Output:
  - gmv_geog_ellips_psdo_Bessel_lat: The geograhic ellipsoidal pseudo Bessel latitude in radian.
  - gmv_geog_ellips_psdo_Bessel_lon: The geograhic ellipsoidal pseudo Bessel longitude in radian.
  */
  data _null_;
    format a_grs80 f_grs80 BEST32.;
    format h BEST32.;
    format RN X Y Z phi labda BEST32.;
    format e_square_grs80 BEST32.;

    format X1 Y1 Z1 BEST32.;
    format alpha beta gamma delta BEST32.;
    format tX tY tZ BEST32.;
    format s BEST32.;
    format R11 R12 R13 R21 R22 R23 R31 R32 R33 BEST32.;
    format X2 Y2 Z2 BEST32.;

    format a_b1841 f_b1841 epsilon BEST32.;
    format e_square_b1841 BEST32.;
    format i phi1 BEST32.;    %* phi1 the new calculated one;

    phi   = &pLat;                      %* 𝜑 phi;
    labda = &pLon;                      %* 𝜆 labda;

    /*
    Conversion to geocentric cartesian ETRS89 coordinates. The ellipsoidal geographic ETRS89 coordinates must be converted to 
    geocentric Cartesian ETRS89 coordinates to be able to apply a 3D similarity transformation.
    */
    a_grs80 = input(symget('gmv_GRS80_a'),BEST32.);
    f_grs80 = input(symget('gmv_GRS80_f'),BEST32.);
    h = input(symget('gmv_ETRS89_h0'),BEST32.);

    e_square_grs80 = f_grs80*(2-f_grs80);
    RN = a_grs80/sqrt(1 - (e_square_grs80 * (sin(phi)**2)));
 
    X = (RN + h) * cos(phi) * cos(labda);
    Y = (RN + h) * cos(phi) * sin(labda);
    Z = ((RN * (1 - e_square_grs80)) + h) * sin(phi);

    call symputx('gmv_geoc_cart_ETRS89_X',strip(put(X,BEST32.)));
    call symputx('gmv_geoc_cart_ETRS89_Y',strip(put(Y,BEST32.)));
    call symputx('gmv_geoc_cart_ETRS89_Z',strip(put(Z,BEST32.)));
    
    /*
    Rigorous 3D similarity transformation of geocentric Cartesian coordinates.
    The formula for a 3D similarity transformation must be applied to the geocentric Cartesian ETRS89 coordinates of the
    point of interest. The obtained geocentric Cartesian coordinates are in the geodetic datum of RD. The geodetic datum
    is often referred to as RD Bessel or just Bessel, even though geocentric Cartesian coordinates do not use the Bessel ellipsoid.
    */
    X1 = X;
    Y1 = Y;
    Z1 = Z;
    alpha = input(symget('gmv_alpha'),BEST32.);
    beta  = input(symget('gmv_beta'),BEST32.);
    gamma = input(symget('gmv_gamma'),BEST32.);
    delta = input(symget('gmv_delta'),BEST32.);
    tX = input(symget('gmv_tX'),BEST32.);
    tY = input(symget('gmv_tY'),BEST32.);
    tZ = input(symget('gmv_tZ'),BEST32.);

    s = 1 + delta;
    R11 = cos(gamma) * cos(beta);
    R12 = cos(gamma) * sin(beta) * sin(alpha)  + sin(gamma) * cos(alpha);
    R13 = -cos(gamma) * sin(beta) * cos(alpha) + sin(gamma) * sin(alpha);
    R21 = -sin(gamma) * cos(beta);
    R22 = -sin(gamma) * sin(beta) * sin(alpha) + cos(gamma) * cos(alpha);
    R23 = sin(gamma) * sin(beta) * cos(alpha) + cos(gamma) * sin(alpha);
    R31 = sin(beta);
    R32 = -cos(beta) * sin(alpha);
    R33 = cos(beta) * cos(alpha);

    X2 = s * (R11 * X1 + R12 * Y1 + R13 * Z1) + tX;
    Y2 = s * (R21 * X1 + R22 * Y1 + R23 * Z1) + tY;
    Z2 = s * (R31 * X1 + R32 * Y1 + R33 * Z1) + tZ;
    call symputx('gmv_geoc_cart_RD_Bessel_X',strip(put(X2,BEST32.)));
    call symputx('gmv_geoc_cart_RD_Bessel_Y',strip(put(Y2,BEST32.)));
    call symputx('gmv_geoc_cart_RD_Bessel_Z',strip(put(Z2,BEST32.)));

    /*
    The geocentric Cartesian Bessel coordinates of the point of interest must be converted back to ellipsoidal geographic
    Bessel coordinates. The ellipsoidal height is not given in the formula, as it is not used. The formula for latitude contains
    the latitude itself. The initial value for the latitude should be used to obtain an approximation of the latitude.
    This approximate value is then used to obtain an improved approximation. The latitude is computed iteratively until
    the difference between subsequent iterations becomes smaller than the precision threshold.
    Note: The ellipsoidal geographic coordinates of a point of interest obtained by datum transformation are pseudo Bessel coordinates.
    */
    X = X2;
    Y = Y2;
    Z = Z2;
    a_b1841 = input(symget('gmv_B1841_a'),BEST32.);
    f_b1841 = input(symget('gmv_B1841_f'),BEST32.);
    epsilon = input(symget('gmv_epsilon_B1841_threshold'),BEST32.);
    e_square_b1841 = f_b1841*(2-f_b1841);

    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    */
    phi1 = input(symget('gmv_ETRS89_lat_dec'),BEST32.);   %* correct, it is an UNTIL loop, thus it is initialized in the loop;
    i = 0;                                                %* iterate counter. To check how many times you iterate;
    do until (abs(phi1-phi) lt epsilon);
      phi = phi1;
      RN = a_b1841/sqrt(1 - (e_square_b1841 * sin(phi)**2));
      if X > 0 then phi1 = atan((Z + e_square_b1841*RN*sin(phi))/sqrt(X**2 + Y**2));
      else if round(X,0.000000000001) eq 0 and round(Y,0.000000000001) eq 0 and round(Z,0.000000000001) ge 0 then phi1 = constant('pi')/2;   %* +90 degrees;
           else phi1 = -1*constant('pi')/2;                                                                                                  %* -90 degrees;
      i + 1;
    end;

    %* The phi or lat value (phi1) has been calculated. Now calculate the labda or lon value;
    if X gt 0 then labda = atan(Y/X);
    else if X lt 0 and Y ge 0 then labda = atan(Y/X) + constant('pi');  %* +180 degrees;
    else if X lt 0 and Y lt 0 then labda = atan(Y/X) - constant('pi');  %* -180 degrees;
    else if X eq 0 and Y gt 0 then labda = constant('pi')/2;            %*  +90 degrees;
    else if X eq 0 and Y lt 0 then labda = -1*constant('pi')/2;         %*  -90 degrees;
    else if X eq 0 and Y eq 0 then labda = 0;

    call symputx('gmv_geog_ellips_psdo_Bessel_lat',strip(put(phi1,BEST32.)));
    call symputx('gmv_geog_ellips_psdo_Bessel_lon',strip(put(labda,BEST32.)));
  run;
%mend RD_datum_transformation;

%macro RD_correction(pLat  /* Pseudo Bessel RD latitude in radian */
                    ,pLon  /* Pseudo Bessel RD longitude in radian */);
  /*
  The ellipsoidal geographic coordinates of a point of interest obtained by datum transformation are pseudo Bessel coordinates.
  Due to the error propagation the pseudo Bessel coordinates must be corrected up to 0.25 m to obtain real Bessel coordinates.
  The horizontal ellipsoidal geographic coordinates of the correction grid points are in real Bessel. There for, also the coordinates
  of the point of interest are needed in real Bessel to determine the right correction. When transforming from ETRS89 to RD, the real
  Bessel coordinates are needed to correct the pseudo Bessel coordinates to real Bessel coordinates. To solve this, the real Bessel
  coordinates are computed iteratively, until the difference between subsequent iterations becomes smaller than the precision threshold.
  
  The correction RD file is a dataset, called &gmv_rdnap_lib..rdcorr2018. The index is the observation. Indexing starts with 1.

  Input:
  - pLat: Pseudo Bessel RD latitude in radian.
  - pLon: Pseudo Bessel RD longitude in radian. 
  Output:
  - gmv_geog_ellips_real_Bessel_lat: The geographic ellipsoidal real Bessel latitude in decimal degrees.
  - gmv_geog_ellips_real_Bessel_lon: The geographic ellipsoidal real Bessel longitude in decimal degrees.
  */
  %local lmv_phi0;                    %* the pseudo RD Bessel latitude, parameter pLat, and converted to degrees;
  %local lmv_phi;                     %* the latitude in degrees;
  %local lmv_phi1;                    %* the new corrected latitude in the loop (degrees);
  %local lmv_labda0;                  %* the pseudo RD Bessel longitude, parameter pLon, , and converted to degrees;
  %local lmv_labda;                   %* the longitude in degrees;
  %local lmv_labda1;                  %* the new corrected longitude in the loop (degrees);
  %local lmv_phinorm;                 %* the normalized longitude of point of interest (dimensionless);
  %local lmv_labdanorm;               %* the normalized longitude of point of interest (dimensionless);
  %local lmv_phi_threshold_bln;       %* boolean: latitude threshold is met or not met;
  %local lmv_labda_threshold_bln;     %* boolean: longitude threshold is met or not met;

  %let lmv_phi_threshold_bln = 0;     %* loop exit criteria or the phi/latitude;
  %let lmv_labda_threshold_bln = 0;   %* loop exit criteria or the labda/longitude;
 
  %* Initialize the loop, and convert to degrees;
  data _null_;
    format lat lon phi labda BEST32.;

    lat = &pLat;
    lon = &pLon;
    phi = lat * 180 / constant('pi');
    labda =  lon * 180 / constant('pi');
    call symputx('lmv_phi0',strip(put(phi,BEST32.)));
    call symputx('lmv_phi',strip(put(phi,BEST32.)));
    call symputx('lmv_phi1',strip(put(phi,BEST32.)));
    call symputx('lmv_labda0',strip(put(labda,BEST32.)));
    call symputx('lmv_labda',strip(put(labda,BEST32.)));
    call symputx('lmv_labda1',strip(put(labda,BEST32.)));
  run;

  %* Here we go into the loop. The phi and labda correction are indenpend of each other;
  %do %until (1=%eval(&lmv_phi_threshold_bln) and 1=%eval(&lmv_labda_threshold_bln));

    %* Get the index used to retrieve RD correction values from the correction table;
    data _null_;
      format phi_min phi_max labda_min labda_max phi_delta labda_delta BEST32.;
      format RDcorrLat RDcorrLon BEST32.;
      format phi0 phi phi1 BEST32.;
      format labda0 labda labda1 BEST32.;
      format phinorm labdanorm BEST32.;
      format nlabda BEST32.;
      format i_nw i_ne i_sw i_se 8.;
      format nw_phi nw_labda BEST32.;
      format ne_phi ne_labda BEST32.;
      format sw_phi sw_labda BEST32.;
      format se_phi se_labda BEST32.;
      format epsilon BEST32.;

      phi0 = input(symget('lmv_phi0'),BEST32.);                %* Here you compare latitude against;
      phi1 = input(symget('lmv_phi1'),BEST32.); 
      phi = phi1;
      labda0 = input(symget('lmv_labda0'),BEST32.);            %* Here you compare longitude against;
      labda1 = input(symget('lmv_labda1'),BEST32.);
      labda = labda1;

      epsilon = input(symget('gmv_epsilon_RD_threshold'),BEST32.);
      phi_threshold_bln = input(symget('lmv_phi_threshold_bln'),8.);
      labda_threshold_bln = input(symget('lmv_labda_threshold_bln'),8.);
      
      phi_min = input(symget('gmv_phi_min'),BEST32.); 
      phi_max = input(symget('gmv_phi_max'),BEST32.); 
      labda_min = input(symget('gmv_labda_min'),BEST32.); 
      labda_max = input(symget('gmv_labda_max'),BEST32.); 
      phi_delta = input(symget('gmv_phi_delta'),BEST32.); 
      labda_delta = input(symget('gmv_labda_delta'),BEST32.); 

      phinorm = (phi-phi_min)/phi_delta;
      labdanorm = (labda-labda_min)/labda_delta;
      nlabda = 1 + ((labda_max-labda_min)/labda_delta);
     
      if phi ge phi_min and phi le phi_max and labda ge labda_min and labda le labda_max then do;
        inside_bound_correction_grid = 1;

        i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
        i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) + 1;
        i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
        i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;
                               
        set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=nw_phi)) point=i_nw;
        set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=ne_phi)) point=i_ne;
        set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=sw_phi)) point=i_sw;
        set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=se_phi)) point=i_se;
        set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=nw_labda)) point=i_nw;
        set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=ne_labda)) point=i_ne;
        set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=sw_labda)) point=i_sw;
        set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=se_labda)) point=i_se;
      end;
      else inside_bound_correction_grid = 0;

      %* Here we calculate lat and lon correction at point of interest in real RD Bessel;
      if phi_threshold_bln eq 0 then do;
        if inside_bound_correction_grid eq 1 then RDcorrLat = (phinorm - floor(phinorm)) * ((nw_phi*(floor(labdanorm) + 1 - labdanorm)) + ne_phi*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_phi*(floor(labdanorm) + 1 - labdanorm)) + se_phi*(labdanorm - floor(labdanorm)));
        else RDcorrLat = 0;
        phi1 = phi0 - RDcorrLat;
        if (abs(phi1-phi) lt epsilon) then do;
          phi_threshold_bln = 1;
          call symputx('lmv_phi_threshold_bln',1);
          call symputx('lmv_phi1',strip(put(phi1,BEST32.)));
        end;
        else do;
          call symputx('lmv_phi1',strip(put(phi1,BEST32.)));
        end;
      end;

      if labda_threshold_bln eq 0 then do;
        if inside_bound_correction_grid eq 1 then RDcorrLon = (phinorm - floor(phinorm)) * ((nw_labda*(floor(labdanorm) + 1 - labdanorm)) + ne_labda*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_labda*(floor(labdanorm) + 1 - labdanorm)) + se_labda*(labdanorm - floor(labdanorm)));
        else RDcorrLon = 0;
        labda1 = labda0 - RDcorrLon;
        if (abs(labda1-labda) lt epsilon) then do;
          labda_threshold_bln = 1;
          call symputx('lmv_labda_threshold_bln',1);
          call symputx('lmv_labda1',strip(put(labda1,BEST32.)));
        end;
        else do;
          call symputx('lmv_labda1',strip(put(labda1,BEST32.)));
        end;
      end;

      stop;
    run;
  %end;

  %let gmv_geog_ellips_real_Bessel_lat = &lmv_phi1;
  %let gmv_geog_ellips_real_Bessel_lon = &lmv_labda1;
%mend RD_correction;

%macro RD_map_projection(pLat /* Real Bessel Latitude on ellips, in decimal degrees */
                        ,pLon /* Real Bessel Longitude on ellips, in decimal degrees */);
  /*
  Projection from ellipsoid to sphere. The corrected ellipsoidal geographic Bessel coordinates of a point of interest must 
  be projected to obtain RD coordinates. Two steps:
  - Gauss conformal projection of coordinates on ellipsoid to coordinates on sphere.
  - Projection from sphere to plane.
  
  Input:
  - pLat: Real Bessel Latitude on ellips, in decimal degrees.
  - pLon: Real Bessel Longitude on ellips, in decimal degrees.
  Output:
  - gmv_RD_x_lon: The x-coordinate in meter.
  - gmv_RD_y_lat: The y-coordinate in meter.
  */
  data _null_;
    format const_90_degrees BEST32.;                             %* this is pi/2 radian which is 90 degrees;
    format const_180_degrees BEST32.;                            %* this is pi radian which is 180 degrees;
    format phi phi0 PHI_C PHI0_C labda labda0 LABDA_C LABDA0_C BEST32.;
    format k x0 y0 a f e BEST32.;
    format RM RN R_sphere BEST32.;
    format q0 w0 q w m n BEST32.;
    format sin_psi_2 cos_psi_2 tan_psi_2 BEST32.;
    format sin_alpha cos_alpha r_distance BEST32.;
    format x y BEST32.;                                          %* the output. the RD x y coordinates;

    const_90_degrees = constant('pi')/2;                          %* 90 degrees in radian;
    const_180_degrees = constant('pi');                           %* 180 degrees in radian;

    phi = &pLat;
    labda= &pLon;

    /*
    Gauss conformal projection of coordinates on ellipsoid to coordinates on sphere.
    Convert the input values back to radian.
    */
    phi = phi * constant('pi')/180;
    labda = labda * constant('pi')/180;

    %* Get the parameters of RD Map projection and Bessel 1841 ellipsoid parameter;
    phi0 = input(symget('gmv_phi0_amersfoort'),BEST32.); 
    labda0 = input(symget('gmv_labda0_amersfoort'),BEST32.); 
    k = input(symget('gmv_k_amersfoort'),BEST32.);
    x0 = input(symget('gmv_x0_amersfoort'),BEST32.);
    y0 = input(symget('gmv_y0_amersfoort'),BEST32.);
    a = input(symget('gmv_B1841_a'),BEST32.);
    f = input(symget('gmv_B1841_f'),BEST32.);

    %* Start with derived parameter calculation of the RD map projection;
    e =  sqrt(f*(2-f));
    q0 = log(tan((phi0 + const_90_degrees)/2)) - (e/2) * (log((1 + e*sin(phi0))/(1 - e*sin(phi0))));
    RN = a / sqrt(1 - (e**2*(sin(phi0)**2)));
    RM = (RN*(1 - e**2))/(1-(e**2*(sin(phi0)**2)));
    R_sphere = sqrt(RM*RN);
    PHI0_C = atan((sqrt(RM)/sqrt(RN))*tan(phi0)); 
    LABDA0_C = labda0;
    w0 = log(tan((PHI0_C + const_90_degrees)/2));
    n = sqrt(1 + ((e**2*(cos(phi0)**4))/(1 - e**2)));
    m = w0 - n*q0;

    /*
    Gauss conformal projection of coordinates on ellipsoid to coordinates on sphere. To prevent undefined results due 
    to taking the tangent of a number close to 90°, a tolerance should be used to test if the latitude is 90°. 
    Rounding the ellipsoidal coordinates in advance to 0.000 000 001° or 2*10−11 rad suffices.
    No rounding done and no 90° and -90° check. 
    */
    q = log(tan((phi + const_90_degrees)/2)) - (e/2) * (log((1 + e*sin(phi))/(1 - e*sin(phi))));
    w = n*q + m;
    PHI_C =  2*atan(exp(w)) - const_90_degrees;
    LABDA_C = LABDA0_C + n*(labda - labda0);

    /*
    Projection from sphere to plane: the second step of the RD map projection of the point of interest is an oblique 
    stereographic conformal projection from sphere to a plane to obtain RD coordinates    
    To prevent arithmetic overflow due to division by a number close to zero, a tolerance should be used to test if the
    point of interest is close to the central point itself or the point opposite on the sphere. Rounding the spherical 
    coordinates in advance to 0.000 000 001° or 2*10−11 rad suffices. No rounding is done here.
    */
    sin_psi_2 = sqrt(sin((PHI_C - PHI0_C)/2)**2 + ((sin((LABDA_C - LABDA0_C)/2)**2)*cos(PHI_C)*cos(PHI0_C)));
    cos_psi_2 = sqrt(1 - sin_psi_2**2);
    tan_psi_2 = sin_psi_2/cos_psi_2;
    sin_alpha = (sin(LABDA_C - LABDA0_C)*cos(PHI_C))/(2*sin_psi_2*cos_psi_2);
    cos_alpha = (sin(PHI_C) - sin(PHI0_C) + 2*sin(PHI0_C)*(sin_psi_2**2))/(2*cos(PHI0_C)*sin_psi_2*cos_psi_2);
    r_distance = 2*k*R_sphere*tan_psi_2;

    if PHI_C eq PHI0_C and LABDA_C eq LABDA0_C then do;
      x = x0;
      y = y0;
    end;
    else do;
      if (PHI_C ne PHI0_C or LABDA_C ne LABDA0_C) and (PHI_C ne -1*PHI0_C or LABDA_C ne const_180_degrees-LABDA0_C) then do;
        x = r_distance*sin_alpha + x0;
        y = r_distance*cos_alpha + y0;
      end;
      else do;     %* undefined;
        x = 0;
        y = 0;
      end;
    end;

    call symputx('gmv_RD_x_lon',strip(put(x,BEST32.)));
    call symputx('gmv_RD_y_lat',strip(put(y,BEST32.)));
  run;
%mend RD_map_projection;

%macro height_transformation(pLat  /* The latitude in decimal degrees */
                            ,pLon  /* The longitude in decimal degrees */
                            ,pH    /* The height. In NAP meter, or ETRS89 meter */
                            ,pType /* The conversion type: 1:from ETRS89 to RD, 2: from RD to ETRS89 */);
  /*
  ETRS89 to RD:
  The ellipsoidal height is not used with RD coordinates as it is purely geometrical and has no physical meaning. The
  height transformation from ellipsoidal ETRS89 height of a point of interest to NAP height is based on the quasi-geoid
  model NLGEO2018. The quasi-geoid height at the point of interest is obtained by bilinear interpolation of a regular grid of
  quasi-geoid height values.
  RD to ETRS89:
  The physical NAP height of a point of interest can be transformed to the purely geometrical ellipsoidal ETRS89 height. The
  height transformation from NAP to ETRS89 is based on the quasi-geoid model NLGEO2018. The quasi-geoid height at the
  point of interest is obtained by bilinear interpolation of a regular grid of quasi-geoid height values

  The NAP file is a dataset, called &gmv_rdnap_lib..nlgeo2018. The index is the observation. Indexing starts with 1.
  
  Input:
  - pLat  : The latitude in decimal degrees.
  - pLon  : The longitude in decimal degrees.
  - pH    : The height. In NAP meter, or ETRS89 meter, depending on pType value.
  - pType : The conversion type: 1:from ETRS89 to RD, 2: from RD to ETRS89.
  Output:
  - gmv_NAP_height   : The NAP height in meter. When converting form ETRS89 to RD.
  - gmv_ETRS89_height: The ETRS height in meter. When converting form RD to ETRS89.
  */
  data _null_;
    format phi_min phi_max labda_min labda_max phi_delta labda_delta BEST32.;
    format phi labda height conv_height BEST32.;
    format phinorm labdanorm BEST32.;
    format nlabda BEST32.;
    format i_nw i_ne i_sw i_se 8.;
    format nw_height ne_height sw_height se_height BEST32.;
    format etrs89_quasi_height BEST32.;
    format conv_type 8.;

    phi = &pLat;
    labda = &pLon;
    height = &pH;
    conv_type = &pType;

    phi_min = input(symget('gmv_phi_min'),BEST32.); 
    phi_max = input(symget('gmv_phi_max'),BEST32.); 
    labda_min = input(symget('gmv_labda_min'),BEST32.); 
    labda_max = input(symget('gmv_labda_max'),BEST32.); 
    phi_delta = input(symget('gmv_phi_delta'),BEST32.); 
    labda_delta = input(symget('gmv_labda_delta'),BEST32.); 

    phinorm = (phi-phi_min)/phi_delta;
    labdanorm = (labda-labda_min)/labda_delta;
    nlabda = 1 + ((labda_max-labda_min)/labda_delta);

    %* Rounding needed for the test validation;
    if round(phi,0.00000001) ge phi_min and round(phi,0.00000001) le phi_max and round(labda,0.00000001) ge labda_min and round(labda,0.00000001) le labda_max then do;

      i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
      i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) +  1;
      i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
      i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;

      set &gmv_rdnap_lib..nlgeo2018(keep=nap_height rename=(nap_height=nw_height)) point=i_nw;
      set &gmv_rdnap_lib..nlgeo2018(keep=nap_height rename=(nap_height=ne_height)) point=i_ne;
      set &gmv_rdnap_lib..nlgeo2018(keep=nap_height rename=(nap_height=sw_height)) point=i_sw;
      set &gmv_rdnap_lib..nlgeo2018(keep=nap_height rename=(nap_height=se_height)) point=i_se;

      etrs89_quasi_height = (phinorm - floor(phinorm)) * ((nw_height*(floor(labdanorm) + 1 - labdanorm)) + ne_height*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_height*(floor(labdanorm) + 1 - labdanorm)) + se_height*(labdanorm - floor(labdanorm)));
    end;
    else do;
      etrs89_quasi_height = -999999;
    end;
    if conv_type eq 1 then do;
      if etrs89_quasi_height ne -999999 then conv_height = height - etrs89_quasi_height;
      else conv_height = -999999;
      call symputx('gmv_NAP_height',strip(put(conv_height,BEST32.)));
    end;
    else do;
      if etrs89_quasi_height ne -999999 then conv_height = height + etrs89_quasi_height;
      else conv_height = -999999;
      call symputx('gmv_ETRS89_height',strip(put(conv_height,BEST32.)));
    end;
    stop;
  run;  
%mend height_transformation;

%macro inverse_map_projection(pX /* RD X coordinate in meter */
                             ,pY /* RD Y coordinate in meter */);
  /*
  Projection from plane to sphere to ellipsoid: RD coordinates of a point of interest must be converted to Bessel coordinates.
  Two steps:
  - Inverse oblique stereographic conformal projection from the RD projection plane to a sphere. 
  - Inverse Gauss conformal projection from the sphere to the Bessel ellipsoid to obtain Bessel coordinates.

  Input:
  - pX: RD X coordinate in meter.
  - pY: RD Y coordinate in meter.
  Output:
  - gmv_geog_ellips_real_Bessel_lat: Geographic ellipsoidal real Bessel latitude in radian.
  - gmv_geog_ellips_real_Bessel_lon: Geographic ellipsoidal real Bessel longitude in radian.
  */
  data _null_;
    format x y BEST32.;                                         %* the input. the RD x y coordinates;
    format const_90_degrees BEST32.;                            %* this is pi/2 radian which is 90 degrees;
    format const_180_degrees BEST32.;                           %* this is pi radian which is 180 degrees;
    format const_360_degrees BEST32.;                           %* this is 2*pi radian which is 360 degrees;
    format phi phi0 PHI_C PHI0_C labda_n labda labda0 LABDA_C LABDA0_C BEST32.;
    format k x0 y0 a f e BEST32.;
    format RM RN R_sphere BEST32.;
    format psi sin_alpha cos_alpha r_distance BEST32.;
    format Xnorm Ynorm Znorm BEST32.;
    format epsilon BEST32.;
    format q0 w0 q w m n BEST32.;

    x = &pX;
    y = &pY;

    /* Inverse oblique stereographic conformal projection from the RD projection plane to a sphere */
    const_90_degrees = constant('pi')/2;              %* 90 degrees in radian;
    const_180_degrees = constant('pi');               %* 180 degrees in radian;
    const_360_degrees = 2*constant('pi');             %* 360 degrees in radian;

    %* Get the parameters of RD Map projection and Bessel 1841 ellipsoid parameter;
    phi0 = input(symget('gmv_phi0_amersfoort'),BEST32.); 
    labda0 = input(symget('gmv_labda0_amersfoort'),BEST32.); 
    k = input(symget('gmv_k_amersfoort'),BEST32.);
    x0 = input(symget('gmv_x0_amersfoort'),BEST32.);
    y0 = input(symget('gmv_y0_amersfoort'),BEST32.);
    a = input(symget('gmv_B1841_a'),BEST32.);
    f = input(symget('gmv_B1841_f'),BEST32.);
    epsilon = input(symget('gmv_epsilon_B1841_threshold'),BEST32.);

    %* Start with derived parameter calculation of the RD map projection;
    e =  sqrt(f*(2-f));
    RN = a / sqrt(1 - (e**2*(sin(phi0)**2)));
    RM = (RN*(1 - e**2))/(1-(e**2*(sin(phi0)**2)));
    R_sphere = sqrt(RM*RN);
    PHI0_C = atan((sqrt(RM)/sqrt(RN))*tan(phi0)); 
    LABDA0_C = labda0;

    %* Inverse oblique stereographic projection of coordinates on plane to coordinates on sphere;
    r_distance = sqrt((x - x0)**2 + (y - y0)**2);
    sin_alpha = (x - x0)/r_distance;
    cos_alpha = (y - y0)/r_distance;
    psi =  2 * atan(r_distance/(2*k*R_sphere));
    if x ne x0 or y ne y0 then do;
      Xnorm = cos(PHI0_C)*cos(psi) - cos_alpha*sin(PHI0_C)*sin(psi);
      Ynorm = sin_alpha*sin(psi);
      Znorm = cos_alpha*cos(PHI0_C)*sin(psi) + sin(PHI0_C)*cos(psi);
    end;
    else do;
      Xnorm = cos(PHI0_C);
      Ynorm = 0;
      Znorm = sin(PHI0_C);
    end;
    PHI_C = arsin(Znorm);
    if Xnorm gt 0 then LABDA_C = LABDA0_C + atan(Ynorm/Xnorm);
    else if Xnorm lt 0 and x ge x0 then LABDA_C = LABDA0_C + atan(Ynorm/Xnorm) + const_180_degrees;
    else if Xnorm lt 0 and x lt x0 then LABDA_C = LABDA0_C + atan(Ynorm/Xnorm) - const_180_degrees;
    else if Xnorm eq 0 and x gt x0 then LABDA_C = LABDA0_C + const_90_degrees;
    else if Xnorm eq 0 and x lt x0 then LABDA_C = LABDA0_C - const_90_degrees;
    else if Xnorm eq 0 and x eq x0 then LABDA_C = LABDA0_C;

    call symputx('gmv_geog_sphere_real_Bessel_lat',strip(put(PHI_C,BEST32.)));
    call symputx('gmv_geog_sphere_real_Bessel_lon',strip(put(LABDA_C,BEST32.)));

    /*
    Projection from sphere to ellipsoid: The second step of the inverse RD map projection is an inverse
    Gauss conformal projection from the sphere to the Bessel ellipsoid to obtain Bessel coordinates.
    Start with remaining derived parameter calculation of the RD map projection.
    */
    q0 = log(tan((phi0 + const_90_degrees)/2)) - (e/2) * (log((1 + e*sin(phi0))/(1 - e*sin(phi0))));
    w0 = log(tan((PHI0_C + const_90_degrees)/2));
    n = sqrt(1 + ((e**2*(cos(phi0)**4))/(1 - e**2)));
    m = w0 - n*q0;

    %* Inverse Gauss conformal projection of coordinates on sphere to coordinates on ellipsoid;
    w = log(tan((PHI_C + const_90_degrees)/2));
    q = (w - m )/n;    
 
    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    */
    phi1 = PHI_C;     %* correct, it is an UNTIL loop, thus it is initialized in the loop;
    i = 0;            %* iterate counter. To check how many times you iterate;
    do until (abs(phi1-phi) lt epsilon);
      phi = phi1;
      if PHI_C gt -1*const_90_degrees and PHI_C lt const_90_degrees then do;
        phi1 = 2*atan(exp(q + (e/2)*log((1 + e*sin(phi))/(1 - e*sin(phi))))) - const_90_degrees;
      end;
      else phi1 = PHI_C;
      i + 1;
    end;
    
    %* The latitute has been calculated, now calculate the longitude;
    labda_n = ((LABDA_C - LABDA0_C)/n) + labda0;
    labda = labda_n + const_360_degrees*floor((const_180_degrees - labda_n)/const_360_degrees);

    call symputx('gmv_geog_ellips_real_Bessel_lat',strip(put(phi1,BEST32.)));
    call symputx('gmv_geog_ellips_real_Bessel_lon',strip(put(labda,BEST32.)));
  run;
%mend inverse_map_projection;

%macro inverse_correction(pLat /* Geographic ellipsoidal real Bessel latitude in radian */
                         ,pLon /* Geographic ellipsoidal real Bessel longitude in radian */);
  /*
  The horizontal ellipsoidal geographic real Bessel coordinates of the point of interest must be corrected to pseudo Bessel coordinates
  using the interpolated correction grid value of the point of interest. No iteration is needed for the transformation from RD to ETRS89
  coordinates as the grid is given in real Bessel coordinates.
  
  The correction RD file is a dataset, called &gmv_rdnap_lib..rdcorr2018. The index is the observation. Indexing starts with 1.

  Input:
  - pLat: Geographic ellipsoidal real Bessel latitude in radian.
  - pLon: Geographic ellipsoidal real Bessel longitude in radian.
  Output:
  - gmv_geog_ellips_psdo_Bessel_lat: Geographic ellipsoidal pseudo Bessel latitude in decimal degrees.
  - gmv_geog_ellips_psdo_Bessel_lon: Geographic ellipsoidal pseudo Bessel longitude in decimal degrees.
  */
  data _null_;
    format lat lon BEST32.;
    format phi_min phi_max labda_min labda_max phi_delta labda_delta BEST32.;
    format RDcorrLat RDcorrLon BEST32.;
    format phi phi1 BEST32.;
    format labda labda1 BEST32.;
    format phinorm labdanorm BEST32.;
    format nlabda BEST32.;
    format i_nw i_ne i_sw i_se 8.;
    format nw_phi nw_labda BEST32.;
    format ne_phi ne_labda BEST32.;
    format sw_phi sw_labda BEST32.;
    format se_phi se_labda BEST32.;

    lat = &pLat;
    lon = &pLon;
    phi = lat * 180 / constant('pi');        %* in degrees;
    labda =  lon * 180 / constant('pi');

    phi_min = input(symget('gmv_phi_min'),BEST32.); 
    phi_max = input(symget('gmv_phi_max'),BEST32.); 
    labda_min = input(symget('gmv_labda_min'),BEST32.); 
    labda_max = input(symget('gmv_labda_max'),BEST32.); 
    phi_delta = input(symget('gmv_phi_delta'),BEST32.); 
    labda_delta = input(symget('gmv_labda_delta'),BEST32.); 

    phinorm = (phi-phi_min)/phi_delta;
    labdanorm = (labda-labda_min)/labda_delta;
    nlabda = 1 + ((labda_max-labda_min)/labda_delta);
     
    if phi ge phi_min and phi le phi_max and labda ge labda_min and labda le labda_max then do;

      i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
      i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) + 1;
      i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
      i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;
 
      set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=nw_phi)) point=i_nw;
      set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=ne_phi)) point=i_ne;
      set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=sw_phi)) point=i_sw;
      set &gmv_rdnap_lib..rdcorr2018(keep=lat_corr rename=(lat_corr=se_phi)) point=i_se;
      set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=nw_labda)) point=i_nw;
      set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=ne_labda)) point=i_ne;
      set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=sw_labda)) point=i_sw;
      set &gmv_rdnap_lib..rdcorr2018(keep=lon_corr rename=(lon_corr=se_labda)) point=i_se;

      RDcorrLat = (phinorm - floor(phinorm)) * ((nw_phi*(floor(labdanorm) + 1 - labdanorm)) + ne_phi*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_phi*(floor(labdanorm) + 1 - labdanorm)) + se_phi*(labdanorm - floor(labdanorm)));
      RDcorrLon = (phinorm - floor(phinorm)) * ((nw_labda*(floor(labdanorm) + 1 - labdanorm)) + ne_labda*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_labda*(floor(labdanorm) + 1 - labdanorm)) + se_labda*(labdanorm - floor(labdanorm)));
    end;
    else do;
      RDcorrLat = 0;
      RDcorrLon = 0;
    end;
    phi1 = phi + RDcorrLat;
    labda1 = labda + RDcorrLon;

    call symputx('gmv_geog_ellips_psdo_Bessel_lat',strip(put(phi1,BEST32.)));
    call symputx('gmv_geog_ellips_psdo_Bessel_lon',strip(put(labda1,BEST32.)));
    stop;
  run;
%mend inverse_correction;

%macro inverse_datum_transformation(pLat /* Geographic ellipsoidal pseudo Bessel latitude in decimal degrees */
                                   ,pLon /* Geographic ellipsoidal pseudo Bessel longitude in decimal degrees */);
  /*
  The corrected ellipsoidal geographic Bessel coordinates of a point of interest must be transformed to ellipsoidal 
  geographic ETRS89 coordinates. Three steps:
  - The ellipsoidal geographic Bessel coordinates of a point of interest must be converted to geocentric Cartesian Bessel 
    coordinates to be able to apply a 3D similarity transformation.
  - The 3D similarity transformation itself.
  - Convert the geocentric ETR89 coordinates to ellipsoidal geographic ETRS89 coordinates. The latitude is computed iteratively. 
    The parameters of the GRS80 ellipsoid are needed for the conversion.

  Input:
  - pLat: Geographic ellipsoidal pseudo Bessel latitude in decimal degrees.
  - pLon: Geographic ellipsoidal pseudo Bessel longitude in decimal degrees.
  Output:
  - gmv_ETRS89_lat_dec degrees: The ETRS89 latitude in decimal degrees.
  - gmv_ETRS89_lon_dec degrees: The ETRS89 longitude in decimal degrees.
  */
  data _null_;
    format a_b1841 f_b1841 BEST32.;
    format h BEST32.;
    format RN X Y Z phi labda BEST32.;
    format e_square_b1841 BEST32.;
    
    format X1 Y1 Z1 BEST32.;
    format a b g d BEST32.;
    format tX tY tZ BEST32.;
    format s BEST32.;
    format R11 R12 R13 R21 R22 R23 R31 R32 R33 BEST32.;
    format X2 Y2 Z2 BEST32.;

    format a_grs80 f_grs80 epsilon BEST32.;
    format e_square_grs80 BEST32.;
    format i phi1 BEST32.;    %* phi1 the new calculated one;

    phi   = &pLat; 
    labda = &pLon;

    /* Convert the ellipsoidal geographic Bessel coordinates to geocentric Cartesian Bessel coordinates. */
    phi = phi*constant('pi')/180;               %* in radian;
    labda = labda*constant('pi')/180;
    a_b1841 = input(symget('gmv_B1841_a'),BEST32.);
    f_b1841 = input(symget('gmv_B1841_f'),BEST32.);
    h = input(symget('gmv_RD_Bessel_h0'),BEST32.);

    e_square_b1841 = f_b1841*(2-f_b1841);
    RN = a_b1841/sqrt(1 - (e_square_b1841 * (sin(phi)**2)));
    X = (RN + h) * cos(phi) * cos(labda);
    Y = (RN + h) * cos(phi) * sin(labda);
    Z = ((RN * (1 - e_square_b1841)) + h) * sin(phi);

    call symputx('gmv_geoc_cart_ETRS89_X',strip(put(X,BEST32.)));
    call symputx('gmv_geoc_cart_ETRS89_Y',strip(put(Y,BEST32.)));
    call symputx('gmv_geoc_cart_ETRS89_Z',strip(put(Z,BEST32.)));

    /*
    Rigorous 3D similarity transformation of geocentric Cartesian coordinates. The obtained geocentric Cartesian
    coordinates are in the geodetic datum of RD. The geodetic datum is often referred to as RD Bessel or just Bessel, 
    even though geocentric Cartesian coordinates do not use the Bessel ellipsoid.
    */
    X1 = X;
    Y1 = Y;
    Z1 = Z;
    a = input(symget('gmv_alpha_inv'),BEST32.);
    b = input(symget('gmv_beta_inv'),BEST32.);
    g = input(symget('gmv_gamma_inv'),BEST32.);
    d = input(symget('gmv_delta_inv'),BEST32.);
    tX = input(symget('gmv_tX_inv'),BEST32.);
    tY = input(symget('gmv_tY_inv'),BEST32.);
    tZ = input(symget('gmv_tZ_inv'),BEST32.);

    s = 1 + d;
    R11 = cos(g) * cos(b);
    R12 = cos(g) * sin(b) * sin(a)  + sin(g) * cos(a);
    R13 = -cos(g) * sin(b) * cos(a) + sin(g) * sin(a);
    R21 = -sin(g) * cos(b);
    R22 = -sin(g) * sin(b) * sin(a) + cos(g) * cos(a);
    R23 = sin(g) * sin(b) * cos(a) + cos(g) * sin(a);
    R31 = sin(b);
    R32 = -cos(b) * sin(a);
    R33 = cos(b) * cos(a);

    X2 = s * (R11 * X1 + R12 * Y1 + R13 * Z1) + tX;
    Y2 = s * (R21 * X1 + R22 * Y1 + R23 * Z1) + tY;
    Z2 = s * (R31 * X1 + R32 * Y1 + R33 * Z1) + tZ;

    call symputx('gmv_geoc_cart_RD_Bessel_X',strip(put(X2,BEST32.)));
    call symputx('gmv_geoc_cart_RD_Bessel_Y',strip(put(Y2,BEST32.)));
    call symputx('gmv_geoc_cart_RD_Bessel_Z',strip(put(Z2,BEST32.)));

    /*
    After the 3D similarity transformation, the geocentric ETR89 coordinates of the point of interest must be converted back
    to ellipsoidal geographic ETRS89 coordinates. The latitude is computed iteratively. The parameters of the GRS80 ellipsoid
    are needed for the conversion
    */
    X = X2;
    Y = Y2;
    Z = Z2;
    a_grs80 = input(symget('gmv_GRS80_a'),BEST32.);
    f_grs80 = input(symget('gmv_GRS80_f'),BEST32.);
    epsilon = input(symget('gmv_epsilon_GRS80_threshold'),BEST32.);
    e_square_grs80 = f_grs80*(2-f_grs80);

    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    */
    phi1 = input(symget('gmv_geog_sphere_real_Bessel_lat'),BEST32.);  %* correct, it is an UNTIL loop, thus it is initialized in the loop;
    i = 0;                                                            %* iterate counter. To check how many time you iterate;
    do until (abs(phi1-phi) lt epsilon);
      phi = phi1;
      RN = a_grs80/sqrt(1 - (e_square_grs80 * sin(phi)**2));
      if X > 0 then phi1 = atan((Z + e_square_grs80*RN*sin(phi))/sqrt(X**2 + Y**2));
      else if round(X,0.000000000001) eq 0 and round(Y,0.000000000001) eq 0 and round(Z,0.000000000001) ge 0 then phi1 = constant('pi')/2;   %* +90 degrees;
           else phi1 = -1*constant('pi')/2;                                                                                                  %* -90 degrees;
      i + 1;
    end;

    %* The phi or lat value (phi1) has been calculated. Now calculate the labda or lon value;
    if X gt 0 then labda = atan(Y/X);
    else if X lt 0 and Y ge 0 then labda = atan(Y/X) + constant('pi');  %* +180 degrees;
    else if X lt 0 and Y lt 0 then labda = atan(Y/X) - constant('pi');  %* -180 degrees;
    else if X eq 0 and Y gt 0 then labda = constant('pi')/2;            %*  +90 degrees;
    else if X eq 0 and Y lt 0 then labda = -1*constant('pi')/2;         %*  -90 degrees;
    else if X eq 0 and Y eq 0 then labda = 0;

    phi1 = phi1*180/constant('pi');     %* in degrees;
    labda = labda*180/constant('pi');

    call symputx('gmv_ETRS89_lat_dec',strip(put(phi1,BEST32.)));
    call symputx('gmv_ETRS89_lon_dec',strip(put(labda,BEST32.)));
  run;
%mend inverse_datum_transformation;

%macro ETRS89_to_RD_v1(pLat        /* ETRS89 latitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                      ,pLon        /* ETRS89 longitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                      ,pH=-999999  /* ETRS89 height in meter. Default no height transformation */
                      ,pType=dec   /* Latitude/Longitude notation style. Default decimal degrees */);
  /*
  Transform ETRS89 to RD. Output global variables containing the result:
  gmv_RD_x_lon  : RD x-coordinate in meter.
  gmv_RD_y_lat  : RD y-coordinate in meter.
  gmv_NAP_height: NAP height in RD meter. When -999999 the no NAP height
  */
  %local lmv_height_bln;

  %if &pType eq dec %then %do;
    data _null_;
      length lat lon h 8.;
      format lat lon h BEST32.;
      lat = &pLat;
      lon = &pLon;
      h = &pH;
      if h ne -999999 then call symputx('lmv_height_bln',1);
      else call symputx('lmv_height_bln',0);
      call symputx('gmv_ETRS89_lat_dec',strip(put(lat,BEST32.)));
      call symputx('gmv_ETRS89_lon_dec',strip(put(lon,BEST32.)));
      call symputx('gmv_ETRS89_height',strip(put(h,BEST32.)));
    run;
  %end;
  %else %do;
    data _null_;
      length lat lon $16.;
      length h 8.;
      format h BEST32.;
      lat = strip(&pLat);
      lon = strip(&pLon);
      h = &pH;
      if h ne -999999 then call symputx('lmv_height_bln',1);
      else call symputx('lmv_height_bln',0);
      call symputx('gmv_ETRS89_lat_dgr',strip(lat));
      call symputx('gmv_ETRS89_lon_dgr',strip(lon));
      call symputx('gmv_ETRS89_height',strip(put(h,BEST32.)));
    run;
    %conv_dgr_to_dec("&gmv_ETRS89_lat_dgr","&gmv_ETRS89_lon_dgr")
  %end;

  %conv_dec_to_rad(&gmv_ETRS89_lat_dec,&gmv_ETRS89_lon_dec)
  %RD_datum_transformation(&gmv_ETRS89_lat_rad,&gmv_ETRS89_lon_rad)
  %RD_correction(&gmv_geog_ellips_psdo_Bessel_lat, &gmv_geog_ellips_psdo_Bessel_lon)
  %RD_map_projection(&gmv_geog_ellips_real_Bessel_lat, &gmv_geog_ellips_real_Bessel_lon);
  %if &lmv_height_bln eq 1 %then %do;
    %height_transformation(&gmv_ETRS89_lat_dec,&gmv_ETRS89_lon_dec,&gmv_ETRS89_height,1);
  %end;
  %else %do;
    %let gmv_NAP_height = %eval(-999999);
  %end;
%mend ETRS89_to_RD_v1;

%macro RD_to_ETRS89_v1(pX          /* RD x-coordinate in meter */
                      ,pY          /* RD y-coordinate in meter */
                      ,pH=-999999  /* NAP height in meter. Default no height transformation */);
  /*
  Transform RO to ETRS89. Output global variables containing the result:
  gmv_ETRS89_lat_dec : ETRS89 latitude in decimal degrees.
  gmv_ETRS89_lon_dec : ETRS89 latitude in decimal degrees.
  gmv_ETRS89_height  : ETRS89 height in meter. When -999999 the no ETRS height.
  */
  %local lmv_height_bln;

  data _null_;
    length x y h 8.;
    format x y h BEST32.;
    x = &pX;
    y = &pY;
    h = &pH;
    if h ne -999999 then call symputx('lmv_height_bln',1);
    else call symputx('lmv_height_bln',0);
    call symputx('gmv_RD_x_lon',strip(put(x,BEST32.)));
    call symputx('gmv_RD_y_lat',strip(put(y,BEST32.)));
    call symputx('gmv_NAP_height',strip(put(h,BEST32.)));
  run;
 
  %inverse_map_projection(&gmv_RD_x_lon,&gmv_RD_y_lat)
  %inverse_correction(&gmv_geog_ellips_real_bessel_lat,&gmv_geog_ellips_real_bessel_lon)
  %inverse_datum_transformation(&gmv_geog_ellips_psdo_Bessel_lat,&gmv_geog_ellips_psdo_Bessel_lon)
  %if &lmv_height_bln eq 1 %then %do;
    %height_transformation(&gmv_ETRS89_lat_dec,&gmv_ETRS89_lon_dec,&gmv_NAP_height,2);
  %end;
  %else %do;
    %let gmv_ETRS89_height = %eval(-999999);
  %end;
%mend RD_to_ETRS89_v1;

%**********************************;
%* END  : version 1 (ETRS89 to RD) ;
%* BEGIN: version 2 (ETRS89 to RD) ;
%**********************************;

%macro rdnaptrans2018_ini_v2;
  /* Initializes all RDNAPTRANS2018 transformation parameters */
  %global gmv_D_rad;          %* helper variable, degrees in radian;
  %global gmv_D_dec;          %* helper variable, degrees in decimal degrees;
  %global gmv_GRS80_a;        %* half major (equator) axis of GRS80 ellipsoid in meter;
  %global gmv_GRS80_f;        %* flattening of GRS80 ellipsoid (dimensionless);
  %global gmv_ETRS89_h0;      %* ellipsoidal ETRS89 height approximately corresponding to 0 m in NAP (m);
  %let gmv_GRS80_a   = 6378137;
  %let gmv_GRS80_f   = %sysevalf(1/298.257222101);
  %let gmv_ETRS89_h0 = 43;
  %put &=gmv_GRS80_a meter;
  %put &=gmv_GRS80_f (dimensionless);
  %put &=gmv_ETRS89_h0 meter;

  /* Used for inverse transformation; RD to ETRS89 */
  %global gmv_epsilon_GRS80_threshold;            %* 𝜀 = precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_epsilon_GRS80_threshold = %sysevalf(0.00000000002); 
  %put &=gmv_epsilon_GRS80_threshold radian;

  /* Seven parameters for the 3D similarity transformation from ETRS89 to RD. */
  %global gmv_tX;       %* translation in direction of X axis meter;
  %global gmv_tY;       %* translation in direction of Y axis meter;
  %global gmv_tZ;       %* translation in direction of Z axis meter;
  %global gmv_alpha;    %* rotation angle around X axis (−1.91513*10−6 rad);
  %global gmv_beta;     %* rotation angle around Y axis (+1.60365*10−6 rad);
  %global gmv_gamma;    %* rotation angle around Z axis (−9.09546*10−6 rad);
  %global gmv_delta;    %* scale difference (dimensionless, −4.07242*10−6);
  %let gmv_tX = %sysevalf(-565.7346);
  %let gmv_tY = %sysevalf(-50.4058);
  %let gmv_tZ = %sysevalf(-465.2895);
  %conv_dgr_dec_rad("0 0 -0.395023")
  %let gmv_alpha = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 0.330776")
  %let gmv_beta = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 -1.876073")
  %let gmv_gamma = &gmv_D_rad;
  %let gmv_delta = %sysevalf(-0.00000407242);
  %put &=gmv_tX meter;
  %put &=gmv_tY meter;
  %put &=gmv_tZ meter;
  %put &=gmv_alpha radian;
  %put &=gmv_beta radian;
  %put &=gmv_gamma radian;
  %put &=gmv_delta (dimensionless);

  /* Seven parameters for the 3D similarity transformation from RD to ETRS89. The suffix inv means inverse */
  %global gmv_tX_inv;       %* translation in direction of X axis meter;
  %global gmv_tY_inv;       %* translation in direction of Y axis meter;
  %global gmv_tZ_inv;       %* translation in direction of Z axis meter;
  %global gmv_alpha_inv;    %* rotation angle around X axis (−1.91513 ∙ 10−6 rad);
  %global gmv_beta_inv;     %* rotation angle around Y axis (+1.60365 ∙ 10−6 rad);
  %global gmv_gamma_inv;    %* rotation angle around Z axis (−9.09546 ∙ 10−6 rad);
  %global gmv_delta_inv;    %* scale difference (dimensionless, −4.07242 ∙ 10−6);
  %let gmv_tX_inv = %sysevalf(565.7381);
  %let gmv_tY_inv = %sysevalf(50.4018);
  %let gmv_tZ_inv = %sysevalf(465.2904);
  %conv_dgr_dec_rad("0 0 0.395026")
  %let gmv_alpha_inv = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 -0.330772")
  %let gmv_beta_inv = &gmv_D_rad;
  %conv_dgr_dec_rad("0 0 1.876074")
  %let gmv_gamma_inv = &gmv_D_rad;
  %let gmv_delta_inv = %sysevalf(0.00000407244);
  %put &=gmv_tX_inv meter;
  %put &=gmv_tY_inv meter;
  %put &=gmv_tZ_inv meter;
  %put &=gmv_alpha_inv radian;
  %put &=gmv_beta_inv radian;
  %put &=gmv_gamma_inv radian;
  %put &=gmv_delta_inv;

  /* Two parameters of Bessel 1841 ellipsoid in the conversion to ellipsoidal geographic pseudo Bessel coordinates */
  %global gmv_B1841_a;                    %* half major (equator) axis of Bessel 1841 ellipsoid in meter;
  %global gmv_B1841_f;                    %* flattening of Bessel 1841 ellipsoid (dimensionless);
  %global gmv_epsilon_B1841_threshold;    %* 𝜀 = precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_B1841_a = %sysevalf(6377397.155);
  %let gmv_B1841_f = %sysevalf(1/299.1528128);
  %let gmv_epsilon_B1841_threshold = %sysevalf(0.00000000002);
  %put &=gmv_B1841_a meter;
  %put &=gmv_B1841_f (dimensionless);
  %put &=gmv_epsilon_B1841_threshold radian; 

  %* RD to ETRS9: Fixed ellipsoidal height used in the conversion to geocentric Cartesian Bessel;
  %global gmv_RD_Bessel_h0;          %* ellipsoidal RD Bessel height approximately corresponding to 0 m in NAP (m) ;
  %let gmv_RD_Bessel_h0 = 0;
  %put &=gmv_RD_Bessel_h0 meter;

  /*
  Parameters used for coordinate correction in conjunction with the tab-separated value ASCII text correction grid file rdcorr2018.txt.
  The values are in degrees, because they are also in degrees in the correction file. No need to convert to radian because at this step
  we are not using Trigonometry functions.
  */
  %global gmv_phi_min;               %* 𝜑𝑚𝑖𝑛 = 50° latitude of southern bound of correction grid;
  %global gmv_phi_max;               %* 𝜑𝑚𝑎𝑥 = 56° latitude of northern bound of correction grid;
  %global gmv_labda_min;             %* 𝜆𝑚𝑖𝑛 = 2° longitude of western bound of correction grid;
  %global gmv_labda_max;             %* 𝜆𝑚𝑎𝑥 = 8° longitude of eastern bound of correction grid;
  %global gmv_phi_delta;             %* Δ𝜑= 0.0125° = 45″ latitude spacing of correction grid, corresponding to about 1.4 km;
  %global gmv_labda_delta;           %* Δ𝜆 = 0.02° = 72″ longitude spacing of correction grid, corresponding to about 1.4 km;
  %global gmv_c0;                    %* 𝑐0 = 0.0000 m correction value outside bounds of correction grid;
  %global gmv_epsilon_RD_threshold;  %* 𝜀 = 0.000 000 001° precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_phi_min = 50;
  %let gmv_phi_max = 56;
  %let gmv_labda_min = 2;
  %let gmv_labda_max = 8;
  %let gmv_phi_delta = %sysevalf(0.0125);
  %let gmv_labda_delta = %sysevalf(0.02);
  %let gmv_c0 = 0;
  %let gmv_epsilon_RD_threshold = %sysevalf(0.000000001);
  %put &=gmv_phi_min degrees;
  %put &=gmv_phi_max degrees;
  %put &=gmv_labda_min degrees;
  %put &=gmv_labda_max degrees;
  %put &=gmv_phi_delta degrees;
  %put &=gmv_labda_delta degrees;
  %put &=gmv_c0 meter;
  %put &=gmv_epsilon_RD_threshold degrees; 

  %global gmv_phi0_amersfoort;                  %* latitude of central point Amersfoort on Bessel ellipsoid;
  %global gmv_labda0_amersfoort;                %* longitude of central point Amersfoort on Bessel ellipsoidl;
  %global gmv_k_amersfoort;                     %* scale factor (dimensionless);
  %global gmv_x0_amersfoort;                    %* false Easting;
  %global gmv_y0_amersfoort;                    %* false Northing;
  %let gmv_k_amersfoort = %sysevalf(0.9999079);
  %let gmv_x0_amersfoort = 155000;
  %let gmv_y0_amersfoort = 463000;
  %conv_dgr_dec_rad("52 9 22.178")
  %let gmv_phi0_amersfoort = &gmv_D_rad;        %* 52.156160556;
  %conv_dgr_dec_rad("5 23 15.500");
  %let gmv_labda0_amersfoort =  &gmv_D_rad;     %*  5.387638889;
  %put &=gmv_phi0_amersfoort radian;
  %put &=gmv_labda0_amersfoort radian;
  %put &=gmv_k_amersfoort (dimensionless);
  %put &=gmv_x0_amersfoort meter;
  %put &=gmv_y0_amersfoort meter;
%mend rdnaptrans2018_ini_v2;

%macro rdnaptrans2018_grid_v2(pRDgrid /* Dataset that contains the RD correction grid */
                             ,pHgrid  /* Datatset that contains the NLGEO2018 height values grid*/);
  /* 
  Load the RD correction grid and the NLGEO height grid into an array of macro variables
  A fixed naming column schema is expected:
  RDCORR2018 | NLGEO2018
  -----------+----------
         i   |          i
  lat_corr   |  etrs89_lat
  lon_corr   |  etrs89_lon
    rd_lat   |  nap_height
    rd_lon   |
  The following macro variables are needed/created in the range 1 - 144781
  - rdcorr2018_lat_corr_[1-144781]
  - rdcorr2018_lon_corr_[1-144781]
  - nlgeo2018_nap_height_[1-144781]
  */
  %do i = 1 %to 144781;
    %global rdcorr2018_lat_corr_&i;
    %global rdcorr2018_lon_corr_&i;
    %global nlgeo2018_nap_height_&i;
  %end;

  proc sql noprint;
    select lat_corr, lon_corr
           into :rdcorr2018_lat_corr_1 - :rdcorr2018_lat_corr_144781
               ,:rdcorr2018_lon_corr_1 - :rdcorr2018_lon_corr_144781
    from &pRDgrid
    order by i;
    
    select nap_height into :nlgeo2018_nap_height_1 - :nlgeo2018_nap_height_144781
    from &pHgrid
    order by i;
  quit;
%mend rdnaptrans2018_grid_v2;

%macro ETRS89_to_RD_v2(pDSin        /* The dataset that contains lat, lon and h that must be transformed to RDNAP */
                      ,pDSout       /* The output dataset */
                      ,pSuppress=1  /* Suppress all intermediate columns in the output: 1=Yes, 0=No */);
  /*
  Convert ETRS89 lat lon h coordinate pair to RD NAP x y H coordinate pair.
  Variables are re-used. So the content of the output dataset reflects the end status of a row. Any intermediate
  variable results are not stored. 
  The input variable are mandatory. When no height conversion is needed, then set h to -999999.
   Input | Output
  -------+--------
    lat  |  RD_x
    lon  |  RD_y
      h  |  RD_H 
  A lot of columns (more than 100) are added to the output dataset. But they can be suppresed.
  */
  
  %* Add the height column, if not specified;
  %if %sysfunc(findc(&pDSin,'.')) ne 0 %then %do;
    %let lmv_lib = %scan(&pDSin,1,'.');
    %let lmv_ds = %scan(&pDSin,2,'.');
  %end; 
  %else %do;
    %let lmv_lib = WORK;
    %let lmv_ds = &pDSin;
  %end;
  proc sql noprint;
    select count(*) into :lmv_height_missing from DICTIONARY.columns
    where libname eq %upcase("&lmv_lib") and memname eq %upcase("&lmv_ds") and upcase(name) eq 'H';
  quit;
  %if &lmv_height_missing eq 0 %then %do;
    proc sql;
      alter table &pDSin add h num format=BEST32.;        %* SAS does not support a default option;
      update &pDSin set h = -999999;
    quit;  
  %end;

  data &pDSout;
    set &pDSin;
    format phi labda h BEST32.;
    format a_grs80 f_grs80 BEST32.;
    format h0_etrs89 BEST32.;
    format RN Xgeo Ygeo Zgeo BEST32.;
    format e_square_grs80 BEST32.;

    format X1geo Y1geo Z1geo BEST32.;
    format alpha beta gamma delta BEST32.;
    format tX tY tZ BEST32.;
    format s BEST32.;
    format R11 R12 R13 R21 R22 R23 R31 R32 R33 BEST32.;
    format X2geo Y2geo Z2geo BEST32.;

    format a_b1841 f_b1841 epsilon_b1841 BEST32.;
    format e_square_b1841 BEST32.;
    format i phi1 BEST32.;                          %* phi1 the new calculated one;
 
    phi   = lat * constant('pi') / 180 ;   %* 𝜑 phi, in radian;
    labda = lon * constant('pi') / 180;    %* 𝜆 labda, in radian;
    
    /*
    Conversion to geocentric cartesian ETRS89 coordinates. The ellipsoidal geographic ETRS89 coordinates must be converted to 
    geocentric Cartesian ETRS89 coordinates to be able to apply a 3D similarity transformation.
    */
    a_grs80 = input(symget('gmv_GRS80_a'),BEST32.);
    f_grs80 = input(symget('gmv_GRS80_f'),BEST32.);
    h0_etrs89 = input(symget('gmv_ETRS89_h0'),BEST32.);

    e_square_grs80 = f_grs80*(2-f_grs80);
    RN = a_grs80/sqrt(1 - (e_square_grs80 * (sin(phi)**2)));
 
    Xgeo = (RN + h0_etrs89) * cos(phi) * cos(labda);
    Ygeo = (RN + h0_etrs89) * cos(phi) * sin(labda);
    Zgeo = ((RN * (1 - e_square_grs80)) + h0_etrs89) * sin(phi);
    
    /*
    Rigorous 3D similarity transformation of geocentric Cartesian coordinates.
    The formula for a 3D similarity transformation must be applied to the geocentric Cartesian ETRS89 coordinates of the
    point of interest. The obtained geocentric Cartesian coordinates are in the geodetic datum of RD. The geodetic datum
    is often referred to as RD Bessel or just Bessel, even though geocentric Cartesian coordinates do not use the Bessel ellipsoid.
    */
    X1geo = Xgeo;
    Y1geo = Ygeo;
    Z1geo = Zgeo;
    alpha = input(symget('gmv_alpha'),BEST32.);
    beta  = input(symget('gmv_beta'),BEST32.);
    gamma = input(symget('gmv_gamma'),BEST32.);
    delta = input(symget('gmv_delta'),BEST32.);
    tX = input(symget('gmv_tX'),BEST32.);
    tY = input(symget('gmv_tY'),BEST32.);
    tZ = input(symget('gmv_tZ'),BEST32.);

    s = 1 + delta;
    R11 = cos(gamma) * cos(beta);
    R12 = cos(gamma) * sin(beta) * sin(alpha)  + sin(gamma) * cos(alpha);
    R13 = -cos(gamma) * sin(beta) * cos(alpha) + sin(gamma) * sin(alpha);
    R21 = -sin(gamma) * cos(beta);
    R22 = -sin(gamma) * sin(beta) * sin(alpha) + cos(gamma) * cos(alpha);
    R23 = sin(gamma) * sin(beta) * cos(alpha) + cos(gamma) * sin(alpha);
    R31 = sin(beta);
    R32 = -cos(beta) * sin(alpha);
    R33 = cos(beta) * cos(alpha);

    X2geo = s * (R11 * X1geo + R12 * Y1geo + R13 * Z1geo) + tX;
    Y2geo = s * (R21 * X1geo + R22 * Y1geo + R23 * Z1geo) + tY;
    Z2geo = s * (R31 * X1geo + R32 * Y1geo + R33 * Z1geo) + tZ;

    /*
    The geocentric Cartesian Bessel coordinates of the point of interest must be converted back to ellipsoidal geographic
    The ellipsoidal geographic coordinates of a point of interest obtained by datum transformation are pseudo Bessel coordinates.
    */
    Xgeo = X2geo;
    Ygeo = Y2geo;
    Zgeo = Z2geo;
    a_b1841 = input(symget('gmv_B1841_a'),BEST32.);
    f_b1841 = input(symget('gmv_B1841_f'),BEST32.);
    epsilon_b1841 = input(symget('gmv_epsilon_B1841_threshold'),BEST32.);
    e_square_b1841 = f_b1841*(2-f_b1841);

    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    */
    phi1 = lat * constant('pi') / 180 ;            %* correct, it is an UNTIL loop, thus it is initialized in the loop;
    i = 0;                                         %* iterate counter. To check how many times you iterate;
    do until (abs(phi1-phi) lt epsilon_b1841);
      phi = phi1;
      RN = a_b1841/sqrt(1 - (e_square_b1841 * sin(phi)**2));
      if Xgeo > 0 then phi1 = atan((Zgeo + e_square_b1841*RN*sin(phi))/sqrt(Xgeo**2 + Ygeo**2));
      else if round(Xgeo,0.000000000001) eq 0 and round(Ygeo,0.000000000001) eq 0 and round(Zgeo,0.000000000001) ge 0 then phi1 = constant('pi')/2;   %* +90 degrees;
           else phi1 = -1*constant('pi')/2;                                                                                                           %* -90 degrees;
      i + 1;
    end;
    phi = phi1;       %* then new phi value, in radian;

    %* The phi or lat value (phi1) has been calculated. Now calculate the labda or lon value, in radian;
    if Xgeo gt 0 then labda = atan(Ygeo/Xgeo);
    else if Xgeo lt 0 and Ygeo ge 0 then labda = atan(Ygeo/Xgeo) + constant('pi');  %* +180 degrees;
    else if Xgeo lt 0 and Ygeo lt 0 then labda = atan(Ygeo/Xgeo) - constant('pi');  %* -180 degrees;
    else if Xgeo eq 0 and Ygeo gt 0 then labda = constant('pi')/2;                  %*  +90 degrees;
    else if Xgeo eq 0 and Ygeo lt 0 then labda = -1*constant('pi')/2;               %*  -90 degrees;
    else if Xgeo eq 0 and Ygeo eq 0 then labda = 0;

    /* RD correction */
    format phi_min phi_max labda_min labda_max phi_delta labda_delta BEST32.;
    format RDcorrLat RDcorrLon BEST32.;
    format phi0  BEST32.;
    format labda0 labda1 BEST32.;
    format phinorm labdanorm BEST32.;
    format nlabda BEST32.;
    format i_nw i_ne i_sw i_se 8.;
    format nw_phi ne_phi sw_phi se_phi BEST32.;
    format nw_labda ne_labda sw_labda se_labda BEST32.;
    format epsilon_RD BEST32.;

    phi =  phi * 180 / constant('pi');       %* in degrees;
    labda =  labda * 180 / constant('pi');   %* in degrees;
    phi_threshold_bln = 0;                   %* loop exit criteria or the phi/latitude;
    labda_threshold_bln = 0;                 %* loop exit criteria or the labda/longitude;
    epsilon_RD = input(symget('gmv_epsilon_RD_threshold'),BEST32.);
    phi_min = input(symget('gmv_phi_min'),BEST32.); 
    phi_max = input(symget('gmv_phi_max'),BEST32.); 
    labda_min = input(symget('gmv_labda_min'),BEST32.); 
    labda_max = input(symget('gmv_labda_max'),BEST32.); 
    phi_delta = input(symget('gmv_phi_delta'),BEST32.); 
    labda_delta = input(symget('gmv_labda_delta'),BEST32.); 
    phi0 = phi;      %* Here you compare latitude against;
    phi1 = phi;
    labda0 = labda;  %* Here you compare longitude against;
    labda1 = labda;

    do until (phi_threshold_bln eq 1 and labda_threshold_bln eq 1);
      phi = phi1;
      labda = labda1;

      phinorm = (phi-phi_min)/phi_delta;
      labdanorm = (labda-labda_min)/labda_delta;
      nlabda = 1 + ((labda_max-labda_min)/labda_delta);

      if phi ge phi_min and phi le phi_max and labda ge labda_min and labda le labda_max then do;
        inside_bound_correction_grid = 1;

        i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
        i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) + 1;
        i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
        i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;

        nw_phi = input(symget(cats("rdcorr2018_lat_corr_",i_nw)),BEST32.);
        ne_phi = input(symget(cats("rdcorr2018_lat_corr_",i_ne)),BEST32.);
        sw_phi = input(symget(cats("rdcorr2018_lat_corr_",i_sw)),BEST32.);
        se_phi = input(symget(cats("rdcorr2018_lat_corr_",i_se)),BEST32.);
        nw_labda = input(symget(cats("rdcorr2018_lon_corr_",i_nw)),BEST32.);
        ne_labda = input(symget(cats("rdcorr2018_lon_corr_",i_ne)),BEST32.); 
        sw_labda = input(symget(cats("rdcorr2018_lon_corr_",i_sw)),BEST32.);
        se_labda = input(symget(cats("rdcorr2018_lon_corr_",i_se)),BEST32.);
      end;
      else inside_bound_correction_grid = 0;

      %* Here we calculate lat and lon correction at point of interest in real RD Bessel;
      if phi_threshold_bln eq 0 then do;
        if inside_bound_correction_grid eq 1 then RDcorrLat = (phinorm - floor(phinorm)) * ((nw_phi*(floor(labdanorm) + 1 - labdanorm)) + ne_phi*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_phi*(floor(labdanorm) + 1 - labdanorm)) + se_phi*(labdanorm - floor(labdanorm)));
        else RDcorrLat = 0;
        phi1 = phi0 - RDcorrLat;
        if (abs(phi1-phi) lt epsilon_RD) then do;
          phi_threshold_bln = 1;
        end;
      end;

      if labda_threshold_bln eq 0 then do;
        if inside_bound_correction_grid eq 1 then RDcorrLon = (phinorm - floor(phinorm)) * ((nw_labda*(floor(labdanorm) + 1 - labdanorm)) + ne_labda*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_labda*(floor(labdanorm) + 1 - labdanorm)) + se_labda*(labdanorm - floor(labdanorm)));
        else RDcorrLon = 0;
        labda1 = labda0 - RDcorrLon;
        if (abs(labda1-labda) lt epsilon_RD) then do;
          labda_threshold_bln = 1;
        end;
      end;
    end;  %* end of do loop;

    phi = phi1;       %* in degrees;
    labda = labda1;   %* in degrees;

    /* Map projection from ellipsoid to sphere. */
    format phi0_amf PHI_C PHI0_C labda0_amf LABDA_C LABDA0_C BEST32.;
    format k_amf x0_amf y0_amf e_b1841 BEST32.;
    format RM R_sphere BEST32.;
    format q0 w0 q w m n BEST32.;
    format sin_psi_2 cos_psi_2 tan_psi_2 BEST32.;
    format sin_alpha cos_alpha r_distance BEST32.;
    format RD_x RD_y BEST32.;                                          %* the output. the RD x y coordinates;

    /*
    Gauss conformal projection of coordinates on ellipsoid to coordinates on sphere.
    Convert the phi/labda values back to radian.
    */
    phi = phi * constant('pi')/180;
    labda = labda * constant('pi')/180;

    %* Get the parameters of RD Map projection and Bessel 1841 ellipsoid parameter;
    phi0_amf = input(symget('gmv_phi0_amersfoort'),BEST32.); 
    labda0_amf = input(symget('gmv_labda0_amersfoort'),BEST32.); 
    k_amf = input(symget('gmv_k_amersfoort'),BEST32.);
    x0_amf = input(symget('gmv_x0_amersfoort'),BEST32.);
    y0_amf = input(symget('gmv_y0_amersfoort'),BEST32.);

    %* Start with derived parameter calculation of the RD map projection;
    e_b1841 =  sqrt(f_b1841*(2-f_b1841));
    q0 = log(tan((phi0_amf + constant('pi')/2)/2)) - (e_b1841/2) * (log((1 + e_b1841*sin(phi0_amf))/(1 - e_b1841*sin(phi0_amf))));
    RN = a_b1841 / sqrt(1 - (e_b1841**2*(sin(phi0_amf)**2)));
    RM = (RN*(1 - e_b1841**2))/(1-(e_b1841**2*(sin(phi0_amf)**2)));
    R_sphere = sqrt(RM*RN);
    PHI0_C = atan((sqrt(RM)/sqrt(RN))*tan(phi0_amf)); 
    LABDA0_C = labda0_amf;
    w0 = log(tan((PHI0_C + constant('pi')/2)/2));
    n = sqrt(1 + ((e_b1841**2*(cos(phi0_amf)**4))/(1 - e_b1841**2)));
    m = w0 - n*q0;

    /*
    Gauss conformal projection of coordinates on ellipsoid to coordinates on sphere. To prevent undefined results due 
    to taking the tangent of a number close to 90°, a tolerance should be used to test if the latitude is 90°. 
    Rounding the ellipsoidal coordinates in advance to 0.000 000 001° or 2*10−11 rad suffices.
    No rounding done and no 90° and -90° check. 
    */
    q = log(tan((phi + constant('pi')/2)/2)) - (e_b1841/2) * (log((1 + e_b1841*sin(phi))/(1 - e_b1841*sin(phi))));
    w = n*q + m;
    PHI_C =  2*atan(exp(w)) - constant('pi')/2;
    LABDA_C = LABDA0_C + n*(labda - labda0_amf);

    /* Projection from sphere to plane */
    sin_psi_2 = sqrt(sin((PHI_C - PHI0_C)/2)**2 + ((sin((LABDA_C - LABDA0_C)/2)**2)*cos(PHI_C)*cos(PHI0_C)));
    cos_psi_2 = sqrt(1 - sin_psi_2**2);
    tan_psi_2 = sin_psi_2/cos_psi_2;
    sin_alpha = (sin(LABDA_C - LABDA0_C)*cos(PHI_C))/(2*sin_psi_2*cos_psi_2);
    cos_alpha = (sin(PHI_C) - sin(PHI0_C) + 2*sin(PHI0_C)*(sin_psi_2**2))/(2*cos(PHI0_C)*sin_psi_2*cos_psi_2);
    r_distance = 2*k_amf*R_sphere*tan_psi_2;

    if PHI_C eq PHI0_C and LABDA_C eq LABDA0_C then do;
      RD_x = x0_amf;
      RD_y = y0_amf;
    end;
    else do;
      if (PHI_C ne PHI0_C or LABDA_C ne LABDA0_C) and (PHI_C ne -1*PHI0_C or LABDA_C ne constant('pi')-LABDA0_C) then do;
        RD_x = r_distance*sin_alpha + x0_amf;
        RD_y = r_distance*cos_alpha + y0_amf;
      end;
      else do;     %* undefined;
        RD_x = 0;
        RD_y = 0;
      end;
    end;

    /* The height transformation. Do only height transformation if an ETRS89 height value is supplied */
    format height BEST32.;
    format nw_height ne_height sw_height se_height BEST32.;
    format RD_H BEST32.;
    format etrs89_quasi_height BEST32.;

    if h ne -999999 then do;

      phi = lat;     %* in degrees;
      labda = lon;   %* in degrees;
      height = h;

      phinorm = (phi-phi_min)/phi_delta;
      labdanorm = (labda-labda_min)/labda_delta;
      nlabda = 1 + ((labda_max-labda_min)/labda_delta);

      %* Rounding needed to pass the test validation;
      if round(phi,0.00000001) ge phi_min and round(phi,0.00000001) le phi_max and round(labda,0.00000001) ge labda_min and round(labda,0.00000001) le labda_max then do;
  
        i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
        i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) +  1;
        i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
        i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;
  
        nw_height = input(symget(cats("nlgeo2018_nap_height_",i_nw)),BEST32.);
        ne_height = input(symget(cats("nlgeo2018_nap_height_",i_ne)),BEST32.);
        sw_height = input(symget(cats("nlgeo2018_nap_height_",i_sw)),BEST32.);
        se_height = input(symget(cats("nlgeo2018_nap_height_",i_se)),BEST32.);
  
        etrs89_quasi_height = (phinorm - floor(phinorm)) * ((nw_height*(floor(labdanorm) + 1 - labdanorm)) + ne_height*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_height*(floor(labdanorm) + 1 - labdanorm)) + se_height*(labdanorm - floor(labdanorm)));
        RD_H = height - etrs89_quasi_height;
      end;
      else do;
        etrs89_quasi_height = -999999;
        RD_H = etrs89_quasi_height;
      end;  
    end;
    else RD_H = -999999;
  run;
  
  %* Keep only the transformation result. Suppress all others;
  %if &pSuppress eq 1 %then %do;
    %* Get the columns from the input dataset and then add the RD transformation values to it;
    proc sql noprint;
      select name into :lmv_DSin_columns separated by ' ' from DICTIONARY.columns
      where libname eq %upcase("&lmv_lib") and memname eq %upcase("&lmv_ds");
    quit;
    %let lmv_DSin_columns = &lmv_DSin_columns RD_x RD_y RD_H;
    %put &=lmv_DSin_columns;
    data &pDSout;
      set &pDSout;
      keep &lmv_DSin_columns;
    run;
  %end;
%mend ETRS89_to_RD_v2;

%macro RD_to_ETRS89_v2(pDSin        /* The dataset that contains x, y and z that must be transformed to ETRS89 */
                      ,pDSout       /* The output dataset */
                      ,pSuppress=1  /* Suppress all intermediate columns in the output: 1=Yes, 0=No */);                     
  /*
  Convert RDNAP x y H coordinate pair to ETRS89 lat lon h coordinate pair.
  Variables are re-used. So the content of the output dataset reflects the end status of a row. Any intermediate
  variable results are not stored.
  The input variables are mandatory. When no height conversion is needed, then set z(H) to -999999.
   Input | Output
  -------+-------------
     x   | ETRS89_lat
     y   | ETRS89_lon
     H   | ETRS89_h
  A lot of columns (more than 100) are added to the output dataset. But they can be suppressed
  */
 
  %* Add the height column, if not specified;
  %if %sysfunc(findc(&pDSin,'.')) ne 0 %then %do;
    %let lmv_lib = %scan(&pDSin,1,'.');
    %let lmv_ds = %scan(&pDSin,2,'.');
  %end; 
  %else %do;
    %let lmv_lib = WORK;
    %let lmv_ds = &pDSin;
  %end;
  proc sql noprint;
    select count(*) into :lmv_height_missing from DICTIONARY.columns
    where libname eq %upcase("&lmv_lib") and memname eq %upcase("&lmv_ds") and upcase(name) eq 'H';
  quit;
  %if &lmv_height_missing eq 0 %then %do;
    proc sql;
      alter table &pDSin add H num format=BEST32.;        %* SAS does not support a default option;
      update &pDSin set H = -999999;
    quit;  
  %end;
 
  data &pDSout;
    set &pDSin;
    format x y BEST32.;                                         %* the input. the RD x y coordinates;
    format phi phi0_amf PHI_C PHI0_C labda_n labda labda0_amf LABDA_C LABDA0_C BEST32.;
    format k_amf x0_amf y0_amf a_b1841 f_b1841 e_b1841 BEST32.;
    format RM RN R_sphere BEST32.;
    format psi sin_alpha cos_alpha r_distance BEST32.;
    format Xnorm Ynorm Znorm BEST32.;
    format epsilon_b1841 BEST32.;
    format q0 w0 q w m n BEST32.;

    %* Start with inverse oblique stereographic conformal projection from the RD projection plane to a sphere;

    %* Get the parameters of RD Map projection and Bessel 1841 ellipsoid parameter;
    phi0_amf = input(symget('gmv_phi0_amersfoort'),BEST32.); 
    labda0_amf = input(symget('gmv_labda0_amersfoort'),BEST32.); 
    k_amf = input(symget('gmv_k_amersfoort'),BEST32.);
    x0_amf = input(symget('gmv_x0_amersfoort'),BEST32.);
    y0_amf = input(symget('gmv_y0_amersfoort'),BEST32.);
    a_b1841 = input(symget('gmv_B1841_a'),BEST32.);
    f_b1841 = input(symget('gmv_B1841_f'),BEST32.);
    epsilon_b1841 = input(symget('gmv_epsilon_B1841_threshold'),BEST32.);

    %* Do the derived parameter calculation of the RD map projection;
    e_b1841 =  sqrt(f_b1841*(2-f_b1841));
    RN = a_b1841 / sqrt(1 - (e_b1841**2*(sin(phi0_amf)**2)));
    RM = (RN*(1 - e_b1841**2))/(1-(e_b1841**2*(sin(phi0_amf)**2)));
    R_sphere = sqrt(RM*RN);
    PHI0_C = atan((sqrt(RM)/sqrt(RN))*tan(phi0_amf)); 
    LABDA0_C = labda0_amf;

    %* Inverse oblique stereographic projection of coordinates on plane to coordinates on sphere;
    r_distance = sqrt((x - x0_amf)**2 + (y - y0_amf)**2);
    sin_alpha = (x - x0_amf)/r_distance;
    cos_alpha = (y - y0_amf)/r_distance;
    psi =  2 * atan(r_distance/(2*k_amf*R_sphere));
    if x ne x0_amf or y ne y0_amf then do;
      Xnorm = cos(PHI0_C)*cos(psi) - cos_alpha*sin(PHI0_C)*sin(psi);
      Ynorm = sin_alpha*sin(psi);
      Znorm = cos_alpha*cos(PHI0_C)*sin(psi) + sin(PHI0_C)*cos(psi);
    end;
    else do;
      Xnorm = cos(PHI0_C);
      Ynorm = 0;
      Znorm = sin(PHI0_C);
    end;
    PHI_C = arsin(Znorm);
    if Xnorm gt 0 then LABDA_C = LABDA0_C + atan(Ynorm/Xnorm);
    else if Xnorm lt 0 and x ge x0_amf then LABDA_C = LABDA0_C + atan(Ynorm/Xnorm) + constant('pi');
    else if Xnorm lt 0 and x lt x0_amf then LABDA_C = LABDA0_C + atan(Ynorm/Xnorm) - constant('pi');
    else if Xnorm eq 0 and x gt x0_amf then LABDA_C = LABDA0_C + constant('pi')/2;
    else if Xnorm eq 0 and x lt x0_amf then LABDA_C = LABDA0_C - constant('pi')/2;
    else if Xnorm eq 0 and x eq x0_amf then LABDA_C = LABDA0_C;

    /* Projection from sphere to ellipsoid */
    q0 = log(tan((phi0_amf + constant('pi')/2)/2)) - (e_b1841/2) * (log((1 + e_b1841*sin(phi0_amf))/(1 - e_b1841*sin(phi0_amf))));
    w0 = log(tan((PHI0_C + constant('pi')/2)/2));
    n = sqrt(1 + ((e_b1841**2*(cos(phi0_amf)**4))/(1 - e_b1841**2)));
    m = w0 - n*q0;

    %* Inverse Gauss conformal projection of coordinates on sphere to coordinates on ellipsoid;
    w = log(tan((PHI_C + constant('pi')/2)/2));
    q = (w - m )/n;    
 
    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    */
    phi1 = PHI_C;     %* correct, it is an UNTIL loop, thus it is initialized in the loop;
    do until (abs(phi1-phi) lt epsilon_b1841);
      phi = phi1;
      if PHI_C gt -1*constant('pi')/2 and PHI_C lt constant('pi')/2 then do;
        phi1 = 2*atan(exp(q + (e_b1841/2)*log((1 + e_b1841*sin(phi))/(1 - e_b1841*sin(phi))))) - constant('pi')/2;
      end;
      else phi1 = PHI_C;
    end;
   
    %* The latitute has been calculated, now calculate the longitude;
    phi = phi1;                                                                                  %* in radian;
    labda_n = ((LABDA_C - LABDA0_C)/n) + labda0_amf;
    labda = labda_n + 2*constant('pi')*floor((constant('pi') - labda_n)/(2*constant('pi')));     %* in radian;

    /* The horizontal RD grid correction */
    format phi_min phi_max labda_min labda_max phi_delta labda_delta BEST32.;
    format RDcorrLat RDcorrLon BEST32.;
    format phinorm labdanorm BEST32.;
    format nlabda BEST32.;
    format i_nw i_ne i_sw i_se 8.;
    format nw_phi nw_labda BEST32.;
    format ne_phi ne_labda BEST32.;
    format sw_phi sw_labda BEST32.;
    format se_phi se_labda BEST32.;

    phi = phi * 180 / constant('pi');        %* in degrees;
    labda =  labda * 180 / constant('pi');   %* in degrees;

    phi_min = input(symget('gmv_phi_min'),BEST32.); 
    phi_max = input(symget('gmv_phi_max'),BEST32.); 
    labda_min = input(symget('gmv_labda_min'),BEST32.); 
    labda_max = input(symget('gmv_labda_max'),BEST32.); 
    phi_delta = input(symget('gmv_phi_delta'),BEST32.); 
    labda_delta = input(symget('gmv_labda_delta'),BEST32.); 

    phinorm = (phi-phi_min)/phi_delta;
    labdanorm = (labda-labda_min)/labda_delta;
    nlabda = 1 + ((labda_max-labda_min)/labda_delta);
     
    if phi ge phi_min and phi le phi_max and labda ge labda_min and labda le labda_max then do;

      i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
      i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) + 1;
      i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
      i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;
 
      nw_phi = input(symget(cats("rdcorr2018_lat_corr_",i_nw)),BEST32.);
      ne_phi = input(symget(cats("rdcorr2018_lat_corr_",i_ne)),BEST32.);
      sw_phi = input(symget(cats("rdcorr2018_lat_corr_",i_sw)),BEST32.);
      se_phi = input(symget(cats("rdcorr2018_lat_corr_",i_se)),BEST32.);
      nw_labda = input(symget(cats("rdcorr2018_lon_corr_",i_nw)),BEST32.);
      ne_labda = input(symget(cats("rdcorr2018_lon_corr_",i_ne)),BEST32.); 
      sw_labda = input(symget(cats("rdcorr2018_lon_corr_",i_sw)),BEST32.);
      se_labda = input(symget(cats("rdcorr2018_lon_corr_",i_se)),BEST32.);

      RDcorrLat = (phinorm - floor(phinorm)) * ((nw_phi*(floor(labdanorm) + 1 - labdanorm)) + ne_phi*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_phi*(floor(labdanorm) + 1 - labdanorm)) + se_phi*(labdanorm - floor(labdanorm)));
      RDcorrLon = (phinorm - floor(phinorm)) * ((nw_labda*(floor(labdanorm) + 1 - labdanorm)) + ne_labda*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_labda*(floor(labdanorm) + 1 - labdanorm)) + se_labda*(labdanorm - floor(labdanorm)));
    end;
    else do;
      RDcorrLat = 0;
      RDcorrLon = 0;
    end;
    phi = phi + RDcorrLat;        %* in degrees;
    labda = labda + RDcorrLon;    %* in degrees;

    /* Inverse datum transformation */
    format h0_RD BEST32.;
    format RN Xgeo Ygeo Zgeo phi BEST32.;
    format e_square_b1841 BEST32.;
    
    format X1geo Y1geo Z1geo BEST32.;
    format alpha beta gamma delta BEST32.;
    format tX tY tZ BEST32.;
    format s BEST32.;
    format R11 R12 R13 R21 R22 R23 R31 R32 R33 BEST32.;
    format X2geo Y2geo Z2geo BEST32.;

    format a_grs80 f_grs80 epsilon_grs80 BEST32.;
    format e_square_grs80 BEST32.;
    format ETRS89_lat ETRS89_lon  BEST32.; 

    /* Convert the ellipsoidal geographic Bessel coordinates to geocentric Cartesian Bessel coordinates. */
    phi = phi*constant('pi')/180;               %* in radian;
    labda = labda*constant('pi')/180;
    h0_RD = input(symget('gmv_RD_Bessel_h0'),BEST32.);

    e_square_b1841 = f_b1841*(2-f_b1841);
    RN = a_b1841/sqrt(1 - (e_square_b1841 * (sin(phi)**2)));
    Xgeo = (RN + h0_RD) * cos(phi) * cos(labda);
    Ygeo = (RN + h0_RD) * cos(phi) * sin(labda);
    Zgeo = ((RN * (1 - e_square_b1841)) + h0_RD) * sin(phi);

    /*
    Rigorous 3D similarity transformation of geocentric Cartesian coordinates. The obtained geocentric Cartesian
    coordinates are in the geodetic datum of RD. The geodetic datum is often referred to as RD Bessel or just Bessel, 
    even though geocentric Cartesian coordinates do not use the Bessel ellipsoid.
    */
    X1geo = Xgeo;
    Y1geo = Ygeo;
    Z1geo = Zgeo;
    alpha = input(symget('gmv_alpha_inv'),BEST32.);
    beta = input(symget('gmv_beta_inv'),BEST32.);
    gamma = input(symget('gmv_gamma_inv'),BEST32.);
    delta = input(symget('gmv_delta_inv'),BEST32.);
    tX = input(symget('gmv_tX_inv'),BEST32.);
    tY = input(symget('gmv_tY_inv'),BEST32.);
    tZ = input(symget('gmv_tZ_inv'),BEST32.);

    s = 1 + delta;
    R11 = cos(gamma) * cos(beta);
    R12 = cos(gamma) * sin(beta) * sin(alpha)  + sin(gamma) * cos(alpha);
    R13 = -cos(gamma) * sin(beta) * cos(alpha) + sin(gamma) * sin(alpha);
    R21 = -sin(gamma) * cos(beta);
    R22 = -sin(gamma) * sin(beta) * sin(alpha) + cos(gamma) * cos(alpha);
    R23 = sin(gamma) * sin(beta) * cos(alpha) + cos(gamma) * sin(alpha);
    R31 = sin(beta);
    R32 = -cos(beta) * sin(alpha);
    R33 = cos(beta) * cos(alpha);

    X2geo = s * (R11 * X1geo + R12 * Y1geo + R13 * Z1geo) + tX;
    Y2geo = s * (R21 * X1geo + R22 * Y1geo + R23 * Z1geo) + tY;
    Z2geo = s * (R31 * X1geo + R32 * Y1geo + R33 * Z1geo) + tZ;

    /* Convert the geocentric ETR89 coordinates of the point of interest back to ellipsoidal geographic ETRS89 coordinates. */
    Xgeo = X2geo;
    Ygeo = Y2geo;
    Zgeo = Z2geo;
    a_grs80 = input(symget('gmv_GRS80_a'),BEST32.);
    f_grs80 = input(symget('gmv_GRS80_f'),BEST32.);
    epsilon_grs80 = input(symget('gmv_epsilon_GRS80_threshold'),BEST32.);
    e_square_grs80 = f_grs80*(2-f_grs80);

    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    */
    phi1 = PHI_C;  %* correct, it is an UNTIL loop, thus it is initialized in the loop;
    do until (abs(phi1-phi) lt epsilon_grs80);
      phi = phi1;
      RN = a_grs80/sqrt(1 - (e_square_grs80 * sin(phi)**2));
      if Xgeo > 0 then phi1 = atan((Zgeo + e_square_grs80*RN*sin(phi))/sqrt(Xgeo**2 + Ygeo**2));
      else if round(Xgeo,0.000000000001) eq 0 and round(Ygeo,0.000000000001) eq 0 and round(Zgeo,0.000000000001) ge 0 then phi1 = constant('pi')/2;   %* +90 degrees;
           else phi1 = -1*constant('pi')/2;                                                                                                           %* -90 degrees;
    end;

    %* The phi or lat value (phi1) has been calculated. Now calculate the labda or lon value;
    if Xgeo gt 0 then labda = atan(Ygeo/Xgeo);
    else if Xgeo lt 0 and Ygeo ge 0 then labda = atan(Ygeo/Xgeo) + constant('pi');  %* +180 degrees;
    else if Xgeo lt 0 and Ygeo lt 0 then labda = atan(Ygeo/Xgeo) - constant('pi');  %* -180 degrees;
    else if Xgeo eq 0 and Ygeo gt 0 then labda = constant('pi')/2;                  %*  +90 degrees;
    else if Xgeo eq 0 and Ygeo lt 0 then labda = -1*constant('pi')/2;               %*  -90 degrees;
    else if Xgeo eq 0 and Ygeo eq 0 then labda = 0;

    ETRS89_lat = phi1*180/constant('pi');     %* in degrees;
    ETRS89_lon = labda*180/constant('pi');    %* in degrees;

    /* The height transformation. Do only height transformation if an RD height value is supplied */
    format H height BEST32.;
    format nw_height ne_height sw_height se_height BEST32.;
    format ETRS89_h BEST32.;
    format etrs89_quasi_height BEST32.;

    if H ne -999999 then do;

      phi = ETRS89_lat;     %* in degrees;
      labda = ETRS89_lon;   %* in degrees;
      height = H;

      phinorm = (phi-phi_min)/phi_delta;
      labdanorm = (labda-labda_min)/labda_delta;
      nlabda = 1 + ((labda_max-labda_min)/labda_delta);

      %* Rounding needed to pass the test validation;
      if round(phi,0.00000001) ge phi_min and round(phi,0.00000001) le phi_max and round(labda,0.00000001) ge labda_min and round(labda,0.00000001) le labda_max then do;
  
        i_nw = ceil(phinorm)*nlabda + floor(labdanorm) + 1;
        i_ne = ceil(phinorm)*nlabda + ceil(labdanorm) +  1;
        i_sw = floor(phinorm)*nlabda + floor(labdanorm) + 1;
        i_se = floor(phinorm)*nlabda + ceil(labdanorm) + 1;
  
        nw_height = input(symget(cats("nlgeo2018_nap_height_",i_nw)),BEST32.);
        ne_height = input(symget(cats("nlgeo2018_nap_height_",i_ne)),BEST32.);
        sw_height = input(symget(cats("nlgeo2018_nap_height_",i_sw)),BEST32.);
        se_height = input(symget(cats("nlgeo2018_nap_height_",i_se)),BEST32.);
  
        etrs89_quasi_height = (phinorm - floor(phinorm)) * ((nw_height*(floor(labdanorm) + 1 - labdanorm)) + ne_height*(labdanorm - floor(labdanorm))) + (floor(phinorm) + 1 - phinorm) * ((sw_height*(floor(labdanorm) + 1 - labdanorm)) + se_height*(labdanorm - floor(labdanorm)));
        ETRS89_h = height + etrs89_quasi_height;
      end;
      else do;
        etrs89_quasi_height = -999999;
        ETRS89_h = etrs89_quasi_height;
      end;  
    end;
    else ETRS89_h = -999999;
  run;
  
  %* Keep only the transformation result. Suppress all others;
  %if &pSuppress eq 1 %then %do;
    %* Get the columns from the input dataset and then add the ETRS89 transformation values to it;
    proc sql noprint;
      select name into :lmv_DSin_columns separated by ' ' from DICTIONARY.columns
      where libname eq %upcase("&lmv_lib") and memname eq %upcase("&lmv_ds");
    quit;
    %let lmv_DSin_columns = &lmv_DSin_columns ETRS89_lat ETRS89_lon ETRS89_h;
    %put &=lmv_DSin_columns;
    data &pDSout;
      set &pDSout;
      keep &lmv_DSin_columns;
    run;
  %end;
%mend RD_to_ETRS89_v2;

%***************************************************************************;
%* END  : version 2 (ETRS89 to RD)                                          ;
%* BEGIN: Import the grid text files and validation and certification files ;
%***************************************************************************;

%macro grid_import_rdcorr2018(pFile /* the location of the RD correction grid */
                             ,pLib  /* the library to store the grid */);
  /*
  See usage explanation at top. One time effort. Part of the functionality setup.
  header: RD_lat_(deg) RD_lon_(deg) lat_corr_(deg) lon_corr_(deg)
  file example: filename reffile disk '/folders/myfolders/sasuser.v94/files/input/rdcorr2018.txt'
  */
  filename reffile disk "&pFile";
  data &pLib..rdcorr2018;
    infile reffile firstobs=2 DLM='09'x;
    informat rd_lat rd_lon lat_corr lon_corr 8.;
    format rd_lat rd_lon lat_corr lon_corr BEST32.;
    input rd_lat rd_lon lat_corr lon_corr;
    i =_N_;
  run;
  %put &=pFile;
  %put &=pLib;
  %put Dataset: &pLib..rdcorr2018;
%mend grid_import_rdcorr2018;

%macro grid_import_nlgeo2018(pFile /* the location of the height correction grid */
                            ,pLib  /* the library to store the grid */);
  /*
  See usage explanation at top. One time effort. Part of the functionality setup.                      
  header      : etrs89_lat(deg) etrs89_lon(deg) nap_height
  file example: filename reffile disk '/folders/myfolders/sasuser.v94/files/input/nlgeo2018.txt'
  */
  filename reffile disk "&pFile";
  data &pLib..nlgeo2018;
    infile reffile firstobs=2 DLM='09'x;
    informat etrs89_lat etrs89_lon nap_height 8.;
    format etrs89_lat etrs89_lon nap_height BEST32.;
    input etrs89_lat etrs89_lon nap_height;
    i =_N_;
  run;
  %put &=pFile;
  %put &=pLib;
  %put Dataset: &pLib..nlgeo2018;
%mend grid_import_nlgeo2018;

%macro self_validation_import(pFile /* the location of the self-validation file */
                             ,pLib  /* the library to store the self-validation file */);
  /*
  The self-validation file is at: https://www.nsgi.nl/geodetische-infrastructuur/producten/programma-rdnaptrans/zelfvalidatie
  The name is: Z001_ETRS89andRDNAP.txt. The dataset is then called: Z001_ETRS89andRDNAP
  The input file is tab separated, it does does not have an header row, but reads as follows: 
  pointer lat lon height x y z;
  -999999 stands for no RD NAP height value.
  file example: filename reffile disk '/folders/myfolders/sasuser.v94/files/input/Z001_ETRS89andRDNAP.txt';
  */                            
  filename reffile disk "&pFile";
  data &pLib..Z001_ETRS89andRDNAP(drop=z0);
    infile reffile DLM='09'x;
    informat ptr lat lon h x y z 8.;
    format ptr 8. lat lon h x y z BEST32. z0 $16.;
    input ptr lat lon h x y z0;
    if z0 ne '*' then z = input(z0, BEST32.);
    else z = -999999;
    i =_N_;
  run;
  %put &=pFile;
  %put &=pLib;
  %put Dataset: &pLib..Z001_ETRS89andRDNAP;
%mend self_validation_import;

%macro certificate_validation_import(pETRS89file /* the location of the ETRS89 certificate validation file */
                                    ,pRDfile     /* the location of the RD certificate validation file */
                                    ,pLib        /* the library to store the certificate validation file */);
  /*
  The certificate validation files are at: https://www.nsgi.nl/geodetische-infrastructuur/producten/programma-rdnaptrans/validatieservice#etrsresult
  002_ETRS89.txt: to certificate ETRS89 to RD transformation -> Dataset: Z002_ETRS89.
  002_RDNAP.txt : to certificate RD to ETRS89 transformation -> Dataset: Z002_RDNAP.
  Header 002_ETRS89.txt: point_id  latitude  longitude  height
  Header 002_RDNAP.txt : point_id  x_coordinate  y_coordinate height
  The input files are space separated.
  file example: filename reffile disk '/folders/myfolders/sasuser.v94/files/input/002_ETRS89.txt';
  */                            
  filename reffile disk "&pETRS89file";
  data &pLib..Z002_ETRS89;
    infile reffile DLM=' ' firstobs=2;
    informat point_id latitude longitude height 8.;
    format point_id 8. latitude longitude height BEST32.;
    input point_id latitude longitude height;
    i = _N_;
  run;
  
  filename reffile disk "&pRDfile";
  data &pLib..Z002_RDNAP;
    infile reffile DLM=' ' firstobs=2;
    informat point_id x_coordinate y_coordinate height 8.;
    format point_id 8. x_coordinate y_coordinate height BEST32.;
    input point_id x_coordinate y_coordinate height;
    i = _N_;
  run;

  %put &=pETRS89file;
  %put &=pRDfile;
  %put &=pLib;
  %put Dataset: &pLib..Z002_ETRS89;
  %put Dataset: &pLib..Z002_RDNAP;
%mend certificate_validation_import;

%***************************************************************************;
%* END  : Import the grid text files and validation and certification files ;
%* BEGIN: Self-validation (v1 and v2)                                       ;
%***************************************************************************;

%macro self_validation_ETRS89_v1(pLib  /* the library where the self-validation dataset is stored */);
  /*
  ETRS89 to RD selfvalidation. 100% score needed.
  The self-validation dataset is called: Z001_ETRS89andRDNAP
  The return dataset is called         : SELF_ETRS89_V1
  
  Next shows what you should get as output:
   max_dx    max_dy    max_dz     dx     dy    dxdy   dz
  0.000338  0.000757  0.000051  10000  10000  10000  10000
  */
 
  %* Set notes option to nonotes, if applicable;
  proc sql noprint;
    select setting into: lmv_option_setting from DICTIONARY.options
    where optname = 'NOTES';
  quit;
  %if &lmv_option_setting eq NOTES %then %do;
    options nonotes;
  %end;
  
  %rdnaptrans2018_ini_v1(&pLib)
  proc sql noprint;
    create table SELF_ETRS89_V1 as select * from &pLib..Z001_ETRS89andRDNAP;
    alter table SELF_ETRS89_V1 add xc num format=BEST32.
                                  ,yc num format=BEST32.
                                  ,zc num format=BEST32.;
  quit;
  %do lc=1 %to 10000;
    data _null_;
      obsnum=&lc;
      set &pLib..Z001_ETRS89andRDNAP point=obsnum;
      call symputx('gmv_ETRS89_lat_dec',strip(put(lat,BEST32.)));
      call symputx('gmv_ETRS89_lon_dec',strip(put(lon,BEST32.)));
      call symputx('gmv_ETRS89_height',strip(put(h,BEST32.)));
      put i=;
     stop;
    run;
    %ETRS89_to_RD_v1(&gmv_ETRS89_lat_dec,&gmv_ETRS89_lon_dec,pH=&gmv_ETRS89_height)
    proc sql;
      update SELF_ETRS89_V1 set xc=&gmv_rd_x_lon, yc=&gmv_rd_y_lat, zc=&gmv_NAP_height
      where i = &lc;
    quit;
  %end;

  %* 100% score is achieved when all three coordinates are smaller then 1mm;
  data &pLib..SELF_ETRS89_V1;
    set SELF_ETRS89_V1 (drop=i);
    format dx dy dz BEST32.;
    dx = abs(xc - x);
    dy = abs(yc - y);
    dz = abs(zc - z);
    if dx < 0.001 then conv_x_ok = 1;
    else conv_x_ok = 0;
    if dy < 0.001 then conv_y_ok = 1;
    else conv_y_ok = 0;
    if conv_x_ok eq 1 and conv_y_ok eq 1 then conv_x_y_ok = 1;
    else conv_x_y_ok = 0;
    if dz < 0.001 then conv_z_ok = 1;
    else conv_z_ok = 0;
  run;

  %* Display the results;
  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 '   max_dx    max_dy    max_dz     dx     dy    dxdy   dz';
    title3 ' 0.000338  0.000757  0.000051  10000  10000  10000  10000';
    select max(dx) as max_dx, max(dy) as max_dy, max(dz) as max_dz,
    (select sum(conv_x_ok) from &pLib..SELF_ETRS89_V1) as dx,
    (select sum(conv_y_ok) from &pLib..SELF_ETRS89_V1) as dy,
    (select sum(conv_x_y_ok) from &pLib..SELF_ETRS89_V1) as dxdy,
    (select sum(conv_z_ok) from &pLib..SELF_ETRS89_V1) as dz
    from &pLib..SELF_ETRS89_V1;
    title;
  quit;
  
  %* Restore original notes option setting;  
  %if &lmv_option_setting eq NOTES %then %do;
    options notes;
  %end;
%mend self_validation_ETRS89_v1;

%macro self_validation_RD_v1(pLib  /* the library where the self-validation dataset is stored */);
  /*
  RD to ETRS89 selfvalidation. You will not get a 100% score. You should get 97.61% score as minimum
  The self-validation dataset is called: Z001_ETRS89andRDNAP
  The return dataset is called         : SELF_RDNAP_V1
  
  Next shows what you should get as output:
  max_dlat  max_dlon   max_dh   dlat  dlon  dlatdlon   dh
  3.534E-8  4.247E-8  0.000051  9774  9857    9761    10000
  */

  %* Set notes option to nonotes, if applicable;
  proc sql noprint;
    select setting into: lmv_option_setting from DICTIONARY.options
    where optname = 'NOTES';
  quit;
  %if &lmv_option_setting eq NOTES %then %do;
    options nonotes;
  %end;
  
  %rdnaptrans2018_ini_v1(&pLib)
  proc sql noprint;
    create table SELF_RDNAP_V1 as select * from &pLib..Z001_ETRS89andRDNAP;
    alter table SELF_RDNAP_V1 add latc num format=BEST32.
                                 ,lonc num format=BEST32.
                                 ,hc num format=BEST32.;
  quit;

  %do lc=1 %to 10000;
    data _null_;
      obsnum=&lc;
      set &pLib..Z001_ETRS89andRDNAP point=obsnum;
      call symputx('gmv_RD_x_lon',strip(put(x,BEST32.)));
      call symputx('gmv_RD_y_lat',strip(put(y,BEST32.)));
      call symputx('gmv_NAP_height',strip(put(z,BEST32.)));
      put i=;
      stop;
    run;
    %RD_to_ETRS89_v1(&gmv_RD_x_lon,&gmv_RD_y_lat,pH=&gmv_NAP_height)
    proc sql;
      update SELF_RDNAP_V1 set latc=&gmv_ETRS89_lat_dec, lonc=&gmv_ETRS89_lon_dec, hc=&gmv_ETRS89_height
      where i = &lc;
    quit;
  %end;
  
  %* 100% score is achieved when all three coordinates are smaller then 0.00000001 meter. That is not gonna happen here;
  data &pLib..SELF_RDNAP_V1;
    set SELF_RDNAP_V1 (drop=i);
    format dlat dlon dh BEST32.;
    dlat = abs(latc - lat);
    dlon = abs(lonc - lon);
    dh = abs(hc - h);
    if dlat lt 0.00000001 then conv_lat_ok = 1;
    else conv_lat_ok = 0;
    if dlon lt 0.00000001 then conv_lon_ok = 1;
    else conv_lon_ok = 0;
    if conv_lat_ok eq 1 and conv_lon_ok eq 1 then conv_lat_lon_ok = 1;
    else conv_lat_lon_ok = 0;
    if z = -999999 and hc = -999999 then conv_h_ok = 1;
    else if dh <= 0.001 then conv_h_ok = 1;
         else conv_h_ok = 0;
  run;
  
  %* Display the results;
  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 'max_dlat  max_dlon   max_dh   dlat  dlon  dlatdlon   dh'; 
    title3 '3.534E-8  4.247E-8  0.000051  9774  9857    9761    10000';
    select max(dlat) as max_dlat, max(dlon) as max_dlon,
    (select max(dh) from &pLib..SELF_RDNAP_V1 where conv_h_ok eq 1 and not(z = -999999 and hc = -999999 )) as max_dh,
    (select sum(conv_lat_ok) from &pLib..SELF_RDNAP_V1) as dlat,
    (select sum(conv_lon_ok) from &pLib..SELF_RDNAP_V1) as dlon,
    (select sum(conv_lat_lon_ok) from &pLib..SELF_RDNAP_V1) as dlatdlon,
    (select sum(conv_h_ok) from &pLib..SELF_RDNAP_V1) as dh
    from &pLib..SELF_RDNAP_V1;
    title;
  quit;
  
  %* Restore original notes option setting;  
  %if &lmv_option_setting eq NOTES %then %do;
    options notes;
  %end;
%mend self_validation_RD_v1;

%macro self_validation_ETRS89_v2(pLib  /* the library where the self-validation dataset is stored */);
  /*
  ETRS89 to RD selfvalidation. 100% score needed.
  The self-validation dataset is called: Z001_ETRS89andRDNAP
  The return dataset is called         : SELF_ETRS89_V2
  
  Next shows what you should get as output:
   max_dx    max_dy    max_dz     dx     dy    dxdy   dz
  0.000338  0.000758  0.000051  10000  10000  10000  10000
  */
  
  %rdnaptrans2018_ini_v2
  %rdnaptrans2018_grid_v2(&pLib..RDCORR2018, &pLib..NLGEO2018)
  %ETRS89_to_RD_v2(&pLib..Z001_ETRS89ANDRDNAP, SELF_ETRS89_V2) 

  %* 100% score is achieved when all three coordinates are smaller then 1mm;
  data &pLib..SELF_ETRS89_V2;
    set SELF_ETRS89_V2 (keep=ptr lat lon h x y z RD_x RD_y RD_h);
    format dx dy dz BEST32.;
    dx = abs(x-RD_x);
    dy = abs(y-RD_y);
    dz = abs(z-RD_h);
    if dx lt 0.001 then conv_x_ok = 1;
      else conv_x_ok = 0;
    if dy lt 0.001 then conv_y_ok = 1;
      else conv_y_ok = 0;
    if conv_x_ok eq 1 and conv_y_ok eq 1 then conv_x_y_ok = 1;
      else conv_x_y_ok = 0;
    if dz lt 0.001 then conv_z_ok = 1;
      else conv_z_ok = 0;
  run;

  %* Display the results;
  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 '   max_dx    max_dy    max_dz     dx     dy    dxdy   dz';
    title3 ' 0.000338  0.000757  0.000051  10000  10000  10000  10000';
    select max(dx) as max_dx, max(dy) as max_dy, max(dz) as max_dh,
    (select sum(conv_x_ok) from &pLib..SELF_ETRS89_V2) as dx,
    (select sum(conv_y_ok) from &pLib..SELF_ETRS89_V2) as dy,
    (select sum(conv_x_y_ok) from &pLib..SELF_ETRS89_V2) as dxdy,
    (select sum(conv_z_ok) from &pLib..SELF_ETRS89_V2) as dz
    from &pLib..SELF_ETRS89_V2;
    title;
  quit;
%mend self_validation_ETRS89_v2;

%macro self_validation_RD_v2(pLib  /* the library where the self-validation dataset is stored */);
  /*
  RD to ETRS89 selfvalidation. You will not get a 100% score. You should get 97.61% score as minimum
  The self-validation dataset is called: Z001_ETRS89andRDNAP
  The return dataset is called         : SELF_RDNAP_V1
  
  Next shows what you should get as output:
  max_dlat  max_dlon   max_dh   dlat  dlon  dlatdlon   dh
  3.534E-8  4.247E-8  0.000051  9774  9857    9761    10000
  */

  %rdnaptrans2018_ini_v2
  %rdnaptrans2018_grid_v2(&pLib..RDCORR2018, &pLib..NLGEO2018)
    
  data Z001_ETRS89ANDRDNAP(rename=(z=H));
    set &pLib..Z001_ETRS89ANDRDNAP(rename=(h=etrs_h));
  run; 
  %RD_to_ETRS89_v2(Z001_ETRS89ANDRDNAP, SELF_RDNAP_V2)

  %* 100% score is achieved when all three coordinates are smaller then 0.00000001 meter. That is not gonna happen here;
  data &pLib..SELF_RDNAP_V2;
    set SELF_RDNAP_V2 (keep=ptr lat lon etrs_h x y H ETRS89_lat ETRS89_lon ETRS89_h);
    format dlat dlon dh BEST32.;
    dlat = abs(lat - ETRS89_lat);
    dlon = abs(lon - ETRS89_lon);
    dh = abs(etrs_h - ETRS89_h);;
    if dlat lt 0.00000001 then lat_conv_ok = 1;
      else lat_conv_ok = 0;
    if dlon lt 0.00000001 then lon_conv_ok = 1;
      else lon_conv_ok = 0;
    if lat_conv_ok eq 1 and lon_conv_ok eq 1 then lat_lon_conv_ok = 1;
      else lat_lon_conv_ok = 0;
    if ETRS89_h eq -999999 then h_conv_ok = 1;
    else if dh lt 0.001 then h_conv_ok = 1;
         else h_conv_ok = 0;
  run;
  
  %* Display the results;
  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 'max_dlat  max_dlon   max_dh   dlat  dlon  dlatdlon   dh';
    title3 '3.534E-8  4.247E-8  0.000051  9774  9857    9761    10000';
    select max(dlat) as max_dlat, max(dlon) as max_dlon,
    (select max(dh) from &pLib..SELF_RDNAP_V2 where h_conv_ok eq 1 and ETRS89_h ne -999999) as max_dh,
    (select sum(lat_conv_ok) from &pLib..SELF_RDNAP_V2) as dlat,
    (select sum(lon_conv_ok) from &pLib..SELF_RDNAP_V2) as dlon,
    (select sum(lat_lon_conv_ok) from &pLib..SELF_RDNAP_V2) as dlatdlon,
    (select sum(h_conv_ok) from &pLib..SELF_RDNAP_V2) as dh
    from &pLib..SELF_RDNAP_V2;
    title;
  quit;
%mend self_validation_RD_v2;

%************************************************;
%* END  : Self-validation (v1 and v2)            ;
%* BEGIN: Certification validation (v1 and v2)   ;
%************************************************;

%macro certify_validation_ETRS89_v1(pLib        /* the library where the ETRS certification dataset is stored */
                                   ,pOutputFile /* the output file */);
  /*
  ETRS89 to RD certification. 100% score needed.
  The certification  dataset is called : Z002_ETRS89
  The return dataset is called         : CERTIFY_ETRS89_V1
  The output file must then be fed into the certification validation service.
  */
 
  %* Set notes option to nonotes, if applicable;
  proc sql noprint;
    select setting into: lmv_option_setting from DICTIONARY.options
    where optname = 'NOTES';
  quit;
  %if &lmv_option_setting eq NOTES %then %do;
    options nonotes;
  %end;
  
  %rdnaptrans2018_ini_v1(&pLib)
  proc sql noprint;
    create table CERTIFY_ETRS89_V1 as select * from &pLib..Z002_ETRS89;
    alter table CERTIFY_ETRS89_V1 add x_coordinate num format=BEST32.
                                         ,y_coordinate num format=BEST32.
                                         ,rd_height num format=BEST32.;
  quit;
  %do lc=1 %to 10000;
    data _null_;
      obsnum=&lc;
      set  &pLib..Z002_ETRS89 point=obsnum;
      call symputx('gmv_ETRS89_lat_dec',strip(put(latitude,BEST32.)));
      call symputx('gmv_ETRS89_lon_dec',strip(put(longitude,BEST32.)));
      call symputx('gmv_ETRS89_height',strip(put(height,BEST32.)));
      put i=;
      stop;
    run;
    %ETRS89_to_RD_v1(&gmv_ETRS89_lat_dec,&gmv_ETRS89_lon_dec,pH=&gmv_ETRS89_height)
    proc sql;
      update CERTIFY_ETRS89_V1 set x_coordinate=&gmv_rd_x_lon
                                  ,y_coordinate=&gmv_rd_y_lat
                                  ,rd_height=&gmv_NAP_height
      where i = &lc;
    quit;
  %end;
  
  %* Restore original notes option setting;  
  %if &lmv_option_setting eq NOTES %then %do;
    options notes;
  %end;
  
  data &pLib..CERTIFY_ETRS89_V1;
    set CERTIFY_ETRS89_V1 (drop=i latitude longitude height);
    rename rd_height=height;
  run;
  
  filename reffile disk "&pOutputFile";
  data _null_;
    set &pLib..CERTIFY_ETRS89_V1;
    file reffile DLM=' ';
    format point_id 8. x_coordinate y_coordinate height BEST32.;
    put point_id x_coordinate y_coordinate @;
    if height ne -999999 then put height @;
    else put 'NaN' @;
    put '0D'x;
  run;
%mend certify_validation_ETRS89_v1;

%macro certify_validation_RD_v1(pLib        /* the library where the RD certification dataset is stored */
                               ,pOutputFile /* the output file */);
  /*
  RD to ETRS89 certification. 100% score needed.
  The certification  dataset is called : Z002_RDNAP
  The return dataset is called         : CERTIFY_RDNAP_V1
  The output file must then be fed into the certification validation service.
  */
 
  %* Set notes option to nonotes, if applicable;
  proc sql noprint;
    select setting into: lmv_option_setting from DICTIONARY.options
    where optname = 'NOTES';
  quit;
  %if &lmv_option_setting eq NOTES %then %do;
    options nonotes;
  %end;
  
  %rdnaptrans2018_ini_v1(&pLib)
  proc sql noprint;
    create table CERTIFY_RDNAP_V1 as select * from &pLib..Z002_RDNAP;
    alter table CERTIFY_RDNAP_V1 add latitude num format=BEST32.
                                    ,longitude num format=BEST32.
                                    ,etrs89_height num format=BEST32.;
  quit;
  %do lc=1 %to 10000;
    data _null_;
      obsnum=&lc;
      set &pLib..Z002_RDNAP point=obsnum;
      call symputx('gmv_RD_x_lon',strip(put(x_coordinate,BEST32.)));
      call symputx('gmv_RD_y_lat',strip(put(y_coordinate,BEST32.)));
      call symputx('gmv_NAP_height',strip(put(height,BEST32.)));
      put i=;
      stop;
    run;
    %RD_to_ETRS89_v1(&gmv_RD_x_lon,&gmv_RD_y_lat,pH=&gmv_NAP_height)
    proc sql;
      update CERTIFY_RDNAP_V1 set latitude=&gmv_ETRS89_lat_dec
                                 ,longitude=&gmv_ETRS89_lon_dec
                                 ,etrs89_height=&gmv_ETRS89_height
      where i = &lc;
    quit;
  %end;
  
  %* Restore original notes option setting;  
  %if &lmv_option_setting eq NOTES %then %do;
    options notes;
  %end;
  
  data &pLib..CERTIFY_RDNAP_V1;
    set CERTIFY_RDNAP_V1 (drop=i x_coordinate y_coordinate height);
    rename etrs89_height=height;
  run;
   
  filename reffile disk "&pOutputFile";
  data _null_;
    set &pLib..CERTIFY_RDNAP_V1;
    file reffile DLM=' ';
    format point_id 8. latitude longitude height BEST32.;
    put point_id latitude longitude @;
    if height ne -999999 then put height @;
    else put 'NaN' @;
    put '0D'x;
  run;
%mend certify_validation_RD_v1;

%macro certify_validation_ETRS89_v2(pLib        /* the library where the ETRS89 certification dataset is stored */
                                   ,pOutputFile /* the output file */);
  /*
  ETRS89 to RD certification. 100% score needed.
  The certification  dataset is called : Z002_ETRS89
  The return dataset is called         : CERTIFY_ETRS89_V2
  The output file must then be fed into the certification validation service.
  */
  %rdnaptrans2018_ini_v2
  %rdnaptrans2018_grid_v2(&pLib..RDCORR2018, &pLib..NLGEO2018)
  
  data Z002_ETRS89;
    set &pLib..Z002_ETRS89 (drop=i);
    rename latitude=lat longitude=lon height=h;
  run;
  %ETRS89_to_RD_v2(Z002_ETRS89, CERTIFY_ETRS89_V2)
  data &pLib..CERTIFY_ETRS89_V2;
    set CERTIFY_ETRS89_V2 (keep=point_id RD_x RD_y RD_h);
  run;
  
  filename reffile disk "&pOutputFile";
  data _null_;
    set &pLib..CERTIFY_ETRS89_V2;
    file reffile DLM=' ';
    format point_id 8. RD_x RD_y RD_h BEST32.;
    put point_id RD_x RD_y @;
    if RD_h ne -999999 then put RD_h @;
    else put 'NaN' @;
    put '0D'x;
  run;
%mend certify_validation_ETRS89_v2;

%macro certify_validation_RD_v2(pLib        /* the library where the RD certification dataset is stored */
                               ,pOutputFile /* the output file */);
  /*
  RD to ETRS89 to certification. 100% score needed.
  The certification  dataset is called : Z002_RDNAP
  The return dataset is called         : CERTIFY_RDNAP_V2
  The output file must then be fed into the certification validation service.
  */
  %rdnaptrans2018_ini_v2
  %rdnaptrans2018_grid_v2(&pLib..RDCORR2018, &pLib..NLGEO2018)
    
  data Z002_RDNAP;
    set &pLib..Z002_RDNAP (drop=i);
    rename x_coordinate=x y_coordinate=y height=H;
  run;
  %RD_to_ETRS89_v2(Z002_RDNAP, CERTIFY_RDNAP_V2)
  data &pLib..CERTIFY_RDNAP_V2;
    set CERTIFY_RDNAP_V2 (keep=point_id ETRS89_lat ETRS89_lon ETRS89_h);
  run;
  
  filename reffile disk "&pOutputFile";
  data _null_;
    set &pLib..CERTIFY_RDNAP_V2;
    file reffile DLM=' ';
    format point_id 8. ETRS89_lat ETRS89_lon ETRS89_h BEST32.;
    put point_id ETRS89_lat ETRS89_lon @;
    if ETRS89_h ne -999999 then put ETRS89_h @;
    else put 'NaN' @;
    put '0D'x;
  run;
 %mend certify_validation_RD_v2;

%*************************************************;
%* END  : Certification validation (v1 and v2)    ;
%* BEGIN: ETRS89 to ITRS transformation Version 1 ;
%*************************************************;

%macro etrs_itrs_ini_v1(pItrf=ITRF2014 /* The ITRF realisation you use; ITRF2008 or ITRF2014 */);
  /* Initializes all ITRS transformation parameters and global macro variables */

  %global gmv_ETRS89_lat_dgr;            %* the lat/lon pair in minutes, second degrees: ellipsoidal geographic ETRS89 coordinates;
  %global gmv_ETRS89_lon_dgr;
  %global gmv_ETRS89_lat_dec;            %* the lat/lon pair in decimal degrees: ellipsoidal geographic ETRS89 coordinates;
  %global gmv_ETRS89_lon_dec;
  %global gmv_ETRS89_height;             %* the height in ETRS89 meter;

  %global gmv_ITRS_lat_dgr;              %* the lat/lon pair in minutes, second degrees: ellipsoidal geographic ITRS2014 coordinates;
  %global gmv_ITRS_lon_dgr;
  %global gmv_ITRS_lat_dec;              %* the lat/lon pair in decimal degrees: ellipsoidal geographic ITRS2014 coordinates;
  %global gmv_ITRS_lon_dec;
  %global gmv_ITRS_height;               %* the height in ITRS2014 meter;

  %global gmv_WGS84_lat_dgr;             %* the lat/lon pair in minutes, second degrees: ellipsoidal geographic WGS84 coordinates;
  %global gmv_WGS84_lon_dgr;
  %global gmv_WGS84_lat_dec;             %* the lat/lon pair in decimal degrees: ellipsoidal geographic WGS84 coordinates;
  %global gmv_WGS84_lon_dec;
  %global gmv_WGS84_height;              %* the height in WGS84 meter;

  %global gmv_D_dec;                     %* helper: degree in decimal notation;
  %global gmv_D_rad;                     %* helper: degree in radian;

  /* Two parameters for the conversion from ellipsoidal geographic coordinates to geocentric Cartesian coordinates */
  %global gmv_GRS80_a;        %* half major (equator) axis of GRS80 ellipsoid in meter;
  %global gmv_GRS80_f;        %* flattening of GRS80 ellipsoid (dimensionless);
  %let gmv_GRS80_a = 6378137;
  %let gmv_GRS80_f = %sysevalf(1/298.257222101);
  %put &=gmv_GRS80_a meter;
  %put &=gmv_GRS80_f;

  /* 
  Seven parameters and yearly rates for the 3D similarity transformation from ITRF2014 to ETRF2000. 
  For the other way around the signs must be inverted: multiply with -1
  */
  %global gmv_itrs_tX;       %* translation in direction of X axis meter: 𝑡𝑋 =+0.0547 m;
  %global gmv_itrs_tY;       %* translation in direction of Y axis meter: 𝑡𝑌 =+0.0522 m;
  %global gmv_itrs_tZ;       %* translation in direction of Z axis meter: 𝑡𝑍 =−0.0741 m;
  %global gmv_itrs_alpha;    %* rotation angle around X axis: 𝛼 =+0.00825∙10−6 rad=+0.001701″;
  %global gmv_itrs_beta;     %* rotation angle around Y axis: 𝛽 =+0.04989∙10−6 rad=+0.010290″;
  %global gmv_itrs_gamma;    %* rotation angle around Z axis: 𝛾 =−0.08063∙10−6 rad=−0.016632″;
  %global gmv_itrs_delta;    %* scale difference (dimensionless): 𝛿 =+0.00212∙10−6 ;

  %global gmv_rate_tX;       %* yearly rate of translation in direction of X axis: 𝑡̇𝑋 =+0.00010 m;
  %global gmv_rate_tY;       %* yearly rate of translation in direction of Y axis: 𝑡̇𝑌 =+0.00010 m;
  %global gmv_rate_tZ;       %* yearly rate of translation in direction of Z axis: 𝑡̇𝑍 =−0.00190 m;
  %global gmv_rate_alpha;    %* yearly rate of rotation angle around X axis: 𝛼̇ =+0.000393∙10−6 rad=+0.0000810″;
  %global gmv_rate_beta;     %* yearly rate of rotation angle around Y axis: 𝛽̇ =+0.002376∙10−6 rad=+0.0004900″;
  %global gmv_rate_gamma;    %* yearly rate of rotation angle around Z axis: 𝛾̇ =−0.003840∙10−6 rad=−0.0007920″;
  %global gmv_rate_delta;    %* yearly rate of scale difference (dimensionless): 𝛿̇ =+0.000110∙10−6;
  
  %* ITRF2014 parameters;
  %if %upcase(&pItrf) eq ITRF2014 %then %do;
    %let gmv_itrs_tX = %sysevalf(0.0547);
    %let gmv_itrs_tY = %sysevalf(0.0522);
    %let gmv_itrs_tZ = %sysevalf(-0.0741);
    %conv_dgr_dec_rad("0 0 -0.001701")
    %let gmv_itrs_alpha = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 -0.010290")
    %let gmv_itrs_beta = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 0.016632")
    %let gmv_itrs_gamma = &gmv_D_rad;
    %let gmv_itrs_delta = %sysevalf(0.00000000212);
  
    %let gmv_rate_tX = %sysevalf(0.00010);
    %let gmv_rate_tY = %sysevalf(0.00010);
    %let gmv_rate_tZ = %sysevalf(-0.00190);
    %conv_dgr_dec_rad("0 0 -0.0000810")
    %let gmv_rate_alpha = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 -0.0004900")
    %let gmv_rate_beta = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 0.0007920")
    %let gmv_rate_gamma = &gmv_D_rad;
    %let gmv_rate_delta = %sysevalf(0.000000000110);
  %end;
  %else %do;
    %* ITRF2008 parameters;
    %if %upcase(&pItrf) eq ITRF2008 %then %do;
      %let gmv_itrs_tX = %sysevalf(0.0531);
      %let gmv_itrs_tY = %sysevalf(0.0503);
      %let gmv_itrs_tZ = %sysevalf(-0.0765);
      %conv_dgr_dec_rad("0 0 -0.001701")
      %let gmv_itrs_alpha = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 -0.010290")
      %let gmv_itrs_beta = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 0.016632")
      %let gmv_itrs_gamma = &gmv_D_rad;
      %let gmv_itrs_delta = %sysevalf(0.00000000214);
    
      %let gmv_rate_tX = %sysevalf(0.00010);
      %let gmv_rate_tY = %sysevalf(0.00010);
      %let gmv_rate_tZ = %sysevalf(-0.00180);
      %conv_dgr_dec_rad("0 0 -0.0000810")
      %let gmv_rate_alpha = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 -0.0004900")
      %let gmv_rate_beta = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 0.0007920")
      %let gmv_rate_gamma = &gmv_D_rad;
      %let gmv_rate_delta = %sysevalf(0.000000000080);
    %end;
    %else %abort abend;
  %end;
  
  %global gmv_ITRF_realisation;
  %let gmv_ITRF_realisation = &pItrf;
  %put &=gmv_ITRF_realisation;
 
  %put &=gmv_itrs_tX meter;
  %put &=gmv_itrs_tY meter;
  %put &=gmv_itrs_tZ meter;
  %put &=gmv_itrs_alpha radian;
  %put &=gmv_itrs_beta radian;
  %put &=gmv_itrs_gamma radian;
  %put &=gmv_itrs_delta (dimensionless);
  
  %put &=gmv_rate_tX meter;
  %put &=gmv_rate_tY meter;
  %put &=gmv_rate_tZ meter;
  %put &=gmv_rate_alpha radian;
  %put &=gmv_rate_beta radian;
  %put &=gmv_rate_gamma radian;
  %put &=gmv_rate_delta (dimensionless);
  
  %global gmv_itrs_ref_epoch;   %* reference epoch (years);
  %let gmv_itrs_ref_epoch = 2010;
  %put &=gmv_itrs_ref_epoch (years);
  
  %global gmv_epsilon_itrs_threshold;         %* 𝜀 = precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_epsilon_itrs_threshold = %sysevalf(0.00000000002);
  %put &=gmv_epsilon_itrs_threshold radian; 
%mend etrs_itrs_ini_v1;

%macro etrs_itrs_output_v1;
  %put &=gmv_ITRF_realisation;
  
  %put &=gmv_ETRS89_lat_dec degrees;
  %put &=gmv_ETRS89_lon_dec degrees;
  %put &=gmv_ETRS89_height meter;

  %put &=gmv_ITRS_lat_dec degrees;;
  %put &=gmv_ITRS_lon_dec degrees;
  %put &=gmv_ITRS_height meter;
  
  %put &=gmv_WGS84_lat_dec degrees;
  %put &=gmv_WGS84_lon_dec degrees;
  %put &=gmv_WGS84_height meter;
%mend etrs_itrs_output_v1;
 
%macro WGS84_to_ETRS89_v1(pLat        /* WGS84 or ETRS89 latitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                         ,pLon        /* WGS84 or ETRS89 longitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                         ,pHeight     /* The elipsoidal height in meter. Set to zero when no height needed */);
  %lm_WGS84_to_ETRS89_v1(&pLat, &pLon, &pHeight, 1)                            
%mend WGS84_to_ETRS89_v1;
 
%macro ETRS89_to_WGS84_v1(pLat        /* WGS84 or ETRS89 latitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                         ,pLon        /* WGS84 or ETRS89 longitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                         ,pHeight     /* The elipsoidal height in meter. Set to zero when no height needed */);
  %lm_WGS84_to_ETRS89_v1(&pLat, &pLon, &pHeight, -1)                            
%mend ETRS89_to_WGS84_v1;
 
%macro lm_WGS84_to_ETRS89_v1(pLat        /* WGS84 or ETRS89 latitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                            ,pLon        /* WGS84 or ETRS89 longitude. Can be in decimals or D M S notation. pLat and pLon must have same notation */
                            ,pHeight     /* The elipsoidal height in meter. Set to zero when no height needed */
                            ,pDirection  /* The transformation direction, 1 (WGS84 to ETRS89) or -1 (ETRS89 to WGS84 */);
  /*
  Transform WGS84 to ETRS89 or ETRS89 to WGS84, depending the direction. Output global variables containing the result:
  gmv_ETRS89_lat_dec or gmv_WGS84_lat_dec : Latitude in decimal degrees.
  gmv_ETRS89_lon_dec or gmv_WGS84_lat_dec : longitude in decimal degrees.
  gmv_ETRS89_height or gmv_WGS84_lat_dec  : height meter. When 0 then no height.
  The gmv_ITRS global macro variables are always identical to the gmv_WGS84 global macro variables.
  A height value is mandatory. Set to zero when there is no height.
  */
  data _null_;
    format a_grs80 f_grs80 e_square_grs80 epsilon BEST32.;
    format phi phi1 labda h etrs_h i BEST32.;
    format RN X Y Z BEST32.;

    format X1 Y1 Z1 BEST32.;
    format alpha beta gamma delta BEST32.;
    format tX tY tZ BEST32.;
    format r_alpha r_beta r_gamma r_delta BEST32.;
    format r_tX r_tY r_tZ BEST32.;
    format s BEST32.;
    format R11 R12 R13 R21 R22 R23 R31 R32 R33 BEST32.;
    format X2 Y2 Z2 BEST32.;
    format t_epoch t BEST32.;
    format tr_way 8.;

    phi   = &pLat;     %* 𝜑 phi, in decimal degrees;
    labda = &pLon;     %* 𝜆 labda, in decimal degrees;
    h = &pHeight;
    tr_way = &pDirection;                                %* transformation directon or transformation way;
    phi1 = phi;                                          %* needed for the loop at the end of this macro;
    
    if tr_way eq 1 then do;                                               %* WGS84 to ETRS89;
      call symputx('gmv_WGS84_lat_dec',strip(put(phi,BEST32.)));          %* in decimal degrees;
      call symputx('gmv_WGS84_lon_dec',strip(put(labda,BEST32.)));
      call symputx('gmv_WGS84_height',strip(put(h,BEST32.)));
      call symputx('gmv_ITRS_lat_dec',strip(put(phi,BEST32.)));
      call symputx('gmv_ITRS_lon_dec',strip(put(labda,BEST32.)));
      call symputx('gmv_ITRS_height',strip(put(h,BEST32.)));
    end;
    else do;                                                               %* ETRS89 to WGS84;
      call symputx('gmv_ETRS89_lat_dec',strip(put(phi,BEST32.)));          %* in decimal degrees;
      call symputx('gmv_ETRS89_lon_dec',strip(put(labda,BEST32.)));
      call symputx('gmv_ETRS89_height',strip(put(h,BEST32.)));
    end;
    
    phi = phi * constant('pi')/180;                      %* in radian;
    labda = labda * constant('pi')/180;
    
    /*
    Conversion to geocentric cartesian coordinates. The ellipsoidal geographic coordinates must be converted to 
    geocentric Cartesian coordinates to be able to apply a 3D similarity transformation.
    */
    a_grs80 = input(symget('gmv_GRS80_a'),BEST32.);
    f_grs80 = input(symget('gmv_GRS80_f'),BEST32.);

    e_square_grs80 = f_grs80*(2-f_grs80);
    RN = a_grs80/sqrt(1 - (e_square_grs80 * (sin(phi)**2)));
 
    X = (RN + h) * cos(phi) * cos(labda);
    Y = (RN + h) * cos(phi) * sin(labda);
    Z = ((RN * (1 - e_square_grs80)) + h) * sin(phi);
    
    /* Rigorous 3D similarity transformation of geocentric Cartesian coordinates. */
    X1 = X;
    Y1 = Y;
    Z1 = Z;
    alpha = tr_way * input(symget('gmv_itrs_alpha'),BEST32.);
    beta  = tr_way * input(symget('gmv_itrs_beta'),BEST32.);
    gamma =  tr_way * input(symget('gmv_itrs_gamma'),BEST32.);
    delta =  tr_way * input(symget('gmv_itrs_delta'),BEST32.);
    tX = tr_way * input(symget('gmv_itrs_tX'),BEST32.);
    tY =  tr_way * input(symget('gmv_itrs_tY'),BEST32.);
    tZ =  tr_way * input(symget('gmv_itrs_tZ'),BEST32.);

    r_alpha = tr_way * input(symget('gmv_rate_alpha'),BEST32.);
    r_beta  = tr_way * input(symget('gmv_rate_beta'),BEST32.);
    r_gamma =  tr_way * input(symget('gmv_rate_gamma'),BEST32.);
    r_delta =  tr_way * input(symget('gmv_rate_delta'),BEST32.);
    r_tX = tr_way * input(symget('gmv_rate_tX'),BEST32.);
    r_tY =  tr_way * input(symget('gmv_rate_tY'),BEST32.);
    r_tZ =  tr_way * input(symget('gmv_rate_tZ'),BEST32.);
  
    %* Adjust the parameters based on current date and reference epoch;
    t_epoch = input(symget('gmv_itrs_ref_epoch'),BEST32.);
    /* 
    For the test point
    d = mdy(10, 1, 2020);
    t = year(d) + (d - mdy(1,1,year(d)))/365;
    */
    t = year(today()) + (today() - mdy(1,1,year(today())))/365;

    alpha = alpha + r_alpha * (t - t_epoch);
    beta = beta + r_beta * (t - t_epoch);
    gamma = gamma + r_gamma * (t - t_epoch);
    delta = delta + r_delta * (t - t_epoch);
    tX = tX + r_tX * (t - t_epoch);
    tY = tY + r_tY * (t - t_epoch);
    tZ = tZ + r_tZ * (t - t_epoch);
    
    s = 1 + delta;
    R11 = cos(gamma) * cos(beta);
    R12 = cos(gamma) * sin(beta) * sin(alpha)  + sin(gamma) * cos(alpha);
    R13 = -cos(gamma) * sin(beta) * cos(alpha) + sin(gamma) * sin(alpha);
    R21 = -sin(gamma) * cos(beta);
    R22 = -sin(gamma) * sin(beta) * sin(alpha) + cos(gamma) * cos(alpha);
    R23 = sin(gamma) * sin(beta) * cos(alpha) + cos(gamma) * sin(alpha);
    R31 = sin(beta);
    R32 = -cos(beta) * sin(alpha);
    R33 = cos(beta) * cos(alpha);

    X2 = s * (R11 * X1 + R12 * Y1 + R13 * Z1) + tX;
    Y2 = s * (R21 * X1 + R22 * Y1 + R23 * Z1) + tY;
    Z2 = s * (R31 * X1 + R32 * Y1 + R33 * Z1) + tZ;

    /* The geocentric Cartesian coordinates of the point of interest must be converted back to ellipsoidal geographic coordinates. */
    X = X2;
    Y = Y2;
    Z = Z2;
    epsilon = input(symget('gmv_epsilon_itrs_threshold'),BEST32.);
    
    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    phi1 is set at the top of this macro. You may also set phi1 = 0.
    */
    i = 0;                                         %* iterate counter. To check how many times you iterate;
    do until (abs(phi1-phi) lt epsilon);
      phi = phi1;                                  %* correct, it is an UNTIL loop, thus it is initialized in the loop;
      RN = a_grs80/sqrt(1 - (e_square_grs80 * sin(phi)**2));
      if X > 0 then phi1 = atan((Z + e_square_grs80*RN*sin(phi))/sqrt(X**2 + Y**2));
      else if round(X,0.000000000001) eq 0 and round(Y,0.000000000001) eq 0 and round(Z,0.000000000001) ge 0 then phi1 = constant('pi')/2;   %* +90 degrees;
           else phi1 = -1*constant('pi')/2;                                                                                                  %* -90 degrees;
      i + 1;
    end;
   
    %* The phi or lat value (phi1) has been calculated. Now calculate the labda or lon value;
    phi = phi1;
    if X gt 0 then labda = atan(Y/X);
    else if X lt 0 and Y ge 0 then labda = atan(Y/X) + constant('pi');  %* +180 degrees;
    else if X lt 0 and Y lt 0 then labda = atan(Y/X) - constant('pi');  %* -180 degrees;
    else if X eq 0 and Y gt 0 then labda = constant('pi')/2;            %*  +90 degrees;
    else if X eq 0 and Y lt 0 then labda = -1*constant('pi')/2;         %*  -90 degrees;
    else if X eq 0 and Y eq 0 then labda = 0;

    %* Rounding height to four decimals, and phi (lat) and labda (lon) to 9 decimals is sufficient accurate;
    etrs_h = round(sqrt(X**2 + Y**2) * cos(phi) + Z * sin(phi) - a_grs80 * sqrt(1 - e_square_grs80*(sin(phi)**2)),0.00000001);
    phi = round(phi * 180 /constant('pi'),0.000000000001);
    labda = round(labda * 180 /constant('pi'),0.000000000001);
    
    if tr_way eq 1 then do;                                                %* WGS84 to ETRS89;
      call symputx('gmv_ETRS89_lat_dec',strip(put(phi,BEST32.)));          %* in decimal degrees;
      call symputx('gmv_ETRS89_lon_dec',strip(put(labda,BEST32.)));
      call symputx('gmv_ETRS89_height',strip(put(etrs_h,BEST32.)));
    end;
    else do;                                                               %* ETRS89 to WGS84;
      call symputx('gmv_WGS84_lat_dec',strip(put(phi,BEST32.)));           %* in decimal degrees;
      call symputx('gmv_WGS84_lon_dec',strip(put(labda,BEST32.)));
      call symputx('gmv_WGS84_height',strip(put(etrs_h,BEST32.)));
      call symputx('gmv_ITRS_lat_dec',strip(put(phi,BEST32.)));
      call symputx('gmv_ITRS_lon_dec',strip(put(labda,BEST32.)));
      call symputx('gmv_ITRS_height',strip(put(etrs_h,BEST32.)));
    end;
  run;
%mend lm_WGS84_to_ETRS89_v1;

%*************************************************;
%* END  : ETRS89 to ITRS transformation Version 1 ;
%* BEGIN: ETRS89 to ITRS transformation Version 2 ;
%*************************************************;

%macro etrs_itrs_ini_v2(pItrf=ITRF2014 /* The ITRF realisation you use; ITRF2008 or ITRF2014 */);
  /* Initializes all ITRS transformation parameters and global macro variables. */
  %global gmv_D_dec;                     %* helper: degree in decimal notation;
  %global gmv_D_rad;                     %* helper: degree in radian;
 
  /* Two parameters for the conversion from ellipsoidal geographic coordinates to geocentric Cartesian coordinates */
  %global gmv_GRS80_a;        %* half major (equator) axis of GRS80 ellipsoid in meter;
  %global gmv_GRS80_f;        %* flattening of GRS80 ellipsoid (dimensionless);
  %let gmv_GRS80_a = 6378137;
  %let gmv_GRS80_f = %sysevalf(1/298.257222101);
  %put &=gmv_GRS80_a meter;
  %put &=gmv_GRS80_f;

  /* 
  Seven parameters and yearly rates for the 3D similarity transformation from ITRF2014 to ETRF2000. 
  For the other way around the signs must be inverted: multiply with -1
  */
  %global gmv_itrs_tX;       %* translation in direction of X axis meter: 𝑡𝑋 =+0.0547 m;
  %global gmv_itrs_tY;       %* translation in direction of Y axis meter: 𝑡𝑌 =+0.0522 m;
  %global gmv_itrs_tZ;       %* translation in direction of Z axis meter: 𝑡𝑍 =−0.0741 m;
  %global gmv_itrs_alpha;    %* rotation angle around X axis: 𝛼 =+0.00825∙10−6 rad=+0.001701″;
  %global gmv_itrs_beta;     %* rotation angle around Y axis: 𝛽 =+0.04989∙10−6 rad=+0.010290″;
  %global gmv_itrs_gamma;    %* rotation angle around Z axis: 𝛾 =−0.08063∙10−6 rad=−0.016632″;
  %global gmv_itrs_delta;    %* scale difference (dimensionless): 𝛿 =+0.00212∙10−6 ;

  %global gmv_rate_tX;       %* yearly rate of translation in direction of X axis: 𝑡̇𝑋 =+0.00010 m;
  %global gmv_rate_tY;       %* yearly rate of translation in direction of Y axis: 𝑡̇𝑌 =+0.00010 m;
  %global gmv_rate_tZ;       %* yearly rate of translation in direction of Z axis: 𝑡̇𝑍 =−0.00190 m;
  %global gmv_rate_alpha;    %* yearly rate of rotation angle around X axis: 𝛼̇ =+0.000393∙10−6 rad=+0.0000810″;
  %global gmv_rate_beta;     %* yearly rate of rotation angle around Y axis: 𝛽̇ =+0.002376∙10−6 rad=+0.0004900″;
  %global gmv_rate_gamma;    %* yearly rate of rotation angle around Z axis: 𝛾̇ =−0.003840∙10−6 rad=−0.0007920″;
  %global gmv_rate_delta;    %* yearly rate of scale difference (dimensionless): 𝛿̇ =+0.000110∙10−6;
  
  %* ITRF2014 parameters;
  %if %upcase(&pItrf) eq ITRF2014 %then %do;
    %let gmv_itrs_tX = %sysevalf(0.0547);
    %let gmv_itrs_tY = %sysevalf(0.0522);
    %let gmv_itrs_tZ = %sysevalf(-0.0741);
    %conv_dgr_dec_rad("0 0 -0.001701")
    %let gmv_itrs_alpha = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 -0.010290")
    %let gmv_itrs_beta = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 0.016632")
    %let gmv_itrs_gamma = &gmv_D_rad;
    %let gmv_itrs_delta = %sysevalf(0.00000000212);
  
    %let gmv_rate_tX = %sysevalf(0.00010);
    %let gmv_rate_tY = %sysevalf(0.00010);
    %let gmv_rate_tZ = %sysevalf(-0.00190);
    %conv_dgr_dec_rad("0 0 -0.0000810")
    %let gmv_rate_alpha = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 -0.0004900")
    %let gmv_rate_beta = &gmv_D_rad;
    %conv_dgr_dec_rad("0 0 0.0007920")
    %let gmv_rate_gamma = &gmv_D_rad;
    %let gmv_rate_delta = %sysevalf(0.000000000110);
  %end;
  %else %do;
    %* ITRF2008 parameters;
    %if %upcase(&pItrf) eq ITRF2008 %then %do;
      %let gmv_itrs_tX = %sysevalf(0.0531);
      %let gmv_itrs_tY = %sysevalf(0.0503);
      %let gmv_itrs_tZ = %sysevalf(-0.0765);
      %conv_dgr_dec_rad("0 0 -0.001701")
      %let gmv_itrs_alpha = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 -0.010290")
      %let gmv_itrs_beta = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 0.016632")
      %let gmv_itrs_gamma = &gmv_D_rad;
      %let gmv_itrs_delta = %sysevalf(0.00000000214);
    
      %let gmv_rate_tX = %sysevalf(0.00010);
      %let gmv_rate_tY = %sysevalf(0.00010);
      %let gmv_rate_tZ = %sysevalf(-0.00180);
      %conv_dgr_dec_rad("0 0 -0.0000810")
      %let gmv_rate_alpha = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 -0.0004900")
      %let gmv_rate_beta = &gmv_D_rad;
      %conv_dgr_dec_rad("0 0 0.0007920")
      %let gmv_rate_gamma = &gmv_D_rad;
      %let gmv_rate_delta = %sysevalf(0.000000000080);
    %end;
    %else %abort abend;
  %end;
  
  %global gmv_ITRF_realisation;
  %let gmv_ITRF_realisation = &pItrf;
  %put &=gmv_ITRF_realisation;
 
  %put &=gmv_itrs_tX meter;
  %put &=gmv_itrs_tY meter;
  %put &=gmv_itrs_tZ meter;
  %put &=gmv_itrs_alpha radian;
  %put &=gmv_itrs_beta radian;
  %put &=gmv_itrs_gamma radian;
  %put &=gmv_itrs_delta (dimensionless);
  
  %put &=gmv_rate_tX meter;
  %put &=gmv_rate_tY meter;
  %put &=gmv_rate_tZ meter;
  %put &=gmv_rate_alpha radian;
  %put &=gmv_rate_beta radian;
  %put &=gmv_rate_gamma radian;
  %put &=gmv_rate_delta (dimensionless);
  
  %global gmv_itrs_ref_epoch;   %* reference epoch (years);
  %let gmv_itrs_ref_epoch = 2010;
  %put &=gmv_itrs_ref_epoch (years);
  
  %global gmv_epsilon_itrs_threshold;         %* 𝜀 = precision threshold for termination of iteration, corresponding to 0.0001 m;
  %let gmv_epsilon_itrs_threshold = %sysevalf(0.00000000002);
  %put &=gmv_epsilon_itrs_threshold radian; 
%mend etrs_itrs_ini_v2;

%macro WGS84_to_ETRS89_v2(pDSin        /* The input data set. Must contain variables lat lon and h in decimal degrees */
                         ,pDSout       /* The output data set */
                         ,pSuppress=1  /* Suppress all intermediate columns in the output: 1=Yes, 0=No */);
  %lm_WGS84_to_ETRS89_v2(&pDSin, &pDSout, 1, &pSuppress)                            
%mend WGS84_to_ETRS89_v2;

%macro ETRS89_to_WGS84_v2(pDSin        /* The input data set. Must contain variables lat lon and h in decimal degrees */
                         ,pDSout       /* The output data set */
                         ,pSuppress=1  /* Suppress all intermediate columns in the output: 1=Yes, 0=No */); 
  %lm_WGS84_to_ETRS89_v2(&pDSin, &pDSout, -1, &pSuppress)                            
%mend ETRS89_to_WGS84_v2;

%macro lm_WGS84_to_ETRS89_v2(pDSin        /* The input data set. Must contain variables lat lon and h in decimal degrees */
                            ,pDSout       /* The output data set */
                            ,pDirection   /* The transformation direction, 1 (WGS84 to ETRS89) or -1 (ETRS89 to WGS84 */
                            ,pSuppress    /* Suppress all intermediate columns in the output: 1=Yes, 0=No */);
  /*
  Transform WGS84 to ETRS89 or ETRS89 to WGS84, depending the direction.
  Input | Output (1)      Output (-1)
  ------+----------------------------
   lat  | ETRS89_lat     WGS84_lat   
   lon  | ETRS89_lon     WGS84_lon
     h  | ETRS89_h       WGS84_h
  A height value is mandatory. Set to zero when there is no height.
  */
 
  %* Add the height column, if not specified;
  %if %sysfunc(findc(&pDSin,'.')) ne 0 %then %do;
    %let lmv_lib = %scan(&pDSin,1,'.');
    %let lmv_ds = %scan(&pDSin,2,'.');
  %end; 
  %else %do;
    %let lmv_lib = WORK;
    %let lmv_ds = &pDSin;
  %end;
  proc sql noprint;
    select count(*) into :lmv_height_missing from DICTIONARY.columns
    where libname eq %upcase("&lmv_lib") and memname eq %upcase("&lmv_ds") and upcase(name) eq 'H';
  quit;
  %if &lmv_height_missing eq 0 %then %do;
    proc sql;
      alter table &pDSin add h num format=BEST32.;        %* SAS does not support a default option;
      update &pDSin set h = 0;
    quit;  
  %end;
 
  data &pDSout;
    set &pDSin;
    format a_grs80 f_grs80 e_square_grs80 epsilon BEST32.;
    format phi phi1 labda h i BEST32.;
    format RN X Y Z BEST32.;

    format X1 Y1 Z1 BEST32.;
    format alpha beta gamma delta BEST32.;
    format tX tY tZ BEST32.;
    format r_alpha r_beta r_gamma r_delta BEST32.;
    format r_tX r_tY r_tZ BEST32.;
    format s BEST32.;
    format R11 R12 R13 R21 R22 R23 R31 R32 R33 BEST32.;
    format X2 Y2 Z2 BEST32.;
    format t_epoch t BEST32.;
    format tr_way 8.;
    format tr_lat tr_lon tr_h BEST32.;                          %* the transformation values, output, later on renamed;

    phi   = lat;     %* 𝜑 phi, in decimal degrees;
    labda = lon;     %* 𝜆 labda, in decimal degrees;
    tr_way = &pDirection;                                %* transformation directon or transformation way;
    phi1 = phi;                                          %* needed for the loop at the end of this macro;
        
    phi = phi * constant('pi')/180;                      %* in radian;
    labda = labda * constant('pi')/180;
    
    /*
    Conversion to geocentric cartesian coordinates. The ellipsoidal geographic coordinates must be converted to 
    geocentric Cartesian coordinates to be able to apply a 3D similarity transformation.
    */
    a_grs80 = input(symget('gmv_GRS80_a'),BEST32.);
    f_grs80 = input(symget('gmv_GRS80_f'),BEST32.);

    e_square_grs80 = f_grs80*(2-f_grs80);
    RN = a_grs80/sqrt(1 - (e_square_grs80 * (sin(phi)**2)));
 
    X = (RN + h) * cos(phi) * cos(labda);
    Y = (RN + h) * cos(phi) * sin(labda);
    Z = ((RN * (1 - e_square_grs80)) + h) * sin(phi);
    
    /* Rigorous 3D similarity transformation of geocentric Cartesian coordinates. */
    X1 = X;
    Y1 = Y;
    Z1 = Z;
    alpha = tr_way * input(symget('gmv_itrs_alpha'),BEST32.);
    beta  = tr_way * input(symget('gmv_itrs_beta'),BEST32.);
    gamma =  tr_way * input(symget('gmv_itrs_gamma'),BEST32.);
    delta =  tr_way * input(symget('gmv_itrs_delta'),BEST32.);
    tX = tr_way * input(symget('gmv_itrs_tX'),BEST32.);
    tY =  tr_way * input(symget('gmv_itrs_tY'),BEST32.);
    tZ =  tr_way * input(symget('gmv_itrs_tZ'),BEST32.);

    r_alpha = tr_way * input(symget('gmv_rate_alpha'),BEST32.);
    r_beta  = tr_way * input(symget('gmv_rate_beta'),BEST32.);
    r_gamma =  tr_way * input(symget('gmv_rate_gamma'),BEST32.);
    r_delta =  tr_way * input(symget('gmv_rate_delta'),BEST32.);
    r_tX = tr_way * input(symget('gmv_rate_tX'),BEST32.);
    r_tY =  tr_way * input(symget('gmv_rate_tY'),BEST32.);
    r_tZ =  tr_way * input(symget('gmv_rate_tZ'),BEST32.);
  
    %* Adjust the parameters based on current date and reference epoch;
    t_epoch = input(symget('gmv_itrs_ref_epoch'),BEST32.);
    /* 
    For the test point
    d = mdy(10, 1, 2020);
    t = year(d) + (d - mdy(1,1,year(d)))/365;
    */
    t = year(today()) + (today() - mdy(1,1,year(today())))/365;

    alpha = alpha + r_alpha * (t - t_epoch);
    beta = beta + r_beta * (t - t_epoch);
    gamma = gamma + r_gamma * (t - t_epoch);
    delta = delta + r_delta * (t - t_epoch);
    tX = tX + r_tX * (t - t_epoch);
    tY = tY + r_tY * (t - t_epoch);
    tZ = tZ + r_tZ * (t - t_epoch);
    
    s = 1 + delta;
    R11 = cos(gamma) * cos(beta);
    R12 = cos(gamma) * sin(beta) * sin(alpha)  + sin(gamma) * cos(alpha);
    R13 = -cos(gamma) * sin(beta) * cos(alpha) + sin(gamma) * sin(alpha);
    R21 = -sin(gamma) * cos(beta);
    R22 = -sin(gamma) * sin(beta) * sin(alpha) + cos(gamma) * cos(alpha);
    R23 = sin(gamma) * sin(beta) * cos(alpha) + cos(gamma) * sin(alpha);
    R31 = sin(beta);
    R32 = -cos(beta) * sin(alpha);
    R33 = cos(beta) * cos(alpha);

    X2 = s * (R11 * X1 + R12 * Y1 + R13 * Z1) + tX;
    Y2 = s * (R21 * X1 + R22 * Y1 + R23 * Z1) + tY;
    Z2 = s * (R31 * X1 + R32 * Y1 + R33 * Z1) + tZ;

    /* The geocentric Cartesian coordinates of the point of interest must be converted back to ellipsoidal geographic coordinates. */
    X = X2;
    Y = Y2;
    Z = Z2;
    epsilon = input(symget('gmv_epsilon_itrs_threshold'),BEST32.);
    
    /*
    Loop until you have reached the precision threshold. It is an UNTIL loop, thus you always enter the loop once.
    The check is done at the bottom. (In SAS syntax the check is listed at the top).
    phi1 is set at the top of this macro. You may also set phi1 = 0.
    */
    i = 0;                                         %* iterate counter. To check how many times you iterate;
    do until (abs(phi1-phi) lt epsilon);
      phi = phi1;                                  %* correct, it is an UNTIL loop, thus it is initialized in the loop;
      RN = a_grs80/sqrt(1 - (e_square_grs80 * sin(phi)**2));
      if X > 0 then phi1 = atan((Z + e_square_grs80*RN*sin(phi))/sqrt(X**2 + Y**2));
      else if round(X,0.000000000001) eq 0 and round(Y,0.000000000001) eq 0 and round(Z,0.000000000001) ge 0 then phi1 = constant('pi')/2;   %* +90 degrees;
           else phi1 = -1*constant('pi')/2;                                                                                                  %* -90 degrees;
      i + 1;
    end;
   
    %* The phi or lat value (phi1) has been calculated. Now calculate the labda or lon value;
    phi = phi1;
    if X gt 0 then labda = atan(Y/X);
    else if X lt 0 and Y ge 0 then labda = atan(Y/X) + constant('pi');  %* +180 degrees;
    else if X lt 0 and Y lt 0 then labda = atan(Y/X) - constant('pi');  %* -180 degrees;
    else if X eq 0 and Y gt 0 then labda = constant('pi')/2;            %*  +90 degrees;
    else if X eq 0 and Y lt 0 then labda = -1*constant('pi')/2;         %*  -90 degrees;
    else if X eq 0 and Y eq 0 then labda = 0;

    %* Rounding height to four decimals, and phi (lat) and labda (lon) to 9 decimals is sufficient accurate;
    tr_h = round(sqrt(X**2 + Y**2) * cos(phi) + Z * sin(phi) - a_grs80 * sqrt(1 - e_square_grs80*(sin(phi)**2)),0.00000001);
    tr_lat = round(phi * 180 /constant('pi'),0.000000000001);
    tr_lon = round(labda * 180 /constant('pi'),0.000000000001);
  run;
  
  %* Rename the transformation fields;
  %if %sysfunc(findc(&pDSout,'.')) ne 0 %then %do;
    %let lmv_lib = %scan(&pDSout,1,'.');
    %let lmv_ds = %scan(&pDSout,2,'.');
  %end;
  %else %do;
    %let lmv_lib = WORK;
    %let lmv_ds = &pDSout;
  %end;  
  proc datasets library=&lmv_lib nolist; 
    modify &lmv_ds;
    %if &pDirection eq 1 %then %do;
      rename tr_lat=ETRS89_lat tr_lon=ETRS89_lon tr_h=ETRS89_h;
    %end;
    %else %do;
      rename tr_lat=WGS84_lat tr_lon=WGS84_lon tr_h=WGS84_h;
    %end;
  quit;
  
  %* Keep only the transformation result. Suppress all others;
  %if &pSuppress eq 1 %then %do;
    %* Get the columns from the input dataset and then add the ETRS89 transformation values to it;
    proc sql noprint;
      select name into :lmv_DSin_columns separated by ' ' from DICTIONARY.columns
      where libname eq %upcase("&lmv_lib") and memname eq %upcase("&lmv_ds");
    quit;
    %if &pDirection eq 1 %then %let lmv_DSin_columns = &lmv_DSin_columns ETRS89_lat ETRS89_lon ETRS89_h;
    %else %let lmv_DSin_columns = &lmv_DSin_columns WGS84_lat WGS84_lon WGS84_h;
    %put &=lmv_DSin_columns;
    data &pDSout;
      set &pDSout;
      keep &lmv_DSin_columns;
    run;
  %end;
%mend lm_WGS84_to_ETRS89_v2;

%macro WGS84_pseudo_validatation_v2(pLib /* The library where CERTIFY_RDNAP_V2 is stored */);
  /*
  This pseudo validation takes dataset CERTIFY_RDNAP_V2 as input. There you have ETRS89 coordinates. They are transformed
  to WGS84 and then back to ETRS89. Then compared to CERTIFY_RDNAP_V2. The coordinates should be equal.
  No version one exists.
  */
  %etrs_itrs_ini_v2
  data tmp_data;
    set &pLib..CERTIFY_RDNAP_V2 (keep=point_id ETRS89_lat ETRS89_lon ETRS89_h);
    rename ETRS89_lat=lat ETRS89_lon=lon ETRS89_h=h;
  run;
  %ETRS89_to_WGS84_v2(tmp_data, ETRS89_to_WGS84_V2);

  data &pLib..ETRS89_to_WGS84_V2;
    set ETRS89_to_WGS84_V2 (keep=point_id lat lon h WGS84_lat WGS84_lon WGS84_h);
    format dlat dlon dh BEST32.;
    dlat = abs(lat - WGS84_lat);
    dlon = abs(lon - WGS84_lon);
    dh = abs(h - WGS84_height);;
    if dlat lt 0.00005 then lat_conv_ok = 1;
      else lat_conv_ok = 0;
    if dlon lt 0.00005 then lon_conv_ok = 1;
      else lon_conv_ok = 0;
    if lat_conv_ok eq 1 and lon_conv_ok eq 1 then lat_lon_conv_ok = 1;
      else lat_lon_conv_ok = 0;
    if WGS84_h eq -999999 then h_conv_ok = 1;
    else if dh lt 0.05 then h_conv_ok = 1;
         else h_conv_ok = 0;
  run;

  proc sql;
    title1 '10000 points are transformed from ETRS89 to WGS84.';
    title2 'lat and lon accuracy is 0.00005 degree, h accuracy is 0.05 meters';
    select max(dlat) as max_dlat, max(dlon) as max_dlon,
    (select max(dh) from &pLib..ETRS89_to_WGS84_V2 where WGS84_height ne -999999) as max_dh,
    (select sum(lat_conv_ok) from &pLib..ETRS89_to_WGS84_V2) as dlat,
    (select sum(lon_conv_ok) from &pLib..ETRS89_to_WGS84_V2) as dlon,
    (select sum(lat_lon_conv_ok) from &pLib..ETRS89_to_WGS84_V2) as dlatdlon,
    (select sum(h_conv_ok) from &pLib..ETRS89_to_WGS84_V2) as dh
    from &pLib..ETRS89_to_WGS84_V2;
    title;
  quit;
 
  data tmp_data;
    set &pLib..ETRS89_to_WGS84_V2 (keep=point_id WGS84_lat WGS84_lon WGS84_h);
    rename WGS84_lat=lat WGS84_lon=lon WGS84_h=h;
  run;
  %WGS84_to_ETRS89_v2(tmp_data, WSG84_to_ETRS89_V2)
  
  data &pLib..WSG84_to_ETRS89_V2;
    set WSG84_to_ETRS89_V2 (keep=point_id lat lon h ETRS89_lat ETRS89_lon ETRS89_h);
    format dlat dlon dh BEST32.;
    dlat = abs(lat - ETRS89_lat);
    dlon = abs(lon - ETRS89_lon);
    dh = abs(h - ETRS89_height);;
    if dlat lt 0.00005 then lat_conv_ok = 1;
      else lat_conv_ok = 0;
    if dlon lt 0.00005 then lon_conv_ok = 1;
      else lon_conv_ok = 0;
    if lat_conv_ok eq 1 and lon_conv_ok eq 1 then lat_lon_conv_ok = 1;
      else lat_lon_conv_ok = 0;
    if ETRS89_h eq -999999 then h_conv_ok = 1;
    else if dh lt 0.05 then h_conv_ok = 1;
         else h_conv_ok = 0;
  run;

  proc sql;
    title1 '10000 points are transformed from WGS84 to ETRS89.';
    title2 'lat and lon accuracy is 0.00005 degree, h accuracy is 0.05 meters';
    select max(dlat) as max_dlat, max(dlon) as max_dlon,
    (select max(dh) from &pLib..WSG84_to_ETRS89_V2 where ETRS89_height ne -999999) as max_dh,
    (select sum(lat_conv_ok) from &pLib..WSG84_to_ETRS89_V2) as dlat,
    (select sum(lon_conv_ok) from &pLib..WSG84_to_ETRS89_V2) as dlon,
    (select sum(lat_lon_conv_ok) from &pLib..WSG84_to_ETRS89_V2) as dlatdlon,
    (select sum(h_conv_ok) from &pLib..WSG84_to_ETRS89_V2) as dh
    from &pLib..WSG84_to_ETRS89_V2;
    title;
  quit;

  proc sql;
    title1 '10000 points are transformed from ETRS89 to WGS84 and back to ETRS89.';
    title2 'The starting ETRS89 coordinates are compared with the transformed ETRS89 coordinates.';
    title3 'The accuracy for the lat and lon is 0.00000000001 and for the h 0.0000001';
    title4 'You should not get any report output below here. Then all ok.';
    select round(abs(T1.ETRS89_lat - T2.ETRS89_lat),0.00000000001) as dlat
          ,round(abs(T1.ETRS89_lon - T2.ETRS89_lon),0.00000000001) as dlon
          ,round(abs(T1.ETRS89_h - T2.ETRS89_height),0.0000001) as dh
          ,T1.ETRS89_lat as a, T2.ETRS89_lat as b
    from  &pLib..CERTIFY_RDNAP_V2 as T1,
          &pLib..WSG84_to_ETRS89_V2 as T2
    where T1.point_id = T2.point_id
      and calculated dlat ne 0
      and calculated dlon ne 0
      and calculated dh ne 0;
    title;
  quit;
%mend WGS84_pseudo_validatation_v2;

%**************************************************;
%* END  : ETRS89 to ITRS transformation Version 2  ;
%* BEGIN: Miscellaneous macros                     ;
%**************************************************;

%macro display_self_validation_results(pLib /* The library were the datasets are stored */);
  /* No check is done if the datasets exists */
  proc sql;
    title1 '10000 pointer are transformed. This is what you should get:';
    title2 '   max_dx    max_dy    max_dz     dx     dy    dxdy   dz';
    title3 ' 0.000338  0.000757  0.000051  10000  10000  10000  10000';
    select max(dx) as max_dx, max(dy) as max_dy, max(dz) as max_dz,
    (select sum(conv_x_ok) from &pLib..SELF_ETRS89_V1) as dx,
    (select sum(conv_y_ok) from &pLib..SELF_ETRS89_V1) as dy,
    (select sum(conv_x_y_ok) from &pLib..SELF_ETRS89_V1) as dxdy,
    (select sum(conv_z_ok) from &pLib..SELF_ETRS89_V1) as dz
    from &pLib..SELF_ETRS89_V1;
    title;
  quit;

  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 'max_dlat  max_dlon   max_dh   dlat  dlon  dlatdlon   dh'; 
    title3 '3.534E-8  4.247E-8  0.000051  9774  9857    9761    10000';
    select max(dlat) as max_dlat, max(dlon) as max_dlon,
    (select max(dh) from &pLib..SELF_RDNAP_V1 where conv_h_ok eq 1 and not(z = -999999 and hc = -999999 )) as max_dh,
    (select sum(conv_lat_ok) from &pLib..SELF_RDNAP_V1) as dlat,
    (select sum(conv_lon_ok) from &pLib..SELF_RDNAP_V1) as dlon,
    (select sum(conv_lat_lon_ok) from &pLib..SELF_RDNAP_V1) as dlatdlon,
    (select sum(conv_h_ok) from &pLib..SELF_RDNAP_V1) as dh
    from &pLib..SELF_RDNAP_V1;
    title;
  quit;
  
  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 '   max_dx    max_dy    max_dz     dx     dy    dxdy   dz';
    title3 ' 0.000338  0.000757  0.000051  10000  10000  10000  10000';
    select max(dx) as max_dx, max(dy) as max_dy, max(dz) as max_dh,
    (select sum(conv_x_ok) from &pLib..SELF_ETRS89_V2) as dx,
    (select sum(conv_y_ok) from &pLib..SELF_ETRS89_V2) as dy,
    (select sum(conv_x_y_ok) from &pLib..SELF_ETRS89_V2) as dxdy,
    (select sum(conv_z_ok) from &pLib..SELF_ETRS89_V2) as dz
    from &pLib..SELF_ETRS89_V2;
    title;
  quit;
  
  proc sql;
    title1 '10000 points are transformed. This is what you should get:';
    title2 'max_dlat  max_dlon   max_dh   dlat  dlon  dlatdlon   dh';
    title3 '3.534E-8  4.247E-8  0.000051  9774  9857    9761    10000';
    select max(dlat) as max_dlat, max(dlon) as max_dlon,
    (select max(dh) from &pLib..SELF_RDNAP_V2 where h_conv_ok eq 1 and ETRS89_h ne -999999) as max_dh,
    (select sum(lat_conv_ok) from &pLib..SELF_RDNAP_V2) as dlat,
    (select sum(lon_conv_ok) from &pLib..SELF_RDNAP_V2) as dlon,
    (select sum(lat_lon_conv_ok) from &pLib..SELF_RDNAP_V2) as dlatdlon,
    (select sum(h_conv_ok) from &pLib..SELF_RDNAP_V2) as dh
    from &pLib..SELF_RDNAP_V2;
    title;
  quit;
 %mend display_self_validation_results;

%****************************;
%* END: Miscellaneous macros ;
%****************************;