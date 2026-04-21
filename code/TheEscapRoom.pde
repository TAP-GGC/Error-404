import processing.sound.*;

// ============ GAME STATE ============
int currentRoomIndex = 0;
boolean gameComplete = false;
PVector spawnPosition;

// ============ GAME OBJECTS ============
Player player;
SoundManager audio;
boolean[] keys = new boolean[256];
ArrayList<Room> rooms = new ArrayList<Room>();
CollectorNPC alex;

MachinePuzzle room2Machine;
OutputBin room2BinInt, room2BinFloat, room2BinString;
KeyItem room2Key;
boolean room2KeyUnlocked = false;

// ============ MAZE GRID (16x16) ============
int[][] mazeGrid = {
  {1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1},
  {1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,1,0,1,0,1,1,1,1,1,1,0,1,0,1},
  {1,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1},
  {1,1,1,1,1,1,1,1,0,1,0,1,1,1,0,1},
  {1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1},
  {1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,1},
  {1,0,1,0,0,1,0,0,0,0,0,1,0,0,0,1},
  {1,0,1,0,1,1,1,1,1,1,0,1,1,1,0,1},
  {1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1},
  {1,1,1,1,1,1,1,1,0,1,1,1,0,1,0,1},
  {1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1},
  {1,0,1,0,1,0,1,1,1,1,0,1,1,1,1,1},
  {1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,1},
  {1,0,1,1,1,1,1,0,1,1,1,1,1,1,0,1},
  {1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1}
};

ArrayList<RectWall> room1Maze = new ArrayList<RectWall>();
final float PLAYER_R = 9; 
final float ROOM_HALF = 400;

// ============ SETUP ============
void setup() {
  size(1820, 980);
  audio = new SoundManager(this);
  
  // Create Rooms
  createRoom1();
  createRoom2();
  createRoom3();

  // Start at Room 1 Entrance
  player = new Player(25, 20, -375); 
  
  // Initialize NPC Alex in Room 1 [cite: 3]
  alex = new CollectorNPC(new PVector(325, 0, 325), player, audio);
  rooms.get(0).addInteractable(alex);
}

void buildRoom1Maze(PVector roomPos) {
  room1Maze.clear();
  float cellSize = 50; 
  float offset = (mazeGrid.length * cellSize) / 2.0;

  for (int row = 0; row < mazeGrid.length; row++) {
    for (int col = 0; col < mazeGrid[row].length; col++) {
      if (mazeGrid[row][col] == 1) {
        float wallX = roomPos.x - offset + (col * cellSize) + cellSize/2;
        float wallZ = roomPos.z - offset + (row * cellSize) + cellSize/2;
        room1Maze.add(new RectWall(wallX, wallZ, cellSize, cellSize));
      }
    }
  }
}

void createRoom1() {
  Room room1 = new Room(new PVector(0, 0, 0), "The Grand Labyrinth");
  buildRoom1Maze(room1.position);

  // Add the Key in the corner [cite: 1]
  KeyItem key = new KeyItem(new PVector(-325, 20, 325), audio);
  room1.addInteractable(key);

  // Add the Exit Door leading to Room 1 (index 1) [cite: 18]
  LockedDoorPuzzle door = new LockedDoorPuzzle(new PVector(-25, 20, 380), key, audio, 1);
  room1.addInteractable(door);

  room1.addInteractable(new DataCube(new PVector(325, 0, -325), "int", "5", audio)); // [cite: 4]
  rooms.add(room1);
}

void createRoom2() {
  Room room2 = new Room(new PVector(600, 0, 0), "Function Factory");

  // Create machine first (save reference)
  room2Machine = new MachinePuzzle(new PVector(600, 0, 0), "int", "float", "String", audio, 2);
  room2.addInteractable(room2Machine);

  // Bins (save references)
  room2BinInt   = new OutputBin(new PVector(500, 0, -120), "int");
  room2BinFloat = new OutputBin(new PVector(600, 0, -120), "float");
  room2BinString= new OutputBin(new PVector(700, 0, -120), "String");
  room2.addInteractable(room2BinInt);
  room2.addInteractable(room2BinFloat);
  room2.addInteractable(room2BinString);

  // Cubes
  room2.addInteractable(new DataCube(new PVector(500, 0, 100), "int", "10", audio));
  room2.addInteractable(new DataCube(new PVector(600, 0, 100), "float", "2.71", audio));
  room2.addInteractable(new DataCube(new PVector(700, 0, 100), "String", "world", audio));

  // Key is created but DISABLED until puzzle complete
  room2Key = new KeyItem(new PVector(750, 0, 150), audio);
  room2Key.active = false;                 // IMPORTANT
  room2.addInteractable(room2Key);

  // Door to room 3
  LockedDoorPuzzle door2 = new LockedDoorPuzzle(new PVector(900, 0, 0), room2Key, audio, 2);
  room2.addInteractable(door2);

  rooms.add(room2);
}
void checkRoom2Puzzle() {

  if (room2Machine.isSolved()
      && room2BinInt.filled
      && room2BinFloat.filled
      && room2BinString.filled) {

    room2Key.active = true;
    player.setStatus("Puzzle complete! The key appeared.");
  }

}

