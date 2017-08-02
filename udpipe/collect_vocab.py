# python 3
import sys

conllu="ID,FORM,LEMMA,UPOS,XPOS,FEAT,HEAD,DEPREL,DEPS,MISC".split(",")


def create_vocab(args):
    tokens={}
    for line in sys.stdin:
        line=line.strip()
        if not line or line.startswith("#"):
            continue
        cols=line.split("\t")
        if args.conllu_column=="FORM" or args.conllu_column=="LEMMA":
            t=cols[conllu.index(args.conllu_column)].lower()
        else:
            t=cols[conllu.index(args.conllu_column)]
        if args.conllu_column=="XPOS" and t=="_": # empty xpos (multiword token)
            continue 
        if t not in tokens:
            tokens[t]=0
        tokens[t]+=1

    # sorted by count
    for w,c in sorted(tokens.items(),key=lambda x:x[1],reverse=True):
        print("\t".join([w,str(c)]))


if __name__=="__main__":

    import argparse
    parser = argparse.ArgumentParser(description='')

    parser.add_argument('--conllu_column', type=str, default='FORM', help='Which conllu column is used in input layer, i.e. do we train word, lemma or feature embeddings, options: FORM, LEMMA, UPOS, XPOS, FEAT')

   
    args = parser.parse_args()

    create_vocab(args)
