//
//  textures.metal
//  Thesis
//
//  Created by István Juhász on 2022. 12. 21..
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>

using namespace metal;

[[visible]]
void basicSelectedShader(realitykit::surface_parameters shader)
{
    realitykit::surface::surface_properties ssh = shader.surface();
    half r = abs(0.40000);
    half g = abs(1.00000);
    half b = abs(1.00000);
    ssh.set_base_color(half3(r, g, b));
    ssh.set_roughness(half(0.0));
    ssh.set_clearcoat(half(1.0));
    ssh.set_clearcoat_roughness(half(0.0));
}

[[visible]]
void basicWrongShader(realitykit::surface_parameters shader)
{
    realitykit::surface::surface_properties ssh = shader.surface();
    half r = abs(1.00000);
    half g = abs(0.00000);
    half b = abs(0.00000);
    ssh.set_base_color(half3(r, g, b));
    ssh.set_roughness(half(0.0));
    ssh.set_clearcoat(half(1.0));
    ssh.set_clearcoat_roughness(half(0.0));
}

[[visible]]
void basicCorrectShader(realitykit::surface_parameters shader)
{
    realitykit::surface::surface_properties ssh = shader.surface();
    half r = abs(0.40000);
    half g = abs(1.00000);
    half b = abs(0.40000);
    ssh.set_base_color(half3(r, g, b));
    ssh.set_roughness(half(0.0));
    ssh.set_clearcoat(half(1.0));
    ssh.set_clearcoat_roughness(half(0.0));
}

[[visible]]
void basicModifier(realitykit::geometry_parameters modifier)
{
    float3 pose = modifier.geometry().model_position();
}
