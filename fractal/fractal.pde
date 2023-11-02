import peasy.*;
import java.util.*;

PeasyCam cam;
HashSet<PVector> points;
float n = 16;
int max = 30;
int scale = 20;

float maxDist;
float minDist;

void exponentiate(PVector v, float n) {
  float x = v.x / scale;
  float y = v.y / scale;
  float z = v.z / scale;
  
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

boolean isBoundary(HashSet<PVector> points, PVector currentPoint) {
  for(int dx = -1; dx <= 1; dx++)
  for(int dy = -1; dy <= 1; dy++)
  for(int dz = -1; dz <= 1; dz++) {
    PVector neighbor = new PVector(dx, dy, dz);
    neighbor.add(currentPoint);
    if(!points.contains(neighbor)) return true;
  }
  
  return false;
}

void calculatePoints() {
  HashSet<PVector> allPoints = new HashSet<PVector>();
  
  for(int x = -max; x<=max; x++)
  for(int y = -max; y<=max; y++)
  for(int z = -max; z<=max; z++) {
    PVector point = new PVector(x,y,z);
    if(bounded(point)) allPoints.add(point);
  }
  
  for(PVector point : allPoints) {
    if(isBoundary(allPoints, point)) points.add(point);
  }
}

void calculateDists() {
  maxDist = 0;
  minDist = 1000000;
  
  for(PVector point : points) {
    float dist = point.mag();
    if(dist > maxDist) maxDist = dist;
    if(dist < minDist) minDist = dist;
  }
}

void setup() {
  size(700,700,P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  
  points = new HashSet<PVector>();
  
  background(255);
  calculatePoints();
  calculateDists();
}

void draw() {
  background(0);
  
  stroke(255);
  strokeWeight(1);
  
  for(PVector point : points) {
    stroke(map(point.mag(), minDist, maxDist, 255, 100));
    point(point.x, point.y, point.z);
  }
}
