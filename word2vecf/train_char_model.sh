#!/bin/bash

### TRAIN CHARACTER N-GRAM EMBEDDINGS

name=$1 # name of the model "name.char.bin"
limit=$2 # word frequency limit

cat > data.tmp

cat data.tmp | grep -P '^[0-9]' | python3 char-ngrams/vocab.py --freq_limit $limit --conllu_column FORM  > $name.vocab

cat data.tmp | grep -P '^[0-9]' | wc -l

cat data.tmp | python3 char-ngrams/extract_transition_seq.py -v $name.vocab --freq_limit $limit --conllu_column FORM --featurizer next_action > $name.dep.contexts
cat data.tmp | python3 char-ngrams/extract_deps_myversion.py -v $name.vocab --freq_limit $limit >> $name.dep.contexts

cat $name.dep.contexts | shuf > $name.dep.contexts.shuffled

./count_and_filter -train $name.dep.contexts.shuffled -cvocab $name.cv -wvocab $name.wv -min-count $limit

./word2vecf -train $name.dep.contexts.shuffled -wvocab $name.wv -cvocab $name.cv -output $name.char.bin -size 100 -negative 5 -threads 4 -iters 10 -binary 1

# remove temporal files
rm -f data.tmp
#rm -r $name.vocab
#rm -r $name.dep.context
#rm -r $name.dep.context.shuffled
#rm -r $name.cv
#rm -r $name.cv






