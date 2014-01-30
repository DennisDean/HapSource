#HapSource

##HAP_Analysis Program
Overview. The HAP_Analysis Program is a tool developed to apply HAP analysis to a data set stored in a MATLAB structure. The graphical user interface includes sections for selecting data, for performing HAP analysis, and for application functions. The user can:
•	Select a database of signals that are stored as a structure in a MATLAB binary file (See below for additional detail)
•	Load the database to memory and display the signals
•	Select a signal for analysis. This signal can be viewed for verification
•	Perform HAP analysis on the selected signal or all the signals in the database; a single mouse click is required to start the analysis 
Results and figures are generated automatically. Results are displayed in the console window as they are generated and figures are written to disk automatically. Functions for tiling and closing all windows are provided. A screen shot of the HAP_Analysis program with generated figures is shown in Figure S3 and is further described below. A demonstration of the program in use is available on YouTube (http://youtu.be/ggJDK7alI2M). Here, the analysis pipeline, output, and program requirements will be described. Several publically available routines are used in the program, and they are acknowledged below. The program can be downloaded from https://sleep.med.harvard.edu/ research/faculty-research/tools/HAP.


##Implementation of Hierarchical AdaPtive Analysis (HAP)

#Program Analysis Pipeline
The HAP_Analysis Program Pipeline is composed of five steps: 
1. Visual Verification
2. Feature Distribution Generation
3. Feature-Feature Scatter Plot Generation
4. HAP Summary Plot Generation
5. Pulsicon Generation. 

In addition, the HAP Analysis Pipeline is designed to provide intermediate results and to reduce the amount of time to analyze HAP output. Each of these steps is briefly described below, and example figures generated at each step are shown in Figure S3).
Visual Verification. The program first displays the input data. The peaks and nadirs identified at each recursive step of the algorithm are shown in a second plot, resulting in an animation of the algorithm. These figures are provided for the user to verify input and that the algorithm is working accordingly. Animation for a 24-hour cortisol profile is posted on YouTube (http://youtu.be/ggJDK7alI2M).
Feature Distribution Generation. Histograms of the features (e.g. rise time, rise amplitude, and accumulation) extracted at each recursion levels are created. The figures are included to provide the user with intermediate analysis results.
Feature-Feature Scatter Plot Generation. Scatter plots of extracted features are provided to allow the user to quickly identify potential relationships in the extracted features. Scatter plots are generated for both raw features (e.g. rise time) and computed features (e.g. accumulation).
HAP Summary Plot Generation. HAP summary plots are provided as a way to compactly review the HAP analysis results. Accumulation, dissipation, and inter-nadir intervals versus recursion number are plotted separately. An accumulation versus dissipation plot is also generated.
Pulsicon Generation. Pulsicons are generated at each analysis iteration.  Note that both a text and a LaTex version of the pulsicon are created. The text version is used for console displays, and the LatTex version is used for figure generation.
In order to further clarify the output generated during the pipeline analysis, a complete summary of figures generated for a single 24 hour cortisol profile is provided in Table S2. In addition, a video illustrating the generation of these figures is available on YouTube (http://www.youtube.com/watch?v=ggJDK7alI2M).
Requirements and Installation. The program is provided as Microsoft Windows executable and is installed from an installation package. The program requires the MATLAB Compiler Runtime (MCR) which enables machines to execute MATLAB code without having MATALAB stored on the machine. The MCR is included in the installation package. The MCR does not need to be installed if MATALB and the MATLAB compiler are stored on the machine. The windows executable was generated with MATALB version 7.14 and MATLAB complier version 4.17.
