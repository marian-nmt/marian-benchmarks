THREADS=16

GIT_MARIAN=http://github.com/marian-nmt/marian-dev.git
GIT_AMUN=http://github.com/marian-nmt/marian.git
GIT_MOSES_SCRIPTS=http://github.com/marian-nmt/moses-scripts.git
GIT_SUBWORD_NMT=http://github.com/rsennrich/subword-nmt.git
GIT_NEMATUS=http://github.com/EdinburghNLP/nematus.git
GIT_SACRE_BLEU=https://github.com/mjpost/sacreBLEU -b master

MARIANDIR=tools/marian-dev
BRANCH=master

.PHONY: install models test tools tools/marian tools/amun marian amun
.SECONDARY:


#####################################################################

install: tools tools/marian tools/amun models test

tools:
	git -C $@/moses-scripts pull || git clone $(GIT_MOSES_SCRIPTS) $@/moses-scripts
	git -C $@/subword-nmt pull || git clone $(GIT_SUBWORD_NMT) $@/subword-nmt
	git -C $@/nematus pull || git clone $(GIT_NEMATUS) $@/nematus
	cd $@/nematus && git apply ../add-timer-to-nematus.patch || true
	git -C $@/sacreBLEU pull || git clone $(GIT_SACRE_BLEU) $@/sacreBLEU

marian: tools/marian
tools/marian:
	git -C $@ pull || git clone $(GIT_MARIAN) -b $(BRANCH) $@
	mkdir -p $@/build && cd $@/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j$(THREADS)

amun: tools/amun
tools/amun:
	git -C $@ pull || git clone $(GIT_AMUN) $@
	mkdir -p $@/build && cd $@/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j$(THREADS)
	# disable top-k/softmax fusion
	cd $@ && git apply ../disable-fusion-in-amun.patch || true
	mkdir -p $@/build-nofus && cd $@/build-nofus && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j$(THREADS)
	cd $@ && git checkout -- src/amun/common/god.cpp

models:
	mkdir -p $@
	cd $@ && bash ./download-wmt16.sh
	cd $@ && bash ./download-wmt17.sh

test:
	tools/marian/build/marian -h 2>/dev/null || echo "Failure"
	tools/amun/build/amun -h 2>/dev/null || echo "Failure"
	tools/amun/build-nofus/amun -h 2>/dev/null || echo "Failure"
