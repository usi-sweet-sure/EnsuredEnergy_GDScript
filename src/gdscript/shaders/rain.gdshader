// Rain and Snow shader by Brian Smith (steampunkdemon.itch.io)
// MIT licence

shader_type canvas_item;

uniform float rain_amount = 200.0;
uniform float near_rain_length : hint_range(0.01, 1.0) = 0.2;
uniform float far_rain_length : hint_range(0.01, 1.0) = 0.1;
uniform float near_rain_width : hint_range(0.1, 1.0) = 1.0;
uniform float far_rain_width : hint_range(0.1, 1.0) = 0.5;
uniform float near_rain_transparency : hint_range(0.1, 1.0) = 1.0;
uniform float far_rain_transparency : hint_range(0.1, 1.0) = 0.5;
// Replace the below reference to source_color with hint_color if you are using a version of Godot before 4.
uniform vec4 rain_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform float base_rain_speed : hint_range(0.1, 1.0) = 0.5;
uniform float additional_rain_speed : hint_range(0.1, 1.0) = 0.5;
uniform float slant : hint_range(-1.0, 1.0) = 0.2;
uniform bool is_snow = false;

void fragment() {
// To control the rainfall from your program comment out the below line and add a new uniform above as:
// uniform float time = 10000.0;
// Then update the time uniform from your _physics_process function by adding delta. You can then pause the rainfall by not changing the time uniform.
	float time = 10000.0 + TIME;

// Uncomment the following line if you are applying the shader to a TextureRect and using a version of Godot before 4.
//	COLOR = texture(TEXTURE,UV);

	vec2 uv = vec2(0.0);
	float remainder = mod(UV.x - UV.y * slant, 1.0 / rain_amount);
	uv.x = (UV.x - UV.y * slant) - remainder;
	float rn = fract(sin(uv.x * rain_amount));
	uv.y = fract((UV.y + rn));
	
	float fade_x = 0.3;
	float fade_y = 0.3;
	
	if (is_snow) {
		fade_x = 0.2;
		fade_y = 0.2;
	}
	
	float alpha_x = smoothstep(0.0, 1.0, 1.0 - distance(UV.x, 0.5) - fade_x);
	float alpha_y = smoothstep(0.0, 1.0, 1.0 - distance(UV.y, 0.5) - fade_y);
	

	
	float alpha = alpha_x * alpha_y;
	vec4 rain_color_alphaed = rain_color;
	rain_color_alphaed.a = alpha;
	
	if(is_snow) {
		float far_rain_length_override = 0.01;
		float near_rain_lengt_override = 0.01;
		float base_rain_speed_override = 0.1;
		float additional_rain_speed_override = 0.2;
		COLOR = mix(COLOR, rain_color_alphaed, step(1.0 - (far_rain_length_override + (near_rain_lengt_override - far_rain_length_override) * rn), fract(uv.y - time * (base_rain_speed_override + additional_rain_speed_override * rn))) * (far_rain_transparency + (near_rain_transparency - far_rain_transparency) * rn) * step(remainder * rain_amount, far_rain_width + (near_rain_width - far_rain_width) * rn));
	} else {
		COLOR = mix(COLOR, rain_color_alphaed, smoothstep(1.0 - (far_rain_length + (near_rain_length - far_rain_length) * rn), 1.0, fract(uv.y - time * (base_rain_speed + additional_rain_speed * rn))) * (far_rain_transparency + (near_rain_transparency - far_rain_transparency) * rn) * step(remainder * rain_amount, far_rain_width + (near_rain_width - far_rain_width) * rn));
	}
}