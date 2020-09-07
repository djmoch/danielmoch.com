# See LICENSE file for copyright and license details
.POSIX:

include config.mk
include files.mk

all: dirs ${TARGETFILES} ${CSS} ${HTMLPOSTS} ${HTMLPAGES} ${PDF}

dirs:
	for dir in $$(echo ${DIRS} | sort | uniq); do [ -d $${dir} ] || \
		mkdir -p $${dir}; done

${PDF}: ${@:.pdf=.md:S/target/src/}
	${LOWDOWN} -s -Tms ${@:.pdf=.md:S/target/src/} | ${TBL} | \
		${TROFF} -ms -Tpdf > $@

${HTMLPOSTS} ${HTMLPAGES}: ${@:.html=.md:S/target/src/} templates/header.html templates/footer.html
	${M4} -DDESCRIPTION="$$(lowdown -Xdescription -Tterm \
			${@:.html=.md:S/target/src/})" \
		-DPAGE_TITLE="$$(lowdown -Xtitle -Tterm \
			${@:.html=.md:S/target/src/})" \
		-DSLUG=${@:S/target//} $@ templates/header.html >$@
	${LOWDOWN} -Thtml ${@:.html=.md:S/target/src/} >>$@
	cat < templates/footer.html >>$@

${CSS}: ${@:.css=.scss:S/target/src/}
	${SASSC} -tcompact ${@:.css=.scss:S/target/src/} $@

${TARGETFILES}: ${@:S/target/files/}
	cp ${@:S/target/files/} $@

serve:
	python -m http.server -d target -b 127.0.0.1 8000

clean:
	rm -rf target

.PHONY: all clean dirs files serve
