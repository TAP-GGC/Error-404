class MachinePuzzle extends Puzzle {
  String requiredType1;
  String requiredType2;
  String requiredType3;
  SoundManager audio;
  int roomUnlock;
  boolean completed = false;

  MachinePuzzle(PVector pos, String type1, String type2, String type3, SoundManager audioRef, int unlockRoomIndex) {
    super(pos, 80);
    requiredType1 = type1;
    requiredType2 = type2;
    requiredType3 = type3;
    audio = audioRef;
    roomUnlock = unlockRoomIndex;
  }

@Override
void interact() {

  if (solved) {
    player.setStatus("Machine already running.");
    return;
  }

  if (player == null) return;

  HandheldItem intCube = player.removeItemType("int");
  HandheldItem floatCube = player.removeItemType("float");
  HandheldItem stringCube = player.removeItemType("String");

  if (intCube != null && floatCube != null && stringCube != null) {

    // give cubes back so bins can use them
    player.inventory.add(intCube);
    player.inventory.add(floatCube);
    player.inventory.add(stringCube);

    solved = true;
    completed = true;

    player.setStatus("Machine activated! Sort the cubes.");

    if (audio != null) audio.playSuccess();

  } else {

    if (intCube != null) player.inventory.add(intCube);
    if (floatCube != null) player.inventory.add(floatCube);
    if (stringCube != null) player.inventory.add(stringCube);

    player.setStatus("Machine needs int, float, and String cubes.");
  }
}

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);

    if (completed) fill(70, 120, 90);
    else fill(70, 70, 90);

    rect(position.x, position.z, 110, 70, 10);

    // screen
    noStroke();
    if (completed) fill(0, 255, 140);
    else fill(255, 220, 0);
    rect(position.x, position.z - 10, 60, 18, 4);

    // label
    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);
    text(completed ? "Machine (ON)" : "Machine (OFF)", position.x, position.z + 40);
  }
}
