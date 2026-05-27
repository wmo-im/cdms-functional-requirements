FILE_BASENAME=cdms-functional-requirements-DRAFT
SOURCE_DIR=./standard
BUILD_DATE=$(shell date -u +%Y-%m-%d)

html:
	asciidoctor --trace -a docdate=$(BUILD_DATE) -o ./compiled/${FILE_BASENAME}.html ${SOURCE_DIR}/index.adoc

pdf:
	asciidoctor --trace -r asciidoctor-diagram -r asciidoctor-pdf -a pdf-theme=theme.yml -a docdate=$(BUILD_DATE) --trace -b pdf -o ./compiled/${FILE_BASENAME}.pdf ${SOURCE_DIR}/index.adoc

docx:
	asciidoctor --trace -r asciidoctor-diagram -a docdate=$(BUILD_DATE) --backend docbook --out-file - ${SOURCE_DIR}/index.adoc | pandoc --from docbook --to docx --lua-filter fix-figure-refs.lua --reference-doc custom-reference.docx --number-sections --output ./compiled/${FILE_BASENAME}.docx

linkcheck:
	find . -name "???.adoc" -exec asciidoc-link-check -p -c ./asciidoc-link-check-config.json {} \;

clean:
	rm -f ${FILE_BASENAME}.{html,pdf,docx}

.PHONY: html pdf docx linkcheck clean