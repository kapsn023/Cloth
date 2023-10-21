public class Ball extends Sphere2{
 
  public Vec3 vel, last_pos;
  public float m;
 
  public Ball(Vec3 cent, float r, Vec3 vel, float m){
   super(cent, r);
   this.vel = vel;
   this.m = m;
 }
}

// Ball on Ball Collision
void ballOnBall(Ball b1, Ball b2){
  if (b1.cent.distanceTo(b2.cent) <= (b1.r + b2.r)){
    Vec3 dir = b1.pos.new_sub(b2.pos);
    dir.normalize();
    double v1 = dot(b1.vel, dir);
    double v2 = dot(b2.vel, dir);
    double m1 = b1.m;
    double m2 = b2.m;
    double cor = 0.1;
    double new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
    double new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
    //ball.cent = sphere.cent.new_add(normal.new_mul(sphere.r + ball.r).new_mul(1.01));
    b1.pos = b2.pos.new_add(dir.new_mul(b1.r + b2.r).new_mul(1));
    b2.pos = b1.pos.new_add(dir.new_mul(b1.r + b2.r).new_mul(-1));
    b1.vel.add(dir.new_mul(new_v1 - v1)); // += dir * (new_v1 - v1); //Change in velocity along the axis
    b2.vel.add(dir.new_mul(new_v2 - v2)); // += dir * (new_v2 - v2); //only affect velocity along axis!
  }
}
