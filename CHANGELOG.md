# Change Log

## [v0.4.0] - 2026-05-15

### Document-level / Architecture

Closes #65 - "Climate Data Management Systems for quality control, homogenization, and archival" replaced with "quality control and long-term climate data management" in clause 1 and c4_level_0 diagram.

Climate Scientist persona description in c4_level_1 updated to include derived climate products.

### Clause 1 (Scope)

"minimal" corrected to "minimum" in the purpose statement. Clarifying NOTE added on the intended breadth of "Earth system domains."

### Clause 6 - Class 1 (Core)

Homogenisation provenance bullet in /req/core/provenance-storage expanded to capture: break points detected with dates and statistical confidence levels, adjustment factors per segment, reference series used, statistical significance, correspondence with known station changes, and retention of both original and adjusted series (incorporating the documentation and data management obligations from the dissolved Homogenisation class).

### Clause 6 - Class 2 (Quality Control)

"automated checks" replaced with "quality checks" in the overview; WMO-No. 1238 justification paraphrased. Blair Trewin note added on check applicability by variable and observation frequency. WMO gross error limits referenced. NOTE added distinguishing CDMS QC from real-time DCPS QC. Island/remote station NOTE added to spatial consistency checks.

New standalone requirement /req/quality-control/observation-retention added as the first requirement in the class, expressing the retention obligation positively: all observations SHALL be retained regardless of quality flag status.

/req/quality-control/execution added to cover QC triggering (automatic on ingestion, on-demand, scheduled/batch).

### Clause 6 - Class 3 (Data Ingestion)

Overview NOTE added clarifying scope (automated streams and manual upload; manual key-entry addressed in data rescue) and dual-purpose CDMS deployments. AWS example added to scheduled polling. Graceful handling of unavailable sources clarified. Drag-and-drop upload downgraded to recommended. DAYCLI moved to monthly BUFR report types. FTP security context added. Granular rejection restructured: file-level rejection is a SHALL minimum, record-level and element-level rejection addressed in a new recommendation block (/rec/data-ingestion/validation). Plausibility check failures stored with quality flags rather than silently discarded. "Data Normalisation" renamed to "Data Standardisation". Duplicate resolution rule documentation made a normative requirement.

SHOULD statements (element-level rejection, plausibility flag storage) moved out of the requirement block into a proper recommendation block /rec/data-ingestion/validation, fixing normative language in the requirement.

/req/data-ingestion/completeness added: new standalone section on Data Completeness Monitoring, covering definition of expected data, detection of missing or late observations, timely alerting, completeness statistics by station/element/period, and distinction between non-receipt and validation failure.

Statement C (basic derived meteorological variables) removed from /req/data-ingestion/standardisation and relocated to the new Basic Climate Computation class (/req/climate-computation/derived-variables).

### Clause 6 - Class 4 (Data API)

PATCH omission NOTE added explaining why PATCH is not required. XML response format downgraded to SHOULD. Duplicate NOTEs under Data Format Interoperability merged into a single NOTE.

### Clause 6 - Class 5 (Basic Climate Computation) — new class

New Requirements Class /req/climate-computation replaces the former Homogenisation class, addressing Denis Stuber's review comment that basic climate computation is a core CDMS function requiring prominent, dedicated coverage.

- /req/climate-computation/derived-variables: computation of basic derived meteorological variables (MSLP, dewpoint, RH) from quality-controlled observations; classified as Required in WMO-No. 1131 §4.5.1.2.
- /req/climate-computation/statistics: computation and storage of summary statistics (daily min/max/mean/totals, monthly/annual aggregations, configurable periods); moved from former /req/climate-products/statistics.
- /rec/climate-computation/homogenisation-detection and /rec/climate-computation/homogenisation-adjustment: statistical break point detection and adjustment calculation; moved from former Homogenisation class (classified as Recommended in WMO-No. 1131 §4.5.1.3).

### Clause 6 - Class 6 (Data Rescue)

Box number added to source document metadata. Double-key verification made conditional on record type. QA/ingest sequencing softened. Keying methods list clarified.

### Clause 6 - Class 7 (Metadata)

Justification restructured with correct WMO-No. 1238 section citations. Height/depth NOTE added for mobile sensor observations. WCMP2 URN example added. Disaggregation/infilling added to lineage. GDC submission text reworded. WIS/WIGOS distinction strengthened. Access constraints NOTE added. Usage tracking downgraded to SHOULD. ET-CCDI reference removed.

### Clause 6 - Class 9 (Climate Products)

/req/climate-products/wmo-products added: generation of WWR (WMO-No. 1186), CLIMAT (FM 71), and DAYCLI products from quality-controlled observation series; all three classified as Required in WMO-No. 1131 §4.4.1.3–4.4.1.5.

