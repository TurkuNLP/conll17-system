# conll17-system
Instructions for TurkuNLP system in CoNLL 2017 Shared Task on Multilingual Parsing from Raw Text to Universal Dependencies.

http://universaldependencies.org/conll17/

# TurkuNLP system:
* Our submission ia a modified version of the UDPipe parsing pipeline with our own delexicalized syntax-based word embeddings.

### Parsing pipeline
* Modified UDPipe is available here: https://github.com/fginter/udpipe. Modifications include allowing the user to extract word and other embeddings from the parsing model after parser training, as well as injecting new embeddings to the parsing model (for example out-of-vocabulary words).
* Example scripts to train and test udpipe with our vector manipulation techniques are at conll17-system/udpipe directory.

### Word embeddings
* Our delexicalised syntax-based word embedding training is available here: https://github.com/jmnybl/word2vecf
* Example script for training delexicalised character n-gram model is train_char_model.sh at conll17-system/word2vecf directory. This character n-gram model can then be used to build word vectors for the given vocabulary.
