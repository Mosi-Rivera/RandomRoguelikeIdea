extern Image reference;
extern vec2 size;
extern vec4 color = vec4(0, 0, 0, 1);
extern float percent;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    vec4 data = Texel(texture, texture_coords);
    vec2 move = normalize(vec2((data.x - 0.5) * 2, (data.y - 0.5 * 2)));
    return (data.b > percent ? Texel(reference, reference_coords + data.b * move) : color);
}