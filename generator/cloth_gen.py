# note: texture coordinates are not correct, they are just a placeholder for now... they're just for making sure the shaders draw tangents and bitangents correctly 

# Function to generate a squared mesh of cloth
def generate_cloth_mesh(size):

	vertices = []
	tex_coords_front = []
	tex_coords_back = []
	faces_front = []
	faces_back = []

	# Generate vertices
	for z in range(size):

		for x in range(size):

			vertices.append([x, 0, z])

			tex_coords_front.append([x / (size - 1), z / (size - 1)])
	
	vertices = vertices + vertices
	normals = [[0, 1, 0], [0, -1, 0]]
	tex_coords = tex_coords_front + tex_coords_front

	# Generate faces
	for z in range(size - 1):

		for x in range(size - 1):

			v1 = z * size + x
			v2 = z * size + x + 1
			v3 = (z + 1) * size + x
			v4 = (z + 1) * size + x + 1

			faces_front.append([v1, v3, v2])
			faces_front.append([v2, v3, v4])

	for z in range(size - 1):

		for x in range(size - 1):

			v1 = z * size + x
			v2 = z * size + x + 1
			v3 = (z + 1) * size + x
			v4 = (z + 1) * size + x + 1

			faces_back.append([v1 + size * size, v2 + size * size, v3 + size * size])
			faces_back.append([v2 + size * size, v4 + size * size, v3 + size * size])

	return vertices, faces_front, faces_back, normals, tex_coords

# Function to write a .obj file
def write_obj_file(vertices, faces_front, faces_back, normals, tex_coords, filepath):

	with open(filepath, 'w') as f:

		for v in vertices:
			f.write(f"v {v[0]}.0 {v[1]}.0 {v[2]}.0\n")

		for tex in tex_coords:
			f.write(f"vt {tex[0]} {tex[1]}\n")

		for norm in normals:
			f.write(f"vn {norm[0]}.0 {norm[1]}.0 {norm[2]}.0\n")

		for face in faces_front:
			f.write(f"f {face[0]+1}/{face[0]+1}/1 {face[1]+1}/{face[1]+1}/1 {face[2]+1}/{face[2]+1}/1\n")

		for face in faces_back:
			f.write(f"f {face[0]+1}/{face[0]+1}/2 {face[1]+1}/{face[1]+1}/2 {face[2]+1}/{face[2]+1}/2\n")

# Generate cloth mesh and write .obj file
size = 10
vertices, faces_front, faces_back, normals, tex_coords = generate_cloth_mesh(size)
write_obj_file(vertices, faces_front, faces_back, normals, tex_coords, 'cloth.obj')