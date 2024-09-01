import numpy as np
import rpy2.robjects.numpy2ri
rpy2.robjects.numpy2ri.activate()
from rpy2.robjects.packages import importr
import rpy2.robjects as robj

R = rpy2.robjects.r
DTW = importr('dtw')

# Generate our data
template = np.array([[1,2,3,4,5],[1,2,3,4,5]]).transpose()
rt,ct = template.shape
query = np.array([[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]).transpose()
rq,cq = query.shape

#converting numpy matrices to R matrices
templateR=R.matrix(template,nrow=rt,ncol=ct)
queryR=R.matrix(query,nrow=rq,ncol=cq)

# Calculate the alignment vector and corresponding distance
alignment = R.dtw(templateR,queryR,keep=True, step_pattern=R.rabinerJuangStepPattern(4,"c"),open_begin=True,open_end=True)

dist = alignment.rx('distance')[0][0]

print dist