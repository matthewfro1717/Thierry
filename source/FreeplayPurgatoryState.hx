package;

import flixel.tweens.FlxEase;
import flixel.addons.display.FlxBackdrop;
import FreeplayExtrasState.SongMetadataa;
import flixel.tweens.FlxTween;
import flash.text.TextField;
import aeroshide.EngineUtils.PlacementHelper.move;
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

class FreeplayPurgatoryState extends MusicBeatState
{
	var songs:Array<SongMetadataa> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 2;
	var kontol:Float = 0;

	var sicks:Int;
	var goods:Int;
	var bads:Int;
	var shits:Int;

	var scoreText:FlxText;
	var diffText:FlxText;
	var rating:Int;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	public var preloadSongs:Bool = true;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var bg:FlxSprite;
	var bg2:FlxSprite;

	var songColors:Array<FlxColor> = [
    	0xFFca1f6f, // GF 0
		0xFFffff52, // THIERRY 1
		0xFFfc6938, // GW3D 2
		0xFF750606, // Meninggal 3
		0xFF0066ba, // Gerlad 4
		0xFF990000, // BONUS SONG 5
		0xFF00943b, // RADIT 6
		0xFF008594, // HEX 7
		0xFFd68f00, // MATT 8
		0xFF12ff35, // Applecore 9
		0xFFFFFFFF, // copy-cat 10

    ];

	override function create()
	{
		FlxG.camera.zoom = 5;
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('apaanYaIni'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			if(!(data[0]=='Bonus-song') && !(data[0]=='Final-showdown') && !(data[0]=='Ram') && !(data[0]=='Glitcher') && !(data[0]=='Run') && !(data[0]=='Applecore') && !(data[0]=='Ghost'))
			{
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			}
			else if(FlxG.save.data.aeroSongUnlocked && data[0]=='Bonus-song')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			else if(FlxG.save.data.mattSongUnlocked && data[0]=='Run')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			else if(FlxG.save.data.mattSongUnlocked && data[0]=='Final-showdown')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			else if(FlxG.save.data.hexSongUnlocked && data[0]=='Ram')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			else if(FlxG.save.data.hexSongUnlocked && data[0]=='Glitcher')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			else if(FlxG.save.data.cheaterSongUnlocked && data[0]=='Applecore')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			else if(FlxG.save.data.setanSongUnlocked && data[0]=='Ghost')
				songs.push(new SongMetadataa(data[0], Std.parseInt(data[2]), data[1], Std.parseInt(data[3])));
			if (FlxG.save.data.memoryTrace)
				{
					trace(data[0], Std.parseInt(data[2]), data[1], data[3]);
				}
			
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg2 = new FlxSprite().makeGraphic(FlxG.width * 16, FlxG.height * 16, FlxColor.GRAY);
		move(-650, -550, bg2);
		bg2.antialiasing = true;
		bg2.alpha = 0.7;
		add(bg2);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.antialiasing = true;
		bg.color = 0xFF464646;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 132, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu";
		var size:Int = 16;

		var text:FlxText = new FlxText(-551, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.4, {ease: FlxEase.expoOut});
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, colorTypeInt:Int)
	{
		songs.push(new SongMetadataa(songName, weekNum, songCharacter, colorTypeInt));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, colorTypeInt:Int)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], colorTypeInt);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{


		super.update(elapsed);

		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		if (rating == 0 && bads == 0 && shits == 0 && goods == 0 && kontol == 0) // Marvelous (SICK) Full Combo
			diffText.text = "UNRATED"; 
		else if (rating == 0 && bads == 0 && shits == 0 && goods == 0 && kontol == 100) // Marvelous (SICK) Full Combo
			diffText.text = "Rating : " + kontol + "% " + "| " + "(MFC)"; 
		else if (rating == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			diffText.text = "Rating : " + kontol + "% " + "| " + "(GFC)"; 
		else if (rating == 0) // Regular FC
			diffText.text = "Rating : " + kontol + "% " + "| " + "(FC)"; 
		else if (rating > 0) // Single Digit Combo Breaks
			diffText.text = "Rating : " + kontol + "% " + "| " + rating + " Misses"; 
		

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if(!(songs[curSelected].songName.toLowerCase()=="termination")){	//Only allow the difficulty to be changed if the song isn't termination.
		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);
		}
		
		if(songs[curSelected].songName.toLowerCase()=="termination")
		{
			curDifficulty = 1; //Force it to hard difficulty.
				//diffText.text = "INSANE+";
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end
		}
		else if(songs[curSelected].songName.toLowerCase()=="ghost")
		{
			curDifficulty = 1; //Force it to hard difficulty.
				//diffText.text = "TRUE MANIA";
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end
		}
		else
		{
			curDifficulty = 2; //Force it to hard difficulty.
				//diffText.text = "HARD";
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end
		}

		if (controls.BACK)
		{
			FlxTween.tween(FlxG.camera, {zoom: 5}, 0.4, {ease: FlxEase.expoIn});
			FlxG.switchState(new FreeplaySelect());
		}

		if (accepted)
		{

			if((songs[curSelected].songName.toLowerCase()=='Bonus-song') && !(FlxG.save.data.aeroSongUnlocked)){
				trace("nice try, get back to your homework");
			}
			else if((songs[curSelected].songName.toLowerCase()=='Final-destination') && !(FlxG.save.data.mattSongUnlocked)){
				trace("PepeLa");
			}
			else
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		if(songs[curSelected].songName.toLowerCase()=="termination")
		{
			curDifficulty = 2; //Force it to hard difficulty.
				//diffText.text = "INSANE+";
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			
			#end
		}
		else
		{
			curDifficulty += change;

			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;
	
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		
			#end
	
			/*
			switch (curDifficulty)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
			}
			/****/
		}	

	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		kontol = Highscore.getAcc(songs[curSelected].songName, curDifficulty);
		rating = Highscore.getMisses(songs[curSelected].songName, curDifficulty);

		rating = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		sicks = Highscore.getSicks(songs[curSelected].songName, curDifficulty);
		goods = Highscore.getGoods(songs[curSelected].songName, curDifficulty);
		bads = Highscore.getBads(songs[curSelected].songName, curDifficulty);
		shits = Highscore.getShits(songs[curSelected].songName, curDifficulty);

		trace(intendedScore + " | " + kontol + " " + kontol + " " + rating + " | " +sicks + " " +goods + " " +bads + " " +shits);
		// lerpScore = 0;
		#end

		if (aeroshide.StaticData.didPreload) { FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0); }

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.text == "chaos")
			{
				FlxG.camera.shake(0.010, 0.1);
			}

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
			FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].colorType]);
		}
	}
}


