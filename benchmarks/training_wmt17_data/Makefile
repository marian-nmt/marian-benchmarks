ROOT 	:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TOOLS 	:= $(realpath $(ROOT)/../../tools)
DATA 	:= $(realpath $(ROOT)/../../marian-examples/wmt2017-uedin/data)

DEVICES  = 1

RUNNERS = shallow deep nematus-deep
OUTPUT_LOGS = $(patsubst %,%.log,$(RUNNERS))
OUTPUT_WPS = $(patsubst %,%.log.wps,$(RUNNERS))


.SECONDARY:

all: $(OUTPUT_LOGS)


#####################################################################
# train models
%.log.wps: %.log
	cat $< | bash extract-wps.sh > $@
%.log: train-%.sh
	bash -x $< $@ $(DEVICES)


#####################################################################
# requirements
requirements: $(DATA)/corpus.bpe.en \
			  $(DATA)/corpus.bpe.de


#####################################################################
# clean
clean-all: clean
	rm -fr model.* *.yml
clean:
	rm -f *.log *.wps
