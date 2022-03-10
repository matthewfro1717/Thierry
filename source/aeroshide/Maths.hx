package aeroshide;

import openfl.events.Event;
import openfl.system.System;
import haxe.SysTools;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * Maths formulas
 * @author Aeroshide
 */

class Maths extends MusicBeatState
{
	public static function truncateFloat( number : Float, precision : Int): Float 
    {
        var num = number;
        num = num * Math.pow(10, precision);
        num = Math.round( num ) / Math.pow(10, precision);
        return num;
    }
}


