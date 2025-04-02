extends Node


signal block_camera
signal unlock_camera
signal move_camera_to(coord: Vector2) # The final position of the camera
signal move_camera_by(coord: Vector2) # The correction to apply to current camera position
signal reset_camera
signal zoom_camera_to(zoom: Vector2)
