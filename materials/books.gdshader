shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec3 uv1_scale = vec3(10.0);
uniform vec3 uv1_offset = vec3(0.28, 0.0, 0.0);

varying vec3 instance_position;

float hash(vec3 p) {
    p = fract(p * vec3(443.8975, 397.2973, 491.1871));
    p += dot(p, p.yxz + 19.19);
    return fract(p.x * p.y);
}

void vertex() {
    instance_position = MODEL_MATRIX[3].xyz;
}

void fragment() {
    vec2 uv = UV * uv1_scale.xy;
    uv.x += uv1_offset.x + hash(instance_position);
    ALBEDO = texture(albedo_texture, uv).rgb;
}
