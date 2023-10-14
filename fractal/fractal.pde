import peasy.*;

PeasyCam cam;
ArrayList<PVector> points;
float n = 3;
int scale = 50;

void exponentiate(PVector v, float n) {
  float x = v.x;
  float y = v.y;
  float z = v.z;
  
  float r_n = pow(x*x+y*y+z*z, n/2);
  float n_phi = n * atan(y/x);
  float n_theta = n * atan(sqrt(x*x+y*y)/z);
  
  v.x = r_n * sin(n_theta) * cos(n_phi);
  v.y = r_n * sin(n_theta) * sin(n_phi);
  v.z = r_n * cos(n_theta);
}

boolean bounded(PVector v) {
  PVector c = v.copy();
  int max_iterations = 100;
  int max_distance_sq = 10000;
  for(int i = 0; i < max_iterations; i++) {
    exponentiate(v, n);
    v.add(c);
    if(v.magSq() > max_distance_sq) return false;
  }
  return true;
}

void calculatePoints(float n_divs) {
  float max = 1;
  float increment = 2*max/n_divs;
  
  for(float x = -max; x<=max; x+=increment)
  for(float y = -max; y<=max; y+=increment)
  for(float z = -max; z<=max; z+=increment) {
    PVector point = new PVector(x,y,z);
    if(bounded(point)) points.add(point);
  }
}

void setup() {
  size(700,700,P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  
  points = new ArrayList<PVector>();
  
  background(255);
  calculatePoints(200);
}

void draw() {
  background(0);
  
  stroke(255);
  strokeWeight(5);
  
  //beginShape();
  for(PVector point : points) point(point.x * scale, point.y * scale, point.z * scale);
  //endShape();
}
