# Introduction to squba

`squba` is a suite of data quality modules, built entirely in R, that
are designed to evaluate different data quality domains throughout the
process of an observational study. They are compatible with both the
OMOP and PCORnet Common Data Models (CDM) and can help investigators to
dive into anything from the patient retention in their attrition, to the
utility of their concept sets, to the fact density within their study
cohort.

Each module, among things specific to the execution of that particular
data quality probe, has certain inputs and parameters that are standard
across the entire suite. This guide will walk through what each of these
inputs are and what role they play in your data quality analysis.

## Analysis-Specific Inputs

### The Cohort

Each module will require you to provide a table containing the
foundation of your study analysis: your cohort! This table must have, at
a minimum, the following four columns:

##### Site

The `site` column is originally intended for network-level analyses
where data from multiple institutions is available. But really, it’s
just the primary grouping variable that will be used in the multi-site
analysis type. You can input the names of different data sources so you
can compare how patients at these institutions behave, or you can input
a different patient characteristic, like sex or a more study-specific
flag, to compare those groups to one another.

##### Patient Identifier

This column will contain all of the unique patient identifiers used to
classify members of your cohort. If you are using the OMOP data model,
this will be the `person_id` column. If you are using PCORnet, this will
be the `patid` column.

##### Start Date

The `start_date` column should indicate the earliest date for which data
can be extracted for that patient. This will most likely be the cohort
entry date.

Note that for longitudinal analyses, patients will only be included in
the time period of interest after their start date has passed. So if a
patient’s start date is 1/1/2010, they will not be treated as a member
of the cohort when looking at the year of 2009 or the month of December
2009, even if they have data available in that period. They will only be
treated as a full member of the cohort starting in the year of 2010 or
the month of January 2010.

##### End Date

The `end_date` column should indicate the latest date for which data can
be extracted for that patient. This may be the end of the follow-up
period or the date of another event that indicates an exit from the
cohort.

Note that for longitudinal analyses, patients will only be included in
the time period of interest before their end date has passed. So if a
patient’s end date is 1/1/2020, they will not be treated as a member of
the cohort when looking at the year of 2021 or the month of February
2020, even if they have data available in that period. They will only be
treated as a full member of the cohort up to and including the year of
2020 or the month of January 2020.

------------------------------------------------------------------------

Providing all this information will give the module three essential
pieces of information:

- Which patients in your dataset should be included in the data quality
  analysis
- How many sites are present among these patients
- What is the cohort period of interest for which data should be
  extracted

### The Definition Table

Each module will ask that you provide a table that defines the targets
for your data quality analysis. While the specific contents of this
table differ between modules, generally it will ask you to provide
information about:

- the CDM table where the domain or variable is defined and any
  additional filtering logic that should be applied to this table
- the column containing concepts or codes that are used to define your
  analysis target
- the date column that should be used for any temporal filtering
- the name of the concept set, found in a pre-defined directory, that is
  used to define a variable

For more details about what is required, please see the documentation
for the specific module you would like to use.

### Concept Sets

`squba` modules expect concept sets, which contain sets of codes to
define a single clinical concept or variable, to be in a specific format
to ensure these files can be referenced in a standard way across the
suite. They must contain the following two columns:

- `concept_id`, which contains the OMOP-specific reference value for a
  given clinical code. For PCORnet implementations, this column should
  still be included but can be left blank or filled with a random
  integer.
- `concept_code`, which contains the actual clinical code, like a LOINC
  or ICD10 code. For OMOP implementations, this column should still be
  included but can be left blank or filled with a random character.

For PCORnet implementations, a `vocabulary_id` column may also be
required. For some domains in this data model, like in the diagnosis
table, there is a field that defines the ontology to which a code
belongs in order to help differentiate between similar vocabularies
(like ICD9 and ICD10). The `vocabulary_id` field should contain the
vocabulary identifier as it appears in the CDM, which will then be
included as a parameter in the join between the concept set and the CDM.

Other information, such as a `concept_name` with the full description of
the concept, can be included in this file but is not required.

**Note:** Any concept set used as input to `squba` should be stored as a
CSV file in a pre-defined file subdirectory in your project (see
[Connecting to your
Data](https://ssdqa.github.io/squba/articles/database_connection.html)
for more details).

## Module Parameters

Most modules, with exceptions for modules like Cohort Attrition that
cannot be assessed longitudinally, will contain `multi_or_single_site`,
`anomaly_or_exploratory`, and `time` as function parameters. The
sections below will explain what each of these parameters means and why
you may want to select one option versus the other.

### Single versus Multi-Site Analyses

This parameter essentially controls whether you want to utilize the
`site` column in your cohort table as a grouping variable. But beyond
that, it also will control whether you are comparing the behavior of the
targets of your analysis (variables, codes, etc.) versus comparing the
behavior of the different sites in your cohort. For example, in the
[Expected Variables
Present](https://ssdqa.github.io/expectedvariablespresent/) module,
toggling this parameter will control whether you see a bar graph
highlighting that your cohort has more hypertension diagnoses than
diabetes diagnoses or whether you see a heat map demonstrating that one
institution has more hypertension diagnoses than another.

If you only have one site in your cohort file, only single site analysis
are possible so you can “set and forget” this parameter. If you have
multiple sites, however, both the single and multi-site analyses are
available to you. A single site analysis when multiple sites are present
in the cohort file will essentially ignore the `site` column and treat
the whole cohort as one big group. If you really only want to target one
site in isolation, you should be sure to filter your cohort before
executing the single site analysis.

### Exploratory versus Anomaly Detection Analyses

This parameter controls the type of computation that will be executed
for the analysis. Exploratory checks extract high level summary
information, like counts and proportions, and make them available to you
so you can get a general picture of what the data looks like. Anomaly
detection checks will take this information and execute a more formal
statistical computation to identify outliers within the result set. In
the [Concept Set
Distribution](https://ssdqa.github.io/conceptsetdistribution/) module,
an exploratory analysis may demonstrate that a few codes stand out as
the most frequently used when defining a variable, but an anomaly
detection analysis may reveal that only one of them is anomalous
compared to the rest of the codes in the concept set.

The Single Site, Anomaly Detection, Cross-Sectional checks tend to apply
different methods of identifying anomalies across all the modules.
However, most of the other anomaly detection methods, described in the
table below, are very similar across the suite.

[TABLE]

### Cross-Sectional versus Longitudinal Analyses

This parameter controls whether you look at a static snapshot of the
data versus a longitudinal time series. It can be beneficial to look at
certain things across time to identify any temporal trends in how the
data behaves. These could be expected, like seeing impacts of the switch
from ICD9 to ICD10, or unexpected, like seeing a sudden spike in the
prescription of a drug from one year to the next.

In the [Clinical Events &
Specialties](https://ssdqa.github.io/clinicalevents.specialties/)
module, toggling this parameter would mean the difference between seeing
that patients in your cohort are primarily seen by Cardiologists and
identifying that this trend is driven by an uptick in Cardiologist
visits starting in 2017.

Two modules, [Cohort
Attrition](https://ssdqa.github.io/cohortattrition/) and [Sensitivity to
Selection
Criteria](https://ssdqa.github.io/sensitivityselectioncriteria/), do not
have longitudinal analyses available since they are focused on the
cohort and its characteristics rather than the behavior of data across
the cohort period.
