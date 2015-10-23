

class Groover
{
    8 => int COLS;
    4 => int ROWS;
    
    int sequencer[COLS][ROWS];
    float border[COLS][ROWS];
    0 => int row;
    0 => int col;

    [[0.5, 0.5, 0.5], // gray
    [1.0, 0.5, 0.5], // red
    [0.5, 1.0, 0.5], // green
    [0.4, 0.4, 1.0], // blue
    [1.0, 1.0, 0.5], // yellow
    [1.0, 0.65, 0.3], // orange
    [1.0, 0.5, 1.0], // magenta
    [0.5, 0.8, 1.0], // uh
    [0.5, 1.0, 1.0]] // cyan
    @=> float colors[][];
    
    100 => float box_size;
    
    chugl @ gfx;
    float WIDTH, HEIGHT;
    float SEQ_X, SEQ_Y, SEQ_W, SEQ_H;
    
    fun void init()
    {
        new chugl @=> gfx;
        gfx.fullscreen();
        gfx.width() => WIDTH;
        gfx.height() => HEIGHT;
        
        WIDTH*0.05 => SEQ_X;
        WIDTH-SEQ_X*2 => SEQ_W;
        HEIGHT*0.3 => SEQ_Y;
        HEIGHT-SEQ_Y => SEQ_H;
        
        SEQ_W/12 => box_size;
    }
    
    fun void go()
    {
        spork ~ mainLoop();
    }
    
    fun void mainLoop()
    {
        while(true)
        {
            render();
            
            (1.0/60.0)::second => now;
        }
    }
    
    fun void update()
    {
        // fade out borders
        for(0 => int i; i < COLS; i++)
        {
            for(0 => int j; j < ROWS; j++)
            {
                0.97 *=> border[i][j];
            }
        }
    }
    
    fun void render()
    {
        if(gfx == null) return;
        
        update();
        
        for(0 => int i; i < COLS; i++)
        {
            for(0 => int j; j < ROWS; j++)
            {
                SEQ_X+SEQ_W/2+(SEQ_W/COLS)*(i-COLS/2)+(SEQ_W/COLS*0.5) => float posX;
                SEQ_Y+SEQ_H/2+(SEQ_H/ROWS)*((ROWS-1-j)-ROWS/2)+(SEQ_H/ROWS*0.5) => float posY;
                
                // draw green indicator
                if(border[i][j] > 0.01)
                {
                    box_size*1.2 => float size;
                    gfx.color(0.2, 0.8, 0.2, border[i][j]);
                    gfx.rect(posX-size/2, posY-size/2, size, size);
                }
                
                // draw border
                box_size*1.02 => float border_size;
                gfx.color(1, 1, 1);
                gfx.rect(posX-border_size/2, posY-border_size/2, border_size, border_size);
                
                // draw step
                sequencer[i][j] => int c;
                gfx.color(colors[j][0], colors[j][1], colors[j][2]);
                gfx.rect(posX-box_size/2, posY-box_size/2, box_size, box_size);
            }
        }
    }
    
    fun void setPos(int r, int c)
    {
        r => row;
        c => col;
        1 => border[row][col];
    }
}

Groover groover;
groover.init();
groover.go();

while(true)
{
    for(int r; r < 4; r++)
    {
        for(int c; c < 8; c++)
        {
            groover.setPos(c, r);
            0.125::second => now;
        }
    }
}

