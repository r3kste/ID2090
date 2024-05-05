#!/usr/bin/python3

# References:
# https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#sklearn.feature_extraction.text.TfidfVectorizer

import sys
import math
import os

# I used OOPS because it is simply better in these cases
# I implemented the classes in a similar manner as sklearn does


class Doc:
    def __init__(self, sentence):
        self.terms = (
            sentence.split(",", 1)[1].strip().replace(",", "").replace(".", "").split()
        )
        self.NO_OF_TERMS = len(self.terms)

    def tf(self, term):
        return self.terms.count(term) / self.NO_OF_TERMS


class Document:
    def __init__(self, file):
        with open(file, "r") as file:
            lines = file.readlines()[1:]
            self.documents = [Doc(line.lower()) for line in lines if line.strip()]
        self.NO_OF_DOCUMENTS = len(self.documents)
        self.LOG2D = math.log2(1 + self.NO_OF_DOCUMENTS)

    def tdf(self, term):
        return sum(term in document.terms for document in self.documents)

    def idf(self, term):
        return self.LOG2D - math.log2(1 + self.tdf(term))

    def tfsum(self, term):
        return sum(document.tf(term) for document in self.documents)

    def tfidf(self, term):
        return self.idf(term) * self.tfsum(term) / self.NO_OF_DOCUMENTS


if not (len(sys.argv) == 2 or len(sys.argv) == 3):
    print(
        "error: invalid number of arguments!\n",
        "expected 1 or 2 arguments, but got ",
        len(sys.argv) - 1,
        "\nusage:\n./question_3.sh [document.csv] [term]\n\t[OR]\n./question_3.sh [document.csv]",
        sep="",
        file=sys.stderr,
    )
    exit(1)

if not os.path.exists(sys.argv[1]):
    print(
        'error: file "',
        sys.argv[1],
        '" not found',
        "\nusage:\n./question_3.sh [document.csv] [term]\n\t[OR]\n./question_3.sh [document.csv]",
        sep="",
        file=sys.stderr,
    )
    exit(1)


D = Document(sys.argv[1])

if len(sys.argv) == 3:
    print(round(D.tfidf(sys.argv[2].lower()), 4))
elif len(sys.argv) == 2:
    tfidf = {}
    for document in D.documents:
        for term in document.terms:
            if term not in tfidf:
                tfidf[term] = D.tfidf(term)
    tfidf = sorted(tfidf.items(), key=lambda x: x[1], reverse=True)
    for ti in tfidf[:5]:
        print(ti[0], ", ", round(ti[1], 4), sep="")
