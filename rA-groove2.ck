// groove receiver

Groover groover;
groover.init();
groover.go();

// patch
sndbuf s[9];
LPF filter[9];
JCRev r => dac;
for( int i; i < s.cap(); i++ ) 
{
    // disable filter (for now)
    // s[i] => filter[i] => r;
    s[i] => r;
    Math.random2f(100, 200) => filter[i].freq;
    2 => filter[i].Q;
    0 => s[i].gain;
}
.01 => r.mix;

"Sounds/Silence.au" => s[0].read;
"Sounds/HBell1Open.au" => s[1].read;
"Sounds/HBell1OpenB.au" => s[2].read;
"Sounds/HBell1Closed.au" => s[3].read;
"Sounds/HBell1ClosedB.au" => s[4].read;
"Sounds/HDjemBass.au" => s[5].read;
"Sounds/HDjemBass.au" => s[6].read;
"Sounds/HDjemTone.au" => s[7].read;
"Sounds/HDjemSlap.au" => s[8].read;

// create our OSC receiver
OscRecv recv;
// use port 6449
6449 => recv.port;
// start listening (launch thread)
recv.listen();

// create an address in the receiver, store in new variable
recv.event( "/plork/synch/clock, i i" ) @=> OscEvent oe;

recv.event( "/plork/synch/filter, f f" ) @=> OscEvent filterEvent;

// <<< pane.width(), pane.height() >>>;

[[1.0, 0.2, 0.3, 0.2, 0.4, 0.1, 0.2, 0.1],
[0.5, 0.1, 0.3, 0.2, 0.4, 0.1, 0.2, 0.1],
[0.8, 0.1, 0.3, 0.2, 0.5, 0.1, 0.2, 0.1],
[0.4, 0.1, 0.3, 0.2, 0.3, 0.1, 0.2, 0.1]] @=> float mygains[][];

int x;
int y;
int value;

spork ~ listenFilterEvent();

// infinite event loop
while ( true )
{
    // wait for event to arrive
    oe => now;

    // grab the next message from the queue. 
    while( oe.nextMsg() != 0 )
    {
        // get x and y
        oe.getInt() => x;
        oe.getInt() => y;
        // set glow
        groover.setPos( x, y );
        // get value
        groover.getStep( x, y ) => value;
        // play the thing
        play( value );
    }
}

// do something
fun void play( int value )
{
    float temp;

    if( value == 0 ) return;

    // if( std.rand2f(0.0,1.0) < mygains[y][x] )
    // {
        // <<< "playing:", value >>>;
        0.2 + std.rand2f( 0.0, mygains[y][x] ) => temp;
        temp => s[value].gain;
        0 => s[value].pos;
    // }
}

fun void listenFilterEvent()
{
    while(true)
    {
        filterEvent => now;
        
        while( filterEvent.nextMsg() != 0 )
        {
            // get x and y
            filterEvent.getFloat() => float freq;
            filterEvent.getFloat() => float Q;
            
            for(0 => int i; i < filter.size(); i++)
            {
                freq => filter[i].freq;
                Q => filter[i].Q;
            }
        }
    }
}
