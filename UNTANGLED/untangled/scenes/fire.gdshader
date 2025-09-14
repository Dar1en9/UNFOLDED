shader_type spatial;

uniform sampler2D albedo_texture;

uniform float vawe_period : hint_range(0, 33);
uniform float vawe_hight : hint_range(-.1, .1);

uniform float speed;

uniform float diformation;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float x = cos(UV.y * vawe_period + TIME * speed ) * vawe_hight;
	float y = sin(UV.x * vawe_period + TIME * speed  ) * vawe_hight;

	vec2 offset;

	offset = vec2(x, y) * (1. - UV.y);
	vec4 res = texture(albedo_texture, UV + offset);
	ALBEDO = res.xyz;
	ALPHA = res.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
