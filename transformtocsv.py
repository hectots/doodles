import sys
import csv

if len(sys.argv[1:]) > 1:
	infile = sys.argv[1]
	outfile = sys.argv[2]

	with open(infile, 'rb') as gen_file:
		gen_reader = csv.reader(gen_file, delimiter='|')

		with open(outfile, 'wb') as csv_file:
			for row in gen_reader:
				csv_file.write(','.join(['"'+field.strip()+'"' for field in row]))
				csv_file.write('\n')
