abstract class Interactable
{
  PVector position;
  boolean active = true;
  float interactionRadius = 50;
  
  Interactable(PVector pos)
  {
    this.position = pos.copy();
  }
  
  Interactable(PVector pos, float radius)
  {
    this.position = pos.copy();
    this.interactionRadius = radius;
  }
  
  boolean canInteract(PVector playerPos)
  {
    return active && PVector.dist(playerPos, position) <= interactionRadius;
  }
  
  void onPlayerEnter() { }
  void onPlayerExit() { }
  
  abstract void interact();
  abstract void display();
}
