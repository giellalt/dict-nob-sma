# cabal update
# cabal install regex-compat-tdfa hxt split

all: data/gaerjiste-vaalteme_2001.tsv

GVclean: GVclean.hs
	ghc -O2 --make $<

data/gaerjiste-vaalteme_2001.pdf:
	mkdir -p data
	wget http://ruovatsijte.no/gaerjiste-vaalteme_2001.pdf -O $@

data/gaerjiste-vaalteme_2001.xml: data/gaerjiste-vaalteme_2001.pdf
	pdftohtml -f 5 -c -s -i -xml $< $@

data/gaerjiste-vaalteme_2001.tsv: data/gaerjiste-vaalteme_2001.xml GVclean
	./GVclean $< >$@.tmp
	mv $@.tmp $@

test: GVclean.hs t/test.xml
	runhaskell -- $^ > t/results.tsv
	diff t/expected.tsv t/results.tsv
