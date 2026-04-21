class SoundManager {
  SoundManager(PApplet app) {
    println("SoundManager ready");
  }

  void speak(String text) {
    println("ALEX SAYS: " + text);
    beep();
  }

  void beep() {
    try {
      java.awt.Toolkit.getDefaultToolkit().beep();
    } catch (Exception e) {
      // ignore
    }
  }

  void playCollect() { beep(); }
  void playError() { beep(); }
  void playSuccess() { beep(); }
  void playKey() { beep(); }
  void playDoorUnlock() { beep(); }
  void playNPC() { beep(); }
}
