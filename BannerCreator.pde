color bgTop, bgBottom;
int oldWidth, oldHeight;
int h, s, c, d = 130, v = 80, z = 26;

PFont jetbrainsmono;
PGraphics bannertop, banner;

Button random, save;
Number hue, sat, change, depth, value, zoom;

void setup() {
  size(1500, 330);
  colorMode(HSB, 360, 100, 100);
  
  oldWidth = width;
  oldHeight = height;
  
  surface.setTitle("Banner Creator");
  surface.setResizable(true);
  registerMethod("pre", this);
  
  jetbrainsmono = createFont("JetBrainsMono-Light.ttf", 14);
  
  random = new Button("Random", 10, 10, 240, 30);
  hue = new Number("Hue", 0, 10, 50, 240, 30);
  sat = new Number("Sat", 0, 10, 90, 240, 30);
  change = new Number("Shift", 0, 10, 130, 240, 30);
  depth = new Number("Depth", 0, 10, 170, 240, 30);
  value = new Number("Gradient", 0, 10, 210, 240, 30);
  zoom = new Number("Zoom", 0, 10, 250, 240, 30);
  save = new Button("Save", 10, 290, 240, 30);
  
  banner = createGraphics(width, height);
  bannertop = createGraphics(width, height);
  
  randomBanner();
}

void pre() {
  if (oldWidth != width || oldHeight != height) {
    oldWidth = width;
    oldHeight = height;
    
    banner = createGraphics(width, height);
    bannertop = createGraphics(width, height);
    drawBanner();
  }
}

void draw() {
  image(banner, 0, 0);
  
  random.draw();
  
  hue.draw();
  sat.draw();
  change.draw();
  depth.draw();
  value.draw();
  zoom.draw();

  save.draw();
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case LEFT: h = h - 5; makeBanner(); updateButtons(); break;
      case RIGHT: h = h + 5; makeBanner(); updateButtons(); break;
      case UP: s = s + 5; makeBanner(); updateButtons(); break;
      case DOWN: s = s - 5; makeBanner(); updateButtons(); break;
    }
  } else {
    switch (key) {
      case 'r': randomBanner(); break;
      case 's': selectOutput("Save your banner...", "selected", new File("banner.png")); break;
      case '=': z = z + 2; makeBanner(); updateButtons(); break;
      case '-': z = z - 2; makeBanner(); updateButtons(); break;
    }
  }
}

void mouseMoved() {
  boolean o = false;
  o = random.hover() || o;
  o = hue.hover() || o;
  o = sat.hover() || o;
  o = change.hover() || o;
  o = depth.hover() || o;
  o = value.hover() || o;
  o = zoom.hover() || o;
  o = save.hover() || o;
  
  cursor(o ? HAND : ARROW);
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    if (random.hover()) randomBanner();
    
    if (hue.decrease.hover()) h = h - 5;
    if (sat.decrease.hover()) s = s - 5;
    if (change.decrease.hover()) c = c - 5;
    if (depth.decrease.hover()) d = d - 5;
    if (value.decrease.hover()) v = v - 5;
    if (zoom.decrease.hover()) z = z - 2;

    if (hue.increase.hover()) h = h + 5;
    if (sat.increase.hover()) s = s + 5;
    if (change.increase.hover()) c = c + 5;
    if (depth.increase.hover()) d = d + 5;
    if (value.increase.hover()) v = v + 5;
    if (zoom.increase.hover()) z = z + 2;

    makeBanner();
    updateButtons();
    
    if (save.hover()) selectOutput("Save your banner...", "selected", new File("banner.png"));
  }
}

void selected(File selection) {
  if (selection != null) {
    banner.save(selection.toString());
  }
}

void updateButtons() {
  hue.setValue(h);
  sat.setValue(s);
  change.setValue(c);
  depth.setValue(d);
  value.setValue(v);
  zoom.setValue(z);
}

void randomBanner() {
  h = round(random(0, 355) / 5) * 5;
  s = round(random(50, 100) / 5) * 5;
  c = round(random(10, 40) / 5) * 5;
  
  makeBanner();
  updateButtons();
}

void makeBanner() {
  h = min(max(h, 0), 355);
  s = min(max(s, 0), 100);
  c = min(max(c, 0), 60);
  d = min(max(d, 0), 255);
  v = min(max(v, 0), 95);
  z = min(max(z, 10), 40);
  
  if (h < 60 || h >= 300) {
    bgTop = color(min(h + c, 355), s / 2, 100);
    bgBottom = color(max(h - c, 0), s, 100 - v);
  } else {
    bgTop = color(max(h - c, 0), s / 2, 100);
    bgBottom = color(min(h + c, 355), s, 100 - v);
  }

  drawBanner();
}

void drawBanner() {
  bannertop.beginDraw();
  
  bannertop.background(0);
  bannertop.stroke(255);
  
  for (int x = 0; x < width; x += z) {
    for (int y = 0; y < height; y += z) {
      drawLine(bannertop, x, y, z);
    }
  }
  
  bannertop.endDraw();
  
  banner.beginDraw();
  banner.background(0);
  banner.strokeWeight(1);
  
  for (int i = 0; i < height + 1; i++) {
    banner.stroke(lerpColor(bgTop, bgBottom, float(i) / height));
    banner.line(0, i, width, i);
  }
  
  banner.blendMode(MULTIPLY);
  banner.tint(255, d);
  banner.image(bannertop, 0, 0);
  banner.tint(255, 255);
  banner.blendMode(BLEND);
  
  banner.endDraw();
}

void drawLine(PGraphics image, int x, int y, int size) {
  if (noise(x / float(size), y / float(size)) >= 0.5) {
    image.strokeWeight(size / 2);
    image.line(x, y, x + size, y + size);
  } else {
    image.strokeWeight(1);
    image.line(x + size, y, x, y + size);
  }
}
