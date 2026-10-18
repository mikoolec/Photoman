extends Camera3D

func scan_visible_objects() -> Array[Dictionary]:
	var visible_list: Array[Dictionary] = []
	
	# 1. Fetch every single object currently in the 'photo_targets' group
	var all_targets = get_tree().get_nodes_in_group("photo_targets")
	print(all_targets)
	
	for target in all_targets:
		# Safety check: make sure the object hasn't been deleted and is a PhotoObject
		if is_instance_valid(target) and target is PhotoObject:
			# 2. Run your SubViewport sight checks
			if is_target_in_sight(target):
				# 3. If visible, add its unique identification profile to our list
				var object_profile = {
					"node": target,
					"name": target.object_id, # "Tree" or "Chair"
					"points": target.point_value
				}
				visible_list.append(object_profile)
				
	return visible_list

# The SubViewport sight check we built earlier
func is_target_in_sight(target: Node3D) -> bool:
	if not is_position_in_frustum(target.global_position):
		return false
	var screen_pos = unproject_position(target.global_position)
	var viewport_rect = Rect2(Vector2.ZERO, get_viewport().size)
	if not viewport_rect.has_point(screen_pos):
		return false
		
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, target.global_position)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	print("lets go")
	if not result.is_empty():
		print("SUCCESS! The ray hit a physical node named: ", result["collider"].name)
	else:
		print("FAILURE: The ray completely missed the Blender submodel collider.")
	if not result.is_empty():

		var current_node = result["collider"]
		
		# Crawl up the scene tree branch starting from the child we hit
		while current_node != null:
			if current_node == target:
				return true # We found our main target higher up in the branch!
			current_node = current_node.get_parent() # Step up one layer
			
	return false # Hit something else completely (like a wall)
