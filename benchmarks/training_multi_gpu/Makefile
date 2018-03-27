

all: roen.multigpu transformer.multigpu deep.multigpu

roen.multigpu:
	bash ./run.sh 4 roen > $@
transformer.multigpu:
	bash ./run.sh 4 transformer > $@
deep.multigpu:
	bash ./run.sh 4 deep > $@

clean:
	rm -rf roen.* transformer.*
