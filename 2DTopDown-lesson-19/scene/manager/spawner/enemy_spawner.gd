extends Node

@onready var timer: Timer = $Timer


@export var mushroom_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager
@export var goblin_scene: PackedScene

var base_spawn_time
var min_spawn_time = 0.2
var difficulty_multipleier = 0.01
var enemy_pool = EnemyPoll.new()

func _ready() -> void:
	enemy_pool.add_mob(mushroom_scene, 30)
	base_spawn_time = timer.wait_time
	arena_time_manager.difficulty_increased.connect(on_difficulty_increased)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var random_distance = randi_range(380, 500)
	
	for i in 24:
		spawn_position = player.global_position + (random_direction * random_distance)
		var raycast = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var intersection = get_tree().root.world_2d.direct_space_state.intersect_ray(raycast)
	
		if intersection.is_empty():
			break
		
		else:
			random_direction = random_direction.rotated(deg_to_rad(15))
	
	return spawn_position

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var chosen_mob = enemy_pool.pick_mob()
	var enemy = chosen_mob.instantiate() as Node2D
	var back_layer = get_tree().get_first_node_in_group("back_layer")
	back_layer.add_child(enemy)
	
	enemy.global_position = get_spawn_position()

func on_difficulty_increased(difficulty_level: int):
	var new_spawn_time = max(min_spawn_time, (base_spawn_time - (difficulty_level * difficulty_multipleier)))
	timer.wait_time = new_spawn_time
	
	if difficulty_level == 1:
		enemy_pool.add_mob(goblin_scene, 70)
		
		
