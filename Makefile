.PHONY: dvi ps pdf all space clean veryclean distclean

SHELL = /bin/sh
MAKE  = gmake

# latex --interaction {batchmode, nonstopmode, scrollmode, errorstopmode}
#TEX = latex --interaction batchmode
TEX = latex
PDFTEX = pdflatex  --interaction errorstopmode
#PDFTEX = xelatex  # has problem with the algorithmic package

######################################################################
# source files

texfiles = $(wildcard *.tex)
bibfiles = $(wildcard *.bib)

tblfiles = $(wildcard tbl/*.tex)

styfiles  = $(wildcard *.sty)

#figfiles  = hg-composed.eps hg-type.eps
figfiles = $(wildcard figures/*.plt)
figfiles += $(wildcard figures/*.pdf)
figfiles += $(wildcard figures/*.ps)
figfiles += $(wildcard figures/*.epsi)
figfiles += $(wildcard figures/*.c)

figfiles += $(wildcard figures/apps/*.fig)
figfiles += $(wildcard figures/apps/*.plt)
figfiles += $(wildcard figures/apps/*.pdf)
figfiles += $(wildcard figures/apps/*.ps)
figfiles += $(wildcard figures/apps/*.epsi)
figfiles += $(wildcard figures/apps/*.c)

tmp_files = $(wildcard *.log)
tmp_files += $(wildcard *.aux)
tmp_files += $(wildcard *.blg)
tmp_files += $(wildcard *.bbl)
tmp_files += $(wildcard *.toc)
tmp_files += $(wildcard *.dvi)
#tmp_files += (texput.log)

######################################################################
# output files
target=proposal

######################################################################
# make targets

all: pdf

dvi: ${target}.dvi

ps: ${target}.ps

pdf: ${target}.pdf

space:
	@if [ -d fig ]; then cd fig; ${MAKE} $@; fi
	@-/bin/rm -f ${tmp_files} *~ ${target}.pdf ${target}.ps

clean veryclean distclean:
	if [ -d fig ]; then cd fig; ${MAKE} $@; fi
	/bin/rm -f ${tmp_files} *~ ${target}.pdf ${target}.ps ${target}.dvi

######################################################################
# rules

%.dvi : %.tex *.tex 
	@if [ -d fig ]; then cd fig; ${MAKE} all; fi
	@${TEX} $<
	@if grep -q bibdata ${*F}.aux ; then \
		bibtex ${*F};	\
		${TEX} $<;	\
		bibtex ${*F};	\
	fi
	@${TEX} $<
#	@-/bin/rm -f ${tmp_files}

%.ps : %.dvi
	dvips -P pdf -G0 -q -o $@ $<

%.pdf : %.ps
	ps2pdf $< $@

#%.pdf : %.tex
#	${PDFTEX} $< $@
#	bibtex ${target}
#	${PDFTEX} $< $@
#	${PDFTEX} $< $@

#%.pdf : %.tex #${texfiles} ${bibfiles} ${styfiles} ${figfiles} ${tblfiles}
#	@if [ -d fig ]; then cd fig; ${MAKE} all; fi
#	pdflatex $<
#	@if grep -q bibdata ${*F}.aux ; then \
#		bibtex ${*F};	\
#		pdflatex $<;	\
#		bibtex ${*F};	\
#	fi
#	pdflatex $< $@
#	@-/bin/rm -f ${tmp_files}


%.bib:	%.aux
	BSTINPUTS=/u/gildea/src/bibtools-2000/bibtools /u/gildea/src/bibtools-2000/bibtools/aux2bib $<
	mv references.bib $@

#hg-example.tex:	hg-example.dot
#	fdp $< -Txdot | PYTHONPATH=/u/gildea/lib/python2.7/site-packages dot2tex -t raw  -f pstricks --figonly > $@
#
#hg-anchored.tex:	hg-anchored.dot
#	fdp $< -Txdot | PYTHONPATH=/u/gildea/lib/python2.7/site-packages dot2tex -t raw  -f pstricks --figonly > $@
#
#hg.pdf:	hg.dot
#	dot -Tpdf hg.dot > $@
#
#hg-composed.pdf:	hg-composed.dot
#	dot -Tpdf hg-composed.dot > $@
#
#hg-composed.eps:	hg-composed.pdf
#	pdftops $< $@
#
#hg-type.pdf:	hg-type.dot
#	dot -Tpdf hg-type.dot > $@
#
#hg-type.eps:	hg-type.pdf
#	pdftops $< $@

######################################################################
# dependences

${target}.dvi: ${texfiles} ${bibfiles} ${styfiles} ${figfiles} ${tblfiles} Makefile
