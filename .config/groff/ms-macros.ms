.de pic-a4
\X'pdf: pdfpic \\$1 \\$2 \\$3 0 8.268i
..

.de head
.ie (\B'\\$1') \{\
.   nr arg \\$1         \" Assigns heading level if it is a valid integer
.   ds title \\$2
.\}
.el \{\
.   nr arg 1            \" Heading level defaults to 1 if no heading level is passed
.   ds title \\$1
.\}
.NH \\n[arg]
.XN \\*[title]
..
