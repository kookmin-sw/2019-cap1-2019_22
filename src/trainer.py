from __future__ import print_function
import os
import sys
import time
import numpy as np

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.contrib import rnn

import sklearn as sk
from sklearn.model_selection import KFold, cross_val_score
from sklearn.metrics import confusion_matrix
from sklearn.utils import shuffle

# Import WiFi Activity data
# csv_convert(window_size,threshold)
from crossvali_input import csv_import, DataSet


FULL_TIME_START = time.time()
window_size = 500
threshold = 60

# Parameters
learning_rate = 0.0001  
training_iters = 1000
batch_size = 200 # The example_size must be bigger than batch size (crossvali_input.py Line.44)
display_step = 50 # Display training condition per 50 iterations

# Network Parameters
n_input = 90 # WiFi activity data input (img shape: 90*window_size)
n_steps = window_size # timesteps
n_hidden = 200 # hidden layer num of features original 200
n_classes = 3 # WiFi activity total classes

# Output folder
OUTPUT_FOLDER_PATTERN = "LR{0}_BATCHSIZE{1}_NHIDDEN{2}/"
output_folder = OUTPUT_FOLDER_PATTERN.format(learning_rate, batch_size, n_hidden)
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# tf Graph input // 
x = tf.placeholder("float", [None, n_steps, n_input]) 
y = tf.placeholder("float", [None, n_classes]) 
# Define weights
weights = {
    'out': tf.Variable(tf.random_normal([n_hidden, n_classes]))
}
biases = {
    'out': tf.Variable(tf.random_normal([n_classes]))
}

def RNN(x, weights, biases):

    # Prepare data shape to match `rnn` function requirements
    # Current data input shape: (batch_size, n_steps, n_input)
    # Required shape: 'n_steps' tensors list of shape (batch_size, n_input)

    # Permuting batch_size and n_steps
    x = tf.transpose(x, [1, 0, 2])
    # Reshaping to (n_steps*batch_size, n_input)
    x = tf.reshape(x, [-1, n_input])
    # Split to get a list of 'n_steps' tensors of shape (batch_size, n_input)
    x = tf.split(x, n_steps, 0)

    # Define a lstm cell with tensorflow
    lstm_cell = rnn.BasicLSTMCell(n_hidden, forget_bias=1.0)

    # Get lstm cell output
    outputs, states = rnn.static_rnn(lstm_cell, x, dtype=tf.float32)

    # Linear activation, using rnn inner loop last output
    return tf.matmul(outputs[-1], weights['out']) + biases['out']

##### main #####
pred = RNN(x, weights, biases)

# Define loss and optimizer
cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits = pred, labels = y)) 
optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)
#https://www.tensorflow.org/api_docs/python/tf/train/AdamOptimizer

# Evaluate model
correct_pred = tf.equal(tf.argmax(pred,1), tf.argmax(y,1))
accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))

# Initializing the variables
init = tf.global_variables_initializer()
cvscores = []
confusion_sum = [[0 for i in range(3)] for j in range(3)] ######## 3 is number of classes

#data import
x_walk, x_laydown, x_sit, y_walk, y_laydown, y_sit = csv_import()

print("walk = ", len(x_walk)," laydown =", len(x_laydown)," sit =", len(x_sit))

#data shuffle
x_walk, y_walk = shuffle(x_walk, y_walk, random_state=0)
x_laydown, y_laydown = shuffle(x_laydown, y_laydown, random_state=0)
x_sit, y_sit = shuffle(x_sit, y_sit, random_state=0)

#k_fold, cross validation
kk = 5

