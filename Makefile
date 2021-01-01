# See LICENSE file for copyright and license details
.POSIX:

all:
	dag

serve:
	python -m http.server -d target -b 127.0.0.1 8000

clean:
	rm -rf target

.PHONY: all clean serve
