class_name Trail2D
extends MeshInstance2D

class TrailMeshPoint extends RefCounted:
	var position: Vector2
	var lifespan: float = 0.0
	
	func older_than(time: float) -> bool:
		return lifespan >= time

var points: Array[TrailMeshPoint] = []

@export var enabled: bool = true

@export var scale_texture: bool = true
@export var from_width: float = 0.5
@export var to_width: float = 0.0
@export_range(0.5, 1.5) var scale_acceleration: float  = 1.0

@export var minimum_distance: float = 0.1
@export var point_duration: float = 1.0


@onready var previous_position: Vector2 = global_position

func _ready() -> void:
	mesh = ImmediateMesh.new()

func _process(delta: float) -> void:
	if enabled and previous_position.distance_to(global_position) > minimum_distance:
		previous_position = global_position
		add_point(global_position)
	
	clear_old_points(delta)
	update_mesh()

func _is_old(point: TrailMeshPoint, time_elapsed: float) -> bool:
	point.lifespan += time_elapsed
	return not point.older_than(point_duration)

func clear_old_points(time_elapsed: float) -> void:
	points.assign(points.filter(_is_old.bind(time_elapsed)))

func update_mesh() -> void:
	mesh.clear_surfaces()
	
	if points.size() < 2:
		return
	
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	
	for index: int in points.size():
		var point: TrailMeshPoint = points[index]
		var percentage: float = float(index) / (points.size() - 1.0)

		var vertices := perpendicular_points(point.position, get_parent().rotation, from_width)
		mesh.surface_set_uv(Vector2(percentage, 0))
		mesh.surface_add_vertex_2d(to_local(vertices[0]))
			
		mesh.surface_set_uv(Vector2(percentage, 1))
		mesh.surface_add_vertex_2d(to_local(vertices[1]))
	
	mesh.surface_end()

func add_point(point_position: Vector2) -> void:
	var new_point := TrailMeshPoint.new()
	new_point.position = point_position
	points.append(new_point)

func remove_point(index: int) -> void:
	points.remove_at(index)

func perpendicular_points(point: Vector2, theta: float, width: float) -> Array[Vector2]:
	# Find angle perpendicular to theta
	var perp_angle: float = theta + PI / 2.0 

	# Calculate half-width for symmetric points
	var half_width: float = width / 2.0

	# Calculate the coordinates of the two points
	var x1: float = point.x + half_width * cos(perp_angle)
	var y1: float = point.y + half_width * sin(perp_angle)

	var x2: float = point.x - half_width * cos(perp_angle)
	var y2: float = point.y - half_width * sin(perp_angle)

	return [Vector2(x1, y1), Vector2(x2, y2)]
