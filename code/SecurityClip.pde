class SecurityClip extends Interactable {
  boolean isGood;
  boolean clipped = false;

  SecurityClip(PVector pos, boolean good) {
    super(pos, 45);
    isGood = good;
  }

  @Override
  void interact() {
    clipped = !clipped;
    if (player != null) {
      player.setStatus((clipped ? "Toggled" : "Untoggled") + " clip");
    }
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(10);
    strokeWeight(2);

    if (isGood) fill(70, 170, 90);
    else fill(190, 70, 70);

    rect(position.x, position.z, 26, 36, 6);

    if (clipped) {
      stroke(255);
      strokeWeight(3);
      line(position.x - 10, position.z - 12, position.x + 10, position.z + 12);
      line(position.x + 10, position.z - 12, position.x - 10, position.z + 12);
    }

    noStroke();
  }
}
