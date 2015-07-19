SLUG = learning-opengl

all: toc

env:;
ifndef LEANPUB_API_KEY
	$(error No LEANPUB_API_KEY defined in env)
endif

preview: env
	curl -d "api_key=${LEANPUB_API_KEY}" "https://leanpub.com/$(SLUG)/preview.json"

preview.pdf: env manuscript/
ifndef LEANPUB_PREVIEW_PDF
	$(error No LEANPUB_PREVIEW_PDF defined in env)
endif
	curl -L "${LEANPUB_PREVIEW_PDF}" -o preview.pdf

# TODO: Single page preview?
#manuscript/%: env
#	curl -d "api_key=${LEANPUB_API_KEY}" -d "@$@" "https://leanpub.com/$(SLUG)/preview/single.json"

toc: manuscript/README.md

manuscript/README.md: manuscript/Book.txt
	./mktoc $< > "$@"


.PHONY: toc preview env
