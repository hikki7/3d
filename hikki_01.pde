
// Global variables
float depth = 900;

float widthOffset;
float heightOffset;
float depthOffset;

int bobCount = 200;
ArrayList<Bob> bobs = new ArrayList<Bob>();


PVector mouseClick = new PVector();

PVector posStart = new PVector();
PVector rotStart = new PVector();
float zoomStart = 0;

PVector cameraPos = new PVector();
PVector cameraRot = new PVector();
float cameraZoom = -800;

void setup() {
  fullScreen(P3D);
  
  hint(DISABLE_DEPTH_TEST);

  widthOffset = width/2;
  heightOffset = height/2;
  depthOffset = depth/2;

  for (int i = 0; i < bobCount; i++) {
    bobs.add(new Bob(random(0.0, width), random(0.0, height), random(0.0, depth), random(0.5, 2.0)));
  }
}


void draw() {
  background(0, 20, 30);
  blendMode(ADD);

  pushMatrix();

  translate(width/2, height/2, depth/2);
  translate(cameraPos.x, cameraPos.y, cameraZoom);
  rotateY(radians(cameraRot.x));
  rotateX(radians(-cameraRot.y));

  for (Bob bob : bobs) {
    bob.run();
  }
  popMatrix();
}


// Initializes camera controls
void mousePressed() {
  if (mouseButton == LEFT) {
    rotStart.set(cameraRot.x, cameraRot.y);
  } else if (mouseButton == CENTER) {
    posStart.set(cameraPos.x, cameraPos.y);
  } else {
    zoomStart = cameraZoom;
  }
  mouseClick.set(mouseX, mouseY);
}


// Camera controls
void mouseDragged() {
  if (mouseButton == LEFT) {
    cameraRot.x = rotStart.x+(mouseX-mouseClick.x);
    cameraRot.y = rotStart.y+(mouseY-mouseClick.y);
  } else if (mouseButton == CENTER) {
    cameraPos.x = posStart.x+(mouseX-mouseClick.x);
    cameraPos.y = posStart.y+(mouseY-mouseClick.y);
  } else if (mouseButton == RIGHT) {
    cameraZoom = zoomStart+(mouseX-mouseClick.x)-(mouseY-mouseClick.y);
  }
}
