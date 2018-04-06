from comet_ml import Experiment
from sklearn.preprocessing import LabelEncoder
import pandas as pd
import numpy as np
from keras.utils import np_utils

import pickle

y_tr = pickle.load(open('y_tr.pkl', 'rb'))
X_train = pickle.load(open('X_train.pkl', 'rb'))

y_train = np.array(pd.get_dummies(y_tr))
max_words = 10000


from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation

experiment = Experiment(api_key="GkMDLZGX3LFP8DPGfIBtYqzcV")
model = Sequential()
model.add(Dense(512, kernel_initializer='glorot_normal',
                input_shape=(max_words,),
                activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(256, kernel_initializer='glorot_normal', activation='sigmoid'))
model.add(Dropout(0.5))
model.add(Dense(len(y_train[0]), kernel_initializer='glorot_normal', activation='softmax'))
# Compile model
model.compile(loss='categorical_crossentropy', optimizer='Nadam', metrics=['accuracy'])

model.fit(X_train, y_train,
  batch_size=32,
  epochs=10,
  verbose=0,
  validation_split=0.3,
  shuffle=True)
