#!/bin/bash

treebank=$1

sbatch -J $treebank.final -o logs/$treebank.final.out -e logs/$treebank.final.err ./train_submission_model.sh $treebank

