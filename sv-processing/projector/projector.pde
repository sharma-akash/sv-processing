import com.google.gson.annotations.*;
import com.google.gson.*;
import com.google.gson.internal.*;
import com.google.gson.internal.bind.*;
import com.google.gson.internal.bind.util.*;
import com.google.gson.reflect.*;
import com.google.gson.stream.*;

// Main application for producing visualizations
import spout.*;
import hypermedia.net.*;

import java.util.*;
import java.lang.*;

public class Scene
{
  int width = 640;
  int height = 480;
  boolean drawn = false;
  Map<String, Command> vizMap;
  Visualization viz;
}

interface Command
{
  void drawViz();
}

public class VisualizationCommand
{
  int sensorID;
  String startDate;
  String endDate;
}

public class VisualizationData
{
  String visualization;
  int[] values;
}

// Create the scene state settings object.
Scene s = new Scene();

Deque<VisualizationData> cmds;

// Provide a spout object for sending/recieving.
Spout spout;

// UDP component
UDP udp_client;

// JSON parser
Gson gson = new Gson();

float r=255, g=255, b = 255;

int[] data;



  
String selectedVisualization = "line";

void settings()
{
  // Ensure P3D is set
  size(s.width, s.height, P3D);
}

void setup()
{
  s.vizMap = new HashMap<String, Command>();

  s.vizMap.put("line", new Command() {
    public void drawViz() { lineGraph(data); };
  });

  s.vizMap.put("scatter", new Command() {
    public void drawViz() { scatterPlot(data); };
  });

  s.vizMap.put("bargraph", new Command() {
    public void drawViz() { barGraph(data, (float)s.height-(s.height/3), (float)s.width/data.length, (float)s.height/2); };
  });
  
  s.vizMap.put("gradient", new Command() {
    public void drawViz() { gradient(data); };
  });
  
  s.vizMap.put("proportional", new Command() {
    public void drawViz() { proportional(data); };
  });

  // Setup our program
  // Deque of commands in
  cmds = new ArrayDeque<VisualizationData>();

  ArrayList<Float> d = noiseLine(0.0, .05, 1, s.width);

  int[] e = new int[d.size()];
  for (int i = 0; i < d.size(); i++)
  {
    e[i] = int(s.height*d.get(i));
  }

  data = e;
  //s.viz = new ScatterPlot(e);

  //// Setup our network
  // Initialize udp client.
  udp_client = new UDP(this, 8051);

  // Turn on logging
  //udp_client.log(true);

  udp_client.listen(true);

  // Initialize spout
  spout = new Spout(this);
  String sender_name = "AR visualizations";

  // Set initial background color
  background(r, g, b);
}

void draw()
{
  println(data);
  if (!cmds.isEmpty())
  {
    VisualizationData cmd = cmds.pop();
    data = cmd.values;
    selectedVisualization = cmd.visualization;
    s.drawn = false;
  }

  //((ScatterPlot) s.viz).drawLine();
  //s.viz.drawn = false;
  if (!s.drawn)
  {
    s.vizMap.get(selectedVisualization).drawViz();
    s.drawn = true;
  }

  // Send the spout texture to memory
  spout.sendTexture();
}

// UDP recieve handler. Name is set automatically.
void receive(byte[] d, String ip, int port)
{
  String msg = new String(d);
  JSONObject json = parseJSONObject(msg);

  if (json == null)
  {
    println("JSONObject not parsed.");
  }
  else
  {
    VisualizationData m = gson.fromJson(msg, VisualizationData.class);
    println(m.visualization);
    println(m.values);
    println(m);
    cmds.push(m);
  }
}