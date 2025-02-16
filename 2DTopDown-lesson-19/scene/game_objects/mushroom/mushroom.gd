extends CharacterBody2D

var max_speed = 50

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component = $HealthComponent

@export var death_scene: PackedScene 
@export var sprite: CompressedTexture2D


func _ready() -> void:
	health_component.died.connect(on_died)

func _process(delta):
	var direction = get_direction_to_player()
	velocity = max_speed * direction
	move_and_slide()
	
	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	var face_sing = sign(direction.x)
	if face_sing != 0:
		animated_sprite_2d.scale.x = face_sing


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - global_position).normalized()
	return Vector2(0,0)
	
func on_died():
	var back_layer = get_tree().get_first_node_in_group("back_layer")
	var death_instance = death_scene.instantiate() as DeathComp
	back_layer.add_child(death_instance)
	death_instance.gpu_particles_2d.texture = sprite
	death_instance.global_position = global_position
	queue_free()
