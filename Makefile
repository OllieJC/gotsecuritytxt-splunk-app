SHELL := /usr/bin/env bash
DEFAULT_GOAL := test
PHONY = clean
PWD := $(PWD)
ONESHELL:

test: build
	docker run -v "$(PWD)/gotsecuritytxt.tar.gz:/app/tmp/gotsecuritytxt.tar.gz" \
		olliecgds/splunk-appinspect splunk-appinspect inspect \
		"/app/tmp/gotsecuritytxt.tar.gz" \
		--mode precert --included-tags cloud

build: clean
	cp --no-preserve=mode -r app/ /tmp/gotsecuritytxt/
	cp --no-preserve=mode README.md /tmp/gotsecuritytxt/
	cd /tmp && COPY_EXTENDED_ATTRIBUTES_DISABLED=true \
	  COPYFILE_DISABLE=true \
	  tar -cvf "$(PWD)/gotsecuritytxt.tar" gotsecuritytxt/* \
		&& cd -
	gzip --no-name "$(PWD)/gotsecuritytxt.tar"

clean:
	rm -rf "/tmp/gotsecuritytxt/" || echo "Temp directory doesn't exist"
	rm -rf "$(PWD)/gotsecuritytxt.tar.gz" || echo "tar.gz doesn't exist"
