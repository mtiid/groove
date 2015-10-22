// value of 8th
0.10::second => dur T;
// number of targets
1 => int targets;
// port
6449 => int port;

// send objects
OscSend xmit[targets];

// aim the transmitter at port
xmit[0].setHost ( "localhost", port );
//xmit[1].setHost ( "albacore.local", port );
/*xmit[2].setHost ( "transfat.local", port );
xmit[3].setHost ( "tofurkey.local", port );
xmit[4].setHost ( "shabushabu.local", port );
xmit[5].setHost ( "dolsotbibimbop.local", port );
xmit[6].setHost ( "blt.local", port );
xmit[7].setHost ( "heartstop.local", port );
xmit[8].setHost ( "doubledouble.local", port );
xmit[9].setHost ( "flavorblasted.local", port );
xmit[10].setHost ( "aguachile.local", port );
xmit[11].setHost ( "turducken.local", port );
xmit[12].setHost ( "xiaolongbao.local", port );
xmit[13].setHost ( "tikkamasala.local", port );
xmit[14].setHost ( "froyo.local", port );
xmit[15].setHost ( "pupuplatter.local", port );
xmit[16].setHost ( "peanutbutter.local", port );
xmit[17].setHost ( "quesadilla.local", port );
xmit[18].setHost ( "snickers.local", port );
*/
// get pane
//AudicleGroove.pane() @=> AudiclePane @ pane;

int x;
int y;
int z;

0 => int W_OFFSET;
0 => int H_OFFSET;
8 => int WIDTH;
4 => int HEIGHT;

// infinite time loop
while( true )
{
    for( H_OFFSET => y; y < H_OFFSET+HEIGHT; y++ )
        for( W_OFFSET => x; x < W_OFFSET+WIDTH; x++ )
        {
            for( 0 => z; z < targets; z++ )
            {
                // start the message...
                xmit[z].startMsg( "/plork/synch/clock", "i i" );

                // a message is kicked as soon as it is complete
                x => xmit[z].addInt; y => xmit[z].addInt;

                xmit[z].startMsg( "/plork/synch/filter", "f f" );
                Math.random2f(100, 500) => xmit[z].addFloat;
                Math.random2f(0.5, 2) => xmit[z].addFloat;
            }

            // advance time
            T => now;
        }
}
