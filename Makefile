# See LICENSE file for copyright and license details
.POSIX:

all: dag target/index.html target/sitemap.xml target/rss.xml

target/index.html: index.db templates/landing_header.html templates/landing_footer.html
	cat templates/landing_header.html >$@
	dagindex -Gohtml >>$@
	cat templates/landing_footer.html >>$@

target/sitemap.xml: index.db
	dagindex -Gositemap -f https://www.danielmoch.com >$@

target/rss.xml: index.db
	dagindex -Gorss -t "Daniel Moch's Weblog" -f 'https://www.danielmoch.com' \
		-d "Daniel Moch's Weblog" -r 'https://www.danielmoch.com/rss.xml' -l en \
		-c 'Contents © 2021 Daniel Moch, CC BY-SA 4.0 License' >$@

dag:
	dag

serve:
	python3 -m http.server -d target -b 127.0.0.1 8000

clean:
	rm -rf target index.db

.PHONY: all clean dag serve
