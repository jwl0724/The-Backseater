shader_type canvas_item;


void fragment() {
	float dist = length(UV - vec2(0.5));
	float alpha = smoothstep(0.5, 0.495, dist);
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = vec4(tex_color.rgb, tex_color.a * alpha);
}