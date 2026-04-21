class CollectorNPC extends Interactable {
  Player playerRef;
  SoundManager audio;

  boolean isFollowing = true;
  float followDistance = 60;
  float followSpeed = 2.4;
  int currentRoomIndex = 0;
  
  // ===== Pathfinding state (Room 1 maze) =====
  int lastPR = -1, lastPC = -1;
  int nextStepR = -1, nextStepC = -1;
  int pathRecalcTimer = 0;

  final float CELL = 50;
  final float NPC_R = 13;   // collision radius for Alex

  CollectorNPC(PVector pos, Player player, SoundManager audio) {
  super(pos, 20);
  this.playerRef = player;
  this.audio = audio;

  spawnPosition = pos.copy();   // save original spawn
}

  void setRoom(int idx) {
    currentRoomIndex = idx;
  }

  @Override
  void interact() {
    isFollowing = !isFollowing;
    if (audio != null) audio.playNPC();
    if (playerRef != null) {
      playerRef.setStatus(isFollowing ? "Alex is now following you." : "Alex stopped following.");
    }
  }

  
void update() {
  if (playerRef == null) return;

  // If not in Room 1, fall back to simple chase (optional)
  if (currentRoomIndex != 0) {
    simpleChase();
    return;
  }

  // Convert Alex and Player positions to maze cells
  int[] aCell = worldToCell(position.x, position.z);
  int[] pCell = worldToCell(playerRef.position.x, playerRef.position.z);

  int ar = aCell[0], ac = aCell[1];
  int pr = pCell[0], pc = pCell[1];

  // ===== Catch =====
  float dxp = playerRef.position.x - position.x;
  float dzp = playerRef.position.z - position.z;
  float distP = sqrt(dxp*dxp + dzp*dzp);

  float catchDistance = 20;
  if (distP < catchDistance) {
    playerRef.position = new PVector(25, 20, -375);
    playerRef.setStatus("Alex caught you!");

    // Respawn Alex to a safe open cell (pick a 0-cell)
    // (row=13,col=14 is open in your grid; change if you want)
    PVector spawn = cellCenter(13, 14);
    position.x = spawn.x;
    position.z = spawn.z;
    return;
  }

  // Recompute path sometimes or when player changes cell
  pathRecalcTimer--;
  if (pathRecalcTimer <= 0 || pr != lastPR || pc != lastPC || nextStepR == -1) {
    int[] step = bfsNextStep(ar, ac, pr, pc);
    nextStepR = step[0];
    nextStepC = step[1];
    lastPR = pr; lastPC = pc;
    pathRecalcTimer = 10; // recalc every ~10 frames
  }

  // If no path found, do a safe-ish simple chase with wall sliding
  if (nextStepR == -1) {
    mazeSlideChase();
    return;
  }

  // Move toward the CENTER of the next cell
  PVector target = cellCenter(nextStepR, nextStepC);
  float dx = target.x - position.x;
  float dz = target.z - position.z;
  float d  = sqrt(dx*dx + dz*dz);

  if (d > 1) {
    dx /= d;
    dz /= d;

    float nextX = position.x + dx * followSpeed;
    float nextZ = position.z + dz * followSpeed;

    // Collision against room1Maze (axis-separated = sliding)
    boolean hitX = false;
    for (RectWall w : room1Maze) {
      if (circleHitsRect(nextX, position.z, NPC_R, w)) { hitX = true; break; }
    }
    if (!hitX) position.x = nextX;

    boolean hitZ = false;
    for (RectWall w : room1Maze) {
      if (circleHitsRect(position.x, nextZ, NPC_R, w)) { hitZ = true; break; }
    }
    if (!hitZ) position.z = nextZ;
  }

  // If we reached the next cell center, force a refresh
  if (dist(position.x, position.z, target.x, target.z) < 6) {
    nextStepR = -1;
  }
}


 @Override
void display() {
  update();

  pushMatrix();
  translate(position.x, position.z);

  float baseR = 18;

  // Distance to player (for intensity)
  float distToPlayer = 999;
  if (playerRef != null) {
    float dx = playerRef.position.x - position.x;
    float dz = playerRef.position.z - position.z;
    distToPlayer = sqrt(dx*dx + dz*dz);
  }

  // Pulse speed increases when close
  float pulseSpeed = (distToPlayer < 120) ? 0.25 : 0.08;
  float pulse = sin(frameCount * pulseSpeed) * 4;
  float r = baseR + pulse;
  float d = r * 2;

  // ===== Dark Aura =====
  noStroke();
  fill(0, 0, 0, 80);
  ellipse(0, 0, d + 20, d + 20);

  // ===== Main Body =====
  stroke(10);
  strokeWeight(3);
  fill(40, 0, 0);
  ellipse(0, 0, d, d);

  // ===== Spikes =====
  stroke(20);
  fill(60, 0, 0);
  for (int a = 0; a < 360; a += 25) {
    float ang = radians(a + frameCount * 0.5);
    float x1 = cos(ang) * (r + 2);
    float z1 = sin(ang) * (r + 2);
    float x2 = cos(ang + radians(8)) * (r + 12);
    float z2 = sin(ang + radians(8)) * (r + 12);
    float x3 = cos(ang - radians(8)) * (r + 12);
    float z3 = sin(ang - radians(8)) * (r + 12);
    triangle(x1, z1, x2, z2, x3, z3);
  }

  // ===== Glowing Red Eyes =====
  noStroke();

  float glow = map(distToPlayer, 200, 40, 80, 255);
  glow = constrain(glow, 80, 255);

  fill(255, 0, 0, glow);
  ellipse(-6, -5, 10, 10);
  ellipse( 6, -5, 10, 10);

  // Eye core
  fill(0);
  ellipse(-6, -5, 4, 4);
  ellipse( 6, -5, 4, 4);

  // ===== Mouth =====
  fill(0);
  arc(0, 5, 18, 14, 0, PI);

  // ===== Teeth =====
  fill(255);
  for (int i = -2; i <= 2; i++) {
    triangle(i * 3, 7, i * 3 - 2, 11, i * 3 + 2, 11);
  }

  popMatrix();

  // ===== Name =====
  fill(255, 0, 0);
  textAlign(CENTER, TOP);
  textSize(12);
  text("A L E X", position.x, position.z + 28);
}
  PVector findSafeSpawnInRoom1() {
  // Try near the player start first (usually open area)
  float baseX = 25;
  float baseZ = -375;

  final float NPC_R = 13;

  // Spiral search: try many offsets until we find a non-wall spot
  for (int radius = 0; radius <= 400; radius += 20) {
    for (int a = 0; a < 360; a += 15) {
      float x = baseX + cos(radians(a)) * radius;
      float z = baseZ + sin(radians(a)) * radius;

      // Keep inside room bounds
      Room r = rooms.get(0);
      float minX = r.position.x - ROOM_HALF + NPC_R;
      float maxX = r.position.x + ROOM_HALF - NPC_R;
      float minZ = r.position.z - ROOM_HALF + NPC_R;
      float maxZ = r.position.z + ROOM_HALF - NPC_R;
      x = constrain(x, minX, maxX);
      z = constrain(z, minZ, maxZ);

      // Check maze walls
      boolean hit = false;
      for (RectWall w : room1Maze) {
        if (circleHitsRect(x, z, NPC_R, w)) { hit = true; break; }
      }

      if (!hit) return new PVector(x, 0, z);
    }
  }

    // Fallback: if somehow everything fails, just put him at room center
    Room r = rooms.get(0);
    return new PVector(r.position.x, 0, r.position.z);
    }
    // Simple chase used outside Room 1 (optional)
  void simpleChase() {
    float dx = playerRef.position.x - position.x;
    float dz = playerRef.position.z - position.z;
    float d  = sqrt(dx*dx + dz*dz);
    if (d < 1) return;
    dx /= d; dz /= d;
    position.x += dx * followSpeed;
    position.z += dz * followSpeed;
  }
  
  // If BFS fails, chase but still slide on walls (Room 1)
  void mazeSlideChase() {
    float dx = playerRef.position.x - position.x;
    float dz = playerRef.position.z - position.z;
    float d  = sqrt(dx*dx + dz*dz);
    if (d < 1) return;
    dx /= d; dz /= d;
  
    float nextX = position.x + dx * followSpeed;
    float nextZ = position.z + dz * followSpeed;
  
    boolean hitX = false;
    for (RectWall w : room1Maze) {
      if (circleHitsRect(nextX, position.z, NPC_R, w)) { hitX = true; break; }
    }
    if (!hitX) position.x = nextX;
  
    boolean hitZ = false;
    for (RectWall w : room1Maze) {
      if (circleHitsRect(position.x, nextZ, NPC_R, w)) { hitZ = true; break; }
    }
    if (!hitZ) position.z = nextZ;
  }
  
  // World position -> (row,col) in 16x16 grid
  int[] worldToCell(float x, float z) {
    int col = int((x + ROOM_HALF) / CELL);
    int row = int((z + ROOM_HALF) / CELL);
    col = constrain(col, 0, mazeGrid[0].length - 1);
    row = constrain(row, 0, mazeGrid.length - 1);
    return new int[]{row, col};
  }
  
  // (row,col) -> world center position
  PVector cellCenter(int row, int col) {
    float cx = -ROOM_HALF + col * CELL + CELL/2;
    float cz = -ROOM_HALF + row * CELL + CELL/2;
    return new PVector(cx, 0, cz);
  }
  
  // BFS next step from (sr,sc) toward (tr,tc). Returns {-1,-1} if no path.
  int[] bfsNextStep(int sr, int sc, int tr, int tc) {
    int R = mazeGrid.length;
    int C = mazeGrid[0].length;
  
    // If target is a wall, no path
    if (mazeGrid[tr][tc] == 1) return new int[]{-1, -1};
  
    boolean[][] vis = new boolean[R][C];
    int[][] parentR = new int[R][C];
    int[][] parentC = new int[R][C];
  
    for (int r=0;r<R;r++) for (int c=0;c<C;c++) { parentR[r][c] = -1; parentC[r][c] = -1; }
  
    int[] qr = new int[R*C];
    int[] qc = new int[R*C];
    int qh=0, qt=0;
  
    vis[sr][sc] = true;
    qr[qt]=sr; qc[qt]=sc; qt++;
  
    int[] dr = {-1, 1, 0, 0};
  int[] dc = {0, 0, -1, 1};

  boolean found = false;
  while (qh < qt) {
    int r = qr[qh], c = qc[qh]; qh++;
    if (r == tr && c == tc) { found = true; break; }

    for (int i=0;i<4;i++) {
      int nr = r + dr[i];
      int nc = c + dc[i];
      if (nr<0||nr>=R||nc<0||nc>=C) continue;
      if (vis[nr][nc]) continue;
      if (mazeGrid[nr][nc] == 1) continue; // wall
      vis[nr][nc] = true;
      parentR[nr][nc] = r;
      parentC[nr][nc] = c;
      qr[qt]=nr; qc[qt]=nc; qt++;
    }
  }

  if (!found) return new int[]{-1, -1};
  if (sr == tr && sc == tc) return new int[]{sr, sc};

  // Backtrack from target to find the cell after start
  int cr = tr, cc = tc;
  while (!(parentR[cr][cc] == sr && parentC[cr][cc] == sc)) {
    int pr = parentR[cr][cc];
    int pc = parentC[cr][cc];
    if (pr == -1) break;
    cr = pr; cc = pc;
    if (cr == sr && cc == sc) break;
  }

  return new int[]{cr, cc};
}
  void reset() {
    position = spawnPosition.copy();
  
    // reset any chase state
    isFollowing = true;
  
    // if using pathfinding, reset these too
    nextStepR = -1;
    nextStepC = -1;
    pathRecalcTimer = 0;
  }
}
