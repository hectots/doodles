import sys
import re

if len(sys.argv[1:]) >= 1:
	encoded_dna = sys.argv[1]

	genes = encoded_dna.split('_')
	regex = re.compile(r'[A-Z\+\-\[\]]')
	wrapped_genes = []
	for gene in genes:
		if regex.match(gene):
			wrapped_genes.append("'"+gene+"'")
		else:
			wrapped_genes.append(gene)
	print '{'+', '.join(wrapped_genes)+'}'