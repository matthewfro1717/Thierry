package;

import flixel.addons.display.FlxBackdrop;
import aeroshide.EngineUtils.PlacementHelper.move;
import flixel.system.FlxSound;
import Controls.Device;
import Controls.Control;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.FlxObject;
import flixel.addons.util.FlxAsyncLoop;
import FreeplayState.SongMetadata;
import aeroshide.StaticData;
#if sys import sys.FileSystem; #end
#if desktop import Discord.DiscordClient; #end

using StringTools;

class FreeplaySelect extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;

	var bg:FlxSprite = new FlxSprite();

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";
	private var camBG:FlxCamera;

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var Catagories:Array<String> = ['canon', 'extras', 'purgatory'];
	private var CurrentPack:Int = StaticData.selectionBuffer;
	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [
		0xFF00137F, // GF but its actually dave!
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI RETARD (thats kinda rude ngl)
		0xFF00FFFF, // SPLIT THE THONNNNN
		0xFF800080, // FESTIVAL
		0xFF116E1C, // MASTA BAMBI
		0xFFFF0000, // KABUNGA
		0xFF0EAE2C, // SECRET MOD LEAK
		0xFFFF0000, // TRISTAN
		FlxColor.fromRGB(162, 150, 188), // PLAYROBOT
		FlxColor.fromRGB(44, 44, 44), // RECURSED
		0xFF31323F, // MOLDY
		0xFF35396C, // FIVE NIGHT
		0xFF0162F5, // OVERDRIVE
		0xFF119A2B, // CHEATING
		0xFFFF0000, // UNFAIRNESS
		0xFF810000, // EXPLOITATION
	];

	public static var skipSelect:Array<String> = ['five-nights', 'vs-dave-rap', 'vs-dave-rap-two'];

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var iconArray:Array<HealthIcon> = [];

	var titles:Array<Alphabet> = [];
	var icons:Array<FlxSprite> = [];

	var doneCoolTrans:Bool = false;

	var defColor:FlxColor;
	var canInteract:Bool = true;

	// recursed
	var timeSincePress:Float;
	var lastTimeSincePress:Float;

	var pressSpeed:Float;
	var pressSpeeds:Array<Float> = new Array<Float>();
	var pressUnlockNumber:Int;
	var requiredKey:Array<Int>;
	var stringKey:String;

	var bgShader:Shaders.GlitchEffect;
	var awaitingExploitation:Bool;

	public static var packTransitionDone:Bool = false;

	var characterSelectText:FlxText;
	var showCharText:Bool = true;
	var bg2:FlxSprite;

	override function create()
	{
		FlxG.camera.zoom = 5;
		#if desktop DiscordClient.changePresence("In the Freeplay Menu", null); #end

		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		showCharText = FlxG.save.data.wasInCharSelect;


		if (awaitingExploitation)
		{
			bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			bg.scrollFactor.set();
			bg.antialiasing = false;
			bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
			add(bg);

			#if SHADERS_ENABLED
			bgShader = new Shaders.GlitchEffect();
			bgShader.waveAmplitude = 0.1;
			bgShader.waveFrequency = 5;
			bgShader.waveSpeed = 2;

			bg.shader = bgShader.shader;
			#end
			defColor = bg.color;
		}
		else
		{
			bg2 = new FlxSprite().makeGraphic(FlxG.width * 16, FlxG.height * 16, FlxColor.YELLOW);
			move(-650, -550, bg2);
			bg2.antialiasing = true;
			bg2.alpha = 0.7;
			add(bg2);

			bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
			bg.antialiasing = true;
			bg.color = 0xFFFFD000;
			add(bg);
		}
		if (FlxG.save.data.terminalFound && !awaitingExploitation)
		{
			Catagories = ['canon', 'extras', 'purgatory', 'terminal'];
		}

		for (i in 0...Catagories.length)
		{
			Highscore.load();

			var CurrentSongIcon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('packs/' + (Catagories[i].toLowerCase()), "preload"));
			CurrentSongIcon.centerOffsets(false);
			CurrentSongIcon.x = (1000 * i + 1) + (512 - CurrentSongIcon.width);
			CurrentSongIcon.y = (FlxG.height / 2) - 256;
			CurrentSongIcon.antialiasing = true;

			var NameAlpha:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, Catagories[i], true, false);
			NameAlpha.x = CurrentSongIcon.x;

			add(CurrentSongIcon);
			icons.push(CurrentSongIcon);
			add(NameAlpha);
			titles.push(NameAlpha);
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.focusOn(camFollow.getPosition());

		if (awaitingExploitation)
		{
			if (!packTransitionDone)
			{
				var curIcon = icons[CurrentPack];
				var curTitle = titles[CurrentPack];

				canInteract = false;
				var expungedPack:FlxSprite = new FlxSprite(curIcon.x, curIcon.y).loadGraphic(Paths.image('packs/uhoh', "preload"));
				expungedPack.centerOffsets(false);
				expungedPack.antialiasing = false;
				expungedPack.alpha = 0;
				add(expungedPack);

				var expungedTitle:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, 'uh oh', true, false);
				expungedTitle.x = expungedPack.x;
				add(expungedTitle);

				FlxTween.tween(curIcon, {alpha: 0}, 1);
				FlxTween.tween(curTitle, {alpha: 0}, 1);
				FlxTween.tween(expungedTitle, {alpha: 1}, 1);
				FlxTween.tween(expungedPack, {alpha: 1}, 1, {
					onComplete: function(tween:FlxTween)
					{
						icons[CurrentPack].destroy();
						titles[CurrentPack].destroy();

						icons[CurrentPack] = expungedPack;
						titles[CurrentPack] = expungedTitle;

						curIcon.alpha = 1;
						curTitle.alpha = 1;

						Catagories = ['uhoh'];
						packTransitionDone = true;
						canInteract = true;
					}
				});
			}
			else
			{
				var originalIconPos = icons[CurrentPack].getPosition();
				var originalTitlePos = titles[CurrentPack].getPosition();

				icons[CurrentPack].destroy();
				titles[CurrentPack].destroy();

				icons[CurrentPack].loadGraphic(Paths.image('packs/uhoh', "preload"));
				icons[CurrentPack].setPosition(originalIconPos.x, originalIconPos.y);
				icons[CurrentPack].centerOffsets(false);
				icons[CurrentPack].antialiasing = false;

				titles[CurrentPack] = new Alphabet(40, (FlxG.height / 2) - 282, 'uh oh', true, false);
				titles[CurrentPack].setPosition(originalTitlePos.x, originalTitlePos.y);

				Catagories = ['uhoh'];
			}
		}
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.6, {ease: FlxEase.expoOut});

		super.create();
	}

	var scoreBG:FlxSprite;

	public function GoToActualFreeplay(where:Int)
	{
        switch (where)
        {
            case 0:
				FlxG.switchState(new FreeplayState());
            case 1:
				FlxG.switchState(new FreeplayExtrasState());
            case 2:
				FlxG.switchState(new FreeplayPurgatoryState());
        }
	}


	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
			CurrentPack = Catagories.length - 1;

		if (CurrentPack == Catagories.length)
			CurrentPack = 0;

		camFollow.x = icons[CurrentPack].x + 256;
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;

		for (song in songs)
		{
			//addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;

		super.update(elapsed);

		#if SHADERS_ENABLED
		if (bgShader != null)
		{
			bgShader.shader.uTime.value[0] += elapsed;
		}
		#end

		if (InMainFreeplayState)
		{
			timeSincePress += elapsed;

			if (timeSincePress > 2 && pressSpeeds.length > 0)
			{
				resetPresses();
			}
			if (pressSpeeds.length >= pressUnlockNumber && !FlxG.save.data.recursedUnlocked)
			{
				var canPass:Bool = true;
				for (i in 0...pressSpeeds.length)
				{
					var pressSpeed = pressSpeeds[i];
					if (pressSpeed >= 0.5)
					{
						canPass = false;
					}
				}
				if (canPass)
				{
				}
				else
				{
					resetPresses();
				}
			}
		}
		else
		{
			timeSincePress = 0;
		}

		// Selector Menu Functions
		if (!InMainFreeplayState)
		{
			scoreBG = null;
			scoreText = null;
			diffText = null;
			characterSelectText = null;

			if (controls.LEFT_P && canInteract)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P && canInteract)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack && canInteract)
			{
				FlxTween.tween(FlxG.camera, {zoom: 5}, 0.6, {ease: FlxEase.expoIn});
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				canInteract = false;

				new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
				{
					loadingPack = true;

					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{

                        StaticData.selectionBuffer = CurrentPack;
						GoToActualFreeplay(CurrentPack);
						resetPresses();
						InMainFreeplayState = true;
						loadingPack = false;
					});
				});
			}
			if (controls.BACK && canInteract && !awaitingExploitation)
			{
				FlxG.switchState(new MainMenuState());
			}

			return;
		}

		// Freeplay Functions
		else
		{
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;

			if (upP && canInteract)
			{
				stringKey = 'up';
				changeSelection(-1);
			}
			if (downP && canInteract)
			{
				stringKey = 'down';
				changeSelection(1);
			}
			if (controls.BACK && canInteract)
			{
				loadingPack = true;
				canInteract = false;

				for (i in grpSongs)
				{
					//i.unlockY = true;

					FlxTween.tween(i, {y: 5000, alpha: 0}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							//i.unlockY = false;

							for (item in icons)
							{
								item.visible = true;
								FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut});
							}
							for (item in titles)
							{
								item.visible = true;
								FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut});
							}

							if (scoreBG != null)
							{
								FlxTween.tween(scoreBG, {y: scoreBG.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										scoreBG = null;
									}
								});
							}

							if (scoreText != null)
							{
								FlxTween.tween(scoreText, {y: scoreText.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										scoreText = null;
									}
								});
							}

							if (diffText != null)
							{
								FlxTween.tween(diffText, {y: diffText.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										diffText = null;
									}
								});
							}
							if (showCharText)
							{
								if (characterSelectText != null)
								{
									FlxTween.tween(characterSelectText, {alpha: 0}, 0.5, {
										ease: FlxEase.expoInOut,
										onComplete: function(spr:FlxTween)
										{
											characterSelectText = null;
										}
									});
								}
							}

							InMainFreeplayState = false;
							loadingPack = false;

							for (i in grpSongs)
							{
								remove(i);
							}
							for (i in iconArray)
							{
								remove(i);
							}

							FlxTween.color(bg, 0.25, bg.color, defColor);

							// MAKE SURE TO RESET EVERYTHIN!
							songs = [];
							grpSongs.members = [];
							iconArray = [];
							curSelected = 0;
							canInteract = true;
						}
					});
				}
			}
			if (accepted && canInteract)
			{
				switch (songs[curSelected].songName)
				{
					case 'canon':
				}
			}
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (scoreText != null)
			//scoreText.text = LanguageManager.getTextString('freeplay_personalBest') + lerpScore;
		positionHighscore();
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (change != 0)
		{
			pressSpeed = timeSincePress - lastTimeSincePress;

			lastTimeSincePress = timeSincePress;

			timeSincePress = 0;
			pressSpeeds.push(Math.abs(pressSpeed));

			var shakeCheck = pressSpeeds.length % 5;
			if (shakeCheck == 0 && pressSpeeds.length > 0 && !FlxG.save.data.recursedUnlocked)
			{
				FlxG.camera.shake(0.003 * (pressSpeeds.length / 5), 0.1);
				FlxG.sound.play(Paths.sound('recursed/thud', 'shared'), 1, false, null, true);
			}
		}

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].songName != 'Enter Terminal')
		{
			#if !switch
			//intendedScore = Highscore.getScore(songs[curSelected].songName);
			#end

			#if PRELOAD_ALL
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			#end
		}

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

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
	}

	function resetPresses()
	{
		pressSpeeds = new Array<Float>();
		pressUnlockNumber = new FlxRandom().int(20, 40);
	}

}