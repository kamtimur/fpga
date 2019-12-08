from elliptic import *


# p=0, a=0, b=0, P=(), q=0
a=0
b=7
p=0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
q=0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
P=(
    0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
    0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
)
curve = EllipticCurve(p,a,b,P,q)

x=0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
y=0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
k=0x906ca16d053ace87150e0cecd97c2c9664c0308914234a23ae4cb0630e47ff76
res=curve.mult(7,P)
print(curve.is_on_curve(res))
print((res[0]))
print((res[1]))
print(bin(res[0]))
print(bin(res[1]))
# inv = invert(2*y,p)
# print((2*y))
# print((p))
# print((inv))