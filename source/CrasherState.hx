package;
import openfl.system.System;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * shut up idiot im not bbpanzu hes a gay
 */
class CrasherState extends FlxState
{

	var _ending:String;
	var _song:String;
	
	public function new(ending:String,song:String) 
	{
		super();
		_ending = ending;
		_song = song;
	}
	
	override public function create():Void 
	{
		trace("LMAO CRASHED");
		FlxG.save.data.willSeeCrashEnding = true;
		var bad = FlxG.save.data.willSeeCrashEnding;
		trace("FLIXEL SAVED TRUE BUT I DONT TRUST IT");
		trace("HERES AN ACTUAL INFO" + bad);

		super.create();
		var end2:FlxSprite = new FlxSprite(0, 0);
		var end:FlxSprite = new FlxSprite(0, 0);
		if (FlxG.save.data.hasSeenCrashEnding)
		{
			end2.loadGraphic(Paths.image("bSOD2"));
			trace("YOU HAVE SEEN THE CRASHER ENDING, LOADING A SPECIAL PICTURE");
			trace("IF YOU SAW NOTHING, THEN THE PICTURE DIDNT LOAD");
			trace(end2);
			add(end2);
		}
		else
		{
			end.loadGraphic(Paths.image("ending/" + _ending));
			trace("YOU HAVENT SEEN THE CRASHER ENDING, LOADING A CRASH PICTURE");
			add(end);
		}
		FlxG.sound.playMusic(Paths.music(_song),1,true);
		
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true);	
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.ENTER){
			endIt();
		}
		
	}
	
	
	public function endIt(){
		trace("LMAO CRASHED");
		FlxG.save.data.willSeeCrashEnding = true;
		var bad = FlxG.save.data.willSeeCrashEnding;
		trace("FLIXEL SAVED TRUE BUT I DONT TRUST IT");
		trace("HERES AN ACTUAL INFO" + bad);
		System.exit(0);
	}
	
}