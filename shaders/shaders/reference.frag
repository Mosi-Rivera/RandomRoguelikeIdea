extern Image reference;
extern vec2 size;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    vec2 reference_coords = Texel(texutre, texture_coords).rg;
    reference_coords.x /= size.x;
    reference_coords.y /= size.y;
    return (Texel(reference, reference_coords));
}