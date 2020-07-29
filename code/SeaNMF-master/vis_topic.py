'''
Visualize Topics
'''
import argparse

from utils import *

parser = argparse.ArgumentParser()
parser.add_argument('--corpus_file', default='data/wedoc_term_mat.txt', help='term document matrix file')
parser.add_argument('--vocab_file', default='data/wevocab.txt', help='vocab file')
parser.add_argument('--par_file', default='202007/20200710W.txt', help='model results file')
opt = parser.parse_args()

docs = read_docs(opt.corpus_file)
vocab = read_vocab(opt.vocab_file)
n_docs = len(docs)
n_terms = len(vocab)
print('n_docs={}, n_terms={}'.format(n_docs, n_terms))

dt_mat = np.zeros([n_terms, n_terms])
for itm in docs:
    for kk in itm:
        for jj in itm:
            if kk != jj:
                dt_mat[int(kk)-1, int(jj)-1] += 1.0
print('co-occur done')
        
W = np.loadtxt(opt.par_file, dtype=float)
n_topic = W.shape[1]
print('n_topic={}'.format(n_topic))

PMI_arr = []
n_topKeyword = 10
for k in range(n_topic):
    topKeywordsIndex = W[:,k].argsort()[::-1][:n_topKeyword]
    PMI_arr.append(calculate_PMI(dt_mat, topKeywordsIndex))
print('Average PMI={}'.format(np.average(np.array(PMI_arr))))

index = np.argsort(PMI_arr)
  
for k in index:
    print('Topic ' + str(k+1) + ': ', end=' ')
    print(PMI_arr[k], end=' ')
    for w in np.argsort(W[:,k])[::-1][:n_topKeyword]:
        print(vocab[w], end=' ')
    print()

#PMI = [0.1124,0.3624,0.6837,0.5339,0.6112,0.2780,0.5090,0.4507,0.4745]
