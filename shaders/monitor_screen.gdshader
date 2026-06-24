shader_type spatial;

uniform sampler2D camera_feed : source_color;
uniform sampler2D original_texture : source_color;

group_uniforms Screen_UV_Bounds;
uniform vec2 screen_uv_min = vec2(0.25, 0.5);
uniform vec2 screen_uv_max = vec2(0.56, 0.67);

void fragment() {
	vec4 base = texture(original_texture, UV);
	bool is_screen = UV.x >= screen_uv_min.x && UV.x <= screen_uv_max.x &&
		UV.y >= screen_uv_min.y && UV.y <= screen_uv_max.y;

	if (is_screen) {
		vec2 screen_uv = (UV - screen_uv_min) / (screen_uv_max - screen_uv_min);
		vec4 cam = texture(camera_feed, screen_uv);
		ALBEDO = vec3(0.0);
		EMISSION = cam.rgb;
	} else {
		ALBEDO = base.rgb;
		EMISSION = vec3(0.0);
	}
}
