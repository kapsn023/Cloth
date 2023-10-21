//Vector Library
//CSCI 5611 Vector 2 Library [Example]
// Stephen J. Guy <sjguy@umn.edu>

public class Vec3 {
  public double x, y, z;
  
  public Vec3(double x, double y, double z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public double length(){
    return Math.sqrt(x*x+y*y+z*z);
  }
  
  public double lengthSqr() {
    return x * x + y * y + z * z;
  }
  
  public Vec3 new_add(Vec3 rhs){
    return new Vec3(x+rhs.x, y+rhs.y, z+rhs.z);
  }
  
  public void add(Vec3 rhs){
    x += rhs.x;
    y += rhs.y;
    z += rhs.z;
  }
  
  public Vec3 new_sub(Vec3 rhs){
    return new Vec3(x-rhs.x, y-rhs.y, z-rhs.z);
  }
  
  public void subtract(Vec3 rhs){
    x -= rhs.x;
    y -= rhs.y;
    z -= rhs.z;
  }
  
  public Vec3 new_mul(double rhs){
    return new Vec3(x*rhs, y*rhs, z*rhs);
  }
  
  public void mul(double rhs){
    x *= rhs;
    y *= rhs;
    z *= rhs;
  }
  
  public void clampToLength(double maxL){
    double magnitude = Math.sqrt(x*x + y*y + z*z);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
      z *= maxL/magnitude;
    }
  }
  
  public void setToLength(double newL){
    double magnitude = Math.sqrt(x*x + y*y + z*z);
    x *= newL/magnitude;
    y *= newL/magnitude;
    z *= newL/magnitude;
  }
  
  public void normalize(){
    double magnitude = Math.sqrt(x*x + y*y + z*z);
    x /= magnitude;
    y /= magnitude;
    z /= magnitude;
  }
  
  public Vec3 new_normalize(){
    double magnitude = Math.sqrt(x*x + y*y + z*z);
    return new Vec3(x/magnitude, y/magnitude, z/magnitude);
  }
  
  public double distanceTo(Vec3 rhs){
    double dx = rhs.x - x;
    double dy = rhs.y - y;
    double dz = rhs.z - z;
    return Math.sqrt(dx*dx + dy*dy + dz*dz);
  }
}

double dot(Vec3 a, Vec3 b){
  return a.x*b.x + a.y*b.y + a.z*b.z;
}

Vec3 cross(Vec3 a, Vec3 b){
  double Cx = a.y*b.z - a.z*b.y;
  double Cy = a.z*b.x - a.x*b.z;
  double Cz = a.x*b.y - a.y*b.x;
  return new Vec3( Cx, Cy, Cz); 
}
