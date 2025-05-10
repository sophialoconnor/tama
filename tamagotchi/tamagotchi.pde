// Pet avatar images
PImage babyImg, teenImg, adultImg, currentAvatar;
PFont myFont;
// Pet stats
int hunger = 100;
int happiness = 100;
int energy = 100;
int age = 0;
int lastUpdate;

void setup() {
  size(400, 400);
myFont = createFont("Georgia", 18);
  textFont(myFont);
  // Load avatar images
  babyImg = loadImage("pet_baby.png");
  teenImg = loadImage("pet_teen.png");
  adultImg = loadImage("pet_adult.png");

  // Load pet state
  loadState();
  updateAvatar();

  lastUpdate = millis();
}

void draw() {
  background(255, 179, 217);

  // Display current avatar
  if (currentAvatar != null) {
    image(currentAvatar, width/2 - currentAvatar.width/2, height/2 - currentAvatar.height/2);
  }

  // Update stats and age
  updateStats();
  updateAge();

  // Display stats
fill(0);
textAlign (LEFT);
text("Hunger: " + hunger, 20, 180);
text("Happiness: " + happiness, 20, 200);
text("Energy: " + energy, 20, 220);
text("Age: " + age, 20, 240);

  // Draw buttons
  drawButton(50, 320, "Feed");
  drawButton(160, 320, "Play");
  drawButton(270, 320, "Sleep");
}
void drawButton(int x, int y, String label) {
  int w = 80;
  int h = 30;

  boolean hovering = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;

  if (hovering) {
    // Glow effect behind button
    noStroke();
    fill(255, 255, 255, 100);  // white with alpha
    rect(x - 5, y - 5, w + 10, h + 10, 8); // larger, soft glow box
  }

  // Button border
  stroke(hovering ? 255 : 0);  // white border on hover
  fill(255, 230, 242);  // button background
  rect(x, y, w, h, 5); // rounded corners

  // Button label
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2);
}

void updateStats() {
  if (millis() - lastUpdate > 2000) {
    hunger = max(0, hunger - 5);
    happiness = max(0, happiness - 3);
    energy = max(0, energy - 2);
    lastUpdate = millis();
  }
}

void updateAge() {
  if (frameCount % (60 * 5) == 0) { // Every 5 seconds
    age++;
    updateAvatar();
    saveState();  // Save on age change
  }
}

void updateAvatar() {
  if (age < 10) {
    currentAvatar = babyImg;
  } else if (age < 20) {
    currentAvatar = teenImg;
  } else {
    currentAvatar = adultImg;
  }
}

void mousePressed() {
  if (mouseX > 50 && mouseX < 130 && mouseY > 320 && mouseY < 350) {
    feed();
  } else if (mouseX > 160 && mouseX < 240 && mouseY > 320 && mouseY < 350) {
    play();
  } else if (mouseX > 270 && mouseX < 350 && mouseY > 320 && mouseY < 350) {
    sleep();
  }
  saveState();  // Save on interaction
}

void feed() {
  hunger = min(100, hunger + 20);
}

void play() {
  happiness = min(100, happiness + 15);
  energy = max(0, energy - 10);
}

void sleep() {
  energy = min(100, energy + 30);
}

void saveState() {
  String[] state = {
    str(hunger),
    str(happiness),
    str(energy),
    str(age)
  };
  saveStrings("pet_state.txt", state);
}

void loadState() {
  String[] state = loadStrings("pet_state.txt");
  if (state != null && state.length == 4) {
    hunger = int(state[0]);
    happiness = int(state[1]);
    energy = int(state[2]);
    age = int(state[3]);
  }
}
