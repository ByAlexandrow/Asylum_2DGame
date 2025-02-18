extends CharacterBody2D
class_name Player

var _is_in_mountain: bool = false
var _can_attack = true
var _attack_animation_name: String = ""

@export_category("Variables")
@export var _move_speed: float = 200.0
@export var _left_attack_name: String = ""
@export var _right_attack_name: String = ""

@export_category("Objects")
@export var _sprite2D: Sprite2D
@export var _bridge: TileMapLayer
@export var _animation: AnimationPlayer


func _ready() -> void:
	update_mountain_state(_is_in_mountain)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	_move()
	_attack()
	_animate()


func _move() -> void:
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	
	velocity = _direction * _move_speed
	move_and_slide()


func _attack() -> void:
	if Input.is_action_just_pressed("left_attack") and _can_attack:
		_can_attack = false
		_attack_animation_name = _left_attack_name
		set_physics_process(false)
	
	if Input.is_action_just_pressed("right_attack") and _can_attack:
		_can_attack = false
		_attack_animation_name = _right_attack_name
		set_physics_process(false)


func _animate() -> void:
	if velocity.x > 0:
		_sprite2D.flip_h = false
	
	if velocity.x < 0:
		_sprite2D.flip_h = true
	
	if _can_attack == false:
		_animation.play(_attack_animation_name)
		return
	
	if velocity:
		_animation.play("PawnBlueRun")
		return
	
	_animation.play("PawnBlueIdle")


func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "PawnBlueAttackHammer" or _anim_name == "PawnBlueAttackAxe":
		_can_attack = true
		set_physics_process(true)


func update_collision_layer_mask(_type: String) -> void:
	if _type == "in":
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
		
	if _type == "out":
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)


func update_mountain_state(_state: bool) -> void:
	_is_in_mountain = _state
	if _is_in_mountain == false:
		_bridge.z_index = 1
	
	if _is_in_mountain == true:
		_bridge.z_index = 0


func get_is_in_mountain() -> bool:
	return _is_in_mountain
