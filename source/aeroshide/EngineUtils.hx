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