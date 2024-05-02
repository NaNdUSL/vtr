import xml.etree.ElementTree as ET

# Function to generate a squared mesh of cloth
def generate_cloth_mesh(height, width):

	vertices = []
	tex_coords_front = []
	faces_front = []
	faces_back = []

	# Generate vertices
	for z in range(height):

		for x in range(width):

			vertices.append([x, 0, z])

			tex_coords_front.append([x / (width - 1), z / (height - 1)])
	
	vertices = vertices
	normals = [[0, 1, 0], [0, -1, 0]]
	tex_coords = tex_coords_front

	# Generate faces
	for z in range(height - 1):

		for x in range(width - 1):

			v1 = z * width + x
			v2 = z * width + x + 1
			v3 = (z + 1) * width + x
			v4 = (z + 1) * width + x + 1

			faces_front.append([v1, v3, v2])
			faces_front.append([v2, v3, v4])

	return vertices, faces_front, faces_back, normals, tex_coords

def generate_cloth_adj(height, width):

	adj = {}

	for i in range(height*width):

		adj[i] = [-1 for _ in range(height*width)]

	counter = 0
	mat = []

	for _ in range(height):

		int_mat = []

		for _ in range(width):

			int_mat.append(counter)
			counter += 1

		mat.append(int_mat)

	# print(mat)

	adj_list = []

	for j in range(height):
		
		for i in range(width):

			above = []
			same_line = []
			under = []

			for x in range(-1, 2):

				if i + x >= 0 and i + x < width and j - 1 >= 0 and 0 != x:

					above.append((i + x, j - 1, 1.414))

				elif i + x >= 0 and i + x < width and j - 1 >= 0:

					above.append((i + x, j - 1, 1))

				if i + x >= 0 and i + x < width and 0 != x:

					same_line.append((i + x, j, 1))

				if i + x >= 0 and i + x < width and j + 1 < height and 0 != x:

					above.append((i + x, j + 1, 1.414))

				elif i + x >= 0 and i + x < width and j + 1 < height:

					above.append((i + x, j + 1, 1))

			indices = above + same_line + under
			indices.sort(key=lambda x: (x[1], x[0]))
			
			adj_list.append(indices)
		
	for i in range(len(adj_list)):

		for tuple in adj_list[i]:

			adj[i][tuple[1] * width + tuple[0]] = tuple[2]

	for i in range(height*width):

		adj[i][i] = 0

	return adj

# Function to write a .obj file
def write_obj_file(height, width, vertices, faces_front, faces_back, normals, tex_coords, filepath_obj):

	vert_stuck = [0, width - 1]

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

		adj = generate_cloth_adj(height, width)

		for elem in adj:

			for weight in adj[elem]:

				f.write(f"{weight}\n")
	
	with open('cloth_vars_info.txt', 'w') as f:

		f.write(f"{height}\n{width}\n{0.80}\n{100.0}\n{height*width}\n0.0\n")

		f.write(f"{len(vert_stuck)}\n")

		for ind in vert_stuck:

			f.write(f"{ind}\n")
	
	with open('cloth_normals_info.txt', 'w') as f:

		for _ in vertices:

			f.write(f"0.0 1.0 0.0\n")

	# Update the number of elements in the .mlib file
	tree = ET.parse('cloth.mlib')
	root = tree.getroot()

	values = {'clothBuffer': {'x': str(height * width), 'y': '4', 'z': '1'}, 'adjBuffer': {'x': str(height * width * height * width), 'y': '1', 'z': '1'}, 'infoBuffer': {'x': str(7 + len(vert_stuck)), 'y': '1', 'z': '1'}, 'normalsBuffer': {'x': str(height * width), 'y': '3', 'z': '1'}}

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
height = 10
width = 10
vertices, faces_front, faces_back, normals, tex_coords = generate_cloth_mesh(height, width)
write_obj_file(height, width, vertices, faces_front, faces_back, normals, tex_coords, 'cloth.obj')