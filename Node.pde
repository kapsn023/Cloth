// Node struct
class Node {
  public Vec2 pos;
  public Vec2 vel;
  public Vec2 last_pos;
  public Node next_node;
  public Node last_node;

  Node(Vec2 pos) {
    this.pos = pos;
    this.vel = new Vec2(0, 0);
    this.last_pos = pos;
    this.next_node = null;
    this.last_node = null;
  }
  Node(Vec2 pos, Node n_node, Node l_node) {
    this.pos = pos;
    this.vel = new Vec2(0, 0);
    this.last_pos = pos;
    this.next_node = n_node;
    this.last_node = l_node;
  }
}
