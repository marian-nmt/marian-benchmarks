#!/bin/bash -v

set -e
source ./venv/bin/activate

t2t-datagen --tmp_dir tmp --data_dir data --problem translate_wngt19_en_de32k_spm --t2t_usr_dir t2t_usr

