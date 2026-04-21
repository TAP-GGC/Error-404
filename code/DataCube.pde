class DataCube extends Interactable {
  String dataType;
  String dataValue;
  boolean collected = false;
  float floatPhase = 0;
  SoundManager audio;

  DataCube(PVector pos, String type, String value, SoundManager audioRef) {
    super(pos, 40);
    this.dataType = type;
    this.dataValue = value;
    this.audio = audioRef;
  }

  @Override
  void interact() {
    if (!collected && active) {
      collected = true;
      active = false;
      if (audio != null) audio.playCollect();
      if (player != null) player.addToInventory(new HandheldItem(dataType, dataValue));
      println("Collected " + dataType + " cube: " + dataValue);
    }
  }

  @Override
  void display() {
    if (collected || !active) return;

    float bob = sin((frameCount + floatPhase) * 0.06) * 4;

    // color by type
    if (dataType.equals("int")) fill(60, 160, 255);
    else if (dataType.equals("float")) fill(60, 255, 160);
    else if (dataType.equals("String")) fill(255, 170, 60);
    else fill(220);

    noStroke();
    rectMode(CENTER);
    rect(position.x, position.z + bob, 28, 28, 6);

    // value label
    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);
    text(dataValue, position.x, position.z + bob + 18);
  }
}
