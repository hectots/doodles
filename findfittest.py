import sys
import csv
import glob
import os

def extract_fitness_from_fittest_image(lookup_dir):
	matches = glob.glob(lookup_dir + "/fittest_*.png")
	_, fitness = os.path.splitext(os.path.basename(matches[0]))[0].split("_")
	return fitness

if len(sys.argv[1:]) >= 1:
	lookup_dir = sys.argv[1]
	options = []
	if len(sys.argv[1:]) > 1: 
		options = sys.argv[2:]

	fittest = extract_fitness_from_fittest_image(lookup_dir)
	found = False

	for gen_filename in glob.glob(lookup_dir + "/gen_*.txt"):
		with open(gen_filename, 'rb') as gen_file:
			gen_reader = csv.reader(gen_file, delimiter='|')
			SEQUENCE_ROW = 0
			DNA_ROW = 1
			FITNESS_FIELD = 2
			IS_FITTEST_FIELD = 3
			for row in gen_reader:
				dna = row[DNA_ROW].strip()
				fitness = row[FITNESS_FIELD].strip()
				is_fittest = row[IS_FITTEST_FIELD].strip() if len(row) == 4 else '_'

				if '-v' in options and is_fittest == 'x':
					print gen_filename, ":", fitness

				if '--dna' in options:
					qdna = options[options.index('--dna') + 1]

					if dna == qdna:
						found = True
						print gen_filename, ":", row[SEQUENCE_ROW]
				elif '-f' in options:
					qf = options[options.index('-f') + 1]

					if qf == fitness:
						found = True
						print gen_filename, ":", row[SEQUENCE_ROW]
				elif fittest == fitness:
					found = True
					print gen_filename, ":", row[SEQUENCE_ROW]
	if not found:
		print "Not found."
