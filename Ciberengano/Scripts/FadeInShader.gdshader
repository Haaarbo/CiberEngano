shader_type canvas_item;

uniform float amount : hint_range(0, 1) = 0.0;
uniform bool mirror_effect = false;

void fragment() {
    float uv_x = mirror_effect ? (1.0 - UV.x) : UV.x;
    COLOR.a = max(0.0, min(1.0, 1.0 - amount + uv_x - mix(0.0, 1.0, amount)));
}