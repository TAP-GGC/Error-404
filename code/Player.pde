class Player {
  PVector position;
  PVector velocity;

  // In 2D, we keep a facing direction so some objects can show arrows, etc.
  PVector facing = new PVector(0, 0, -1);

  ArrayList<HandheldItem> inventory;
  Interactable currentTarget;
  boolean hasKey = false;

  // HUD/status
  String statusMessage = "";
  int statusTimer = 0;

  Player(float x, float y, float z) {
    position = new PVector(x, y, z);
    velocity = new PVector();
    inventory = new ArrayList<HandheldItem>();
  }

  void setFacing(float dx, float dz) {
    if (abs(dx) < 0.001 && abs(dz) < 0.001) return;
    facing.x = dx;
    facing.z = dz;
    facing.normalize();
  }

  PVector getForwardVector() {
    // Used by some old code; in 2D we return facing on the (x,z) plane.
    return new PVector(facing.x, 0, facing.z);
  }

  PVector getRightVector() {
    // Perpendicular in 2D plane.
    return new PVector(-facing.z, 0, facing.x);
  }

  void interactWithTarget() {
    if (currentTarget != null) {
      currentTarget.interact();
    } else {
      setStatus("Nothing to interact with.");
    }
  }

  void addToInventory(HandheldItem item) {
    inventory.add(item);
    setStatus("Picked up: " + item.itemType);
  }

  boolean hasItemType(String type) {
    for (HandheldItem item : inventory) {
      if (item.itemType.equals(type)) return true;
    }
    return false;
  }

  HandheldItem removeItemType(String type) {
    for (int i = 0; i < inventory.size(); i++) {
      if (inventory.get(i).itemType.equals(type)) {
        return inventory.remove(i);
      }
    }
    return null;
  }

  void setStatus(String msg) {
    statusMessage = msg;
    statusTimer = 140;
    println(msg);
  }

  void display() {
    // Draw player (in world coordinates; the main sketch already translated the world)
    if (statusTimer > 0) statusTimer--;

    noStroke();
    fill(220);
    ellipse(position.x, position.z, 26, 26);

    // facing indicator
    stroke(255);
    strokeWeight(2);
    line(position.x, position.z, position.x + facing.x * 18, position.z + facing.z * 18);
    noStroke();
  }
}
