

all: roen.multigpu transformer.multigpu

roen.multigpu:
	bash ./run.sh 4 roen > $@
transformer.multigpu:
	bash ./run.sh 4 transformer > $@	

clean:
	rm -rf roen.* transformer.*
