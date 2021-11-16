package;
import openfl.system.System;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * shut up idiot im not bbpanzu hes a gay
 */
class CrasherStateEnding extends FlxState
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
		super.create();
		var end:FlxSprite = new FlxSprite(0, 0);
		end.loadGraphic(Paths.image("ending/" + _ending));
		FlxG.sound.playMusic(Paths.music(_song),1,true);
		add(end);
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
		FlxG.save.data.setanSongUnlocked = true;
		trace("GAVE GHOST SONG ACCESS");
		trace("LMAO CRASHED");
		FlxG.save.data.willSeeCrashEnding = false;
		FlxG.save.data.hasSeenCrashEnding = true;
		var bad = FlxG.save.data.willSeeCrashEnding;
		trace("FLIXEL SAVED TRUE BUT I DONT TRUST IT");
		trace("HERES AN ACTUAL INFO" + bad);
		checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
		'week5_nomiss', 'week6_nomiss', 'week7_nomiss']);
		System.exit(0);
	}
	
	private function checkForAchievement(achievesToCheck:Array<String>):String {
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName)) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'week3_nomiss':
						if (FlxG.save.data.hasSeenCrashEnding)
						{
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}

}