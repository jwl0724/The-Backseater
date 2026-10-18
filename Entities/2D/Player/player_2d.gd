extends CharacterBody2D
class_name Player2D

@export var base_damage: float = 1
@export var base_move_speed: float = 30
@export var base_health: float = 20
@export var base_health_regen: float = 0.1
@export var base_attack_speed: float = 1 ## the attack interval will be 3 / attack_speed
@export var base_projectile_count: int = 1

var damage: float = base_damage
var move_speed: float = base_move_speed
var health: float = base_health
var health_regen: float = base_health_regen
var attack_speed: float = base_attack_speed
var projectile_count: float = base_projectile_count
