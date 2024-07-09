@tool
extends Node2D

@onready var test: Sprite2D = $test
@onready var bird_particles: GPUParticles2D = $bird_particles

func _process( _delta : float) -> void:
	test.position = get_local_mouse_position()
	bird_particles.process_material.set_shader_parameter( "repel_pos", get_local_mouse_position() )
	if Input.is_mouse_button_pressed( MOUSE_BUTTON_LEFT ):
		bird_particles.process_material.set_shader_parameter( "range", 256 )
	else:
		bird_particles.process_material.set_shader_parameter( "range", 64 )
