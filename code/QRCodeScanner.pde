class QRCodeScanner extends Puzzle {
  String requiredCode;
  boolean scanned = false;

  QRCodeScanner(PVector pos, String code) {
    super(pos, 70);
    requiredCode = code;
  }

  @Override
  void interact() {
    if (scanned) {
      if (player != null) player.setStatus("QR already scanned.");
      return;
    }
    scanned = true;
    solved = true;
    if (player != null) player.setStatus("Scanned QR: " + requiredCode);
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);
    fill(55, 55, 75);
    rect(position.x, position.z, 70, 70, 8);

    // fake QR blocks
    noStroke();
    fill(240);
    for (int i = -2; i <= 2; i++) {
      for (int j = -2; j <= 2; j++) {
        if ((i+j+frameCount/10) % 2 == 0) rect(position.x + i*10, position.z + j*10, 8, 8);
      }
    }

    fill(255);
    textAlign(CENTER, TOP);
    textSize(12);
    text(scanned ? "QR ✓" : "QR", position.x, position.z + 40);
  }
}
