import mxnet as mx
a = mx.nd.ones((2, 3), mx.gpu())
b = a * 2 + 1
print(b.asnumpy())
