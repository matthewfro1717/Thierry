package aeroshide;

import flixel.FlxSprite;

class PlacementHelper extends FlxSprite
{

    public static function move(x:Int, y:Int, sprite:FlxSprite) 
    {
        sprite.x = x;
        sprite.y = y;
    }
}