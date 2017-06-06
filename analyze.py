import os
import glob
import pprint
from shutil import copyfile

debug = False

test_cases = {}
for f in glob.glob("tests_*/test_*/fittest*.png"):
	fitness = float(f.split("/")[2].split("_")[1].replace(".png", ""))

	test_case = f.split("/")[0]
	if not test_cases.has_key(test_case):
		test_cases[test_case] = []
	test_cases[test_case].append(fitness)

	if not os.path.exists("images/" + test_case + "/"):
		os.makedirs("images/" + test_case)

	copyfile(f, "images/" + test_case + "/" + str(fitness) + ".png")

for test_case, fitneses in test_cases.items():
	print test_case
	best_test = 0
	first = 0
	second = 0
	third = 0
	last = 1
	sum_total = 0
	for i, f in enumerate(fitneses):
		if f > first:
			third = second
			second = first
			first = f
			best_test = i
		if f < first and f > second:
			third = second
			second = f
		if f < second and f > third:
			third = f

		if f < last:
			last = f

		sum_total += f

	avg_fitness = sum_total / len(fitneses)

	print "\tBest Test: %d, Max: %f, Avg: %f, Min: %f" % (best_test, first, avg_fitness, last)

	if not os.path.exists("images/" + test_case + "/top"):
		os.makedirs("images/" + test_case + "/top")

	copyfile("images/" + test_case + "/" + str(first) + ".png", "images/" + test_case + "/top/" + str(first) + ".png")
	copyfile("images/" + test_case + "/" + str(second) + ".png", "images/" + test_case + "/top/" + str(second) + ".png")
	copyfile("images/" + test_case + "/" + str(third) + ".png", "images/" + test_case + "/top/" + str(third) + ".png")

if debug:
	pprint.pprint(test_cases)