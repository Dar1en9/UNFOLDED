@tool

extends Sprite3D

var sqeesh_diformation := Vector3(0.89, 1.11, 1.0)
var sqeesh_duration := 0.17

var tween
var transtween

func squish_animation():
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, "scale", sqeesh_diformation, sqeesh_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector3(sqeesh_diformation.y, sqeesh_diformation.x, 1.0), sqeesh_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "scale", Vector3.ONE, sqeesh_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.play()


func transition_animation(duration : float):
	var material = material_override as ShaderMaterial
	
	if transtween:
		transtween.kill()
	transtween = create_tween()
	
	transtween.tween_property(material, "shader_parameter/transform_ind", 1.0, duration)
	transtween.play()
