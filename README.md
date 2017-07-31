# conll17-system
Instructions for TurkuNLP system in CoNLL 2017 Shared Task on Multilingual Parsing from Raw Text to Universal Dependencies.

http://universaldependencies.org/conll17/

# TurkuNLP system:
* Our submission ia a modified version of the UDPipe parsing pipeline with our own delexicalized syntax-based word embeddings.

### Parsing pipeline
* Modified UDPipe is available here: https://github.com/fginter/udpipe. Modifications include allowing the user to extract word and other embeddings from the parsing model after parser training, as well as injecting new embeddings to the parsing model (for example for out-of-vocabulary words).

### Word embeddings
* Our delexicalised syntax-based word embedding training is available here: https://github.com/jmnybl/word2vecf
* 
