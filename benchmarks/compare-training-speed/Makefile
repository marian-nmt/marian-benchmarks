THREADS=16

GIT_MARIAN=http://github.com/marian-nmt/marian-dev.git
GIT_AMUN=http://github.com/marian-nmt/marian.git
GIT_NEMATUS=http://github.com/EdinburghNLP/nematus.git
GIT_SOCKEYE=https://github.com/awslabs/sockeye

CUDA_DIR=/usr/local/cuda-9.1
MARIAN_FLAGS=-DCUDA_TOOLKIT_ROOT_DIR=$(CUDA_DIR)
MARIAN_BRANCH=master

TOOLS = tools/marian tools/amun tools/nematus tools/sockeye tools/fairseq

.PHONY: clean data install test tools $(TOOLS)
.SECONDARY:


install: tools


#####################################################################

tools: $(TOOLS)

install-marian: tools/marian
tools/marian:
	git -C $@ pull || git clone $(GIT_MARIAN) -b $(MARIAN_BRANCH) $@
	mkdir -p $@/build && cd $@/build && cmake .. -DCMAKE_BUILD_TYPE=Release $(MARIAN_FLAGS) && make -j$(THREADS)

install-amun: tools/amun
tools/amun:
	git -C $@ pull || git clone $(GIT_AMUN) $@
	mkdir -p $@/build && cd $@/build && cmake .. -DCMAKE_BUILD_TYPE=Release $(MARIAN_FLAGS) && make -j$(THREADS)

install-nematus: tools/nematus
tools/nematus:
	git -C $@ pull || git clone $(GIT_NEMATUS) $@

install-sockeye: tools/sockeye
tools/sockeye:
	git -C $@ pull || git clone $(GIT_SOCKEYE) $@
	cd $@ && LD_LIBRARY_PATH=$$LD_LIBRARY_PATH:$(CUDA_DIR) pip3 install -r requirements/requirements.gpu-cu91.txt --user
	cd $@ && pip3 install . --user

install-fairseq: tools/fairseq
tools/fairseq:
	pip3 install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp35-cp35m-linux_x86_64.whl --user
	#pip3 install torchvision --user
	mkdir -p $@

#####################################################################

data:
	test -s data/corpus.bpe.en || cd $@ && bash download-files.sh
	test -s data/corpus.bpe.en || cd $@ && bash preprocess-data.sh


#####################################################################

test:
	tools/marian/build/marian -h 2>/dev/null || echo "Failure"
	tools/amun/build/amun -h 2>/dev/null || echo "Failure"
	tools/nematus/nematus/nmt.py -h 2>/dev/null || echo "Failure"
	cd tools/sockeye && python3 -m sockeye.train -h >/dev/null || echo "Failure"


#####################################################################

clean:
	rm -rf $(TOOLS)

