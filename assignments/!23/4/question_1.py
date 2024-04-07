import sympy as sp
import yaml

# with open("/home/h3kste12/code/ID2090/assignments/!23/4/obj.yml", "r") as file:
#     A = yaml.load(file, Loader=yaml.Loader)
#     A = sp.Matrix(A)

N = 3
A = sp.ones(N)
# A = sp.Matrix([[-3, 4], [4, 3]])
I = sp.eye(A.shape[0])
k = sp.Symbol("k")

eigenvalues = sp.roots((k * I - A).det(), k)
eigenvalues = sp.Matrix(
    [sorted([k for k, v in eigenvalues.items() for _ in range(v)])],
)
print("Eigenvalues:")
sp.pprint(eigenvalues)

eigenvectors = []
for eigenvalue in set(eigenvalues):
    x, y, z = sp.symbols("x y z")
    C_Matrix = eigenvalue * I - A
    solution = C_Matrix.nullspace()
    for sol in solution:
        eigenvectors.append(sol)

# U, D = A.diagonalize()

U = sp.Matrix([eigenvectors])
print("U:")
sp.pprint(U)

# D = sp.diag(*eigenvalues)
D = U.inv() * A * U
print("D:")
sp.pprint(D)

sp.pprint(eigenvectors)
P = [eigenvector * eigenvector.transpose() for eigenvector in eigenvectors]
sp.pprint(P)
# print("Decomposition:")
# lambda1, lambda2, lambda3 = sp.symbols("lambda1 lambda2 lambda3")
# expr = U * D * U.inv() / 3
# print(sp.pretty(expr))

classes = []
if A == A.adjoint():
    classes.append("Hermitian")

if A * A.adjoint() == sp.eye(*A.shape):
    classes.append("Unitary")

if all([eigenvalue >= 0 for eigenvalue in eigenvalues]):
    classes.append("Positively Semidefinite")

if all([eigenvalue > 0 for eigenvalue in eigenvalues]):
    classes.append("Positively Definite")

if A * A.adjoint() == A.adjoint() * A:
    classes.append("Normal")

# sp.pprint(A * A.adjoint())
# print("Classification:")
# print(classes)
