shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float strength = 3.0;
uniform float lod: hint_range(0.0, 5) = 0.0;

vec4 blur_size(sampler2D tex,vec2 fragCoord, vec2 pixelSize) {
	// This was not working well when animated
    vec4 color = vec4(0.,0.,0.,0.);

    vec2 pixel = fragCoord/pixelSize;
    int x_min = max(int(pixel.x-strength), 0);
    int x_max = min(int(pixel.x+strength), int(1./pixelSize.x));
    int y_min = max(int(pixel.y-strength), 0);
    int y_max = min(int(pixel.y+strength), int(1./pixelSize.y));

    int count =0;

    // Sum the pixels colors
    for(int x=x_min; x <= x_max; x++) {
        for(int y = y_min; y <= y_max; y++) {           
            color += texture(tex, vec2(float(x), float(y)) * pixelSize);
            count++;
        }
    }
    
    // Divide the color by the number of colors you summed up
    color /= float(count);
    
    return color;
}

void fragment() {
    //COLOR = blur_size(SCREEN_TEXTURE,SCREEN_UV,SCREEN_PIXEL_SIZE);
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
}