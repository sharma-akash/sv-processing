import java.util.*;
import java.lang.*;


import spout.*;
import processing.opengl.*;
import hypermedia.net.*;

Spout spout;
float[][] heat_array;
int[] values;

void setup() {
  size(1200, 1200, OPENGL);
  //// Setup our network
  // Initialize udp client.

  // Turn on logging
  //udp_client.log(true);

 
  
  spout = new Spout(this);
  spout.createSender("Spout from Processing");
  heat_array = new float[width][height];
  makeArray();
  applyColor(1.0);
  
}

// Fill array with Perlin noise (smooth random) values
void makeArray() {
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      // Range is 24.8 - 30.8
      heat_array[w][h] = 24.8 + 6.0 * noise(h * 0.01, w * 0.02);
    }
  }
}
 
void applyColor(float c) {  // Generate the heat map
  pushStyle(); 
  // Set drawing mode to HSB instead of RGB
  colorMode(HSB, 1, 1, 1);
  loadPixels();
  int p = 0;
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      // Get the heat map value 
      float value = heat_array[w][h];
      // Constrain value to acceptable range.
      value = constrain(value, 26, 28);
      // Map the value to the hue
      // 0.2 blue
      // 1.0 red
      value = map(value, 25, 30, 0.2, c*1.0);
      pixels[p++] = color(value, 0.9, 1);
    }
  }
  updatePixels();
  spout.sendTexture();
  popStyle(); 
}

void draw()
{
}