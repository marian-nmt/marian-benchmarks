ROOT 	:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TOOLS 	:= $(realpath $(ROOT)/../../tools)
MODEL	:= $(realpath $(ROOT)/../../models/wmt17_systems/en-de)

DEVICE	= 0

RUNNERS = nematus marian marian.batch16 marian.batch32 marian.batch64 amun-cpu
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
		| $(TOOLS)/moses-scripts/scripts/recaser/detruecase.perl \
		| $(TOOLS)/moses-scripts/scripts/tokenizer/detokenizer.perl -l en \
		| $(TOOLS)/sacreBLEU/sacrebleu.py -t wmt16 -l en-de > $@


#####################################################################
# run toolkits
# run nematus
nematus.out: wmt16.en.prep
	cd $(MODEL) && CUDA_VISIBLE_DEVICES=$(DEVICE) THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=cuda,on_unused_input=warn \
		python $(TOOLS)/nematus/nematus/translate.py -m model.l2r.ens1.npz --suppress-unk -v \
		-k 5 -n -p 5 \
		< $(ROOT)/$< > $(ROOT)/$@ 2> $(ROOT)/$@.log

# run marian
marian.out: wmt16.en.prep
	$(TOOLS)/marian/build/marian-decoder -c $(MODEL)/../marian.en-de.yml -d $(DEVICE) \
		-b 5 -n \
		< $< > $@ 2> $@.log
marian.batch%.out: wmt16.en.prep
	$(TOOLS)/marian/build/marian-decoder -c $(MODEL)/../marian.en-de.yml -d $(DEVICE) \
		-b 5 -n --mini-batch $* --maxi-batch 100 --maxi-batch-sort src \
		< $< > $@ 2> $@.log

# run amun
amun-cpu.out: wmt16.en.prep
	$(TOOLS)/amun/build/amun -c $(MODEL)/../amun.en-de.yml -d $(DEVICE) \
		-b 5 -n \
		< $< > $@ 2> $@.log
amun-cpu.batch%.out: wmt16.en.prep
	$(TOOLS)/amun/build/amun -c $(MODEL)/../amun.en-de.yml -d $(DEVICE) \
		-b 5 -n --mini-batch $* --maxi-batch 6400 \
		< $< > $@ 2> $@.log

%.out.log: %.out
	echo "do nothing"


#####################################################################
# prepare input file
wmt16.en.prep: wmt16.en
	cat $< \
		| $(TOOLS)/moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
		| $(TOOLS)/moses-scripts/scripts/tokenizer/tokenizer.perl -l en -penn -q \
		| $(TOOLS)/moses-scripts/scripts/recaser/truecase.perl -model $(MODEL)/truecase-model.en \
		| $(TOOLS)/subword-nmt/apply_bpe.py --vocabulary $(MODEL)/vocab.en --vocabulary-threshold 50 -c $(MODEL)/bpe.model.en \
		> $@
wmt16.en:
	$(TOOLS)/sacreBLEU/sacrebleu.py -t wmt16 -l en-de --echo src > $@


#####################################################################
# clean
clean:
	rm -f wmt16.* *.out *.log
