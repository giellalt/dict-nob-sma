Updating the nobsma using smanob:

- snu smanob til nobsma på nytt
 ==> DONE
- overskrive dei eksisterende nobsma-filene og legge ut på webdict på nytt
 ==> TODO

Question:
When reverting, shall @cip consider only the files in the smanob/src dir or perhaps also
from the ped/sma/src?

Answer:
smanob is a dict, ped/sma/src has "too many" synonyms, to make a working Leksa.
Thus:
- Revert smanob/src to nobsma/src. 
- Thereafter make a list of nob lemmata in ped/sma/nob/ that are missing 
  in nobsma/src, and present that as a diff list.
- Then the lexicographers go through this list and add interesting ones to nobsma.

