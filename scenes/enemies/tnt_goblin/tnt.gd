extends Area2D

const SPEED := 300

var direction: Vector2
var explode = false

@onready var health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	decide_direction()
	health_component.health_changed.connect(on_health_changed)

func _physics_process(delta: float) -> void:
	if not explode:
		global_position += SPEED * direction * delta

func decide_direction():
	direction = (GameManager.character_now.global_position - global_position).normalized()


func _on_area_entered(area: Area2D) -> void:
	%AnimationPlayer.play("explode")
	explode = true


func _on_body_entered(body: Node2D) -> void:
	%AnimationPlayer.play("explode")
	explode = true

func on_health_changed():
	%AnimationPlayer.play("explode")
	explode = true
