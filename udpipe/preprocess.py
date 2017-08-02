# python 3
import sys

ID,FORM,LEMMA,UPOS,XPOS,FEAT,HEAD,DEPREL,DEPS,MISC=range(10)

for line in sys.stdin:
    line=line.strip()
    if not line or line.startswith("#"):
        print(line)
        continue
    cols=line.split("\t")
    if "-" not in cols[ID]:
        xpostag=cols[UPOS]+"|"+cols[FEAT]
        cols[XPOS]=xpostag

        # is it too long?
        limit=100
        if len(cols[XPOS])>limit:
            print("truncating",cols[XPOS],file=sys.stderr)
            for i in range(int(len(cols[XPOS].split("|"))-1),1,-1):
                splitted="|".join(cols[XPOS].split("|")[:i])
                if len(splitted)<=limit:
                    cols[XPOS]=splitted
                    break
            if len(cols[XPOS])>limit:
                cols[XPOS]="_"


    print("\t".join(cols))
