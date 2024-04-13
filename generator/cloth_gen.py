# Function to generate a squared mesh of cloth
def generate_cloth_mesh(size):

	vertices = []
	tang_front = []
	tang_back = []
	faces_front = []
	faces_back = []

	# Generate vertices
	for z in range(size):

		for x in range(size):

			vertices.append([x, 0, z])

			# tang_front.append([1, 0, 0])
			# tang_back.append([-1, 0, 0])
	
	vertices = vertices + vertices
	normals = [[0, 1, 0], [0, -1, 0]]
	tangents = tang_front + tang_back

	# Generate faces and tangents
	for x in range(size-1):

		for z in range(size-1):

			v1 = z * size + x
			v2 = z * size + x + 1
			v3 = (z + 1) * size + x
			v4 = (z + 1) * size + x + 1

			faces_front.append([v1, v3, v2])
			faces_front.append([v2, v3, v4])

	for x in range(size-1):

		for z in range(size - 1):

			v1 = z * size + x
			v2 = z * size + x + 1
			v3 = (z + 1) * size + x
			v4 = (z + 1) * size + x + 1

			faces_back.append([v1 + size * 2, v2 + size * 2, v3 + size * 2])
			faces_back.append([v2 + size * 2, v4 + size * 2, v3 + size * 2])

	return vertices, faces_front, faces_back, normals, tangents

# Function to write a .obj file
def write_obj_file(vertices, faces_front, faces_back, normals, tangents, filepath):
	with open(filepath, 'w') as f:
		for v in vertices:
			f.write(f"v {v[0]}.0 {v[1]}.0 {v[2]}.0\n")
		for tan in tangents:
			f.write(f"vt {tan[0]}.0 {tan[1]}.0 {tan[2]}.0\n")
		for norm in normals:
			f.write(f"vn {norm[0]}.0 {norm[1]}.0 {norm[2]}.0\n")
		for face in faces_front:
			f.write(f"f {face[0]+1}//0 {face[1]+1}//0 {face[2]+1}//0\n")
		for face in faces_back:
			f.write(f"f {face[0]+1}//1 {face[1]+1}//1 {face[2]+1}//1\n")

# Generate cloth mesh and write .obj file
size = 3
vertices, faces_front, faces_back, normals, tangents = generate_cloth_mesh(size)
write_obj_file(vertices, faces_front, faces_back, normals, tangents, 'cloth.obj')