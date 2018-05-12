public class Visualization
{
  Boolean drawn = false;
  private int[] data;
  
  public void setData(int[] d)
  {
    println("setting data");
    data = d;
  }
  
  public void draw()
  {
    if (!drawn)
    {
      text("No Viz", 0, (float)s.height/2+3);
    }
    drawn = true;
  }
}

float[][] heat_array;

void lineGraph(int[] data)
{
  clear();
  int max = findMax(data);

  stroke(color(255, 255, 255));
  noFill();
  beginShape();
  for (int i = 0; i < data.length; i++)
  {
    vertex(map(i, 0, data.length, 20, s.width-20),
            map(data[i], 0, max, 20, s.height-20));
  }
  endShape();
}

void scatterPlot(int[] data)
{
  clear();
  println("drawing plot");
  println(data);
  int max = findMax(data);
  for (int i = 0; i < data.length; i++)
  {
    ellipse(map(i, 0, data.length, 5, s.width-5),
            map(data[i], 0, max, 5, s.height-5), 4, 4);
  }
}

void checkerBoard() {
  for (int i = 0; i < s.width; i += 50)
  {
    for (int j = 0; j < s.height; j += 50)
    {
      if ((i+j)%20 == 0)
      {
        fill(150,0,0);
      }
      else
      {
        fill(100,0,0);
      }
      rect(i, j, 50, 50);
    }
  }
}

int findMax(int[] d)
{
  int m = d[0];
  for (int i = 0; i < d.length; i++)
  {
    if (d[i] > m)
    {
      m = d[i];
    }
  }
  return m;
}

void barGraph(int[] v, float y, float f, float s)
{
  clear();
  for (int i = 0; i < v.length; i++)
  {
    //println(v[i]);
    colorMode(HSB,1.0);
    fill(v[i], 1.0, 1.0);

    rect(i*f, y, f, -v[i]*s);
  }
}

void proportional(int[] data){
  clear();
  int sum = 0;
  int avg = 0;
  int total = 0;
  for (int i = 0; i < data.length; i++){
    sum += data[i];
    total++;
  }
  avg = sum/total;
  translate(500, height*0.35, -200);
  sphere(avg);
}

void gradient(int[] data){
  /*int sum = 0;
  int avg = 0;
  int total = 0;
  for (int i = 0; i < data.length; i++){
    sum += data[i];
    total++;
  }
  avg = sum/total;
  
  clear();
  noStroke();
  ellipseMode(RADIUS);
  frameRate(1);
  colorMode(HSB, 360, 100, 100);

  drawGradient(width/2, height/2, avg);
  */
}

void drawGradient(float x, float y, int avg) {

  
  int radius = width/3;
  float h = avg%360;
  for (int r = radius; r > 0; --r) {
    fill(h, 90, 90);
    ellipse(x, y, r, r);
    h = (h + 1) % 360;
  }
}

/*
void heatMap(float c) {  // Generate the heat map
  for (int h = 0; h < height; h++) {
    for (int w = 0; w < width; w++) {
      // Range is 24.8 - 30.8
      heat_array[w][h] = 24.8 + 6.0 * noise(h * 0.01, w * 0.02);
    }
  }
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
      value = constrain(value, 25, 30);
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
*/