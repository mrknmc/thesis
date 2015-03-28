all:
	# Do all includes
	latexpand report.Rnw > knitted.Rnw
	# Then knit the file
	Rscript -e 'library(knitr); knit("knitted.Rnw", output="report.tex")'
	# Then do the standard thing
	xelatex -shell-escape report.tex
	# bibtex report
	bibtex report
	xelatex -shell-escape report.tex
	xelatex -shell-escape report.tex
