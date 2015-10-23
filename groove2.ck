
public class Groover
{
    8 => int COLS;
    4 => int ROWS;
    8 => int CTRLS;
    
    int sequencer[COLS][ROWS];
    float border[COLS][ROWS];
    float ctrlBorder[CTRLS+1];
    0 => int row;
    0 => int col;
    0 => int ctrl;

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
    float CTRL_X, CTRL_Y, CTRL_W, CTRL_H;
    
    fun void init()
    {
        new chugl @=> gfx;
        gfx.fullscreen();
        gfx.width() => WIDTH;
        gfx.height() => HEIGHT;
        
        WIDTH*0.05 => SEQ_X;
        WIDTH-SEQ_X*2 => SEQ_W;
        HEIGHT*0.33 => SEQ_Y;
        HEIGHT-SEQ_Y => SEQ_H;
        
        0 => CTRL_X;
        WIDTH => CTRL_W;
        0 => CTRL_Y;
        SEQ_Y-CTRL_Y => CTRL_H;
        
        SEQ_W/(COLS*1.55) => box_size;
        
        setControl(0);
    }
    
    fun void go()
    {
        spork ~ mainLoop();
        spork ~ doMouseClick();
    }
    
    fun void mainLoop()
    {
        while(true)
        {
            render();
            
            (1.0/30.0)::second => now;
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
        
        for(0 => int i; i < CTRLS+1; i++)
        {
            if(i != ctrl)
                0.93 *=> ctrlBorder[i];
        }
    }
    
    fun void render()
    {
        if(gfx == null) return;
        
        update();
        
        // draw sequencer
        for(0 => int i; i < COLS; i++)
        {
            for(0 => int j; j < ROWS; j++)
            {
                SEQ_X+SEQ_W/2+(SEQ_W/COLS)*(i-COLS/2)+(SEQ_W/COLS*0.5) => float posX;
                SEQ_Y+SEQ_H/2+(SEQ_H/ROWS)*((ROWS-1-j)-ROWS/2)+(SEQ_H/ROWS*0.5) => float posY;
                
                // draw indicator
                if(border[i][j] > 0.01)
                {
                    box_size*1.25 => float size;
                    gfx.color(0.2, 0.8, 0.2, border[i][j]);
                    gfx.rect(posX-size/2, posY-size/2, size, size);
                }
                
                // draw border
                box_size*1.02 => float border_size;
                gfx.color(1, 1, 1);
                gfx.rect(posX-border_size/2, posY-border_size/2, border_size, border_size);
                
                // draw step
                sequencer[i][j] => int c;
                gfx.color(colors[c][0], colors[c][1], colors[c][2]);
                gfx.rect(posX-box_size/2, posY-box_size/2, box_size, box_size);
            }
        }
        
        // draw controls
        for(0 => int i; i < 1+CTRLS; i++)
        {
            CTRL_X+CTRL_W/2+(CTRL_W/(CTRLS+1))*(i-(CTRLS+1)/2.0)+(CTRL_W/(CTRLS+1)*0.5) => float posX;
            CTRL_Y+CTRL_H/2 => float posY;
            
            // draw indicator
            if(ctrlBorder[i] > 0.01)
            {
                box_size*1.25 => float size;
                gfx.color(0.2, 0.8, 0.2, ctrlBorder[i]);
                gfx.rect(posX-size/2, posY-size/2, size, size);
            }
            
            // draw border
            box_size*1.02 => float border_size;
            gfx.color(1, 1, 1);
            gfx.rect(posX-border_size/2, posY-border_size/2, border_size, border_size);
            
            i+1 => int c;
            if(i == CTRLS)
                0 => c;
            // draw control
            gfx.color(colors[c][0], colors[c][1], colors[c][2]);
            gfx.rect(posX-box_size/2, posY-box_size/2, box_size, box_size);
        }
    }
    
    fun int getClickedStep(float x, float y)
    {
        for(0 => int i; i < COLS; i++)
        {
            for(0 => int j; j < ROWS; j++)
            {
                SEQ_X+SEQ_W/2+(SEQ_W/COLS)*(i-COLS/2)+(SEQ_W/COLS*0.5) => float posX;
                SEQ_Y+SEQ_H/2+(SEQ_H/ROWS)*((ROWS-1-j)-ROWS/2)+(SEQ_H/ROWS*0.5) => float posY;
                
                if(x > posX-box_size/2 && x < posX+box_size/2 &&
                   y > posY-box_size/2 && y < posY+box_size/2)
                {
                    return j*COLS+i;
                }
            }
        }
        
        return -1;
    }
    
    fun int getClickedControl(float x, float y)
    {
        // draw controls
        for(0 => int i; i < 1+CTRLS; i++)
        {
            CTRL_X+CTRL_W/2+(CTRL_W/(CTRLS+1))*(i-(CTRLS+1)/2.0)+(CTRL_W/(CTRLS+1)*0.5) => float posX;
            CTRL_Y+CTRL_H/2 => float posY;
            
            if(x > posX-box_size/2 && x < posX+box_size/2 &&
               y > posY-box_size/2 && y < posY+box_size/2)
            {
                return i;
            }
        }
        
        return -1;
    }
    
    fun void doMouseClick()
    {
        while(true)
        {
            gfx.pointer.stateChange => now;
            
            if(gfx.pointer.state)
            {
                gfx.pointer.x => float x;
                gfx.pointer.y => float y;

                getClickedStep(x, y) => int step;
                if(step >= 0)
                {
                    step%COLS => int col;
                    step/COLS => int row;
                    
                    <<< "col:", col, "row:", row >>>;
                    
                    setStep(col, row, ctrl);
                }
                else
                {
                    getClickedControl(x, y) => int c;
                    if(c >= 0)
                    {
                        <<< "ctrl:", c >>>;
                        setControl(c);
                    }
                }
            }
            else
            {
            }
        }
    }
    
    fun void setControl(int c)
    {
        c => ctrl;
        1 => ctrlBorder[c];
    }
    
    fun void setPos(int c, int r)
    {
        r => row;
        c => col;
        1 => border[col][row];
    }
    
    fun int getStep(int c, int r)
    {
        return sequencer[c][r];
    }
    
    fun void setStep(int c, int r, int value)
    {
        value => sequencer[c][r];
    }
}


