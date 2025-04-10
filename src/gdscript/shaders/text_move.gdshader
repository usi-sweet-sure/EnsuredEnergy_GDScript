shader_type canvas_item;

uniform vec2 direction = vec2(-1.0, 0.0);
uniform float speed = 0.1;
uniform float text_length = 200.0;
uniform bool enters_from_right = false;

void vertex() {
	vec2 delta_x = (direction * fract(TIME * speed) * text_length);

	if (enters_from_right) {
		delta_x += vec2(text_length, 0.0);
	}

	vec2 new_vertex = VERTEX + delta_x;
	VERTEX = new_vertex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
