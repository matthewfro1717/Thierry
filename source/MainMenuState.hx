package;


import lime.ui.Window;
import aeroshide.EngineUtils.PlacementHelper.move;
import flixel.addons.display.FlxBackdrop;
import console.Log;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import aeroshide.StaticData;
import flixel.math.FlxMath;
import flash.system.System;
import flixel.*;
import flixel.FlxState;
import openfl.system.System;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import Sys.*;
import Achievements;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var storymenu:FlxSprite = new FlxSprite().makeGraphic(625, 125, FlxColor.BLACK);

	var freeplay:FlxSprite = new FlxSprite().makeGraphic(450, 125, FlxColor.BLACK);
	var credits:FlxSprite = new FlxSprite().makeGraphic(450, 125, FlxColor.BLACK);
	var options:FlxSprite = new FlxSprite().makeGraphic(450, 125, FlxColor.BLACK);

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	var kontol:FlxSprite;
	var bego:FlxSprite;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = " " + nightly;
	public static var gameVer:String = "Aeroshide Engine // ALPHA 1.1";
	public var frame:Int;
	public var whichonetobouncelol:Bool = true; //TRUE IS LEFT
	var daChoice:String;
	var bg:FlxSprite;
	var bg2:FlxSprite;

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		if (TitleState.firstBoot || StaticData.fromCredits)
		{
			transIn = FlxTransitionableState.defaultTransIn;
			TitleState.firstBoot = false;
		}
		else
		{
			transIn = null;
		}
		
		transOut = null;
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end	

		if (StaticData.fromCredits)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			StaticData.fromCredits = false;
		}

		

		persistentUpdate = persistentDraw = true;

		bg2 = new FlxSprite().makeGraphic(FlxG.width * 16, FlxG.height * 16, FlxColor.YELLOW);
		move(-650, -550, bg2);
		bg2.antialiasing = true;
		bg2.alpha = 0.7;
		add(bg2);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.antialiasing = true;
		bg.color = 0xFFFFD000;
		add(bg);


		

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		//add(magenta);
		// magenta.scrollFactor.set();

		
		//shadow backronf used for transtistion

		kontol = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		kontol.scrollFactor.x = 0;
		kontol.scrollFactor.y = 0.15;
		kontol.setGraphicSize(Std.int(kontol.width * 1.4), Std.int(kontol.height * 1.4));
		kontol.updateHitbox();
		kontol.screenCenter();
		kontol.antialiasing = true;
		kontol.visible = false;
		kontol.color = 0xFFea71fd;
		//add(kontol);

		bego = new FlxSprite(-80).loadGraphic(Paths.image('credits'));
		bego.scrollFactor.x = 0;
		bego.scrollFactor.y = 0;
		//bego.setGraphicSize(Std.int(bego.width * 1.4), Std.int(bego.height * 1.4));
		bego.updateHitbox();
		bego.screenCenter();
		bego.antialiasing = true;
		bego.visible = false;
		bego.color = 0xFF444444;
		//add(bego);
		//add(bg);

		storymenu.x = -590;
		storymenu.y = -270;
		storymenu.visible = false;
		add(storymenu);

		freeplay.x = -590;
		freeplay.y = -120;
		freeplay.visible = false;
		add(freeplay);

		credits.x = -590;
		credits.y = 30;
		credits.visible = false;
		add(credits);

		options.x = -590;
		options.y = 180;
		options.visible = false;
		add(options);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		var scale:Float = 1;

		for (i in 0...optionShit.length)
			{
				var offset:Float = 90 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 150)  + offset);
				menuItem.scale.x = scale;
				menuItem.scale.y = scale;
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.x = -450;
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if(optionShit.length < 6) scr = 0;
				menuItem.antialiasing = true;
				menuItem.scrollFactor.set(0, scr);
				//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
				menuItem.updateHitbox();

				FlxTween.tween(menuItem,{x: 4},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						changeItem();
					}});

				/*new FlxTimer().start(1 , function(tmr:FlxTimer)
					{
						FlxTween.angle(menuItem, menuItem.angle, 10, 1, {ease: FlxEase.quartInOut});
					});
					/****/

			}

		Achievements.loadAchievements();

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + "Thierry Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();



		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;
		if (FlxG.keys.pressed.SEVEN)
		{
			FlxG.switchState(new IconBounceState());
		}


		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			//ALTERNATE CONTROLS
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			//idk lol

			if (FlxG.mouse.overlaps(storymenu))
			{
				curSelected = 0;
				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
			
					if (spr.ID == curSelected)
					{
						spr.animation.play('selected');
						//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					}
			
					spr.updateHitbox();
				});
			}
			else if (FlxG.mouse.overlaps(freeplay))
			{
				curSelected = 1;
				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
			
					if (spr.ID == curSelected)
					{
						spr.animation.play('selected');
						//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					}
			
					spr.updateHitbox();
				});
			}
			else if (FlxG.mouse.overlaps(credits))
			{
				curSelected = 2;
				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
			
					if (spr.ID == curSelected)
					{
						spr.animation.play('selected');
						//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
					}
			
					spr.updateHitbox();
				});
			}
			else if (FlxG.mouse.overlaps(options))
				{

					curSelected = 3;
					menuItems.forEach(function(spr:FlxSprite)
					{
						spr.animation.play('idle');
				
						if (spr.ID == curSelected)
						{
							spr.animation.play('selected');
							//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
						}
				
						spr.updateHitbox();
					});
				}

			//testing out mouse inputs

			if (controls.ACCEPT || FlxG.mouse.justPressed)
			{
				if (optionShit[curSelected] == 'ost')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.switchState(new CrasherState("bSOD", "bSOD"));
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							daChoice = optionShit[curSelected];

							switch(daChoice)
							{
								case "freeplay":
									FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
									FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
									FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
									FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
									FlxTween.tween(spr, {alpha: 0}, 0.4, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});
								case "options":
									kontol.visible = true;

									FlxTween.tween(spr, {alpha: 0}, 1, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});
								case "credits":
									bego.visible = true;
									FlxTween.tween(bg, {y: -2500}, 1.5, {ease: FlxEase.expoInOut});
									FlxTween.tween(magenta, {y: -2500}, 1.7, {ease: FlxEase.expoInOut});
									FlxTween.tween(spr, {y: -2500}, 1.9, {ease: FlxEase.expoInOut});
									FlxTween.tween(spr, {alpha: 0}, 1.5, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});
							}

						}
						else
						{
							daChoice = optionShit[curSelected];
							switch(daChoice)
							{
								case "options":
									FlxTween.tween(spr, {alpha: 0}, 1, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});
								case "credits":

									FlxTween.tween(spr, {y: -2500}, 1.9, {ease: FlxEase.expoInOut});
									FlxTween.tween(spr, {alpha: 0}, 1.5, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});
							}

							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								daChoice = optionShit[curSelected];
								

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplaySelect());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
										trace("Options selected");
									case 'credits':
										FlxG.switchState(new CreditsState());
										
										
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		/*
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
		/****/
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	override function beatHit()
	{
		super.beatHit();
		
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	} 
}
