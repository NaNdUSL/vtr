import xml.etree.ElementTree as ET

# Function to generate a squared mesh of cloth
def generate_cloth_mesh(size):

	vertices = []
	tex_coords_front = []
	faces_front = []
	faces_back = []

	# Generate vertices
	for z in range(size):

		for x in range(size):

			vertices.append([x, 0, z])

			tex_coords_front.append([x / (size - 1), z / (size - 1)])
	
	vertices = vertices
	normals = [[0, 1, 0], [0, -1, 0]]
	tex_coords = tex_coords_front

	# Generate faces
	for z in range(size - 1):

		for x in range(size - 1):

			v1 = z * size + x
			v2 = z * size + x + 1
			v3 = (z + 1) * size + x
			v4 = (z + 1) * size + x + 1

			faces_front.append([v1, v3, v2])
			faces_front.append([v2, v3, v4])

	return vertices, faces_front, faces_back, normals, tex_coords

def generate_cloth_adj(size):

	adj = {}

	for i in range(size*size):

		adj[i] = [-1 for _ in range(size*size)]
	
	counter = 0
	mat = []

	for _ in range(size):

		int_mat = []

		for _ in range(size):

			int_mat.append(counter)
			counter += 1
		
		mat.append(int_mat)

	# print(mat)

	for j in range(size):
		
		for i in range(size):

			if i - 1 >= 0 and j - 1 >= 0:

				adj[mat[i][j]][(i - 1) * size + (j - 1)] = 1.414
			
			if i - 1 >= 0:

				adj[mat[i][j]][(i - 1) * size + j] = 1.0
			
			if i - 1 >= 0 and j + 1 < size:

				adj[mat[i][j]][(i - 1) * size + (j + 1)] = 1.414
			
			if j - 1 >= 0:

				adj[mat[i][j]][i * size + (j - 1)] = 1.0
			
			if j + 1 < size:

				adj[mat[i][j]][i * size + (j + 1)] = 1.0
			
			if i + 1 < size and j - 1 >= 0:

				adj[mat[i][j]][(i + 1) * size + (j - 1)] = 1.414
			
			if i + 1 < size:

				adj[mat[i][j]][(i + 1) * size + j] = 1.0
			
			if i + 1 < size and j + 1 < size:

				adj[mat[i][j]][(i + 1) * size + (j + 1)] = 1.414

	for i in range(size*size):

		adj[i][i] = 0

	# print(adj)
	return adj

# Function to write a .obj file
def write_obj_file(size, vertices, faces_front, faces_back, normals, tex_coords, filepath_obj):

	with open(filepath_obj, 'w') as f:

		index = 0
		for v in vertices:
			f.write(f"v {v[0]}.0 {index}.0 {v[2]}.0\n")
			index += 1

		for tex in tex_coords:
			f.write(f"vt {tex[0]} {tex[1]}\n")

		for norm in normals:
			f.write(f"vn {norm[0]}.0 {norm[1]}.0 {norm[2]}.0\n")

		for face in faces_front:
			f.write(f"f {face[0]+1}/{face[0]+1}/1 {face[1]+1}/{face[1]+1}/1 {face[2]+1}/{face[2]+1}/1\n")

		for face in faces_back:
			f.write(f"f {face[0]+1}/{face[0]+1}/2 {face[1]+1}/{face[1]+1}/2 {face[2]+1}/{face[2]+1}/2\n")

	with open('cloth_buffer_info.txt', 'w') as f:

		elem_count = 0

		for v in vertices:

			f.write(f"{v[0]}.0 {v[1]}.0 {v[2]}.0 1.0\n")
			elem_count += 1

	with open('cloth_adj_info.txt', 'w') as f:

		adj = generate_cloth_adj(size)

		for elem in adj:

			for weight in adj[elem]:

				f.write(f"{weight}\n")
	
	with open('cloth_vars_info.txt', 'w') as f:

		f.write(f"{size}\n{0.033}\n{100.0}\n{size*size}\n0.0\n")

	# Update the number of elements in the .mlib file
	tree = ET.parse('cloth.mlib')
	root = tree.getroot()

	values = {'clothBuffer': {'x': str(size * size), 'y': '4', 'z': '1'}, 'adjBuffer': {'x': str(size ** 4), 'y': '1', 'z': '1'}, 'infoBuffer': {'x': '5', 'y': '1', 'z': '1'}}

	# Find the buffers element
	buffers = root.find('buffers')

	for buffer in buffers.findall('buffer'):
		# Get the name of the buffer
		name = buffer.get('name')
		# If the name is in the values dictionary, update the DIM values
		if name in values:
			dim = buffer.find('DIM')
			dim.set('x', values[name]['x'])
			dim.set('y', values[name]['y'])
			dim.set('z', values[name]['z'])

	# Write the changes back to the file
	tree.write('cloth.mlib')

# Generate cloth mesh and write .obj file
size = 10
vertices, faces_front, faces_back, normals, tex_coords = generate_cloth_mesh(size)
write_obj_file(size, vertices, faces_front, faces_back, normals, tex_coords, 'cloth.obj')