shader_type canvas_item;

uniform sampler2D palette : hint_albedo;

void fragment () {
	vec4 sample = texture(TEXTURE, UV);
	float brightness = length(sample.rgb)/2f;
	vec2 coords = vec2(clamp(brightness, 0f, 1f), 0);
	COLOR.rgb = texture(palette, coords).rgb;
	COLOR.a = sample.a;
}