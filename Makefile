THREADS=16

GIT_MARIAN=http://github.com/marian-nmt/marian-dev.git
GIT_MARIAN_EXAMPLES=http://github.com/marian-nmt/marian-examples.git
GIT_AMUN=http://github.com/marian-nmt/marian.git
GIT_MOSES_SCRIPTS=http://github.com/marian-nmt/moses-scripts.git
GIT_SUBWORD_NMT=http://github.com/rsennrich/subword-nmt.git
GIT_NEMATUS=http://github.com/EdinburghNLP/nematus.git
GIT_SACRE_BLEU=https://github.com/mjpost/sacreBLEU -b master

MARIAN_FLAGS=-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-9.0
MARIAN_BRANCH=master

.PHONY: install models test tools tools/marian tools/amun tools/nematus marian amun marian-examples
.SECONDARY:


#####################################################################

install: tools models marian-examples test

tools: tools/nematus tools/marian tools/amun
	git -C $@/moses-scripts pull || git clone $(GIT_MOSES_SCRIPTS) $@/moses-scripts
	git -C $@/subword-nmt pull || git clone $(GIT_SUBWORD_NMT) $@/subword-nmt
	git -C $@/sacreBLEU pull || git clone $(GIT_SACRE_BLEU) $@/sacreBLEU

tools/nematus:
	test -d $@ && cd $@ && git stash
	git -C $@ pull || git clone $(GIT_NEMATUS) $@
	cd $@ && git apply ../add-timer-to-nematus.patch || true

marian: tools/marian
tools/marian:
	git -C $@ pull || git clone $(GIT_MARIAN) -b $(MARIAN_BRANCH) $@
	mkdir -p $@/build && cd $@/build && cmake .. -DCMAKE_BUILD_TYPE=Release $(MARIAN_FLAGS) && make -j$(THREADS)

amun: tools/amun
tools/amun:
	git -C $@ pull || git clone $(GIT_AMUN) $@
	mkdir -p $@/build && cd $@/build && cmake .. -DCMAKE_BUILD_TYPE=Release $(MARIAN_FLAGS) && make -j$(THREADS)
	# disable top-k/softmax fusion
	cd $@ && git apply ../disable-fusion-in-amun.patch || true
	mkdir -p $@/build-nofus && cd $@/build-nofus && cmake .. -DCMAKE_BUILD_TYPE=Release $(MARIAN_FLAGS) && make -j$(THREADS)
	cd $@ && git checkout -- src/amun/common/god.cpp

marian-examples:
	git -C $@ pull || git clone $(GIT_MARIAN_EXAMPLES)

models:
	mkdir -p $@
	cd $@ && bash ./download-wmt16.sh
	cd $@ && bash ./download-wmt17.sh

test:
	tools/marian/build/marian -h 2>/dev/null || echo "Failure"
	tools/amun/build/amun -h 2>/dev/null || echo "Failure"
	tools/amun/build-nofus/amun -h 2>/dev/null || echo "Failure"
