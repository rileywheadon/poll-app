import numpy as np
from scipy.stats import gaussian_kde

'''
INPUT:
    - data: the list of dictionaries created for the "scale" poll type
    - bandwidth: bandwidth of the kernel density estimation (higher bandwidth => smoother function)
OUTPUT: List of two parallel lists representing (x, y) points 
        e.g. [
                [0, 1, 2, 3, 4, 5], <-- x-vals
                [2, 5, 1, 5, 2, 4]  <-- y-vals
        ]
'''
def smooth_hist(data, bandwidth):
    x_vals = np.linspace(0, 100, 101)
    # bug: if data is length 1 it will not work
    if len(data) < 2:
        return [x_vals.tolist(), x_vals.tolist()]
    adj_data = [[i["value"]] * i["count"] for i in data]
    adj_data = [i for j in adj_data for i in j]
    return [x_vals.tolist(), gaussian_kde(adj_data, bw_method=bandwidth)(x_vals).tolist()]