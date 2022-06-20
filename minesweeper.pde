Grid grid;

void setup () {
  size(800, 800, P2D);
  surface.setResizable(true);
  surface.setTitle("Minesweeper");
  grid = new Grid(20,30);
  grid.populate_mines(90);
}

void draw() {
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
  if (key == 'q' || key == 'Q'){
    exit();
  }
  if (key == ' '){
    grid.cells.get(grid.selected_x+grid.selected_y*grid.n_x).has_flag ^= true;
  }
  if (key == ENTER || key == RETURN) { 
     if (!grid.cells.get(grid.selected_x+grid.selected_y*grid.n_x).has_flag 
      && !grid.cells.get(grid.selected_x+grid.selected_y*grid.n_x).is_visible) {
      grid.uncover(grid.selected_x, grid.selected_y);
      }
      }
  
 
  if (key == CODED) {
  switch (keyCode) {
    case UP:
      grid.selected_y = (grid.selected_y > 0)?(grid.selected_y-1):(grid.selected_y);
    break;
    case DOWN:
      grid.selected_y = (grid.selected_y < grid.n_y - 1)?(grid.selected_y+1):(grid.selected_y);
    break;
    case LEFT:
      grid.selected_x = (grid.selected_x > 0)?(grid.selected_x-1):(grid.selected_x);
    break;
    case RIGHT:
      grid.selected_x = (grid.selected_x < grid.n_x - 1)?(grid.selected_x+1):(grid.selected_x);
    break;
    
  }
  }
}
