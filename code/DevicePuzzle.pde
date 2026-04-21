class DevicePuzzle extends Puzzle {
  DeviceForm form;
  SoundManager audio;

  DevicePuzzle(PVector pos, DeviceForm f, SoundManager audioRef) {
    super(pos, 80);
    form = f;
    audio = audioRef;
  }

  @Override
  void interact() {
    if (solved) {
      if (player != null) player.setStatus("Device puzzle already solved.");
      return;
    }

    if (form != null && form.filled) {
      solved = true;
      if (audio != null) audio.playSuccess();
      if (player != null) player.setStatus("Device puzzle solved!");
    } else {
      if (audio != null) audio.playError();
      if (player != null) player.setStatus("Fill out the form first.");
    }
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);
    fill(60, 60, 80);
    rect(position.x, position.z, 150, 80, 10);

    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(solved ? "DEVICE OK ✓" : "DEVICE CHECK", position.x, position.z);
  }
}
