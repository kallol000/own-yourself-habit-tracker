#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;      // Index 0, 1
uniform float uTime;     // Index 2 (Expected 0.0 to 6.28)
uniform vec3 uColorA;    // Index 3, 4, 5
uniform vec3 uColorB;    // Index 6, 7, 8

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;

    // --- SEAMLESS LOOP LOGIC ---
    // By wrapping uTime in sin/cos, the value at 0.0 is the same as 6.28.
    // This creates a "swaying" motion that never 'snaps'.
    float timeX = sin(uTime); 
    float timeY = cos(uTime);

    // Create organic movement by warping the UV coordinates
    vec2 movement = uv;
    movement.x += timeX * 0.1;
    movement.y += timeY * 0.1;

    // Layer multiple waves for a "mesh" effect
    // Wave 1: Horizontal swaying
    float wave1 = sin(movement.x * 3.0 + timeX);
    
    // Wave 2: Vertical swaying at a slightly different frequency
    float wave2 = cos(movement.y * 3.0 + timeY);

    // Wave 3: Center-out pulse
    float dist = distance(uv, vec2(0.5));
    float wave3 = sin(dist * 5.0 - uTime);

    // Combine the waves to create the "Mix Factor"
    float finalFactor = (wave1 + wave2 + wave3) / 3.0;
    
    // Map from (-1.0 to 1.0) to (0.0 to 1.0)
    finalFactor = finalFactor * 0.5 + 0.5;

    // Output the blend of your two dynamic colors
    fragColor = vec4(mix(uColorA, uColorB, finalFactor), 1.0);
}