#!/bin/bash
set -e

# Download data, create train and val sets
echo Download and setup data...
chmod 755 ./setup_project_and_data.sh
./setup_project_and_data.sh
echo Finished data setup

# Train
cd ./Mask_RCNN/samples/ship

# Weights directory $1 ../../logs/ship20180815T0023
# Get last weights file i.e. mask_rcnn_ship_0067.h5
last_weights=`ls ../../logs/ship20180815T0023/ | tail -n 1`
weights_path="../../logs/ship20180815T0023/$last_weights"
echo Training, staring with weights $last_weights

python3 ./ship.py train --dataset=./datasets --weights=$weights_path
echo Finished training

# Upload weights to s3
trained_weights=`ls ../../logs/ship20180815T0023/ | tail -n 1`
trained_weights_path="../../logs/ship20180815T0023/$trained_weights"
echo Uploading $trained_weights weights to s3...
aws s3 cp $trained_weights_path s3://airbus-kaggle/weights
echo Uploaded trained weights to s3

# sudo docker run -it 001413338534.dkr.ecr.us-east-1.amazonaws.com/deep-learning-gpu bash ./train.sh
