
# Dette skal bli ei makefil for å lage nobsma.fst, 
# ei fst-fil som tar nob og gjev ei sma-omsetjing.

# Førebels er det berre eit shellscript.

# Kommando for å lage nobsma.fst
echo "LEXICON Root" > bin/nobsma.lexc
cat src/*_nobsma.xml | tr '\n' '™' | sed 's/<e>/£/g;'| tr '£' '\n'| sed 's/<re>[^>]*>//g;'|tr '<' '>'| cut -d">" -f5,15| tr ' ' '_'| tr '>' ':'| grep -v '__'|sed 's/$/ # ;/g' >> bin/nobsma.lexc
xfst -e "read lexc < bin/nobsma.lexc"

# deretter i xfst:
# invert
# save bin/nobsma.fst
