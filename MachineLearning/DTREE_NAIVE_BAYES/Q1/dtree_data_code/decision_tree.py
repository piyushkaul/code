"""
Author: Yashoteja Prabhu
Email: yashoteja.prabhu@gmail.com
Date:   25-Mar-2016
"""

"""
This sample code demonstrates how to:
- load text data into python using pandas module
- preprocess textual categorical features
- build decision tree using training data
- predict scores over novel test data
"""

# Loading requisite libraries
import sys
import os
import re
import pandas as pd
import numpy as np
import pdb
import math
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import OneHotEncoder

# This function encodes a symbolic categorical attribute (eg: female/male) as a set of numerical one-versus-all features (one-hot-encoding)
def one_hot_encode_categorical(Xtrn,Xval,Xtst):
	lenc = LabelEncoder()
	catvar = Xtrn.columns[Xtrn.dtypes==object]
	oenc = OneHotEncoder(categorical_features=(Xtrn.dtypes==object),sparse=False)

	# Convert from, say, male/female to 0/1 (refer online for more details)
	for var in catvar:
		lenc.fit( pd.concat( [Xtrn[var],Xval[var],Xtst[var]] ) )
		Xtrn[var] = lenc.transform(Xtrn[var])
		Xval[var] = lenc.transform(Xval[var])
		Xtst[var] = lenc.transform(Xtst[var])

	# one-hot-encoding of 0-(k-1) valued k-categorical attribute
	oenc.fit( pd.concat( [Xtrn,Xval,Xtst] ) )
	Xtrn = pd.DataFrame(oenc.transform(Xtrn))
	Xval = pd.DataFrame(oenc.transform(Xval))
	Xtst = pd.DataFrame(oenc.transform(Xtst))
	return (Xtrn,Xval,Xtst)

# Read training data and partition into features and target label
data = pd.read_csv("train.csv")
Xtrn = data.drop("Survived",1)
Ytrn = data["Survived"]

# Read validation data and partition into features and target label
data = pd.read_csv("validation.csv")
Xval = data.drop("Survived",1)
Yval = data["Survived"]

# Read test data and partition into features and target label
data = pd.read_csv("test.csv")
Xtst = data.drop("Survived",1)
Ytst = data["Survived"]

# convert a symbolic categorical attribute (eg: female/male) to set of numerical one-versus-all features (one-hot-encoding)
Xtrn,Xval,Xtst = one_hot_encode_categorical(Xtrn,Xval,Xtst)


for min_samples_split_val in range(1,20):
	for min_samples_leaf_val in range(1,20):
		for max_depth_val in range(2,20):
		# Build a simple depth-5 decision tree with information gain split criterion
	#		dtree = DecisionTreeClassifier(criterion="entropy",max_depth, splitter='best', min_samples_split, min_samples_leaf, min_weight_fraction_leaf=0.0, max_features=None, random_state=None, max_leaf_nodes=None, class_weight=None, presort=False )
			dtree = DecisionTreeClassifier(criterion="entropy",max_depth=max_depth_val, min_samples_split=min_samples_split_val, min_samples_leaf=min_samples_leaf_val)
			dtree.fit(Xtrn,Ytrn)

# function score runs prediction on data, and outputs accuracy. 
# If you need predicted labels, use "predict" function
			print "\n"

			print 'min_samples_split = %d min_samples_leaf = %d max_depth = %d' % (min_samples_split_val,min_samples_leaf_val,max_depth_val)

			print "training accuracy: ",
			print dtree.score(Xtrn,Ytrn)

			print "validation accuracy: ",
			print dtree.score(Xval,Yval)

			print "test accuracy: ",
			print dtree.score(Xtst,Ytst)

