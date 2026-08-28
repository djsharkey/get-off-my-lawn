extends Node

signal item_grabbed(item: Item, owner: Node3D)
signal item_used(item: Item, owner: Node3D)
signal item_dropped(item: Item)
signal grass_cut(area_instance: Area3D) # would this go here for increasing progress? also in line 3 of grass_area3d.gd
