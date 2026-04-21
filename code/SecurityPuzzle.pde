class SecurityPuzzle extends Puzzle {
  ArrayList<SecurityClip> clips;
  SoundManager audio;

  SecurityPuzzle(PVector pos, ArrayList<SecurityClip> clipList, SoundManager audioRef) {
    super(pos, 80);
    clips = clipList;
    audio = audioRef;
  }

  @Override
  void interact() {
    if (solved) {
      if (player != null) player.setStatus("Security system already solved!");
      return;
    }

    boolean correct = true;
    for (SecurityClip clip : clips) {
      // Rule: good clips must be ON, bad clips must be OFF
      if (clip.isGood && !clip.clipped) correct = false;
      if (!clip.isGood && clip.clipped) correct = false;
    }

    if (correct) {
      solved = true;
      if (audio != null) audio.playSuccess();
      if (player != null) player.setStatus("Security solved! You escaped!");
    } else {
      if (audio != null) audio.playError();
      if (player != null) player.setStatus("Not correct. Good clips ON, bad clips OFF.");
    }
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);
    fill(55, 55, 75);
    rect(position.x, position.z, 140, 80, 10);

    // screen
    noStroke();
    if (solved) fill(0, 255, 170);
    else fill(255, 220, 0);
    rect(position.x, position.z - 12, 90, 18, 4);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(solved ? "SYSTEM: CLEAR" : "SYSTEM: CHECK", position.x, position.z - 12);

    textAlign(CENTER, TOP);
    text("Security Console", position.x, position.z + 26);
  }
}
