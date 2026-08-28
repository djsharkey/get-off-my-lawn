extends Node

signal item_grabbed(item: Item, owner: Node3D)
signal item_used(item: Item, owner: Node3D)
signal item_dropped(item: Item)
signal interactable_selected(interactable: Interactable)
signal interactable_entered(interactable: Interactable)
signal interactable_exited(interactable: Interactable)
