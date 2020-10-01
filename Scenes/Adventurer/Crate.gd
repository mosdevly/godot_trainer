extends StaticBody2D

# Animation Tree State Machine
# This refers to the AnimationTree, which, in a nutshell, stores all player
# animations as a tree and travels along the tree to perform the animation
# requested.
var state_machine
export (int) var max_hits = 2 

func _ready() -> void:
    state_machine = $AnimationTree.get("parameters/playback")

func _on_HitArea_area_entered(area: Area2D) -> void:
    if max_hits:
        state_machine.travel("hit")
        max_hits -= 1
    elif not max_hits:
        state_machine.travel("shatter") 
