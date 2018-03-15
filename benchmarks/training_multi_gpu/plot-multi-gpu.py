"""
Bar chart demo with pairs of bars grouped for easy comparison.
"""
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import argparse

# print mpl.style.available
# plt.style.use('ggplot')

TITLE = 'Multi-GPU training (NVIDIA Tesla P100)\nro-en example, mini-batch fitted to 12GB workspace'

parser = argparse.ArgumentParser()
parser.add_argument("-n", "--num-gpus", required=True, type=int)
parser.add_argument("-1", "--sync", nargs='+', required=True)
parser.add_argument("-2", "--async", nargs='+', required=True)
parser.add_argument("-o", "--output-png", required=True)
parser.add_argument("-t", "--title", default=TITLE)

args = parser.parse_args()


values1 = [float(v) for v in args.sync]
values2 = [float(v) for v in args.async]
n = args.num_gpus


fig, ax = plt.subplots(figsize=(10, 5))
ax.yaxis.grid()

index = np.arange(n)
bar_width = 0.4
line_index = index + bar_width / 2.0
opacity = 0.6

rects1 = plt.bar(index, values1, bar_width,
                 alpha=opacity,
                 color='b',
                 label='sync',
                 align='center',
                 zorder=10)
lines1 = plt.plot(line_index, values1, color='b')

rects2 = plt.bar(index + bar_width, values2, bar_width,
                 alpha=opacity,
                 color='r',
                 label='async',
                 align='center',
                 zorder=10)
lines2 = plt.plot(line_index, values2, color='r')


plt.ylim(0, 70000)
plt.xlim(-.5, n)
plt.xlabel('No. of GPUs')
plt.ylabel('Words per seconds')
plt.title(TITLE)
plt.xticks(index + bar_width / 2, xrange(1, n+1))
plt.legend(loc='upper left')

plt.savefig(args.output_png)
