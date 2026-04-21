class KeyItem extends Interactable {
  boolean collected = false;
  SoundManager audio;

  KeyItem(PVector pos, SoundManager audioRef) {
    super(pos, 45);
    this.audio = audioRef;
  }

  @Override
  void interact() {
    if (!collected && active) {
      collected = true;
      active = false;
      if (audio != null) audio.playKey();
      if (player != null) {
        player.hasKey = true;
        player.setStatus("Picked up a key!");
      }
    }
  }

  @Override
  void display() {
    if (collected || !active) return;

    // simple key icon
    noStroke();
    fill(255, 215, 0);
    ellipse(position.x, position.z, 18, 18);
    rectMode(CORNER);
    rect(position.x + 6, position.z - 3, 20, 6, 3);
    rect(position.x + 18, position.z - 6, 6, 12, 2);

    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);
    text("KEY", position.x, position.z + 12);
  }
}
