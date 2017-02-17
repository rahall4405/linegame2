int rows, columns;
int side = 100;

color palleteColors[] = { color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), 
  color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)};
color colors[][];
int topColorRow;
int bottomColorRow;
int startingCheckColumn;

void setup() {
 //size(1900, 1000);
 size(800,800);
 background(190,190,190);
  rows = height/side;
  columns = width/side;
  colors = new color [rows] [columns];
  strokeWeight(5);
  for (int i=0; i<rows; i++) 
    for (int j=0; j<columns; j++) {
      colors[i][j] = palleteColors[floor(random(0, palleteColors.length))];
      
         fill(colors[i][j]);
         rect(j*side, i*side, side, side, 10);
      
     
    }
}

void draw() {
}

int score =0;
int matchedBoxes = 0;
void mouseClicked() {
   //<>//
  
  // (mouseX, mouseY) --> (c, r) //<>//
  // find the box that the user clicked on
  int selectedColumn = mouseX/side;
  int selectedRow = mouseY/side;

  //color of the box user clicked on
  color selectedColor = colors[selectedRow][selectedColumn]; 
  
  int matchedBoxes = 0; //count # of boxes with selected color
  boolean adjacentColorMatches;
  // must check for adjacent matches to make sure that there is at least 2 boxesof the same color
  if(selectedColumn > 0 && selectedColumn < columns -1) {
    adjacentColorMatches = colors[selectedRow][selectedColumn] == colors[selectedRow][selectedColumn-1] ||
    colors[selectedRow][selectedColumn] == colors[selectedRow][selectedColumn+1];
    
  } else if (selectedColumn > 0) {
    adjacentColorMatches = colors[selectedRow][selectedColumn] == colors[selectedRow][selectedColumn-1];
  } else {
    adjacentColorMatches = colors[selectedRow][selectedColumn] == colors[selectedRow][selectedColumn+1];
  }
  fixColorColumn(selectedColumn,selectedRow,selectedColor,adjacentColorMatches);
 
 
   checkColumns();
   checkColumns();
   redrawScreen();
  
  // check columns
  
  score += matchedBoxes*matchedBoxes; // pow(matchedBoxes, 3); favors higher number of matched colors
  println(matchedBoxes*matchedBoxes, score); 
  
}

void fixColorColumn(int selectedColumn,int selectedRow,color selectedColor, 
boolean adjacentColorMatches) {
   topColorRow = selectedRow;
   bottomColorRow = selectedRow;
   matchedBoxes++;
   // find the top row that mathces for the column //<>//
   for(int i= selectedRow+1;i<rows;i++) { //<>//
     if (colors[i][selectedColumn] == selectedColor) {
       topColorRow = i;
        matchedBoxes++;
        
     } else {
       break;
     }
     
   }
   // find the bottom row that matches for the column
   for(int i= selectedRow-1;i>=0;i--) {
     if (colors[i][selectedColumn] == selectedColor) {
       bottomColorRow = i;
        matchedBoxes++;
     } else {
       break;
     }
   }
    // if there is more than one block that matches color
   if ( topColorRow != bottomColorRow || adjacentColorMatches) {
     int numberOfChangesInPosition = topColorRow - bottomColorRow;
     for (int i=topColorRow; i >= 0; i--) {
       if (i <=  numberOfChangesInPosition) {
         colors[i][selectedColumn] = 0;
       } else {
         colors[i][selectedColumn] = colors[i-numberOfChangesInPosition-1][selectedColumn];
         
       }
     }
   }
    if (selectedColumn+1 < columns) {
       if (selectedColor == colors[selectedRow][selectedColumn+1])
         fixColorColumn(selectedColumn+1,selectedRow,selectedColor,true);
     }
    /* if(selectedRow+1 < rows) { 
       if (selectedColor == colors[selectedRow+1][selectedColumn])
         fixColorColumn(selectedColumn,selectedRow+1,selectedColor,true);
     } */
     if(selectedColumn-1 >= 0) {
       if (selectedColor == colors[selectedRow][selectedColumn-1])
         fixColorColumn(selectedColumn-1,selectedRow,selectedColor,true);
     }
   
   for(int i= bottomColorRow; i<=topColorRow;i++) {
     
     if (selectedColumn+1 < columns) {
       if (selectedColor == colors[i][selectedColumn+1])
         fixColorColumn(selectedColumn+1,i,selectedColor,true);
     }
    /* if(selectedRow+1 < rows) { 
       if (selectedColor == colors[selectedRow+1][selectedColumn])
         fixColorColumn(selectedColumn,selectedRow+1,selectedColor,true);
     } */
     if(selectedColumn-1 >= 0) {
       if (selectedColor == colors[i][selectedColumn-1])
         fixColorColumn(selectedColumn-1,i,selectedColor,true);
     }
   }
     /*if(selectedRow-1 > 0) {
       if (selectedColor == colors[selectedRow-1][selectedColumn])
       fixColorColumn(selectedColumn,selectedRow-1,selectedColor,true);
   } */
   
   
   
  }
  void redrawScreen() {
    clear();
    background(190,190,190);
     for (int i=0; i<rows; i++) 
    for (int j=0; j<columns; j++) {
      //colors[i][j] = palleteColors[floor(random(0, palleteColors.length))];
      if (colors[i][j] !=0) {
         fill(colors[i][j]);
         rect(j*side, i*side, side, side, 10);
      }
     
    }
    
  }
  
  void checkColumns() {
    for(int i=0; i< columns-1; i++) {
      boolean allBlank = true; //<>//
      for(int j=0;j<rows;j++) { //<>//
        if (colors[j][i] != 0) {
          allBlank = false;
        }
      }
      if(allBlank) {
        pullOver(i); //<>//
        //checkColumns();
        break;
      }
     
    
    }
  
  }  
  
  void pullOver(int column) {
    for (int i=column; i<=columns-1; i++) { //<>//
      
      for(int j=0;j<rows;j++) {
        if(i==columns-1) {
        colors[j][i] = 0;
        } else {
        colors[j][i] = colors[j][i+1];
        }
      }

    }
  }