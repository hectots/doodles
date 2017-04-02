// DoodleAlphabet

static class DoodleAlphabet {
  static final char DOODLE_POINT     = '.';
  static final char DOODLE_LINE      = '|';
  static final char DOODLE_ANGLE     = '^';
  static final char DOODLE_ARC       = 'u';
  static final char DOODLE_SPIRAL    = '@';
  static final char DOODLE_LOOP      = '&';
  static final char DOODLE_OVAL      = 'o';
  static final char DOODLE_EYE       = 'e';
  static final char DOODLE_TRIANGLE  = '4';
  static final char DOODLE_RECTANGLE = 'H';
  static final char DOODLE_HOUSE     = 'A';
  static final char DOODLE_CLOUD     = '*';
  
  static final char DOODLE_START_TRANSLATE = '(';
  static final char DOODLE_END_TRANSLATE   = ')';
  static final char DOODLE_START_ROTATE    = '{';
  static final char DOODLE_END_ROTATE      = '}';
  static final char DOODLE_START_SCALE     = '<';
  static final char DOODLE_END_SCALE       = '>';
  static final char DOODLE_START_SAVE      = '[';
  static final char DOODLE_END_SAVE        = ']';
  
  static final char DOODLE_MODIFIER_UP   = '+';
  static final char DOODLE_MODIFIER_DOWN = '-';
  
  static final char[] SYMBOLS = {
    DOODLE_POINT,
    DOODLE_LINE,
    DOODLE_ANGLE,
    DOODLE_ARC,
    DOODLE_SPIRAL,
    DOODLE_LOOP,
    DOODLE_OVAL,
    DOODLE_EYE,
    DOODLE_TRIANGLE,
    DOODLE_RECTANGLE,
    DOODLE_HOUSE,
    DOODLE_CLOUD
  };
  
  static final char[] TRANSFORMS = {
    DOODLE_START_TRANSLATE,
    DOODLE_END_TRANSLATE,
    DOODLE_START_ROTATE,
    DOODLE_END_ROTATE,
    DOODLE_START_SCALE,
    DOODLE_END_SCALE,
    DOODLE_START_SAVE,
    DOODLE_END_SAVE
  };
  
  static final char[] MODIFIERS = {
    DOODLE_MODIFIER_UP,
    DOODLE_MODIFIER_DOWN
  };
  
  static boolean isTransform(char symbol) {
    for (char transform : TRANSFORMS) {
      if (symbol == transform) {
        return true;
      }
    }
    
    return false;
  }
  
  static char getStartPair(char transform) {
    switch (transform) {
      case DOODLE_END_TRANSLATE:
        return DOODLE_START_TRANSLATE;
      case DOODLE_END_ROTATE:
        return DOODLE_START_ROTATE;
      case DOODLE_END_SCALE:
        return DOODLE_START_SCALE;
      case DOODLE_END_SAVE:
        return DOODLE_START_SAVE;
    }
    
    return '?'; // not a transform
  }
  
  static char getEndPair(char transform) {
    switch (transform) {
      case DOODLE_START_TRANSLATE:
        return DOODLE_END_TRANSLATE;
      case DOODLE_START_ROTATE:
        return DOODLE_END_ROTATE;
      case DOODLE_START_SCALE:
        return DOODLE_END_SCALE;
      case DOODLE_START_SAVE:
        return DOODLE_END_SAVE;
    }
    
    return '?'; // not a transform
  }
}