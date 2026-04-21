class OutputBin extends Interactable {

  String targetType;
  boolean filled = false;

  OutputBin(PVector pos, String type) {
    super(pos, 60);
    targetType = type;
  }

  @Override
  void interact() {

    if (player == null) return;

    // Machine must be activated first
    if (!room2Machine.solved) {
      player.setStatus("Turn on the machine first!");
      return;
    }

    // Already filled
    if (filled) {
      player.setStatus("This bin already has a " + targetType + " cube.");
      return;
    }

    // Try to remove correct cube from player
    HandheldItem item = player.removeItemType(targetType);

    if (item != null) {

      filled = true;

      player.setStatus("Placed " + targetType + " cube into bin!");

      if (audio != null) audio.playSuccess();

    } else {

      player.setStatus("You need a " + targetType + " cube.");

    }
  }

  @Override
  void display() {

    rectMode(CENTER);
    stroke(20);
    strokeWeight(2);

    if (filled) fill(60, 140, 90);
    else fill(50, 50, 65);

    rect(position.x, position.z, 80, 60, 10);

    // bin opening
    noStroke();
    fill(0, 0, 0, 90);
    rect(position.x, position.z - 10, 60, 12, 6);

    // label
    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);

    if (filled)
      text(targetType + " ✓", position.x, position.z + 35);
    else
      text(targetType, position.x, position.z + 35);
  }
}
