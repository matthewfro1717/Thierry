package;

import flixel.util.FlxTimer;
import TitleState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayBuffer extends MusicBeatState
{

	var songs:Array<SongMeta> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	public var bruhify:Int;
	public var timing:Int;
	var intendedScore:Int = 0;
	public var preloadSongs:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	public var firstboothere:Bool;
	public var frame:Int;
	var logo:FlxSprite;
	var text:FlxText;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		var buffSonglist = CoolUtil.coolTextFile(Paths.txt('listLaguTolol'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMeta(data[0], Std.parseInt(data[2]), data[1]));
			trace("Array 1 pushed");
			
		}
		for (i in 0...buffSonglist.length)
		{
			var otherdata:Array<String> = buffSonglist[i].split(':');
			songs.push(new SongMeta(otherdata[0], Std.parseInt(otherdata[2]), otherdata[1]));
			trace("Array 2 pushed");
		}

		logo = new FlxSprite().loadGraphic(Paths.image('thierryLogo'));
		logo.screenCenter();
		logo.alpha = 1;
		text = new FlxText("PRELOADING ASSETS TO RAM... (" + (bruhify) + " / "+ (songs.length + 1) + ")");
		text.screenCenter(X);
		text.screenCenter(Y);
		text.y += 300;
		text.x -= 350;
		text.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		text.scrollFactor.set();
		if (TitleState.firstBoot)
		{
			add(logo);
			add(text);
		}


		
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.pressed.SPACE)
		{
			trace("[WARNING] PRELOADING SKIPPED!");
			FlxG.switchState(new CoolMenuState());
		}

		text.text = ("PRELOADING ASSETS TO RAM... (" + (bruhify) + " / "+ (songs.length + 1) + ")");
		frame++;
		if (frame % 60 == 0)
			beatHit();
		
	}

	function loopBuffer() 
	{

	}
	override function beatHit() 
	{
		timing++;
		if (timing % 4 == 0)
			bruhify++;
		text.text = ("PRELOADING ASSETS TO RAM... (" + (bruhify) + " / "+ (songs.length + 1) + ")");
		if (preloadSongs && TitleState.firstBoot)
		{
			trace("PRELOAD STARTED! (SNAPSHOT-8)");

			for (i in 0...songs.length)
			{
				bruhify++;
				text.text = ("PRELOADING ASSETS TO RAM... (" + (bruhify) + " / "+ (songs.length + 1) + ")");
				FlxG.sound.playMusic(Paths.inst(songs[i].songName), 0);
				trace("Preloading " + (i + 1) + " / "+ songs.length);
				preloadSongs = false;
			}
			preloadSongs = false;
			TitleState.firstBoot = false;
			trace("PRELOAD COMPLETE");
			FlxG.switchState(new CoolMenuState());
			

		}
		else if (!preloadSongs && TitleState.firstBoot)
		{
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				preloadSongs = true;
			});
			
		}
		else
		{
			trace("EITHER PRELOADING FAILED, OR ALL ASSETS HAS BEEN PRELOADED!\n SKIPPING!");
			FlxG.switchState(new CoolMenuState());
		}	
	}
}


class SongMeta
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
