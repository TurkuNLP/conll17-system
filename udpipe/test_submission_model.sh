#!/bin/bash
#SBATCH -N 1
#SBATCH -p serial
#SBATCH -t 3-00:00:00
#SBATCH --mem=8000
#SBATCH -c 2

source /homeappl/home/jmnybl/appl_taito/venv_keras_py3/bin/activate
set -e

l="$1"  # treebank code

echo $l

tmpdata=/tmp/jmnybl/$l.test
modelpath=/wrk/jmnybl/udv2.0-submission-data/udpipe-models/$l
mkdir -p $tmpdata

# gather all the needed material into tmpdata (vector models, treebank files)
python gather_data.py $l $tmpdata
cp $modelpath/$l.model $tmpdata/$l.model
cp $modelpath/train_words $tmpdata/train_words
cp $modelpath/train.vectors $tmpdata/train.vectors

# test trained model without any embedding replacement
../../src/udpipe --accuracy --tag --parse "$tmpdata/$l.model" $tmpdata/$l-ud-dev.conllu

# extract embeddings from udpipe model
../../src/tools/extract_embeddings $tmpdata/$l.model

# build devel vocabulary
cat $tmpdata/$l-ud-dev.conllu | python collect_vocab.py --conllu_column FORM > $tmpdata/devel_words

# build vector model for devel set vocabulary
python /homeappl/home/jmnybl/appl_taito/word2vecf_myfork/char-ngrams/simulate_fasttext.py -m $tmpdata/char-word.vectors -v $tmpdata/devel_words -o $tmpdata/devel.vectors

# move vectors
python /homeappl/home/jmnybl/appl_taito/wvlib_light/move_nn.py $tmpdata/train.vectors $tmpdata/$l.model_emb.form.vectors $tmpdata/devel.vectors $tmpdata/moved.devel.vectors --word-counts $tmpdata/train_words --freq-threshold 3

# parse dev set
../../src/udpipe --tag --parse --parser="extra_form_emb=$tmpdata/moved.devel.vectors" "$modelpath/$l.model" $tmpdata/$l-ud-dev.conllu > $tmpdata/parsed.dev.conllu

# run official evaluator
python ../evaluation_script/conll17_ud_eval.py $tmpdata/$l-ud-dev.conllu $tmpdata/parsed.dev.conllu -w ../evaluation_script/weights.clas

echo "testing done"





