class_name Quality

func getCoverQuality(location, iterations, characterSize,vertices):
	# Set up the initial angle
	var theta = 0
	var RADIUS = 20
	var RANDOM_RADIUS = 10
	var ANGLE = 180

	# We start with no hits
	var hits = 0
	for i in range(iterations):
		# Create the from location
		var from = location
		from.x += RADIUS * cos(theta) + randomBinomial() * RANDOM_RADIUS
		from.y += randf() * 2 * RANDOM_RADIUS
		#from.z += RADIUS * sin(theta) + randomBinomial() * RANDOM_RADIUS
	# Check for a valid from location
		if not inSameRoom(from, location,vertices): 
			break

		# Create the to location
		var to = location
		to.x += randomBinomial() * characterSize.x
		to.y += randf() * characterSize.y
		#to.z += randomBinomial() * characterSize.z

		# Do the check
		
		if doesRayCollide(from, to,location): 
			hits+=1
			# Update the angle
			theta += ANGLE
	return float(hits) / float(iterations)

var rng = RandomNumberGenerator.new()    

func randomBinomial():
	rng.randomize()
	return rng.randi_range(0,1)-rng.randi_range(0,1)
func inSameRoom(x,y,vertices):
	return visibleF(x,y,vertices)
	
func visibleF(p1,p2,S):
	var line1 = p2-p1
	var lines = S 
	var visible = true
	for line2 in lines:		
		if (line2[1] == p1 and line2[0] == p2) or (line2[0]==p1 and line2[1]==p2):
			continue
		if Geometry2D.segment_intersects_segment(line2[1],line2[0],p1,p2) == null:
			visible = visible and true
		if Geometry2D.segment_intersects_segment(line2[0],line2[1],p1,p2) == null:
			visible = visible and true
		if Geometry2D.segment_intersects_segment(line2[1],line2[0],p2,p1) == null:
			visible = visible and true
		if Geometry2D.segment_intersects_segment(line2[0],line2[1],p2,p1) == null:
			visible = visible and true
		else:
			visible = visible and false
			return visible		
	return visible
	
func doesRayCollide(from,to,location):
	if Geometry2D.segment_intersects_segment(from, to, to, location)!= null:
		return true
	else:
		return false

func getVisibilityQuality(location, iterations, characterSize,vertices):
	# Set up the initial angle
	var theta = 0
	var RADIUS = 20
	var RANDOM_RADIUS= 10
	var ANGLE = 180

	# We start with no hits
	var hits = 0
	for i in range(iterations):
		# Create the from location
		var from = location
		from.x += RADIUS * cos(theta) + randomBinomial() * RANDOM_RADIUS
		from.y += randf() * 2 * RANDOM_RADIUS
		#from.z += RADIUS * sin(theta) + randomBinomial() * RANDOM_RADIUS
	# Check for a valid from location
		if not inSameRoom(from, location,vertices): 
			break

		# Create the to location
		var to = location
		to.x += randomBinomial() * characterSize.x
		to.y += randf() * characterSize.y
		#to.z += randomBinomial() * characterSize.z

		# Do the check
		hits+=rayLength(from, to)
		# Update the angle
		theta += ANGLE
	return float(hits) / float(iterations)
	
func rayLength(x,y):
	return (y-x).length_squared()
		
		
		
func getSniperQuality(location, iterations, characterSize,vertices):
	# Set up the initial angle
	var theta = 0
	var RADIUS = 20
	var RANDOM_RADIUS= 10
	var ANGLE = 180

	# We start with no hits
	var hits = 0
	for i in range(iterations):
		# Create the from location
		var from = location
		from.x += RADIUS * cos(theta) + randomBinomial() * RANDOM_RADIUS
		from.y += randf() * 2 * RANDOM_RADIUS
		#from.z += RADIUS * sin(theta) + randomBinomial() * RANDOM_RADIUS
	# Check for a valid from location
		if not inSameRoom(from, location,vertices): 
			break

		# Create the to location
		var to = location
		to.x += randomBinomial() * characterSize.x
		to.y += randf() * characterSize.y
		#to.z += randomBinomial() * characterSize.z

		# Do the check
		if doesRayCollide(from, to,location):
			hits+=rayLength(from, to)
			# Update the angle
			theta += ANGLE
	return float(hits) / float(iterations)
	

func getTerrainQuality(location, iterations, characterSize,vertices):
	# Set up the initial angle
	var theta = 0
	var RADIUS = 20
	var RANDOM_RADIUS= 10
	var ANGLE = 180

	# We start with no hits
	var hits = 0
	for i in range(iterations):
		# Create the from location
		var from = location
		from.x += RADIUS * cos(theta) + randomBinomial() * RANDOM_RADIUS
		from.y += randf() * 2 * RANDOM_RADIUS
		#from.z += RADIUS * sin(theta) + randomBinomial() * RANDOM_RADIUS
	# Check for a valid from location
		if not inSameRoom(from, location,vertices): 
			break

		# Create the to location
		var to = location
		to.x += randomBinomial() * characterSize.x
		to.y += randf() * characterSize.y
		#to.z += randomBinomial() * characterSize.z

		# Do the check
		hits+=rayLength(from, to)
		# Update the angle
		theta += ANGLE
	return float(hits) / float(iterations)
