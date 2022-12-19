import random
from itertools import count
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import time
from matplotlib.animation import FuncAnimation

pi = 3.14

plt.style.use('fivethirtyeight')

xx_vals = [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
xy_vals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

yx_vals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
yy_vals = [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

index = count()

def animate(i):
    robo_state = pd.read_csv('robo_state.csv')
    len = robo_state['f_lnk_len']
    theta = robo_state['f_theta_rad']
    len = [2, 1]
    x = [0, 0, 0]
    y = [0, 0, 0]

    # theta = [(i*0.01*pi) % 2*pi, (i*0.01*pi) % 0.5*pi] 
    print("%2.2f RADs   %2.2f" % (theta[0], theta[1]))

    x[1] = len[0]*np.cos(theta[0])
    y[1] = len[0]*np.sin(theta[0])
    x[2] = len[0]*np.cos(theta[0]) + len[1]*np.cos(theta[0] + theta[1])
    y[2] = len[0]*np.sin(theta[0]) + len[1]*np.sin(theta[0] + theta[1])

    plt.cla()
    plt.plot(x, y, c="red", marker="o")
    plt.scatter(xx_vals, xy_vals, c="white", marker="")
    plt.scatter(yx_vals, yy_vals, c="white", marker="")
    

ani = FuncAnimation(plt.gcf(), animate, interval=100)

plt.tight_layout()
plt.show()