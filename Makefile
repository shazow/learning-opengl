SLUG = learning-opengl

BOOKFILES = $(filter-out */README.md,*/Subset.txt,manuscript/*)

all: toc combined.md

env:;
ifndef LEANPUB_API_KEY
	$(error No LEANPUB_API_KEY defined in env)
endif

preview: env
	curl -d "api_key=${LEANPUB_API_KEY}" "https://leanpub.com/$(SLUG)/preview.json"

preview.pdf: env
ifndef LEANPUB_PREVIEW_PDF
	$(error No LEANPUB_PREVIEW_PDF defined in env)
endif
	curl -L "${LEANPUB_PREVIEW_PDF}" -o preview.pdf

toc: manuscript/README.md

manuscript/README.md: $(BOOKFILES)
	./mkbook < manuscript/Book.txt > "$@"

combined.md: $(BOOKFILS)
	echo "title.md" | cat - manuscript/Book.txt | PREFIX="manuscript/" ./mkbook > "$@"


.PHONY: toc preview env
