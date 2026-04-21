class DeviceForm extends Interactable {
  boolean filled = false;

  DeviceForm(PVector pos) {
    super(pos, 70);
  }

  @Override
  void interact() {
    filled = true;
    if (player != null) player.setStatus("Filled out the device safety form.");
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);
    fill(filled ? color(70, 160, 110) : color(70, 70, 95));
    rect(position.x, position.z, 130, 80, 10);

    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(filled ? "FORM ✓" : "FORM", position.x, position.z);
  }
}
