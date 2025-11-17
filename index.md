# Study-Specific Quality, Utility, and Breadth Assessment (squba)

Dive into data quality with `squba`!

This suite of R packages will allow you to investigate multiple facets
of data quality and customize analyses based on your study-specific
needs. Each module will allow you to conduct up to 8 different analyses
in either the OMOP or PCORnet CDM, all aimed at taking a different view
of the data while still addressing the same data quality probe. To learn
more about the theory behind `squba`, see our manuscript (coming soon)!

This package will download all currently available modules, of which
there are **11** (as of 11/2025). The “Modules” dropdown contains the
list of each module and links out to the module-specific documentation.
You can also see more granular descriptions of each module and check
type on [PEDSpace](https://hdl.handle.net/20.500.14642/2), our metadata
repository.

## Installation

Install the development version of the package:

``` r
devtools::install_github('ssdqa/squba')
```

If you would like to install individual modules, navigate to the
appropriate repository for installation instructions.

## Available Modules

- Cohort Fitness
  - [Patient Facts](https://github.com/ssdqa/patientfacts): Assesses the
    availability of patient clinical data per year of follow-up as a
    factor of visit type
  - [Patient Event
    Sequencing](https://github.com/ssdqa/patienteventsequencing):
    Evaluates the plausibility of the temporal relationship between two
    clinical events
  - [Patient Record
    Consistency](https://github.com/ssdqa/patientrecordconsistency):
    Checks for consistency within a patient’s clinical record to ensure
    the information is confirmatory and complete
- Variable Testing
  - [Expected Variables
    Present](https://ssdqa.github.io/expectedvariablespresent):
    Evaluates the presence and distribution of study variables at the
    patient & row levels
  - [Quantitative Variable
    Distribution](https://github.com/ssdqa/quantvariabledistribution):
    Summarizes the distribution of quantitative study variables (ex: lab
    test results)
  - [Categorical Variable
    Distribution](https://github.com/ssdqa/categoricalvariabledistribution):
    Summarizes the distribution of categorical study variables, based on
    what is present in the data (ex: drug dosage units)
- Concept-Set Testing
  - [Concept Set
    Distribution](https://ssdqa.github.io/conceptsetdistribution):
    Computes the distribution of concepts that make up a given study
    variable
  - [Source and Concept
    Vocabularies](https://github.com/ssdqa/sourceconceptvocabularies):
    Identifies and summarizes concept mappings for source-to-concept or
    concept-to-source relationships
- Dataset Fitness
  - [Clinical Events &
    Specialties](https://ssdqa.github.io/clinicalevents.specialties):
    Assesses the concordance between a clinical event and the associated
    specialtist providers or care sites
- Cohort Identification
  - [Cohort Attrition](https://ssdqa.github.io/cohortattrition): Examine
    each step of a study’s attrition criteria to identify potential
    irregularities in cohort construction
  - [Sensitivity to Selection
    Criteria](https://ssdqa.github.io/sensitivityselectioncriteria):
    Compare demographics, utilization patterns, and clinical fact makeup
    of a base cohort definition to alternate cohort definitions
