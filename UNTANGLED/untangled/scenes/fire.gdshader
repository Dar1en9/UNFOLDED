shader_type spatial;

uniform sampler2D init_texture;
uniform sampler2D trans_texture;
uniform sampler2D noise_texture;

uniform float vawe_period : hint_range(0, 33);
uniform float vawe_hight : hint_range(-.1, .1);

uniform float speed;

uniform float transform_ind;


void fragment() {
	float x = cos(UV.y * vawe_period + TIME * speed ) * vawe_hight;
	float y = sin(UV.x * vawe_period + TIME * speed  ) * vawe_hight;

	vec2 offset = vec2(x, y) * (1. - UV.y);
	float real_trans_ind = transform_ind * (texture(noise_texture, UV - offset * 5.).x + .5);
	float light_trans_ind = 1. - abs(transform_ind - 0.5) * 2.;
	
	vec4 res;
	if (real_trans_ind < 0.5) {
		res = texture(init_texture, UV + offset)  * (light_trans_ind * 4. + 1.);
	}
	else {
		res = texture(trans_texture, UV);

	}
	ALBEDO = res.xyz;
	ALPHA = res.a;
}

//void light() {
	//DIFFUSE_LIGHT = vec3(1.) * ALBEDO;
//}
