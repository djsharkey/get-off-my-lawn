extends Node

signal item_grabbed(item: Item, owner: Node3D)
signal item_used(item: Item, owner: Node3D)
signal item_dropped(item: Item)
signal interactable_selected(interactable: Interactable)
signal interactable_entered(interactable: Interactable)
signal interactable_exited(interactable: Interactable)
signal grass_cut(area_instance: Area3D) # would this go here for increasing progress? also in line 3 of grass_area3d.gd
signal progress_increased(task: Constants.Tasks, points: float)
signal task_progress_requested(task: Constants.Tasks)
