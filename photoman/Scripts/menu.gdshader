shader_type canvas_item;

// Wymuszamy powtarzanie teksturowania (repeat_enable) bezpośrednio w samplerze
uniform sampler2D noise_texture : repeat_enable;
uniform vec2 speed = vec2(0.1, 0.1);

void fragment() {
    // Przesuwamy współrzędne UV w czasie
    vec2 shifted_uv = UV + TIME * speed;
    
    // Pobieramy kolor z przypisanej tekstury z nowymi współrzędnymi
    COLOR = texture(noise_texture, shifted_uv);
}