# Launch the graph.
with tf.Session(config=tf.ConfigProto(log_device_placement=True)) as sess:
    for i in range(kk):

        TRAIN_1KK_START = time.time()
        #Initialization
        train_loss = []
        train_acc = []
        validation_loss = []
        validation_acc = []

        #Roll the data
        x_walking = np.roll(x_walking, int(len(x_walking) // kk), axis=0)
        y_walking = np.roll(y_walking, int(len(y_walking) // kk), axis=0)
        x_laydown = np.roll(x_laydown, int(len(x_laydown) // kk), axis=0)
        y_laydown = np.roll(y_laydown, int(len(y_laydown) // kk), axis=0)
        x_empty = np.roll(x_empty, int(len(x_empty) // kk), axis=0)
        y_empty = np.roll(y_empty, int(len(y_empty) // kk), axis=0)
        
        wifi_x_train = np.r_[x_walking[int(len(x_walking) / kk):], \
                             x_laydown[int(len(x_laydown) / kk):], \
                             x_empty[int(len(x_empty) // kk):]]
        wifi_y_train = np.r_[y_walking[int(len(y_walking) / kk):], \
                             y_laydown[int(len(y_laydown) / kk):],\
                             y_empty[int(len(y_empty) // kk):]]

        wifi_y_train = wifi_y_train[:,1:]

        wifi_x_validation = np.r_[x_walking[:int(len(x_walking) / kk)], \
                                  x_laydown[:int(len(x_laydown) / kk)], \
                                  x_empty[:int(len(x_empty) // kk)]]

        wifi_y_validation = np.r_[y_walking[:int(len(y_walking) / kk)], \
                                  y_laydown[:int(len(y_laydown) / kk)],\
                                  y_empty[:int(len(y_empty) // kk)]]

        wifi_y_validation = wifi_y_validation[:,1:]


        #data set
        #print(wifi_x_train.shape(0), wifi_y_train.shape(0))
        wifi_train = DataSet(wifi_x_train, wifi_y_train)
        wifi_validation = DataSet(wifi_x_validation, wifi_y_validation)
        print(wifi_x_train.shape, wifi_y_train.shape, wifi_x_validation.shape, wifi_y_validation.shape)
        saver = tf.train.Saver()
        sess.run(tf.initialize_all_variables())
        ckpt = tf.train.get_checkpoint_state('model')
        if ckpt and ckpt.model_checkpoint_path:
            saver.restore(sess, 'model/model.ckpt')

        step = 1

        # Keep training until reach max iterations
        while step < training_iters:
            TRAIN_ITER_100TIMES_START = time.time()
            batch_x, batch_y = wifi_train.next_batch(batch_size)
            x_vali = wifi_validation.images[:]
            y_vali = wifi_validation.labels[:]
            # Reshape data to get 28 seq of 28 elements
            batch_x = batch_x.reshape((batch_size, n_steps, n_input)) 
            x_vali = x_vali.reshape((-1, n_steps, n_input)) 
            # Run optimization op (backprop)
            sess.run(optimizer, feed_dict={x: batch_x, y: batch_y})

            # Calculate batch accuracy
            acc = sess.run(accuracy, feed_dict={x: batch_x, y: batch_y})
            acc_vali = sess.run(accuracy, feed_dict={x: x_vali, y: y_vali})
            # Calculate batch loss
            loss = sess.run(cost, feed_dict={x: batch_x, y: batch_y})
            loss_vali = sess.run(cost, feed_dict={x: x_vali, y: y_vali})

            # Store the accuracy and loss
            train_acc.append(acc)
            train_loss.append(loss)
            validation_acc.append(acc_vali)
            validation_loss.append(loss_vali)

            if step % display_step == 0:
                print("Iter " + str(step) + ", Minibatch Training  Loss= " + \
                    "{:.6f}".format(loss) + ", Training Accuracy= " + \
                    "{:.5f}".format(acc) + ", Minibatch Validation  Loss= " + \
                    "{:.6f}".format(loss_vali) + ", Validation Accuracy= " + \
                    "{:.5f}".format(acc_vali) )
                TRAIN_ITER_100TIMES_END = time.time() - TRAIN_ITER_100TIMES_START
            step += 1

        #Calculate the confusion_matrix
        cvscores.append(acc_vali * 100)
        y_p = tf.argmax(pred, 1)
        val_accuracy, y_pred = sess.run([accuracy, y_p], feed_dict={x: x_vali, y: y_vali})
        y_true = np.argmax(y_vali,1)
        print(sk.metrics.confusion_matrix(y_true, y_pred))
        confusion = sk.metrics.confusion_matrix(y_true, y_pred)
        confusion_sum = confusion_sum + confusion
        ## there can't be broadcasted (5,5) (3,3) so we had to change confusion_sum

        #Save the Accuracy curve
        fig = plt.figure(2 * i - 1)
        plt.plot(train_acc)
        plt.plot(validation_acc)
        plt.xlabel("n_epoch")
        plt.ylabel("Accuracy")
        plt.legend(["train_acc","validation_acc"],loc=4)
        plt.ylim([0,1])
        plt.savefig((output_folder + "Accuracy_" + str(i) + ".png"), dpi=150)

        #Save the Loss curve
        fig = plt.figure(2 * i)
        plt.plot(train_loss)
        plt.plot(validation_loss)
        plt.xlabel("n_epoch")
        plt.ylabel("Loss")
        plt.legend(["train_loss","validation_loss"],loc=1)
        plt.ylim([0,2])
        plt.savefig((output_folder + "Loss_" + str(i) + ".png"), dpi=150)
        TRAIN_1KK_END = time.time() - TRAIN_1KK_START

    print("Optimization Finished!")
    print("%.1f%% (+/- %.1f%%)" % (np.mean(cvscores), np.std(cvscores)))
    saver.save(sess, output_folder + "model.ckpt")

    #Save the confusion_matrix
    np.savetxt(output_folder + "confusion_matrix.txt", confusion_sum, delimiter=",", fmt='%d')
    np.savetxt(output_folder + "accuracy.txt", (np.mean(cvscores), np.std(cvscores)), delimiter=".", fmt='%.1f')
    FULL_TIME_END = time.time() - FULL_TIME_START

    print("FULL CALCULATE TIME : " , FULL_TIME_END)
    #time.strftime("%H:%M:%S", FULL_TIME_END)
    print('100TIMES ITERATION TIME : ' , TRAIN_ITER_100TIMES_END)
    #time.strftime("%H:%M:%S", TRAIN_ITER_100TIMES_END)
    print('\n')
    print("1 KK CALCULATE TIME  ", TRAIN_1KK_END)
    #time.strftime("%H:%M:%S", TRAIN_1KK_END)
    print('Finished!!!!')
