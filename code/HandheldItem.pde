class HandheldItem {
  // For puzzles we need a simple type label ("int", "float", "String", "key", etc.)
  String itemType;

  // Optional extra info
  String itemName;
  String itemValue;

  HandheldItem(String itemType) {
    this.itemType = itemType;
    this.itemName = itemType;
    this.itemValue = "";
  }

  HandheldItem(String itemType, String value) {
    this.itemType = itemType;
    this.itemName = itemType;
    this.itemValue = value;
  }
}
