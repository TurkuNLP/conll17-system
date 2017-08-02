#!/bin/bash
#SBATCH -N 1
#SBATCH -p serial
#SBATCH -t 3-00:00:00
#SBATCH --mem=8000
#SBATCH -c 2

set -e
source /homeappl/home/jmnybl/appl_taito/venv_keras_py3/bin/activate

l="$1"  # treebank code

parserparams="params_parser_submission"

echo $l
echo $parserparams

tmpdata=/tmp/jmnybl/$l.train.final
modelpath=/wrk/jmnybl/udv2.0-submission-data/udpipe-models-final/$l
mkdir -p $tmpdata
mkdir -p $modelpath

# gather all the needed material into tmpdata (vector models, treebank files)
python gather_data.py $l $tmpdata

#preprocess training data
cat $tmpdata/$l-ud-train.conllu | python preprocess.py > $tmpdata/preprocessed-train.conllu

# collect training set vocabulary
cat $tmpdata/preprocessed-train.conllu | python collect_vocab.py --conllu_column FORM > $tmpdata/train_words
cat $tmpdata/preprocessed-train.conllu | python collect_vocab.py --conllu_column XPOS > $tmpdata/train_features

# build vector model for training set vocabulary
python /homeappl/home/jmnybl/appl_taito/word2vecf_myfork/char-ngrams/simulate_fasttext.py -m $tmpdata/char-word.vectors -v $tmpdata/train_words -o $tmpdata/train.vectors

python /homeappl/home/jmnybl/appl_taito/word2vecf_myfork/feature_embeddings/simulate_fasttext.py -m $tmpdata/char-feature.vectors -v $tmpdata/train_features -o $tmpdata/train.feature.vectors

# train udpipe
../../src/udpipe --tokenizer=`grep "^$l " params_tokenizer | sed "s/^$l //"` --train --tagger=`grep "^$l " params_tagger | sed "s/^$l //"` --parser=`grep "^$l " $parserparams | sed "s/^$l //"` $modelpath/$l.model $tmpdata/preprocessed-train.conllu

cp $tmpdata/train_words $modelpath/train_words
cp $tmpdata/train_features $modelpath/train_features
cp $tmpdata/train.vectors $modelpath/train.vectors
cp $tmpdata/train.feature.vectors $modelpath/train.feature.vectors

echo "training ready"

rm -rf $tmpdata





