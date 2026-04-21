class FunctionMachine extends Interactable {
  String inputType;
  String outputType;
  SoundManager audio;

  FunctionMachine(PVector pos, String inType, String outType, SoundManager audioRef) {
    super(pos, 80);
    inputType = inType;
    outputType = outType;
    audio = audioRef;
  }

  @Override
  void interact() {
    if (player == null) return;

    HandheldItem in = player.removeItemType(inputType);
    if (in != null) {
      player.addToInventory(new HandheldItem(outputType, in.itemValue));
      if (audio != null) audio.playSuccess();
      player.setStatus("Converted " + inputType + " -> " + outputType);
    } else {
      if (audio != null) audio.playError();
      player.setStatus("Need a " + inputType + " cube to use this machine.");
    }
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);
    fill(70, 70, 95);
    rect(position.x, position.z, 130, 70, 10);

    noStroke();
    fill(255, 220, 0);
    rect(position.x, position.z - 10, 80, 16, 4);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(inputType + " → " + outputType, position.x, position.z - 10);

    fill(255);
    textAlign(CENTER, TOP);
    text("Function Machine", position.x, position.z + 28);
  }
}
