figfiles = rule_stats.eps model.eps bleu.eps 

all: ${figfiles}

%.eps : %.plt
	./$< > $@
