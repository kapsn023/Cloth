

// Link length
float link_length = 0.2;

// Gravity
Vec3 gravity3 = new Vec3(0, 8, 0);

// Scaling factor for the scene
float scene_scale = 1.0;

// Physics Parameters
int relaxation_steps = 1;
int sub_steps = 10;

Camera camera;
int rows = 21;
int cols = 21;
Ball[][] cloth = new Ball[rows][cols];
Vec3 cloth_base = new Vec3(-2, -2, -8);
Sphere2 sphere = new Sphere2(new Vec3(0, 0, -8.5), 0.75);

Boolean drag = true;
Vec3 v_air = new Vec3(0, 0, -1.5);
double p = 1.0;
double cd = 1;

void setup() {
  size(500, 500, P3D);
  camera = new Camera();
  surface.setTitle("Double Pendulum");
    
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < cols; j++){
      cloth[i][j] = new Ball(new Vec3(cloth_base.x + j * link_length, cloth_base.y, cloth_base.z - i * link_length),
          0.05, new Vec3(0, 0, 0), 1.0);  
    }
  }
}

void update_physics(float dt) {
   
 for (int i = 0; i < rows; i++){
    for (int j = 0; j < cols; j++){
      cloth[i][j].last_pos = cloth[i][j].pos;
      cloth[i][j].vel = cloth[i][j].vel.new_add(gravity3.new_mul(dt));
      cloth[i][j].pos = cloth[i][j].pos.new_add(cloth[i][j].vel.new_mul(dt));
    }
  }
  
  // Constrain the distance between nodes to the link length
 for (int k = 0; k < relaxation_steps; k++) {  
   for (int i = 1; i < rows; i++){
     for (int j = 0; j < cols; j++){
       Vec3 delta = cloth[i][j].pos.new_sub(cloth[i-1][j].pos);
       double delta_len = delta.length();
       double correction = delta_len - link_length;
       Vec3 delta_normalized = delta.new_normalize();
       cloth[i][j].pos = cloth[i][j].pos.new_sub(delta_normalized.new_mul(correction / 2));
       cloth[i-1][j].pos = cloth[i-1][j].pos.new_add(delta_normalized.new_mul(correction / 2));
    }
  }
  for (int i = 0; i < rows; i++){
    for (int j = 1; j < cols; j++){
      Vec3 delta = cloth[i][j].pos.new_sub(cloth[i][j-1].pos);
      double delta_len = delta.length();
      double correction = delta_len - link_length;
      Vec3 delta_normalized = delta.new_normalize();
      cloth[i][j].pos = cloth[i][j].pos.new_sub(delta_normalized.new_mul(correction / 2));
      cloth[i][j-1].pos = cloth[i][j-1].pos.new_add(delta_normalized.new_mul(correction / 2));
    }
  }
  
    // Fix the base node in place   
    for (int j = 0; j < cols; j++){
      cloth[0][j].pos = new Vec3(cloth_base.x + j * link_length, cloth_base.y, cloth_base.z);
    }
  }
  
  //for (int i = 1; i < rows; i++){
  //  for (int j = 0; j < cols; j++){
  //    if (cloth[i][j].pos.distanceTo(sphere.pos) < (cloth[i][j].r + sphere.r)){
  //      Vec3 normal = (cloth[i][j].pos.new_sub(sphere.pos)).new_normalize();
  //      cloth[i][j].pos = sphere.pos.new_add(normal.new_mul(sphere.r + cloth[i][j].r).new_mul(1.0));
  //      Vec3 velNormal = normal.new_mul(dot(cloth[i][j].vel,normal));
  //      cloth[i][j].vel.subtract(velNormal.new_mul(1.1));
  //    }
  //  }
  //}
  
  // Update the velocities (PBD)
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < cols; j++){
      cloth[i][j].vel = cloth[i][j].pos.new_sub(cloth[i][j].last_pos).new_mul(1/dt);
    }
  } 
  
  // Add drag force
  if (drag){
    // Goes square by square
    for (int i = 1; i < rows; i++){
      for (int j = 1; j < cols; j++){
        // First Triangle
        Vec3 r1 = cloth[i][j].pos;
        Vec3 r2 = cloth[i-1][j].pos;
        Vec3 r3 = cloth[i-1][j-1].pos;
        Vec3 n = cross(r2.new_sub(r1), r3.new_sub(r1));
        
        Vec3 v1 = cloth[i][j].vel;
        Vec3 v2 = cloth[i-1][j].vel;
        Vec3 v3 = cloth[i-1][j-1].vel;
        Vec3 v = (v1.new_add(v2.new_add(v3)).new_mul(1.0 / 3.0)).new_sub(v_air);
        
        Vec3 faero = n.new_mul((v.length() * dot(v, n)) / (2 * n.length()));
        faero.mul((-1.0/2.0) * p * cd / 3);
        
        v1.add(faero);
        v2.add(faero);
        v3.add(faero);
        
        // Second Triangle
        r1 = cloth[i][j].pos;
        r2 = cloth[i-1][j-1].pos;
        r3 = cloth[i][j-1].pos;
        n = cross(r2.new_sub(r1), r3.new_sub(r1));
        
        v1 = cloth[i][j].vel;
        v2 = cloth[i-1][j-1].vel;
        v3 = cloth[i][j-1].vel;
        v = v1.new_add(v2.new_add(v3)).new_mul(1.0 / 3.0).new_sub(v_air);
        
        faero = n.new_mul((v.length() * dot(v, n)) / (2 * n.length()));
        faero.mul((-1.0/2.0) * p * cd / 3);
        
        v1.add(faero);
        v2.add(faero);
        v3.add(faero);
      }
    }
  }
 
}

