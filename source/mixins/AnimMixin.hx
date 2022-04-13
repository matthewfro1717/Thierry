package mixins;


import Song.SwagSong;

using StringTools;

class AnimMixin extends PlayState
{
    public static var forceAnimTreshold:Int = 0;

    public static function makeOpponentIdle(LAGU:SwagSong, Opponent:Character, OpponentTwo:Character, Askers:Int, dadExecute:Bool) 
    {
        if (LAGU.song == 'Brute' && OpponentTwo != null && dadExecute)
        {
            if (Askers ==0)
            {
                OpponentTwo.playAnim('idle');
            }
            if (Askers ==1)
            {
                Opponent.playAnim('idle');
            }
            
        }
        else if (!dadExecute && OpponentTwo != null)
        {
            forceAnimTreshold += 1;

            if (forceAnimTreshold >= 10)
            {
                forceAnimTreshold = 0;
                OpponentTwo.playAnim('idle');
                Opponent.playAnim('idle');
            }
        } 

    } //336
}