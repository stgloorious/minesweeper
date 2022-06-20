/**
 * @brief contains all cells
 *
 */
class Grid {
  ArrayList<Cell> cells;
  int n_x; //number of cells
  int n_y;
  int cell_size;
  PVector offset;
  int selected_x;
  int selected_y;

  PImage mine_img;
  PImage flag_img;

  Grid (int nx, int ny) {
    n_x = nx;
    n_y = ny;
    mine_img = loadImage("mine.png");
    flag_img = loadImage("flag.png");
    cells = new ArrayList<Cell>();
    cell_size = width/n_x;
    for (int y = 0; y < n_y; y++) {
      for (int x = 0; x < n_x; x++) {
        cells.add(new Cell(cell_size, x, y, mine_img, flag_img));
      }
    }
    selected_x = 0;
    selected_y = 0;
    offset = new PVector(0, 0);
  }

  void populate_mines(int n_mines) {
    while (n_mines > 0) {
      int x = int(random(n_x));
      int y = int(random(n_y));
      if (!(cells.get(x+n_x*y).has_mine)) {
        cells.get(x+n_x*y).has_mine=true;
        n_mines--;
      }
    }
  }

  /**
   * @brief Updates and redraws grid
   * @note to be called periodically
   */
  void update () {
    for (int x = 0; x < n_x; x++) {
      for (int y = 0; y < n_y; y++) {
        grid.count_neighbors(x, y);
        if (x == selected_x && y == selected_y) {
          cells.get(x+n_x*y).is_selected = true;
        } else {
          cells.get(x+n_x*y).is_selected = false;
        }
      }
    }

    //resize cells if window size changed and redraw
    for (Cell c : cells) {
      cell_size = min(width/n_x, height/n_y);
      offset.x = (width-n_x*c.size)/2;
      offset.y = (height-n_y*c.size)/2;
      c.offset = offset;
      c.size = cell_size;
      c.update();
    }
  }

  /**
   * @brief counts neighbors of (x,y) and updates value in object
   * @returns number of neighbors of (x,y);
   */
  int count_neighbors(int x, int y) {
    cells.get(x+n_x*y).n_neighbors=0;
    for (int dx=-1; dx<=1; dx++) {
      for (int dy=-1; dy<=1; dy++) {
        if ((x==0 && dx==-1)||(x==n_x-1 && dx==1)||
          (y==0 && dy==-1)||(y==n_y-1 && dy==1)) {
          continue;
        }
        if (dx==0 && dy==0) {
          continue;
        }
        if (cells.get((x+dx)+n_x*(y+dy)).has_mine) {
          cells.get(x+n_x*y).n_neighbors++;
        }
      }
    }
    return cells.get(x+n_x*y).n_neighbors;
  }

  /**
   * @brief uncovers all cells at the end of the game and highlights incorrect flags
   *
   */
  void uncover_all() {
    for (Cell c : cells) {
      c.is_visible = true;
      if (c.has_flag && !c.has_mine) {
        c.color_visible = color(255, 0, 0);
      }
      c.update();
    }
  }

  /**
   * @brief uncovers an individual cell and its neighbors if necessary, or aborts the game
   *
   */
  void uncover(int x, int y) {
    if (cells.get(x+n_x*y).has_mine) {
      game_over(x, y);
    }
    if (!(cells.get(x+n_x*y).is_visible) && !(cells.get(x+n_x*y).has_flag)) {
      cells.get(x+n_x*y).is_visible = true;
      if (count_neighbors(x, y)==0) {
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            if ((x == 0 && dx == -1) || (x == n_x - 1 && dx == 1)
              || (y == 0 && dy == -1) || (y == n_y - 1 && dy == 1)) {
              continue;
            }
            uncover(x+dx, y+dy);
          }
        }
      }
    }
  }

  void game_over(int x, int y) {
    cells.get(x+y*n_x).color_visible = color(255, 0, 0);
    selected_x = -1;
    uncover_all();
    textSize(height*0.1);
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    //text("Game over!",width/2,height/2);
  }
};
