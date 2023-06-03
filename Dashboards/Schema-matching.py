import csv
from array import *
from difflib import SequenceMatcher

# initialize array with zeros
def init_array(arr, n_rows, n_cols):
    for i in range(0, n_rows):
        arr.append([])
        for j in range(0, n_cols):
            arr[i].append(0)
    return arr


def columns(csv_name):
    with open(csv_name, newline='') as csvfile:
        return csv.reader(csvfile).__next__()

# returns the length of the longest matching sequences.
def longest_sequence_matching(str1, str2):
    seqMatch = SequenceMatcher(None, str1, str2) # how many chars are identical in a sequence
    match = seqMatch.find_longest_match(0, len(str1), 0, len(str2)) # finds the longest match
    if (match.size != 0):
        return len(str1[match.a: match.a + match.size])
    else:
        return 0

# gets file name and column and returns all the values in the column
def columns_values(csv_name, field_name):
    values_array = []
    with open(csv_name, newline='',encoding= "ISO-8859-1") as file:
        reader = csv.DictReader(file)
        for r in reader:
            values_array.append(r[field_name])

    return values_array

# calculates similarity for the values in each 2 fields.
def fields_instance_similarity(field1_values, field2_values):
    sum_grades = 0
    for value_1 in field1_values:
        for value_2 in field2_values:
            grade = longest_sequence_matching(value_2, value_1) / max(len(value_2), len(value_1))
            sum_grades += grade

    return sum_grades / (len(field1_values)*len(field2_values)) # sum / 3dd el sadot

# flm2 - gets 2 files and creates the matrix.
def flm2(csv1_name, csv2_name):
    columns1 = columns(csv1_name)
    columns2 = columns(csv2_name)

    similarity_matrix = []
    similarity_matrix = init_array(similarity_matrix, len(columns1), len(columns2))

    i, j = 0, 0
    for field1 in columns1:
        field1_values = columns_values(csv1_name, field1)
        for field2 in columns2:
            field2_values = columns_values(csv2_name, field2)
            similarity_matrix[i][j] = fields_instance_similarity(field1_values, field2_values)
            j += 1
        i += 1
        j = 0

    return similarity_matrix

# flm1 - gets the 2 files and creates the similarity matrix
def flm1(csv1_name, csv2_name):
    columns1 = columns(csv1_name)
    columns2 = columns(csv2_name)

    similarity_matrix = []
    similarity_matrix = init_array(similarity_matrix, len(columns1), len(columns2))
    i, j = 0, 0

    for field1 in columns1:
        for field2 in columns2:
            num_matching_chars = longest_sequence_matching(field2, field1)
            similarity_matrix[i][j] = float(num_matching_chars * 2) / (len(field2) + len(field1))
            j += 1
        i += 1
        j = 0


    return similarity_matrix


#Section c is implemented here, the function receives two matrices and computes the average matching value and we set the binary correspondence matrix.
def slm1(similarity_matrixflm1, similarity_matrixflm2):
    threshold = 0.275
    correspondence = []
    correspondence = init_array(correspondence, len(similarity_matrixflm1), len(similarity_matrixflm2[0]))
    for i in range(len(similarity_matrixflm1)):
        for j in range(len(similarity_matrixflm2[0])):
            matchingProbAvg = (similarity_matrixflm1[i][j]+similarity_matrixflm2[i][j])
            if matchingProbAvg >= threshold:
                correspondence[i][j]=1

    return correspondence

def evaluate(correspondence,manualMatch):
    truepositive,truenegative,falsepositive,falsenegative,total,match=0,0,0,0,0,0

    print("Evaluate function\n")

    with open(manualMatch, newline='') as manual:
        reader = csv.DictReader(manual)
        i, j = 0, 0
        for row in reader:
            true_correspondence = row["Match"]
            predicate_correspondence = str(correspondence[i][j])

            # if both equal 0
            if true_correspondence == predicate_correspondence and true_correspondence == '0':
                truenegative += 1
            # if both equal 1
            if true_correspondence == predicate_correspondence and true_correspondence == '1':
                truepositive += 1
            # if they are not equal and predicate = 1
            if true_correspondence != predicate_correspondence and predicate_correspondence == '1':
                falsepositive += 1
            # if they are not equal and predicate = 0
            if true_correspondence != predicate_correspondence and predicate_correspondence == '0':
                falsenegative += 1

            j = (j+1)%13
            if j==0 : i+=1

    precision = float(truepositive) / (truepositive + falsepositive)
    recall = float(truepositive) / (truepositive + falsenegative)

    F1  = 2 * precision * recall / (precision + recall)
    F50 = 2501 * precision * recall / (2500 * precision) + recall

    return precision,recall,  F1, F50




def match(file1, file2):
    precision, recall, F1, F50 = evaluate(slm1(flm1('data/new_egg_gaming_laptops.csv','data/laptop_price.csv'),flm2('data/new_egg_gaming_laptops.csv','data/laptop_price.csv')),'data/exactmatch.csv')
    print("Precision : ",precision)
    print("Recall : ",recall)
    print("F1 : ",F1)
    print("F50 : ",F50)

match('data/new_egg_gaming_laptops.csv', 'data/laptop_price.csv')