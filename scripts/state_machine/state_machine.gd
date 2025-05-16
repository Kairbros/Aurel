class_name StateMachine extends Node

@onready var controlled_node = self.owner
@export var default_state : StateBase 
var last_state_name : String 
var current_state : StateBase 

func _ready() -> void:
	call_deferred("_set_default_state")

func _set_default_state():
	current_state = default_state
	last_state_name = current_state.name
	_start_state_machine()
func _start_state_machine():
	current_state.state_machine = self
	current_state.start()

func change_to(NewState : String):
	last_state_name = current_state.name
	current_state.end()
	current_state = get_node(NewState)
	_start_state_machine()

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)
func _process(delta: float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)
func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)
