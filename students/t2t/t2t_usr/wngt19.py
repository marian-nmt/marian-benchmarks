"""Data generators for the WNGT19 Efficiency Shared Task"""

# https://github.com/tensorflow/tensor2tensor/blob/master/tensor2tensor/data_generators/translate_ende.py
# https://github.com/tensorflow/tensor2tensor/blob/4d96546af045b869e3a3f826a21b634e9631e43d/tensor2tensor/models/transformer.py#L1729

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from tensor2tensor.data_generators import problem
from tensor2tensor.data_generators import translate
from tensor2tensor.models import transformer
from tensor2tensor.utils import registry


_WNGT_SPM_TRAIN_NOISYBT4 = [
    [
        "http://data.statmt.org/romang/wngt/data/wngt19.train.spm.tgz",
        ("noisybt.merge.train.4.filtered.spm.en",
         "noisybt.merge.train.4.filtered.spm.de")
    ]
]

_WNGT_SPM_VALID_DATASET = [
    [
        "http://data.statmt.org/romang/wngt/data/wngt19.valid.spm.tgz",
        ("valid.spm.en", "valid.spm.de")
    ]
]


@registry.register_problem
class TranslateWngt19EnDe32kSpm(translate.TranslateProblem):
    """WNGT19 shared task with data segmented with SentencePiece"""

    @property
    def additional_training_datasets(self):
        """Allow subclasses to add training datasets."""
        return []

    def source_data_files(self, dataset_split):
        train = dataset_split == problem.DatasetSplit.TRAIN
        train_datasets = _WNGT_SPM_TRAIN_NOISYBT4 + self.additional_training_datasets
        return train_datasets if train else _WNGT_SPM_VALID_DATASET


@registry.register_hparams
def transformer_wngt19_tiny1():
    hp = transformer.transformer_base()
    # Architecture
    hp.num_encoder_layers = 6
    hp.num_decoder_layers = 1
    hp.hidden_size = 256
    hp.filter_size = 1536
    hp.shared_embedding_and_softmax_weights = True
    hp.layer_preprocess_sequence = ""
    hp.layer_postprocess_sequence = "dan"
    # Turn off dropout
    hp.layer_prepostprocess_dropout = 0.0
    hp.attention_dropout = 0.0
    hp.relu_dropout = 0.0
    hp.label_smoothing = 0.0
    return hp

