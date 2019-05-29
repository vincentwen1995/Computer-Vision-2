import os
import numpy as np
import trimesh
import pyrender
import h5py
from data_def import PCAModel, Mesh

bfm = h5py.File("model2017-1_face12_nomouth.h5", 'r')