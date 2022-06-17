Grid grid;

void setup () {
  size(800, 800);
  surface.setResizable(true);
  surface.setTitle("Minesweeper");
  grid = new Grid(20,30);
  grid.populate_mines(90);
}


void draw () {
  background(0);
  grid.update();
}


void mouseClicked () {
  int x = int((mouseX-grid.offset.x)/grid.cell_size);
  int y = int((mouseY-grid.offset.y)/grid.cell_size);
  if (mouseButton == LEFT) {
    if (!grid.cells.get(x+y*grid.n_x).has_flag 
    && !grid.cells.get(x+y*grid.n_x).is_visible) {
      grid.uncover(x, y);
    }
  } else {
    if (!grid.cells.get(x+y*grid.n_x).is_visible){
      grid.cells.get(x+y*grid.n_x).has_flag ^= true;
    }
  }
}

void keyPressed () {
  if (key == 'r' || key == 'R'){
    setup();
  }
}
