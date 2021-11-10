package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if desktop
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var characters:FlxSprite;

	override public function create():Void
	{

		/*
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		/****/
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			if (FlxG.save.data.willSeeCrashEnding)
			{
				FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			}
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(bg);

		}

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuStuff/bg'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 1.4));
		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(bg);
		
		}
		

		characters = new FlxSprite(1500);
		characters.frames = Paths.getSparrowAtlas('menuStuff/Blossom_Characters');
		characters.antialiasing = true;
		characters.animation.addByPrefix('dance', 'Character_Sillouettes instance 1', 24, false);
		characters.animation.play('dance');
		characters.screenCenter(Y);
		characters.setGraphicSize(Std.int(characters.width * 1.3));

		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(characters);
		
		}

		FlxTween.tween(characters, {x: -2400}, 10, {
			ease: FlxEase.sineIn, type: LOOPING,
				onComplete: function(twn:FlxTween)
				{
					characters.x = 1500;
			}
		});
		

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.screenCenter();
		logoBl.y = -100;
		// logoBl.color = FlxColor.BLACK;
		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(logoBl);
	
		}

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		logoBl.screenCenter(X);
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			if (FlxG.save.data.willSeeCrashEnding)
			{
				FlxG.sound.play(Paths.sound('game_start'), 0.7);
			}
			else
			{
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			}
			
			

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{

				// Get current version of Kade Engine

				var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe"); //SHUT UP KADE I DONT CARE

				http.onData = function (data:String) {
				  
				  	if (!MainMenuState.kadeEngineVer.contains(data.trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
					{
						if (FlxG.save.data.willSeeCrashEnding)
						{
							FlxG.switchState(new GlitchedMainMenu());
						}
						else
						{
							FlxG.switchState(new MainMenuState());
						}
						
					}
					else
					{
						if (FlxG.save.data.willSeeCrashEnding)
						{
							FlxG.switchState(new GlitchedMainMenu());
						}
						else
						{
							FlxG.switchState(new MainMenuState());
						}
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}
				
				http.request();

			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
		}

		
		characters.animation.play('dance');
		logoBl.animation.play('bump');

		FlxG.log.add(curBeat);


		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				if (FlxG.save.data.willSeeCrashEnding)
				{
					createCoolText(['fhjcfsehjgfcshgfs', 'jgojdhrfgiuchn']);
				}
				else
				{
					createCoolText(['Kade Engine', 'by']);
				}
				
			// credTextShit.visible = true;
			case 3:
				if (FlxG.save.data.willSeeCrashEnding)
				{
					addMoreText('jkdcfjksdfhusuegxfhuisex');
				}
				else
				{
					addMoreText('Kade Eninge');
				}
				
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				if (FlxG.save.data.willSeeCrashEnding)
				{
					if (Main.watermarks)
						createCoolText(['wesxefxsefwfrhdfjfjwshdbnjsdfbnj', 'xdchksecgsvgcuhsrcfgcgfsrgc', 'and hsdcfhjkagscuiasgcuh']);
					else
						createCoolText(['rcacrgawcrgqergq3rhetjrj4u5jffvdtvjcr6hec', 'inlyfnb,rguvdgriktjwegcfvrjtybjvwectghrftjgbyrk']);
				}
				else
				{
					if (FlxG.save.data.willSeeCrashEnding)
					{
						if (Main.watermarks)// SEREM :):):):):)
							createCoolText(['youre to blame', 'youre to blame', 'youre to blame']);
						else
							createCoolText(['youre to blame', 'youre to blame']);
					}
					else
					{
						if (Main.watermarks)
							createCoolText(['me', 'myself', 'and i']);
						else
							createCoolText(['In Partnership', 'with']);
					}

				}
			case 7:
				if (FlxG.save.data.willSeeCrashEnding)
					{
						if (Main.watermarks)
							addMoreText('theiuhcguidjfhgcuiosdhfgioscduiogdscgsgcscghc');
						else
						{
							addMoreText('Ngsgcsgcsgcscgsewgsgsgsgsdcfsdgcgscgsgsgccsdgsroundgcsgscdgscgsgsds');
							ngSpr.visible = true;
						}
					}
					else
					{
						if (Main.watermarks)
							addMoreText('present');
						else
						{
							addMoreText('Newgrounds');
							ngSpr.visible = true;
						}
					}

			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				if (FlxG.save.data.willSeeCrashEnding)
					addMoreText('sfsfcstsgjkdbsfhjsrbgihcbgjdbhjrtnjdbgnjkdbgjksg');
				else
				{
					addMoreText('VS');
				}
				
			// credTextShit.visible = true;
			case 14:
				if (FlxG.save.data.willSeeCrashEnding)
					addMoreText('scgscgsgcscgsgcsfcrtecribe84bycw84gt7824784272bc husdfbuasegfysagfxyuasgfasuigsaugt');
				else
				{
					addMoreText('THIERRY');
				}
			// credTextShit.text += '\nNight';
			case 15:
				if (FlxG.save.data.willSeeCrashEnding)
					addMoreText('andjfhdfuiweghuofgjkfgjksgklhkosfgjksdghjkfgjkslfghjk');
				else
				{
					addMoreText('MOD'); // credTextShit.text += '\nFunkin';
				}
				

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
