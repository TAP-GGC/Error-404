class Room {
  PVector position;
  String name;
  ArrayList<Interactable> interactables;

  Room(PVector pos, String roomName) {
    position = pos;
    name = roomName;
    interactables = new ArrayList<Interactable>();
  }

  void addInteractable(Interactable obj) {
    interactables.add(obj);
  }

  void display() {
    // Draw all objects (2D)
    for (Interactable obj : interactables) {
      if (obj.active) obj.display();
    }

    // Room title near top-center of room (world coords)
    fill(255, 255, 255, 220);
    textAlign(CENTER, TOP);
    textSize(16);
    text(name, position.x, position.z - 380);
  }
}
