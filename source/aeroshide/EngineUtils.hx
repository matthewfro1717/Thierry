package aeroshide;

import flixel.FlxSprite;

class PlacementHelper extends FlxSprite
{

    // TODO : RENAME CLASS TO ENGINE UNTILITES AND ADD MORE TIME COSUMING DECLARATIONS
    public static function move(x:Float, y:Float, sprite:FlxSprite) 
    {
        sprite.x = x;
        sprite.y = y;
    }
}

class Maths extends MusicBeatState
{
	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
	/*
		function generateRanking():String
		{
			var ranking:String = "N/A";

			if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
				ranking = "(MFC)";
			else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
				ranking = "(GFC)";
			else if (misses == 0) // Regular FC
				ranking = "(FC)";
			else if (misses < 10) // Single Digit Combo Breaks
				ranking = "(SDCB)";
			else if (misses < 100) // Double Digit Combo Breaks
				ranking = "(DDCB)";
			else
				ranking = "(Goblok)";

			// WIFE TIME :)))) (based on Wife3)

			var wifeConditions:Array<Bool> = [
				accuracy >= 99.9935, // AAAAA
				accuracy >= 99.980, // AAAA:
				accuracy >= 99.970, // AAAA.
				accuracy >= 99.955, // AAAA
				accuracy >= 99.90, // AAA:
				accuracy >= 99.80, // AAA.
				accuracy >= 99.70, // AAA
				accuracy >= 99, // AA:
				accuracy >= 96.50, // AA.
				accuracy >= 93, // AA
				accuracy >= 90, // A:
				accuracy >= 85, // A.
				accuracy >= 80, // A
				accuracy >= 70, // B
				accuracy >= 60, // C
				accuracy >= 55, // D
				accuracy < 54 // stupid
			];

			for(i in 0...wifeConditions.length)
			{
				var b = wifeConditions[i];
				if (b)
				{
					switch(i)
					{
						case 0:
							ranking += " AAAAA";
						case 1:
							ranking += " AAAA:";
						case 2:
							ranking += " AAAA.";
						case 3:
							ranking += " AAAA";
						case 4:
							ranking += " AAA:";
						case 5:
							ranking += " AAA.";
						case 6:
							ranking += " AAA";
						case 7:
							ranking += " AA:";
						case 8:
							ranking += " AA.";
						case 9:
							ranking += " AA";
						case 10:
							ranking += " A:";
						case 11:
							ranking += " A.";
						case 12:
							ranking += " A";
						case 13:
							ranking += " B";
						case 14:
							ranking += " C";
						case 15:
							ranking += " D";
						case 16:
							ranking += " Goblok!";
					}
					break;
				}
			}

			if (accuracy == 0)
				ranking = "N/A";

			return ranking;
		}
		/****/
}