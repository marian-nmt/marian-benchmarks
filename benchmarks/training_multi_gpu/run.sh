#!/bin/bash -x
#
#SBATCH --job-name=multigpu
#SBATCH --output=multigpu.log
#
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH --partition=big
#SBATCH --gres=gpu:8

if [ $# -lt 2 ]; then
    echo "Usage: $0 <max-gpus> roen|transformer"
    exit 1
fi

MAXGPUS=$1
PREFIX=$2

# synchronous
for i in `seq 0 $(($MAXGPUS - 1))`; do
    bash -x ./train-$PREFIX.sh $PREFIX.sync.$i $i "--sync-sgd"
done
bash ./show-wps.sh $PREFIX.sync > $PREFIX.sync.wps

# asynchronous
for i in `seq 0 $(($MAXGPUS - 1))`; do
    bash -x ./train-$PREFIX.sh $PREFIX.async.$i $i
done
bash ./show-wps.sh $PREFIX.async > $PREFIX.async.wps

# plotting
python plot-multi-gpu.py -o $PREFIX.multigpu.png -n $MAXGPUS \
    -1 `bash extract-wps.sh $PREFIX.sync` \
    -2 `bash extract-wps.sh $PREFIX.async`
