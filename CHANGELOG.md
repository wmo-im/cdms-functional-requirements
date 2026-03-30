# Change Log

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