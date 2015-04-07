#!/bin/bash
#
#$ -N demCmu_26_01_27
#$ -m be
#$ -l qp=LOW,h_rt=24:00:00
#$ -cwd
/usr/local/bin/matlab << EOF
HOME = getenv('HOME');
addpath([HOME '/mlprojects/matlab/general']);
cd ~/mlprojects/hgplvm/matlab
hgplvmToolboxes
demCmu_26_01_27
EOF
