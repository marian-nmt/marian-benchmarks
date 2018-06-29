THREADS=16

GIT_MARIAN_EXAMPLES=http://github.com/marian-nmt/marian-examples.git
GIT_MOSES_SCRIPTS=http://github.com/marian-nmt/moses-scripts.git
GIT_SUBWORD_NMT=http://github.com/rsennrich/subword-nmt.git
GIT_SACRE_BLEU=https://github.com/mjpost/sacreBLEU -b master

.PHONY: all tools
.SECONDARY:


tools:
	git -C $@/moses-scripts pull || git clone $(GIT_MOSES_SCRIPTS) $@/moses-scripts
	git -C $@/subword-nmt pull || git clone $(GIT_SUBWORD_NMT) $@/subword-nmt
	git -C $@/sacreBLEU pull || git clone $(GIT_SACRE_BLEU) $@/sacreBLEU

