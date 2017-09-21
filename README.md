# ClusDoC package for co-clustering analysis for single molecule localization microscopy (SMLM) data

This software was used for the following publications:
SV Pageon, PR Nicovich, M Mollazade, T Tabarin, K Gaus. "Clus-DoC: a combined cluster detection and colocalization analysis for single-molecule localization microscopy data" <it>Molecular Biology of the Cell</it> 27 (22), 3627-3636. 

Pageon, Sophie V., et al. "Functional role of T-cell receptor nanoclusters in signal initiation and antigen discrimination." <it>Proceedings of the National Academy of Sciences</it> (2016): 201607436.

# Requirements

- MATLAB 2014b or later
- Distributed computing, Image Processing, and statistical analyses toolboxes

Compiled dependent MEX functions for 64 bit PC are included in the repository.  Source files are included in the .\private\mexSource folder.  You will need to compile these functions and replace those in the .\private\ folder to run on architectures other than 64 bit Windows.  

# Quick start
- Clone all files into the desired folder, either by downloading package link or through git clone https://github.com/PRNicovich/ClusDoC.git.

- Navigate to local cloned repository in MATLAB file path

- Execute by calling 'ClusDoC' at command prompt.

- Once GUI window opens, click on 'Select Input File(s)' button.  In subsequent pop-up, select file .\Test dataset\1.txt.  File .\Test dataset\coordinates.txt should also load.

- Select output folder by clicking 'Set Output Path' button.  The default choice of .\Test dataset\ is sufficient.

- Proceed with choosing ROIs or downstream analysis. 