/req/climate-products/statistics removed and relocated to /req/climate-computation/statistics in the new Basic Climate Computation class. Dependency updated to include /req/climate-computation.

### Clause 7 - Class 13 (Security)

Custom role definition downgraded to SHOULD recommendation. Personal data list expanded.

---

## [v0.3.0] - 2021-05-26

### Document-level / Architecture
Closes #31 - System architecture - Arrow from WIS2 to CDMS bidirectional relationship split into two explicit arrows to clarify data flow direction. The relationship is genuinely bidirectional - CDMS both receives subscribed observations from WIS2 and publishes climate data back for international exchange.

Closes #33 - Possible confusion referring to this doc as a specification
Text updated to incorporate proposed changes from @gepeng86, clarifying the document's purpose and relationship to WMO-No. 1131.

Closes #38 - Quotes and comma positions
Punctuation moved outside quotation marks throughout, consistent with the WMO Style Guide.

Closes #39 - Forecasting systems also benefit from station data
Forecasting added to the list of downstream operational meteorological systems.

Closes #42 - Except CDMS, all systems should be "external systems"All systems except CDMS now marked as external systems in the C4 Level 1 diagram.

Closes #43 - Administrator users
"System Operator" renamed to "System Administrator" in the diagram and clause 1. In the UI overview, updated to "users" as the more appropriate general term.

### Clause 2 (Conformance)
Closes #46 - User interface should be requiredUser Interface conformance class promoted from Recommended to Required.

### Clause 6 - Class 1 (Core)

Closes #47 - Geographic location of the observation for fixed stations
Mobile platforms are now explicitly in scope, justified by the WMO-No. 1131 requirement to support observations from across all Earth system domains. Clarifying text added noting that for fixed stations, location is derived from station metadata.

Closes #48 - Non-WIGOS metadata storage
/req/core/metadata-storage split into Statement A (WIGOS metadata) and Statement B (non-WIGOS metadata), making non-WIGOS metadata storage a normative requirement.

Closes #49 - Alternate station identifiers (not WIGOS)
/req/metadata-management/wigos similarly split into Statement A (WIGOS) and Statement B (non-WIGOS), consistent with the change to /req/core/metadata-storage.

### Clause 6 - Class 2 (Quality Control)

Closes #52 - QC thresholds
Clarifying note added explaining that thresholds may be fixed values or dynamically derived (e.g. percentile-based), and that simple fixed-threshold configurations should remain straightforward to set up.

Closes #53 - Reprocessing of previously checked observations
On-demand reprocessing of previously checked observations added explicitly, in addition to scheduled/batch reprocessing.

Closes #54 - Comparison with neighbouring stations vs buddy checks
Buddy checks removed. Replaced with a more general neighbouring observation check with configurable selection criteria including maximum distance, elevation difference, station type, covariability, and predefined station lists. "Observations" used rather than "stations" to cover both fixed and mobile platform cases.

### Clause 6 - Class 3 (Data Ingestion)

Closes #55 - Explicit BUFR formats
BUFR clarified as a single binary format supporting hourly observations, daily summaries (including DAYCLI report types), and monthly summaries. FM-12 SYNOP and FM-71 CLIMAT named explicitly as TAC alphanumeric formats (WMO-No. 306, Volume I.1). BUFR export
confirmed as a SHALL requirement per WMO-No. 1131 §8.3.1.1. 

Closes #56 - Explicit list of supported formats
Covered by #55.

### Clause 6 - Class 4 (API)

Closes #57 - OpenAPI / Swagger
Note added recommending implementations provide API documentation in OpenAPI format, made available at a well-known endpoint.

### Clause 6 - Class 5 (Homogenisation)

Closes #58 - Data to be homogenized
Clarifying note added: homogenisation methods are most reliably applied to monthly data; application to daily or sub-daily data is possible but introduces greater uncertainty.

### Clause 6 - Class 6 (Data Rescue)

Closes #59 - observational recordS (with an s)?
Typo fixed.

### Clause 6 - Class 7 (Metadata)

Closes #60 - WIGOS standard includes the metadata history
No change. WMO-No. 1192 does not explicitly require metadata history. The /req/metadata-management/history requirement complements and adds specificity not provided by the WIGOS Metadata Standard.

Closes #61 - Dataset Quality Reporting from self-inspection or entered by users manually? Clarifying note added: quality metrics may be derived automatically from QC results or entered manually by data managers. GCOS reporting requirements removed from Statement B - out of scope.

Closes #62 - Second version of WMDR Note added acknowledging WMDR v2 is under development and that implementations should plan for compatibility when published. Current text intentionally references WMDR without specifying a version.