/**
 * @brief Individual cell
 *
 */
class Cell {
  /* Game state */
  boolean is_visible;
  boolean has_flag;
  boolean has_mine;
  int n_neighbors;

  /* Position & Dimension */
  int pos_x; // indexed position of cell
  int pos_y;
  PVector offset; //Global offset wrt canvas
  int size; // pixel width/height of cell

  /* Appearance */
  color color_visible;
  color color_hidden;
  color color_text;
  color color_selected;
  PImage mine_img;
  PImage flag_img;
  boolean is_selected;

  Cell (int cell_size, int x_pos, int y_pos, PImage mine, PImage flag) {
    is_visible = false;
    n_neighbors = 0;
    has_mine = false;
    pos_x = x_pos;
    pos_y = y_pos;
    offset = new PVector(0, 0);
    size = cell_size;
    color_visible = color(180);
    color_hidden = color(50);
    color_selected = color(220);
    is_selected = false;
    mine_img = mine;
    flag_img = flag;
  }

  /**
   * @brief Draws cell on canvas
   *
   */
  void update() {
    // Draw cell box
    if (is_visible) {
      if (is_selected) {
          fill(color_selected);
      } else {
          fill(color_visible);
      }
    }
    else {
      if (is_selected) {
          fill(color_selected);
      } else {
          fill(color_hidden);
      }

    }

    rect(offset.x+pos_x*size, offset.y+pos_y*size, size, size);

    // Uncovered, empty cell shows number of neighbors
    if (is_visible & !has_mine) {
      fill(color_text);
      textAlign(CENTER, BASELINE);
      textSize(size);
      if (n_neighbors > 0) {
        text(n_neighbors, offset.x+pos_x*size+size/2, offset.y+pos_y*size+size*0.8);
      }
    }
    // Draw mines and flags
    if (is_visible && has_mine) {
      imageMode(CENTER);
      image(mine_img, offset.x+pos_x*size+size/2, offset.y+pos_y*size+size/2, size, size);
    }
    if (has_flag) {
      imageMode(CENTER);
      image(flag_img, offset.x+pos_x*size+size/2, offset.y+pos_y*size+size/2, size, size);
    }
  }
};
