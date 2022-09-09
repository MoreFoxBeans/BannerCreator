class Button {
  String l;
  int x, y, w, h, r, s;
  color bg, og, fg;
  
  Button(String label, int xPos, int yPos, int width, int height, int radius, int stroke, color background, color outline, color text) {
    l = label;
    x = xPos;
    y = yPos;
    w = width;
    h = height;
    r = radius;
    s = stroke;
    bg = background;
    og = outline;
    fg = text;
  }
  
  Button(String label, int xPos, int yPos, int width, int height) {
    l = label;
    x = xPos;
    y = yPos;
    w = width;
    h = height;
    r = 4;
    s = 1;
    bg = color(0, 128);
    og = color(360, 224);
    fg = color(360, 224);
  }
  
  void draw() {
    noStroke();
    
    if (pressed()) {
      fill(lerpColor(bg, color(0, 0, 0), 0.25));
    } else if (hover()) {
      fill(lerpColor(bg, color(0, 0, 100), 0.25));
    } else {
      fill(bg);
    }
    
    if (s > 0) {
      strokeWeight(s);
      stroke(og);
    } else {
      noStroke();
    }
    
    rect(x, y, w, h, r);
    
    noStroke();
    
    textAlign(CENTER, CENTER);
    fill(fg);
    textFont(jetbrainsmono);
    text(l, x + (w / 2), y + (h / 2) - 3);
  }
  
  void setLabel(String newlabel) { l = newlabel; }
  String getLabel() { return l; }
  
  boolean hover() { return mouseX >= x && mouseX < (x + w) && mouseY >= y && mouseY < (y + h); }
  boolean pressed() { return mousePressed && mouseButton == LEFT && hover(); }
}

class Number {
  Button display, decrease, increase;
  String l;
  int v, x, y, w, h;
  
  Number(String label, int value, int xPos, int yPos, int width, int height) {
    l = label;
    v = value;
    x = xPos;
    y = yPos;
    w = width;
    h = height;
    
    display = new Button(l + " (" + str(v) + ")", x + h + 10, y, w - h * 2 - 20, h);
    decrease = new Button("-", x, y, h, h);
    increase = new Button("+", x + w - h, y, h, h);
  }
  
  void draw() {
    display.draw();
    decrease.draw();
    increase.draw();
  }
  
  void setLabel(String newlabel) { l = newlabel; display.l = newlabel + " (" + str(v) + ")"; }
  String getLabel() { return l; }

  void setValue(int newvalue) { v = newvalue; setLabel(l); }
  int getValue() { return v; }

  boolean hover() { return decrease.hover() || display.hover() || increase.hover(); }
}
