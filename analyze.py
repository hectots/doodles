import glob
import pprint

debug = False

test_cases = {}
for f in glob.glob("tests_*/test_*/fittest*.png"):
	fitness = float(f.split("/")[2].split("_")[1].replace(".png", ""))

	test_case = f.split("/")[0]
	if not test_cases.has_key(test_case):
		test_cases[test_case] = []
	test_cases[test_case].append(fitness)

for test_case, fitneses in test_cases.items():
	print test_case
	max_fitness = 0
	sum_total = 0
	for f in fitneses:
		if f > max_fitness:
			max_fitness = f
		sum_total += f

	avg_fitness = sum_total / len(fitneses)

	print "\tMax: %f, Avg: %f" % (max_fitness, avg_fitness)

if debug:
	pprint.pprint(test_cases)