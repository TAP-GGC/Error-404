class CodingPuzzle extends Puzzle {
  String question;
  String answer;
  boolean completed = false;

  CodingPuzzle(PVector pos, String q, String a) {
    super(pos, 70);
    question = q;
    answer = a;
  }

  @Override
  void interact() {
    if (completed) {
      if (player != null) player.setStatus("Puzzle already solved.");
      return;
    }

    // Simple: auto-solve when interacted (you can extend to input)
    completed = true;
    solved = true;
    if (player != null) player.setStatus("Solved coding puzzle: " + question);
  }

  @Override
  void display() {
    rectMode(CENTER);
    stroke(25);
    strokeWeight(2);
    fill(completed ? color(70, 150, 100) : color(80, 80, 110));
    rect(position.x, position.z, 110, 60, 10);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(completed ? "CODE ✓" : "CODE ?", position.x, position.z);
  }
}
