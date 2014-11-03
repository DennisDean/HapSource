#HapSource

HAP's motivating idea is to use a context free language description of pulsatile data to derive a data parser. The data parser implictly converts the times series to a graph. The graph representation motivates the analysis and is represented as a text string, which we define as a pulsicon. A description of the implementation follows. More details regarding the underlying theory can be found in my thesis.

Dean II, DA, (2011) [*Integrating Formal Language Theory with Mathematical Modeling to Solve Computational issues in Sleep and Circadian Applications*](http://dl.acm.org/citation.cfm?id=2231315), Doctoral Dissertation, Intercampus Biomedical Engineering and Biotechnology Program, University of Massachusetts

More details regarding the implementation can be found in the supplementary materials of the following article.

Dean II, DA, Adler, GK, Nguyen, DP, Klerman, EB, [Biological Time Series Analysis Using a Context Free Language: Applicability to Pulsatile Hormone Data](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0104087), PLoS One, 2014

##HAP_Analysis Program
Overview. The HAP_Analysis Program is a tool developed to apply HAP analysis to a data set stored in a MATLAB structure. The graphical user interface includes sections for selecting data, for performing HAP analysis, and for application functions. The user can:
*	Select a database of signals that are stored as a structure in a MATLAB binary file (See below for additional detail)
*	Load the database to memory and display the signals
*	Select a signal for analysis. This signal can be viewed for verification
*	Perform HAP analysis on the selected signal or all the signals in the database; a single mouse click is required to start the analysis 


##Implementation of Hierarchical AdaPtive Analysis (HAP)

###Program Analysis Pipeline
The HAP_Analysis Program Pipeline is composed of five steps: 
* Visual Verification
* Feature Distribution Generation
* Feature-Feature Scatter Plot Generation
* HAP Summary Plot Generation
* Pulsicon Generation. 

In addition, the HAP Analysis Pipeline is designed to provide intermediate results and to reduce the amount of time to analyze HAP output. Each of these steps is briefly described below, and example figures generated at each step are shown in Figure S3).

*Visual Verification.* The program first displays the input data. The peaks and nadirs identified at each recursive step of the algorithm are shown in a second plot, resulting in an animation of the algorithm. These figures are provided for the user to verify input and that the algorithm is working accordingly. Animation for a 24-hour cortisol profile is posted on YouTube (http://youtu.be/ggJDK7alI2M).

*Feature Distribution Generation.* Histograms of the features (e.g. rise time, rise amplitude, and accumulation) extracted at each recursion levels are created. The figures are included to provide the user with intermediate analysis results.

*Feature-Feature Scatter Plot Generation.* Scatter plots of extracted features are provided to allow the user to quickly identify potential relationships in the extracted features. Scatter plots are generated for both raw features (e.g. rise time) and computed features (e.g. accumulation).

*HAP Summary Plot Generation.* HAP summary plots are provided as a way to compactly review the HAP analysis results. Accumulation, dissipation, and inter-nadir intervals versus recursion number are plotted separately. An accumulation versus dissipation plot is also generated.

*Pulsicon Generation.* A Pulsicon is a text representation of the analyzed time series. Pulsicons are generated at each analysis iteration.  Note that both a text and a LaTex version of the pulsicon are created. The text version is used for console displays, and the LatTex version is used for figure generation.

###Requirements and Installation. 
The program is provided as Microsoft Windows executable and is installed from an installation package. The program requires the MATLAB Compiler Runtime (MCR) which enables machines to execute MATLAB code without having MATALAB stored on the machine. The MCR is included in the installation package. The MCR does not need to be installed if MATALB and the MATLAB compiler are stored on the machine. The windows executable was generated with MATALB version 2013a.

##Acknowledgements
HAP uses the following publically available functions: [tilefigs](http://www.mathworks.com/matlabcentral/fileexchange/38581-tilefigs), [Latex Figure Output](http://www.mathworks.com/ matlabcentral/fileexchange/12607-figure-management-utilities) and the [scattermatrx](www.datatool.com) 
