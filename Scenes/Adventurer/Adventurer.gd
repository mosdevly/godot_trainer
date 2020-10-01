extends KinematicBody2D

# Animation Tree State Machine
# This refers to the AnimationTree, which, in a nutshell, stores all player
# animations as a tree and travels along the tree to perform the animation
# requested.
var state_machine
var velocity = Vector2.ZERO
export var run_speed = 80

func _ready():
    # Clicking on AnimationTree in the scene menu, look at the inspector to the Parameters section and see Playback
    state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta: float) -> void:
    get_input()
    velocity = move_and_slide(velocity)

func get_input():
    var current = state_machine.get_current_node()
    velocity = Vector2.ZERO
    
    # FIXME: Using _just_pressed the animation fails to play through.
    if Input.is_action_pressed("attack"):
        state_machine.travel("slash")
        return  # avoid other inputs when attacking
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
        $Sprite.scale.x = $Sprite.scale.y * 1
        state_machine.travel("walk")
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
        $Sprite.scale.x = $Sprite.scale.y * -1
        state_machine.travel("walk")
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    velocity = velocity.normalized() * run_speed
    
    if velocity.length() == 0:
        state_machine.travel('idle')
    if velocity.length() > 0:
        state_machine.travel('walk')


func _on_SwordHitBox_area_entered(area: Area2D) -> void:
    if area.is_in_group("hurtbox"):
        area.take_damage()
