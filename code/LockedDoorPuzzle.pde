class LockedDoorPuzzle extends Puzzle {
  KeyItem requiredKey;
  boolean unlocked = false;
  SoundManager audio;
  int unlocksRoom;

  LockedDoorPuzzle(PVector pos, KeyItem key, SoundManager audioRef, int unlockRoomIndex) {
    super(pos, 70);
    requiredKey = key;
    audio = audioRef;
    unlocksRoom = unlockRoomIndex;
  }

  @Override
  void interact() {
    if (unlocked) {
      if (player != null) player.setStatus("Door already unlocked. Enter it!");
      return;
    }

    if (player != null && player.hasKey) {
      unlocked = true;
      solved = true;
      if (audio != null) audio.playDoorUnlock();
      if (player != null) player.setStatus("Door unlocked! Walk through and press E.");
    } else {
      if (audio != null) audio.playError();
      if (player != null) player.setStatus("Door is locked. Find the key.");
    }
  }

  @Override
  void display() {
    // door panel
    rectMode(CENTER);
    stroke(10);
    strokeWeight(2);
    if (unlocked) fill(90, 150, 110);
    else fill(120, 90, 90);
    rect(position.x, position.z, 44, 70, 6);

    // handle
    noStroke();
    fill(30);
    ellipse(position.x + 14, position.z, 6, 6);

    // label
    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);
    text(unlocked ? "DOOR (open)" : "DOOR (locked)", position.x, position.z + 40);
  }
}
