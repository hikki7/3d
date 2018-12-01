
class Bob{
  
 
  PVector pos;
  PVector dir;
  float speed;

  Bob(float _x, float _y, float _z, float _speed) {
    this.pos = new PVector(_x, _y, _z);
    this.dir = PVector.random3D();
    this.dir.normalize();
    this.speed = _speed;
  }

  public void run() {
    move(); 
    keepInBounds();
    draw();
  }

  void move() {
    this.pos.x += this.dir.x*this.speed;
    this.pos.y += this.dir.y*this.speed;
    this.pos.z += this.dir.z*this.speed;
  }

  void keepInBounds() {
    if (this.pos.x < 0) {
      this.pos.x = 0;
      this.dir.x *= -1;
    } else if (this.pos.x > width) {
      this.pos.x = width;
      this.dir.x *= -1;
    }

    if (this.pos.y < 0) {
      this.pos.y = 0;
      this.dir.y *= -1;
    } else if (this.pos.y > height) {
      this.pos.y = height;
      this.dir.y *= -1;
    }

    if (this.pos.z < 0) {
      this.pos.z = 0;
      this.dir.z *= -1;
    } else if (this.pos.z > depth) {
      this.pos.z = depth;
      this.dir.z *= -1;
    }
  }

  // Get number of close enough bobs
  ArrayList<Bob> getNeighbors(float threshold) {
    ArrayList<Bob> proximityBobs = new ArrayList<Bob>();

    for (Bob otherBob : bobs) {
      if (this == otherBob) {
        continue;
      }

      float distance = dist(this.pos.x, this.pos.y, this.pos.z, 
        otherBob.pos.x, otherBob.pos.y, otherBob.pos.z);
      if (distance < threshold) {
        proximityBobs.add(otherBob);
      }
    }

    return proximityBobs;
  }

  void draw() {
    ArrayList<Bob> proximityBobs = this.getNeighbors(120);

    if (proximityBobs.size() > 0) {
      float blendValue = map(proximityBobs.size(), 0, 6, 0.0, 1.0);
      color smallColor = color(0, 255, 255, 100);
      color bigColor = color(255, 0, 0, 100);
      color currentColor = lerpColor(smallColor, bigColor, blendValue);

      // Draw line
      stroke(currentColor);

      for (Bob otherBob : proximityBobs) {
        line(this.pos.x-widthOffset, this.pos.y-heightOffset, this.pos.z-depthOffset, 
          otherBob.pos.x-widthOffset, otherBob.pos.y-heightOffset, otherBob.pos.z-depthOffset);
      }

      // Draw red bob
      smooth();
      stroke(150, 150, 200, 10);
      strokeWeight(proximityBobs.size()*10);
      point(this.pos.x-widthOffset, this.pos.y-heightOffset, this.pos.z-depthOffset);

      stroke(currentColor);
      strokeWeight(proximityBobs.size()*3);
      point(this.pos.x-widthOffset, this.pos.y-heightOffset, this.pos.z-depthOffset);

      stroke(20,20,225);
      strokeWeight(proximityBobs.size());
      point(this.pos.x-widthOffset, this.pos.y-heightOffset, this.pos.z-depthOffset);
      noSmooth();
    }

    stroke(255);
    strokeWeight(1);
    point(this.pos.x-widthOffset, this.pos.y-heightOffset, this.pos.z-depthOffset);

    // Bobs with too many neighbours slow down, otherwise speed it up
    if (proximityBobs.size() > 2) {
      this.speed *= 0.97;
    } else {
      this.speed *= 1.01;
    }
    this.speed = max(0.25, min(this.speed, 6));
  }
}
