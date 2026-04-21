class VoiceManager {
  
  VoiceManager() {
    println("Voice: fallback mode (beep only)");
  }
  
  void speak(String text) {
    // Beep and print
    java.awt.Toolkit.getDefaultToolkit().beep();
    println("🔊 Alex says: " + text);
  }
}
