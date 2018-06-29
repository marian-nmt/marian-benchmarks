ROOT 	:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TOOLS 	:= $(realpath $(ROOT)/../tools)
SCRIPTS	:= $(realpath $(ROOT)/../../../tools)
MODEL	:= $(realpath $(ROOT)/../models/wmt16_systems/en-de)

DEVICE	= 0

RUNNERS = nematus marian amun marian.batch64 marian.batch32 marian.batch16 amun.batch64 amun.batch32 amun.batch16 amun.nofus amun.nofus.batch64 amun.nofus.batch32 amun.nofus.batch16
OUTPUT_TEXTS = $(patsubst %,%.out,$(RUNNERS))
OUTPUT_TIMES = $(patsubst %,%.out.time,$(RUNNERS))
OUTPUT_WPS = $(patsubst %,%.out.wps,$(RUNNERS))
OUTPUT_BLEU = $(patsubst %,%.out.bleu,$(RUNNERS))

.SECONDARY:

all: time wps bleu

time: $(OUTPUT_TIMES)
	tail *.out.time
wps: $(OUTPUT_WPS)
	tail *.out.wps
bleu: $(OUTPUT_BLEU)
	tail *.out.bleu


#####################################################################

# collect outputs
%.out.time: %.out.log
	python $(TOOLS)/extract_time.py -t $* -i $< > $@

%.out.wps: %.out.log
	python $(TOOLS)/extract_time.py -t $* -i $< --wps wmt16.en.prep > $@

%.out.bleu: %.out
	cat $< \
		| sed 's/\@\@ //g' \
		| $(SCRIPTS)/moses-scripts/scripts/recaser/detruecase.perl \
		| $(SCRIPTS)/moses-scripts/scripts/tokenizer/detokenizer.perl -l en \
		| $(SCRIPTS)/sacreBLEU/sacrebleu.py -t wmt16 -l en-de > $@


#####################################################################

# run nematus
nematus.out: wmt16.en.prep
	cd $(MODEL) && CUDA_VISIBLE_DEVICES=$(DEVICE) THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=cuda,on_unused_input=warn \
		python $(TOOLS)/nematus/nematus/translate.py -m model.npz -v \
		-k 5 -n -p 5 \
		< $(ROOT)/$< > $(ROOT)/$@ 2> $(ROOT)/$@.log

# run marian
marian.out: wmt16.en.prep
	$(TOOLS)/marian/build/marian-decoder -m $(MODEL)/model.npz -d $(DEVICE) \
		-v $(MODEL)/vocab.en.json $(MODEL)/vocab.de.json --dim-emb 500 --dim-vocabs 85000 85000 \
		-b 5 -n \
		< $< > $@ 2> $@.log
marian.batch%.out: wmt16.en.prep
	$(TOOLS)/marian/build/marian-decoder -m $(MODEL)/model.npz -d $(DEVICE) \
		-v $(MODEL)/vocab.en.json $(MODEL)/vocab.de.json --dim-emb 500 --dim-vocabs 85000 85000 \
		-b 5 -n --mini-batch $* --maxi-batch 100 --maxi-batch-sort src \
		< $< > $@ 2> $@.log

# run amun
amun.out: wmt16.en.prep
	$(TOOLS)/amun/build/amun -m $(MODEL)/model.npz -d $(DEVICE) \
		-s $(MODEL)/vocab.en.json -t $(MODEL)/vocab.de.json -d $(DEVICE) \
		-b 5 -n \
		< $< > $@ 2> $@.log
amun.batch%.out: wmt16.en.prep
	$(TOOLS)/amun/build/amun -m $(MODEL)/model.npz -d $(DEVICE) \
		-s $(MODEL)/vocab.en.json -t $(MODEL)/vocab.de.json \
		-b 5 -n --mini-batch $* --maxi-batch 6400 \
		< $< > $@ 2> $@.log

# run amun with disabled k-top/softmax fusion
amun.nofus.out: wmt16.en.prep
	$(TOOLS)/amun/build-nofus/amun -m $(MODEL)/model.npz -d $(DEVICE) \
		-s $(MODEL)/vocab.en.json -t $(MODEL)/vocab.de.json \
		-b 5 -n \
		< $< > $@ 2> $@.log
amun.nofus.batch%.out: wmt16.en.prep
	$(TOOLS)/amun/build-nofus/amun -m $(MODEL)/model.npz -d $(DEVICE) \
		-s $(MODEL)/vocab.en.json -t $(MODEL)/vocab.de.json \
		-b 5 -n --mini-batch $* --maxi-batch 6400 \
		< $< > $@ 2> $@.log

%.out.log: %.out
	echo "do nothing"


#####################################################################

# prepare input file
wmt16.en.prep: wmt16.en
	cat $< \
		| $(SCRIPTS)/moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
		| $(SCRIPTS)/moses-scripts/scripts/tokenizer/tokenizer.perl -l en -penn -q \
		| $(SCRIPTS)/moses-scripts/scripts/recaser/truecase.perl -model $(MODEL)/truecase-model.en \
		| $(SCRIPTS)/subword-nmt/subword_nmt/apply_bpe.py -c $(MODEL)/ende.bpe \
		> $@
wmt16.en:
	$(SCRIPTS)/sacreBLEU/sacrebleu.py -t wmt16 -l en-de --echo src > $@


#####################################################################

clean:
	rm -f wmt16.* *.out *.log *.time *.wps *.bleu
