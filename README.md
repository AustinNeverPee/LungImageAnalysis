# LungImageAnalysis
A project that analyzes CT images to find if a patient has lung cancer.
Lung image analysis is a medical image processing project. It detects lung cancer from the analysis of computed tomography (CT) images of chest. Four main steps are shown below:

### Lung Region Segmentation
It contains a series of image processing techniques, that is, Bit-Plane Slicing, Erosion, Median Filter, Dilation, Outlining, Lung Border Extraction and Flood-Fill algorithms. 

### Nodule Candidates Segmentation
Clustering Algorithm is used here. Nodule candidates can be gotten after this step.

### Nodule Features Extraction
Three different kinds of features are extracted from each nodule candidate. 

### Model Training & Testing
Neural network is used in this step.