void createRoom3() {
  Room room3 = new Room(new PVector(1200, 0, 0), "Device Safety Tracker");

  ArrayList<SecurityClip> clips = new ArrayList<SecurityClip>();
  clips.add(new SecurityClip(new PVector(1100, 0, 50), true));
  clips.add(new SecurityClip(new PVector(1150, 0, 0), false));
  clips.add(new SecurityClip(new PVector(1200, 0, -50), true));
  clips.add(new SecurityClip(new PVector(1250, 0, 0), false));
  clips.add(new SecurityClip(new PVector(1300, 0, 50), true));
  for (SecurityClip clip : clips) room3.addInteractable(clip);

  SecurityPuzzle security = new SecurityPuzzle(new PVector(1200, 0, -150), clips, audio);
  room3.addInteractable(security);

  rooms.add(room3);
}

// ============ DRAW ============
void draw() {
  background(18, 18, 26);
  if (gameComplete) { drawVictoryScreen(); return; }

  Room currentRoom = rooms.get(currentRoomIndex);
  handleMovement(currentRoom);
  updatePlayerTarget(currentRoom);
  if (currentRoomIndex == 1) checkRoom2Puzzle();

  pushMatrix();
  
  // 1) Zoom so the whole room fits on screen
  float roomSize = ROOM_HALF * 2.0;                 // room width/height in world units
  float s = min(width / roomSize, height / roomSize);
  scale(s);
  
  // 2) Center the camera on the ROOM (not the player)
  translate(width/(2.0*s) - currentRoom.position.x,
            height/(2.0*s) - currentRoom.position.z);
  
  // Floor
  fill(30, 30, 45);
  rectMode(CENTER);
  rect(currentRoom.position.x, currentRoom.position.z, ROOM_HALF*2, ROOM_HALF*2);

  if (currentRoomIndex == 0) {
    for (RectWall w : room1Maze) w.display();
  }
  
  currentRoom.display(); // 
  player.display(); // [cite: 11]
  popMatrix();

  drawHUD(currentRoom);
}

// ============ INTERACTION & HUD ============
void updatePlayerTarget(Room currentRoom) {
  Interactable nearest = null;
  float nearestDist = 60; // Max interaction distance

  for (Interactable obj : currentRoom.interactables) {
    if (!obj.active) continue;
    float d = dist(player.position.x, player.position.z, obj.position.x, obj.position.z);
    if (d < nearestDist) { 
      nearest = obj; 
      nearestDist = d; 
    }
  }
  player.currentTarget = nearest; // [cite: 11]
}

void drawHUD(Room currentRoom) {
  noStroke();
  fill(0, 0, 0, 120);
  rect(10, 10, 360, 110, 10);

  fill(255);
  textAlign(LEFT, TOP);
  text("Room: " + currentRoom.name, 20, 18);
  text("Inventory: " + player.inventory.size() + " cubes", 20, 38);
  text("KEY: " + (player.hasKey ? "yes" : "no"), 20, 58);
  text("WASD move, F interact", 20, 78);

  

  // Interaction prompt
  if (player.currentTarget != null) {
    fill(255);
    textAlign(CENTER, BOTTOM);
    text("Press F to interact", width/2, height - 18);
  }

  // Status line (bottom left)
  if (player.statusMessage != null && player.statusTimer > 0) {
    fill(0, 0, 0, 140);
    rect(10, height - 46, 520, 36, 10);
    fill(255);
    textAlign(LEFT, CENTER);
    text(player.statusMessage, 20, height - 28);
  }
}

