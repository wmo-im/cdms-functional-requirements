FILE_BASENAME=cdms-functional-requirements-DRAFT
SOURCE_DIR=./standard

html:
	asciidoctor --trace -o ./compiled/${FILE_BASENAME}.html ${SOURCE_DIR}/index.adoc

pdf:
	asciidoctor --trace -r asciidoctor-diagram -r asciidoctor-pdf -a pdf-theme=theme.yml --trace -b pdf -o ./compiled/${FILE_BASENAME}.pdf ${SOURCE_DIR}/index.adoc

docx:
	asciidoctor --trace -r asciidoctor-diagram --backend docbook --out-file - ${SOURCE_DIR}/index.adoc | pandoc --from docbook --to docx --reference-doc custom-reference.docx --number-sections --toc --output ./compiled/${FILE_BASENAME}.docx

linkcheck:
	find . -name "???.adoc" -exec asciidoc-link-check -p -c ./asciidoc-link-check-config.json {} \;

clean:
	rm -f ${FILE_BASENAME}.{html,pdf,docx}

.PHONY: html pdf docx linkcheck clean