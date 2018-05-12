    import processing.opengl.*;
    import spout.*;
    
    Spout spout;
     
    PVector[] vecs = new PVector[100];
    int num = 400;
     
    void setup() {
      size(1000,1000,OPENGL);
      for (int i=0; i<vecs.length; i++) {
        vecs[i] = new PVector(random(num),random(num),random(num));
      }
       spout = new Spout(this);
       spout.createSender("Spout from Processing");
    }
     
    void draw() {
      background(0);
      translate(width/2,height/2);
      scale(1,-1,1); 
     
      noFill();
      strokeWeight(1);
      box(num);
     
      translate(-num/2,-num/2,-num/2);
      for (int i=0; i<vecs.length; i++) {
        PVector v = vecs[i];
        stroke(255,75);
        strokeWeight(2);
        line(v.x,0,v.z,v.x,v.y,v.z);
        stroke(255);
        strokeWeight(5);
        point(v.x,v.y,v.z);
      }
      
      spout.sendTexture();
    }