import http.requests.*;
import java.util.*;
import java.time.format.*;
import java.time.*;
import spout.*;

// Some constants for our scene.
int x_limit = 640;
int y_limit = 480;
int frame_rate = 60;

Spout spout;

float darray[];

float c_value = 1;

public class Data
{
  public long time;
  public float value;
}

// Array of Data Objects.
Data[] data;

void barGraph(float[] v, float y, float f, float s)
{
  for (int i = 0; i < v.length; i++)
  {
    //println(v[i]);
    colorMode(HSB,1.0);
    fill(v[i], 1.0, 1.0);

    rect(i*f, y, f, -v[i]*s);
  }
}

void settings()
{
  // Create size of display.
  size(x_limit, y_limit, P3D);
  

}
void setup() 
{
  // Set framerate.
  frameRate(frame_rate); 
  background(0);
  // Make request for file
  GetRequest get = new GetRequest("http://localhost:8529/_db/sensor_collection/_api/document/some_building/2152");
  get.addHeader("Authorization", "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjAyMjE3ODksImlhdCI6MS41MTc2Mjk3ODk4NjYyODJlKzYsImlzcyI6ImFyYW5nb2RiIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidGVzdGVyIn0=.3RLQYazlpSl-pwIRTdVAdDSy_2c_XwEkbbcUYBBoICI=");
  get.send();
  
  JSONObject j = parseJSONObject(get.getContent());
  JSONArray a;
  println(j);
  if (j == null)
  {
    println("Error loading JSON object");
  }
  else
  {  
    DateTimeFormatter f = DateTimeFormatter.ofPattern("MMM dd HH:mm:ss uuuu");
    a = j.getJSONArray("Readings");
    data = new Data[a.size()];
    for (int i = 0; i < a.size(); i++)
    {
      JSONObject o = a.getJSONObject(i);
      data[i] = new Data();
      ZonedDateTime t = LocalDateTime.from(f.parse(o.getString("time")+" 2018")).atZone(ZoneId.systemDefault());
      data[i].time = t.toEpochSecond();
      data[i].value = o.getFloat("value");
    }
  }
  
  darray = new float[data.length];
  for(int i = 0; i < data.length; i++) {
    darray[i] = data[i].value;
  }
  println(x_limit/darray.length);
  
  spout = new Spout(this);
  spout.createSender("Spout from Processing");
}


void draw()
{
  barGraph(darray, y_limit-y_limit/(3+c_value), (float)x_limit/darray.length, y_limit/2);
  spout.sendTexture();
}

void mouseClicked()
{
    println(c_value);
    if (c_value < 3.0)
    {
      c_value += .05;
    }
    else
    {
      c_value = 1.0;
    }
}