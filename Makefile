SLUG = learning-opengl

all: preview.pdf

env:;
ifndef LEANPUB_API_KEY
	$(error No LEANPUB_API_KEY defined in env)
endif
ifndef LEANPUB_PREVIEW_PDF
	$(error No LEANPUB_PREVIEW_PDF defined in env)
endif

preview.pdf: env manuscript/
	curl -d "api_key=${LEANPUB_API_KEY}" "https://leanpub.com/$(SLUG)/preview.json"
	curl -L "${LEANPUB_PREVIEW_PDF}" -o preview.pdf

# TODO: Single page preview?
#manuscript/%: env
#	curl -d "api_key=${LEANPUB_API_KEY}" -d "@$@" "https://leanpub.com/$(SLUG)/preview/single.json"
