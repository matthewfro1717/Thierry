package;

import flixel.math.FlxMath;
import flixel.addons.display.FlxBackdrop;
import aeroshide.StaticData;
import aeroshide.EngineUtils.PlacementHelper.move;
import openfl.system.Capabilities;
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
	var logoHasBeenAdded:Bool = false;
	var bumpin:Bool = true;
	var canPressEnter:Bool = false;

	var curWacky:Array<String> = [];
	var twoWacky:Array<String> = [];
	var treeWacky:Array<String> = [];
	var iconRPC:String;

	var wackyImage:FlxSprite;
	var characters:FlxSprite;
	public static var firstBoot:Bool = true;

	var bg:FlxSprite;

	var pressedEnter:Bool;

	override public function create():Void
	{

		
		//FlxG.save.data.kebal = false;

		/*
		characters = new FlxSprite(1500);
		characters.frames = Paths.getSparrowAtlas('menuStuff/Blossom_Characters');
		characters.antialiasing = true;
		characters.animation.addByPrefix('dance', 'Character_Sillouettes instance 1', 24, false);
		characters.animation.play('dance');
		characters.screenCenter(Y);
		characters.setGraphicSize(Std.int(characters.width * 1.3));

		/****/

		/*
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		/****/
		
		
		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		twoWacky = FlxG.random.getObject(getIntroTextShit());
		treeWacky = FlxG.random.getObject(getIntroTextShit());


		// DEBUG BULLSHIT

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;
			//for test commit

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

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(-1, 0), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.42, FlxG.height * 4.2));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(1, 0),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.42, FlxG.height * 4.2));

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

		Conductor.changeBPM(148);
		persistentUpdate = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuStuff/beg'));
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

		var bg2 = new FlxSprite().makeGraphic(FlxG.width * 16, FlxG.height * 16, FlxColor.YELLOW);
		#if debug
		move(-650, -550, bg2);
		#end
		bg2.antialiasing = true;
		bg2.alpha = 0.7;
		add(bg2);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.antialiasing = true;
		bg.color = 0xFFFFD000;
		add(bg);
		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(bg);
		
		}
		

		/*
		characters = new FlxSprite(1500);
		characters.frames = Paths.getSparrowAtlas('menuStuff/Blossom_Characters');
		characters.antialiasing = true;
		characters.animation.addByPrefix('dance', 'Character_Sillouettes instance 1', 24, false);
		characters.animation.play('dance');
		characters.screenCenter(Y);
		characters.setGraphicSize(Std.int(characters.width * 1.3));
		/****/

		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(characters);
		
		}

		/*
		FlxTween.tween(characters, {x: -2400}, 10, {
			ease: FlxEase.sineIn, type: LOOPING,
				onComplete: function(twn:FlxTween)
				{
					characters.x = 1500;
			}
		});

		/****/
		

		logoBl = new FlxSprite().loadGraphic(Paths.image('thierryLogo'));
		logoBl.antialiasing = true;
		logoBl.updateHitbox();
		logoBl.screenCenter();
		logoBl.y -= 50;
		// logoBl.color = FlxColor.BLACK;
		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			add(logoBl);
			logoHasBeenAdded = true;
	
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

		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
		DiscordClient.changePresence("In the Title Screen", iconRPC);
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

		if (logoHasBeenAdded)
		{
			var scrollSpeed:Float = 50;
			bg.x -= scrollSpeed * elapsed;
			bg.y -= scrollSpeed * elapsed;

			var mult:Float = FlxMath.lerp(1, logoBl.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			var mult2:Float = FlxMath.lerp(1, logoBl.scale.y, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			logoBl.scale.set(mult, mult2);
			logoBl.updateHitbox();

		}





		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		/* fullscreen implkrementation late
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		/****/

		
		pressedEnter = FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed;

		#if mobiles
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;



		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch



			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)

			#end

			titleText.animation.play('press');

			if (FlxG.save.data.willSeeCrashEnding)
				{
					
				}
				else
				{
					FlxTween.tween(logoBl, {x: -1500}, 3.5, {ease: FlxEase.expoInOut});
					//FlxTween.tween(characters, {y: -1500}, 3.7, {ease: FlxEase.expoInOut});
					FlxTween.tween(titleText, {y: 1500}, 3.7, {ease: FlxEase.expoInOut});
				}



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
			{ //fuck you kade

				FlxG.switchState(new MainMenuState());

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

	function createTheFunne(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var uang:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			uang.screenCenter(X);
			uang.y += (i * 60) + 320;
			credGroup.add(uang);
			textGroup.add(uang);
		}
	}

	function addMoreFunne(text:String)
	{
		var notcool:Alphabet = new Alphabet(0, 0, text, true, false);
		notcool.screenCenter(X);
		notcool.y += (textGroup.length * 60) + 320;
		credGroup.add(notcool);
		textGroup.add(notcool);
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

		if (logoHasBeenAdded)
		{
			trace('beatHit');
			logoBl.setGraphicSize(Std.int(logoBl.width + 50), Std.int(logoBl.height + 20));
			logoBl.updateHitbox();
		}

		if (FlxG.save.data.willSeeCrashEnding)
		{
			//FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
		}
		else
		{
			if (curBeat % 2 == 0 && bumpin)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
			}
			
		}
		
		//trace(Capabilities.os);
		
		//characters.animation.play('dance');
		logoBl.animation.play('bump');

		FlxG.log.add(curBeat);


		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 3:
				addMoreText('Me');
				addMoreText('Myself and I');
			case 4:
				addMoreText('Presents');
			case 5:
				deleteCoolText();
			case 6:
				createCoolText([twoWacky[0]]);
			case 7:
				addMoreText(twoWacky[1]);
			case 8:
				deleteCoolText();
			case 9:
				createCoolText([curWacky[0]]);
			case 10:
				addMoreText(curWacky[1]);
			case 11:
				deleteCoolText();
			case 12:
				addMoreText("Friday Night Funkin'");
			case 13:
				addMoreText('Vs. Thierry');
			case 14:
				addMoreText('THE FULL MOD');
			case 15:
				addMoreText('');
			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		bumpin = false;

		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