void handleMovement(Room currentRoom) {
  float speed = 4;
  float dx = 0, dz = 0;
  
  if (keys['W'] || keys['w']) dz -= speed;
  if (keys['S'] || keys['s']) dz += speed;
  if (keys['A'] || keys['a']) dx -= speed;
  if (keys['D'] || keys['d']) dx += speed;

  if (dx != 0 || dz != 0) player.setFacing(dx, dz);

  // Calculate intended next position
  float nextX = player.position.x + dx;
  float nextZ = player.position.z + dz;

  // --- ROOM BOUNDARY LIMITS ---
  // Limits based on the Room's center position and ROOM_HALF (400)
  float minX = currentRoom.position.x - ROOM_HALF + PLAYER_R;
  float maxX = currentRoom.position.x + ROOM_HALF - PLAYER_R;
  float minZ = currentRoom.position.z - ROOM_HALF + PLAYER_R;
  float maxZ = currentRoom.position.z + ROOM_HALF - PLAYER_R;

  if (currentRoomIndex == 0) {
    // 1. First, check against Maze Walls
    boolean hitWall = false;
    for (RectWall w : room1Maze) {
      if (circleHitsRect(nextX, nextZ, PLAYER_R, w)) {
        hitWall = true;
        break;
      }
    }
    
    // 2. Only move if NOT hitting a wall AND within the Room outer boundary
    if (!hitWall) {
      player.position.x = constrain(nextX, minX, maxX);
      player.position.z = constrain(nextZ, minZ, maxZ);
    }
  } else {
    // For Room 2 and 3: Just keep them inside the square
    player.position.x = constrain(nextX, minX, maxX);
    player.position.z = constrain(nextZ, minZ, maxZ);
  }
}

void keyPressed() {
  if (keyCode < 256) keys[keyCode] = true;

  if (key == 'f' || key == 'F' ) {
    player.interactWithTarget();

    if (player.currentTarget instanceof LockedDoorPuzzle) {
      LockedDoorPuzzle door = (LockedDoorPuzzle) player.currentTarget;
      if (door.isSolved() && door.unlocksRoom < rooms.size()) {
        currentRoomIndex = door.unlocksRoom;
        // Spawn player near bottom of new room
        Room nr = rooms.get(currentRoomIndex);
        player.position = new PVector(nr.position.x, 0, nr.position.z + 150);
        player.setStatus("Entered " + nr.name);

        if (alex.isFollowing) {
          alex.position = new PVector(player.position.x - 50, 0, player.position.z - 50);
        }
        alex.setRoom(currentRoomIndex);
      }
    }

    if (player.currentTarget instanceof SecurityPuzzle) {
      SecurityPuzzle sp = (SecurityPuzzle) player.currentTarget;
      if (sp.isSolved()) {
        gameComplete = true;
      }
    }
  }
}
void keyReleased() { if (keyCode < 256) keys[keyCode] = false; }

class RectWall {
  float x, z, w, h;
  RectWall(float x, float z, float w, float h) { this.x = x; this.z = z; this.w = w; this.h = h; }
  void display() {
    fill(100, 110, 130);
    stroke(180, 190, 210);
    rectMode(CENTER);
    rect(x, z, w, h);
  }
}

boolean circleHitsRect(float cx, float cz, float r, RectWall rw) {
  float closestX = constrain(cx, rw.x - rw.w/2, rw.x + rw.w/2);
  float closestZ = constrain(cz, rw.z - rw.h/2, rw.z + rw.h/2);
  float dx = cx - closestX;
  float dz = cz - closestZ;
  return (dx*dx + dz*dz) <= r*r;
}

void drawVictoryScreen() {
  background(0, 20, 0);
  fill(255, 215, 0);
  textAlign(CENTER, CENTER);
  textSize(52);
  text("ESCAPE SUCCESSFUL!", width/2, height/3);
  fill(255);
  textSize(24);
  text("You've completed all rooms!", width/2, height/2);
  text("Press R to restart", width/2, height/2 + 60);
  if (keys['R'] || keys['r']) resetGame();
}
void resetGame() {
  currentRoomIndex = 0;
  gameComplete = false;
  rooms.clear();
  
  // Rebuild the world
  createRoom1();
  createRoom2();
  createRoom3();
  
  player = new Player(25, 20, -375); 
  
  alex = new CollectorNPC(new PVector(175, 0, 175), player, audio);
  rooms.get(0).addInteractable(alex);
  
  player.setStatus("System Rebooted. Escape the Labyrinth.");
}
