Files in the enclosed ZIP folders are source code for required MEX functions for ClusDoC.  

Win64 compiled versions are included in the repository.  For other architectures these files need to be re-compiled.

In kdtree2_mex, final file will be kddtree2rnearest.mexXXX.  Others are not required.

In optics_dbscan_mex_src, compiled file will be pdsdbscan.mexXXX.  This will need to be renamed to t_dbscan.mexXXX.  

Copy both built MEX files into the .\private\ folder of the ClusDoC repo so they can be called by the ClusDoC functions.