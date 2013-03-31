feature_detekta
===============

Detects and displays matching features of images, no matter how much the orientation of the photos differ. 

There are two methods of doing this implemented in this code. 

The first uses a form of the SIFT algorithm (with only rotation invariance). This is the one with fewer false
positives and is overall more reliable. The algorithm is described in detail here:
http://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf

The second just uses image patches of 11 x 11 pixel size around features, and usually has a good number of matches but also more false positives. 

Features are detected with Harris Corner Detection algorithm:
http://www.bmva.org/bmvc/1988/avc-88-023.pdf
