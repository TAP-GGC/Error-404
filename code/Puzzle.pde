abstract class Puzzle extends Interactable {
  protected boolean solved = false;
  int unlocksRoom = -1;

  Puzzle(PVector pos, float radius) {
    super(pos, radius);
  }

  Puzzle(PVector pos, float radius, int unlocks) {
    super(pos, radius);
    this.unlocksRoom = unlocks;
  }

  boolean isSolved() {
    return solved;
  }
}
