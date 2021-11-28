# See LICENSE file for copyright and license details
.POSIX:

all: dag target/index.html target/posts/index.html target/sitemap.xml target/rss.xml

target/posts/index.html: index.db templates/landing_header.html templates/landing_footer.html templates/nav.html
	m4 -I templates templates/landing_header.html >$@
	dagindex -Gohtml >>$@
	cat templates/landing_footer.html >>$@

target/index.html: templates/index.html templates/nav.html
	dagindex -A -t "Home" -s "/" \
		-p $$(stat -f%m templates/index.html) -x
	mkdir -p target
	m4 -I templates -DSLUG=https://www.danielmoch.com/ \
		templates/index.html >$@

target/sitemap.xml: index.db
	dagindex -Gositemap -f https://www.danielmoch.com >$@

target/rss.xml: index.db target/posts/index.html
	dagindex -Gorss -t "Daniel Moch's Weblog" -f 'https://www.danielmoch.com' \
		-d "Daniel Moch's Weblog" -r 'https://www.danielmoch.com/rss.xml' -l en \
		-c 'Contents © 2021 Daniel Moch, CC BY-SA 4.0 License' >$@

dag:
	dag

serve:
	python3 -m http.server -d target -b 127.0.0.1 8000

clean:
	rm -rf target index.db

deploy: all
	openrsync --rsync-path=/usr/bin/openrsync -a --del target/ \
		root@phosphorus.danielmoch.com:/var/www/htdocs/dotcom

.PHONY: all clean dag serve deploy
