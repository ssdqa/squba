# Study Specific Data Quality Analysis (ssdqa)

Welcome to the SSDQA ecosystem! This package will download all currently available modules, of which there are **9** (as of 11/2024).

Install the development version of the package:

``` r
devtools::install_github('ssdqa/ssdqa')
```


If you would like to install individual modules, navigate to the appropriate repository for installation instructions.

## Available Modules
- Cohort Fitness
  - [Patient Facts](https://github.com/ssdqa/patientfacts): Assesses the availability of patient clinical data per year of follow-up as a factor of visit type
  - [Patient Event Sequencing](https://github.com/ssdqa/patienteventsequencing): Evaluates the plausibility of the temporal relationship between two clinical events
  - [Patient Record Consistency](https://github.com/ssdqa/patientrecordconsistency): Checks for consistency within a patient's clinical record to ensure the information is confirmatory and complete
- Variable Testing
  - [Expected Variables Present](https://github.com/ssdqa/expectedvariablespresent): Evaluates the presence and distribution of study variables
- Concept-Set Testing
  - [Concept Set Distribution](https://github.com/ssdqa/conceptsetdistribution): Computes the distribution of concepts that make up a given study variable
  - [Source and Concept Vocabularies](https://github.com/ssdqa/sourceconceptvocabularies): Identifies and summarizes concept mappings for source-to-concept or concept-to-source relationships
- Dataset Fitness
  - [Clinical Events & Specialties](https://github.com/ssdqa/clinicalevents.specialties): Assesses the concordance between a clinical event and the associated specialtist providers or care sites
- Cohort Identification
  - [Cohort Attrition](https://github.com/ssdqa/cohortattrition): Examine each step of a study's attrition criteria to identify potential irregularities in cohort construction
  - [Sensitivity to Selection Criteria](https://github.com/ssdqa/sensitivityselectioncriteria): Compare demographics, utilization patterns, and clinical fact makeup of a base cohort definition to alternate cohort definitions 
