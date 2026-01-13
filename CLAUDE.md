# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AsciiDoc documentation project for the **WMO Climate Data Management System (CDMS) Functional and Non-functional Requirements Specification**. It is a companion document to WMO-No. 1131 (Climate Data Management System Specifications).

## Build Commands

Builds require Docker. First build the Docker image:

```bash
docker build -t cdms-asciidoctor .
```

Then run make commands inside the container:

```bash
# Build PDF (most common)
docker run --rm -v "$(pwd):/documents" cdms-asciidoctor make pdf

# Build HTML
docker run --rm -v "$(pwd):/documents" cdms-asciidoctor make html

# Build Word document
docker run --rm -v "$(pwd):/documents" cdms-asciidoctor make docx

# Validate links
docker run --rm -v "$(pwd):/documents" cdms-asciidoctor make linkcheck
```

Outputs are written to `compiled/cdms-functional-requirements-DRAFT.{pdf,html,docx}`

## Document Structure

```
standard/
├── index.adoc                    # Main document entry point
├── figures/                      # PlantUML C4 diagrams (c4_level_0-3.puml)
└── sections/
    ├── clause_0/                 # Front matter (empty/minimal)
    ├── clause_1/                 # Scope, system context, architecture
    ├── clause_2-5/               # Supporting sections
    ├── clause_6/                 # Functional Requirements (10 classes)
    │   ├── class_1_core.adoc
    │   ├── class_2_quality_control.adoc
    │   ├── class_3_data_ingestion.adoc
    │   ├── class_4_api.adoc
    │   ├── class_5_homogenisation.adoc
    │   ├── class_6_data_rescue.adoc
    │   ├── class_7_metadata.adoc
    │   ├── class_8_ui.adoc
    │   ├── class_9_climate_products.adoc
    │   └── class_10_automation.adoc
    └── clause_7/                 # Non-functional Requirements (7 classes)
        ├── class_11_performance.adoc
        ├── class_12_reliability.adoc
        ├── class_13_security.adoc
        ├── class_14_usability.adoc
        ├── class_15_maintainability.adoc
        ├── class_16_interoperability.adoc
        └── class_17_data_governance.adoc
```

## Writing Requirements

Requirements follow OGC Modular Specification format with:
- Unique identifiers (e.g., `/req/core/data-model`)
- Requirements class tables at section start
- Individual requirement blocks with `Identifier` and `Statement` fields
- Auto-incrementing counter: `{counter:req-id}`

Example requirement block:
```asciidoc
[[req_core_data_model]]
===== Observation Data Model
[cols="1,4"]
|===
2+^|**Requirement {counter:req-id}**
|Identifier|/req/core/data-model
|Statement a|The system SHALL implement...
|===
```

## Diagrams

C4 architecture diagrams in `standard/figures/` are PlantUML files rendered to SVG during build. They are included in AsciiDoc via:
```asciidoc
[plantuml, c4_level_0, svg]
----
include::../../figures/c4_level_0.puml[]
----
```

## Git Workflow

**NEVER:**
- Merge pull requests
- Push directly to main branch

Always create feature branches and PRs for changes. Let the repository owner review and merge.

## Key Files

- `Dockerfile` - Build environment with asciidoctor, pandoc, graphviz, plantuml support
- `theme.yml` - PDF styling (extends asciidoctor-pdf default theme)
- `custom-reference.docx` - Template for Word output formatting
