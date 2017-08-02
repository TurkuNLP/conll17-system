# python3 script to put all relevant training/testing data into one place
import sys
import glob
import os

d={'hr': 'Croatian', 'nl': 'Dutch', 'hi': 'Hindi', 'grc_proiel': 'Ancient_Greek', 'ar': 'Arabic', 'et': 'Estonian', 'pl': 'Polish', 'es': 'Spanish', 'ko': 'Korean', 'la': 'Latin', 'no_bokmaal': 'Norwegian-Bokmaal', 'da': 'Danish', 'eu': 'Basque', 'fr': 'French', 'fr_partut': 'French', 'ro': 'Romanian', 'gl': 'Galician', 'fi': 'Finnish', 'grc': 'Ancient_Greek', 'sv_lines': 'Swedish', 'hu': 'Hungarian', 'ur': 'Urdu', 'zh': 'ChineseT', 'cs_cac': 'Czech', 'he': 'Hebrew', 'tr': 'Turkish', 'lv': 'Latvian', 'no_nynorsk': 'Norwegian-Nynorsk', 'nl_lassysmall': 'Dutch', 'fi_ftb': 'Finnish', 'el': 'Greek', 'ru': 'Russian', 'kk': 'Kazakh', 'la_ittb': 'Latin', 'sl_sst': 'Slovenian', 'de': 'German', 'es_ancora': 'Spanish', 'sv': 'Swedish', 'ug': 'Uyghur', 'it': 'Italian', 'id': 'Indonesian', 'sk': 'Slovak', 'gl_treegal': 'Galician', 'uk': 'Ukrainian', 'en_partut': 'English', 'cs_cltt': 'Czech', 'la_proiel': 'Latin', 'ja': 'Japanese', 'cu': 'Old_Church_Slavonic', 'en': 'English', 'en_lines': 'English', 'got': 'Gothic', 'ca': 'Catalan', 'pt': 'Portuguese', 'sl': 'Slovenian', 'cs': 'Czech', 'ru_syntagrus': 'Russian', 'vi': 'Vietnamese', 'it_partut': 'Italian', 'bg': 'Bulgarian', 'fa': 'Persian', 'ga': 'Irish', 'pt_br': 'Portuguese', 'fr_sequoia': 'French'}

treebank=sys.argv[1]
outdir=sys.argv[2]
print(treebank,d[treebank],outdir)

# fetch ud data, this is easy, we can use just treebank code
#path="/wrk/jmnybl/udv2.0-baselinemodel-data/"
path="/wrk/jmnybl/udv2.0-conll-treebanks/"
for f in glob.glob(path+treebank+"/*.conllu"):
    fname=f.rsplit("/",1)[-1]
    os.system("cp {} {}".format(f,outdir+"/"+fname))


# fetch char embeddings for words
path="/wrk/jmnybl/udv2.0-submission-data/word-embeddings120517/"
if os.path.isfile(path+d[treebank]+".char.vectors"):
    fname=glob.glob(path+d[treebank]+".char.vectors")[0]
    os.system("cp {} {}".format(fname,outdir+"/char-word.vectors"))
else:
    print("File {} does not exist, cannot copy".format(path+d[treebank]+".vectors"), file=sys.stderr)

# fetch char embeddings for features
path="/wrk/jmnybl/udv2.0-submission-data/feature-embeddings/"
if os.path.isfile(path+treebank+".char.vectors"):
    fname=glob.glob(path+treebank+".char.vectors")[0]
    os.system("cp {} {}".format(fname,outdir+"/char-feature.vectors"))
else:
    print("File {} does not exist, cannot copy".format(path+d[treebank]+".vectors"), file=sys.stderr)

