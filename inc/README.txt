This is a first draft of a nob-sma dictionary, based on the work by several authors, and found here (full history included):

http://www.hemnes.sapmi.net/
http://www.hemnes.sapmi.net/Gaerjiste-vaalteme_2001.doc (Word document, used here)
http://www.hemnes.sapmi.net/Gaerjiste-vaalteme_2001.pdf (alternative pdf format)

The Word document was opened in AbiWord, and saved as HTML with default settings (except that AbiWord-specific namespace was not included).

The HTML file was then converted to XML/XHTML using the following command:

tidy -utf8 Gaerjiste-vaalteme_2001-abi.html | tail +2 | xmllint --html --xmlout --dropdtd --format - > Gaerjiste-vaalteme_2001.xhtml

As written by the authors, the text is freely available, and other users are encouraged to use and extend it. That is, it is in the public domain.
