// ~/.config/hypr/shaders/saturation.glsl
#version 320 es
precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // Calcula a luminância (padrão ITU-R BT.709)
    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));

    // Fator de saturação (1.0 = normal, 1.5 = +50% de saturação, 2.0 = dobro)
    float saturation_factor = 2.3;

    vec3 saturated_color = mix(vec3(luma), color.rgb, saturation_factor);

    fragColor = vec4(saturated_color, color.a);
}