boolean paused = false;

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  camera.HandleKeyPressed();
}

float time = 0;
void draw() {
  float dt = 1.0 / 20; //Dynamic dt: 1/frameRate;
  
  if (!paused) {
    for (int i = 0; i < sub_steps; i++) {
      time += dt / sub_steps;
      update_physics(dt / sub_steps);
    }
  }

  camera.Update(1.0/20);
  
  background(255); //<>//
  noStroke();
  lights();
  
  // Draw Nodes (green with black outline)
  fill(204, 102, 0);
  
  //for (int i = 0; i < rows; i++){
  //  for (int j = 0; j < cols; j++){
  //    translate((float)cloth[i][j].pos.x * scene_scale, (float)cloth[i][j].pos.y * scene_scale, (float)cloth[i][j].pos.z * scene_scale);
  //    sphere(cloth[i][j].r * scene_scale);
  //    translate((float)-cloth[i][j].pos.x * scene_scale, (float)-cloth[i][j].pos.y * scene_scale, (float)-cloth[i][j].pos.z * scene_scale);
  //  }
  //}
  for (int i = 1; i < rows; i++){
    for (int j = 0; j < cols-1; j++){
      if ((j + i) % 2 == 0){
        fill(204, 102, 0);
      }
      else {
        fill(224, 122, 20);
      }
      
      // First Triangle
      Vec3 r1 = cloth[i][j].pos;
      Vec3 r2 = cloth[i-1][j+1].pos;
      Vec3 r3 = cloth[i-1][j].pos;
      
      beginShape(TRIANGLES);
      vertex((float)r1.x, (float)r1.y, (float)r1.z);
      vertex((float)r2.x, (float)r2.y, (float)r2.z);
      vertex((float)r3.x, (float)r3.y, (float)r3.z);
      
      
      // Second Triangle
      r1 = cloth[i][j].pos;
      r2 = cloth[i][j+1].pos;
      r3 = cloth[i-1][j+1].pos;
      
      vertex((float)r1.x, (float)r1.y, (float)r1.z);
      vertex((float)r2.x, (float)r2.y, (float)r2.z);
      vertex((float)r3.x, (float)r3.y, (float)r3.z);
      
      endShape();
    }
  }
  
  fill(102, 24, 240);
  translate((float)sphere.pos.x * scene_scale, (float)sphere.pos.y * scene_scale, (float)sphere.pos.z * scene_scale);
  //sphere(sphere.r);
  translate((float)-sphere.pos.x * scene_scale, (float)-sphere.pos.y * scene_scale, (float)-sphere.pos.z * scene_scale);
}
