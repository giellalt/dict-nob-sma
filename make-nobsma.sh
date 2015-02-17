
echo ""
echo ""
echo "---------------------------------------------------"
echo "Shellscript to make a transducer of the dictionary."
echo ""
echo "It writes a lexc file to bin, containing the line	 "
echo "LEXICON Root										 "
echo "Thereafter, it picks lemma and first translation	 "
echo "of the dictionary, adds them to this lexc file,	 "
echo "and compiles a transducer bin/nobsma.fst		 "
echo ""
echo "Usage:"
echo "lookup bin/nobsma.fst"
echo "(or if your alias is set up: just write nobsma)"
echo "---------------------------------------------------"
echo ""
echo ""

echo "LEXICON Root" > bin/nobsma.lexc

cat src/*_nobsma.xml   | \
tr '\n' '™'            | \
sed 's/<e>/£/g;'       | \
tr '£' '\n'            | \
sed 's/<re>[^>]*>//g;' | \
tr '<' '>'             | \
cut -d">" -f5,15       | \
tr ' ' '_'             | \
tr '>' ':'             | \
grep -v '__'           | \
sed 's/$/ # ;/g'       >> bin/nobsma.lexc




printf "read lexc < bin/nobsma.lexc \n\
invert net \n\
save stack bin/nobsma.fst \n\
quit \n" > tmpfile
xfst -utf8 < tmpfile
rm -f tmpfile
