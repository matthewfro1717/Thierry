package;

import aeroshide.EngineUtils.Maths;
import aeroshide.StaticData;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;
import sys.io.File;
import lime.app.Application;
import haxe.Exception;
import Controls.Control;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import aeroshide.EngineUtils.PlacementHelper.move;
#if windows
import lime.app.Application;
import sys.FileSystem;
#end

/**
	hey you fun commiting people, 
	i don't know about the rest of the mod but since this is basically 99% my code 
	i do not give you guys permission to grab this specific code and re-use it in your own mods without asking me first.
	the secondary dev, ben
 */
class CharacterInSelect
{
	public var name:String;
	public var noteMs:Array<Float>;
	public var forms:Array<CharacterForm>;

	public function new(name:String, noteMs:Array<Float>, forms:Array<CharacterForm>)
	{
		this.name = name;
		this.noteMs = noteMs;
		this.forms = forms;
	}
}

class CharacterForm
{
	public var name:String;
	public var polishedName:String;
	public var noteType:String;
	public var noteMs:Array<Float>;
    public var minus:Int;

	public function new(name:String, polishedName:String, noteMs:Array<Float>, noteType:String = 'normal')
	{
		this.name = name;
		this.polishedName = polishedName;
		this.noteType = noteType;
		this.noteMs = noteMs;
	}
}

class CharSelectState extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var curForm:Int = 0;
	public var notemodtext:FlxText;
	public var characterText:FlxText;
	public var wasInFullscreen:Bool;

	var scrollSpd:FlxText;
	var gostTapping:FlxText;
	var botPlay:FlxText;
	var showcaseMode:FlxText;
	var alternateVocals:FlxText;
	public var funnyIconMan:HealthIcon;
	public static var scoreBG:FlxSprite;

	public var tipArray:Array<String> = [
		"Tip: Press your keybinds to test out the Character's animations and press SPACE to reset it to idle.",
		"Tip: Press CONTROL to open Pre-Song Configuration!",
		"Tip: Unlock Characters by purchasing them from the Shop!",
	];

	var strummies:FlxTypedGroup<FlxSprite>;

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public var isDebug:Bool = false;

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;

	var currentSelectedCharacter:CharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var arrows:Array<FlxSprite> = [];
	var charColor:Array<FlxColor> =
	[
		0xff006cca, // BOYFRIEND
		0xffff2c2c, // GW
	];

	var charColorPinter:Int;
	var basePosition:FlxPoint;
	var bg:FlxSprite;
	var bg2:FlxSprite;

	public var characters:Array<CharacterInSelect> = [
		new CharacterInSelect('bf', [1, 1, 1, 1],
		[
			new CharacterForm('bf', 'Boyfriend', [1, 1, 1, 1]),
		]),
		new CharacterInSelect('bob', [2, 2, 2, 2], 
		[
			new CharacterForm('bob', 'Red Bob', [2, 2, 2, 2]),
		]),
	];

	#if SHADERS_ENABLED
	var bgShader:Shaders.GlitchEffect;
	#end

	public function new()
	{
		super();
	}

	override public function create():Void
	{

		StaticData.isInCharacterSelect = true;
		Conductor.changeBPM(110);

		camGame = new FlxCamera();
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTransition);
		FlxCamera.defaultCameras = [camGame];
		Transition.nextCamera = camTransition;

		FlxG.camera.zoom = 1.2;
		camHUD.zoom = 0.75;

		if (FlxG.save.data.charactersUnlocked == null)
		{
			reset();
		}
		currentSelectedCharacter = characters[current];

		FlxG.sound.playMusic(Paths.music("goodEnding"), 1, true);

		// create BG

		bg2 = new FlxSprite().makeGraphic(FlxG.width * 16, FlxG.height * 16, FlxColor.GRAY);
		move(-650, -550, bg2);
		bg2.antialiasing = true;
		bg2.alpha = 0.7;
		add(bg2);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.antialiasing = true;
		bg.color = 0xFF464646;
		add(bg);

		var varientColor = 0xFF878787;

		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, 'bf');
		char.cameras = [camHUD];
		char.x = char.charModelOffset[0];
		char.y = char.charModelOffset[1];
		add(char);
        

		basePosition = char.getPosition();

		strummies = new FlxTypedGroup<FlxSprite>();
		strummies.cameras = [camHUD];

		add(strummies);
		generateStaticArrows(false);

		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Boyfriend");
		characterText.setFormat(Paths.font("vcr.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 5;
		characterText.screenCenter(X);
		characterText.cameras = [camHUD];
		characterText.antialiasing = true;
		characterText.y = (FlxG.height / 8) - 200;
		add(characterText);

		scoreBG = new FlxSprite(0, characterText.y).makeGraphic(500, 220, 0xFF000000);
		scoreBG.screenCenter();
		scoreBG.x -= 342;
		scoreBG.y = characterText.y + 630;
		scoreBG.alpha = 0.6;
		add(scoreBG);

		var resetText = new FlxText(FlxG.width, FlxG.height, tipArray[FlxG.random.int(0, tipArray.length)]);
		resetText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resetText.autoSize = false;
		resetText.fieldWidth = FlxG.height;
		resetText.x -= resetText.textField.textWidth - 200;
		resetText.y -= resetText.textField.textHeight - 100;
		resetText.borderSize = 3;
		resetText.cameras = [camHUD];
		resetText.antialiasing = true;
		add(resetText);

		funnyIconMan = new HealthIcon('bf', true);
		funnyIconMan.cameras = [camHUD];
		funnyIconMan.visible = false;
		funnyIconMan.antialiasing = true;
		updateIconPosition();
		add(funnyIconMan);

		var arrowLeft:FlxSprite = new FlxSprite(10, 0).loadGraphic(Paths.image("ui/ArrowLeft_Idle", "preload"));
		arrowLeft.screenCenter(Y);
		arrowLeft.antialiasing = true;
		arrowLeft.scrollFactor.set();
		arrowLeft.cameras = [camHUD];
		arrows[0] = arrowLeft;
		add(arrowLeft);

		var arrowRight:FlxSprite = new FlxSprite(-5, 0).loadGraphic(Paths.image("ui/ArrowRight_Idle", "preload"));
		arrowRight.screenCenter(Y);
		arrowRight.antialiasing = true;
		arrowRight.x = 1280 - arrowRight.width - 5;
		arrowRight.scrollFactor.set();
		arrowRight.cameras = [camHUD];
		arrows[1] = arrowRight;
		add(arrowRight);

		//option texts

		scrollSpd = new FlxText(FlxG.width, FlxG.height, "Scroll Speed: < " + Maths.truncateFloat(FlxG.save.data.scrollSpeed, 1) + " >");
		scrollSpd.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scrollSpd.fieldWidth = FlxG.height;
		scrollSpd.x = scoreBG.x - 245;
		scrollSpd.y = (scoreBG.y + 120);
		scrollSpd.borderSize = 3;
		scrollSpd.cameras = [camHUD];
		scrollSpd.antialiasing = true;
		add(scrollSpd);

		gostTapping = new FlxText(FlxG.width, FlxG.height, "Ghost Tapping: < " + (FlxG.save.data.epico ? "Disabled" : "Enabled") + " >");
		gostTapping.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		gostTapping.fieldWidth = FlxG.height;
		gostTapping.x = scoreBG.x - 245;
		gostTapping.y = (scoreBG.y+ 120) + 40;
		gostTapping.borderSize = 3;
		gostTapping.cameras = [camHUD];
		gostTapping.antialiasing = true;
		add(gostTapping);

		botPlay = new FlxText(FlxG.width, FlxG.height, "BotPlay: < " + (FlxG.save.data.botplay ? "on" : "off") + " >");
		botPlay.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlay.fieldWidth = FlxG.height;
		botPlay.x = scoreBG.x - 245;
		botPlay.y = (scoreBG.y+ 120) + 80;
		botPlay.borderSize = 3;
		botPlay.cameras = [camHUD];
		botPlay.antialiasing = true;
		add(botPlay);

		showcaseMode = new FlxText(FlxG.width, FlxG.height, "Showcase Mode: < " + (FlxG.save.data.showcaseMode ? "Enabled" : "Disabled") + " >");
		showcaseMode.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		showcaseMode.fieldWidth = FlxG.height;
		showcaseMode.x = scoreBG.x - 245;
		showcaseMode.y = (scoreBG.y+ 120) + 120;
		showcaseMode.borderSize = 3;
		showcaseMode.cameras = [camHUD];
		showcaseMode.antialiasing = true;
		add(showcaseMode);

		alternateVocals = new FlxText(FlxG.width, FlxG.height, "Use Alternate Vocals: < " + (StaticData.useAlternateVocals ? "True" : "False") + " >");
		alternateVocals.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		alternateVocals.fieldWidth = FlxG.height;
		alternateVocals.x = scoreBG.x - 245;
		alternateVocals.y = (scoreBG.y+ 120) + 160;
		alternateVocals.borderSize = 3;
		alternateVocals.cameras = [camHUD];
		alternateVocals.antialiasing = true;
		add(alternateVocals);

		super.create();

		switch (currentSelectedCharacter.name)
		{
			case 'bf':
				charColorPinter = 0;
			case 'bob':
				charColorPinter = 1;
		}

		FlxTween.color(bg, 0.25, bg.color, charColor[charColorPinter]);

		Transition.nextCamera = camTransition;
	}

	private function generateStaticArrows(noteType:String = 'normal', regenerated:Bool):Void
	{
		if (regenerated)
		{
			if (strummies.length > 0)
			{
				strummies.forEach(function(babyArrow:FlxSprite)
				{
					remove(babyArrow);
					strummies.remove(babyArrow);
				});
			}
		}
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, FlxG.height - 40);

			var noteAsset:String = 'NOTE_assets';
			switch (noteType)
			{
				case '3D':
					noteAsset = 'NOTE_assets_3D';
			}

			babyArrow.frames = Paths.getSparrowAtlas(noteAsset);
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			babyArrow.antialiasing = true;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

			babyArrow.x += Note.swagWidth * i;
			switch (Math.abs(i))
			{
				case 0:
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					babyArrow.animation.addByPrefix('static', 'arrowUP');
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			babyArrow.ID = i;

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 3.5));
			babyArrow.y -= (FlxG.height / 8) + 615;
			babyArrow.alpha = 0;

			var baseDelay:Float = regenerated ? 0 : 0.5;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: baseDelay + (0.2 * i)});
			babyArrow.cameras = [camHUD];
			strummies.add(babyArrow);
		}
	}

	override public function update(elapsed:Float):Void
	{
		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;

		#if SHADERS_ENABLED
		if (bgShader != null)
		{
			bgShader.shader.uTime.value[0] += elapsed;
		}
		#end
		Conductor.songPosition = FlxG.sound.music.time;

		var controlSet:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];

		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			StaticData.isInCharacterSelect = false;
			if (wasInFullscreen)
			{
				FlxG.fullscreen = true;
			}
			LoadingState.loadAndSwitchState(new FreeplayState());
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			char.playAnim('idle', true);
		}

		if (FlxG.keys.justPressed.CONTROL)
		{
			scoreBG.visible = false;
			openSubState(new OptionsMenuMini(true));
		}

		#if debug
		if (FlxG.keys.justPressed.SEVEN)
		{
			for (character in characters)
			{
				for (form in character.forms)
				{
					unlockCharacter(form.name); // unlock everyone
				}
			}
		}
		#end

		for (i in 0...controlSet.length)
		{
			if (controlSet[i] && !PressedTheFunny)
			{
				strummies.forEach(function(sprite:FlxSprite)
				{
					if (i == sprite.ID)
					{
						sprite.animation.play('confirm', true);
						if (sprite.animation.curAnim.name == 'confirm')
						{
							sprite.centerOffsets();
							sprite.offset.x -= 13;
							sprite.offset.y -= 13;
						}
						else
						{
							sprite.centerOffsets();
						}
						sprite.animation.finishCallback = function(name:String)
						{
							sprite.animation.play('static', true);
							sprite.centerOffsets();
						}
					}
				});
                
				switch (i)
				{
					case 0:
						char.playAnim(char.nativelyPlayable ? 'singLEFT' : 'singRIGHT', true);
					case 1:
						char.playAnim('singDOWN', true);
					case 2:
						char.playAnim('singUP', true);
					case 3:
						char.playAnim(char.nativelyPlayable ? 'singRIGHT' : 'singLEFT', true);
						
				}
			}
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			if (isLocked(characters[current].forms[curForm].name))
			{
				FlxG.camera.shake(0.05, 0.1);
				return;
			}
			if (PressedTheFunny)
			{
				return;
			}
			else
			{
				PressedTheFunny = true;
			}
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null;
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.fadeOut(1.9, 0);
			FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));
			new FlxTimer().start(1.9, endIt);
		}
		if (FlxG.keys.justPressed.LEFT && !selectedCharacter)
		{
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			arrows[0].loadGraphic(Paths.image("ui/ArrowLeft_Pressed", "preload"));
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			arrows[1].loadGraphic(Paths.image("ui/ArrowRight_Pressed", "preload"));
		}

		if (FlxG.keys.justReleased.LEFT)
			arrows[0].loadGraphic(Paths.image("ui/ArrowLeft_Idle", "preload"));
		if (FlxG.keys.justReleased.RIGHT)
			arrows[1].loadGraphic(Paths.image("ui/ArrowRight_Idle", "preload"));

		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].forms.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].forms.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		#if debug
		if (FlxG.keys.justPressed.R && !selectedCharacter)
		{
			reset();
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.N && !FlxG.keys.pressed.SHIFT)
		{
            char.x += 1;
		}

		if (FlxG.keys.justPressed.M && !FlxG.keys.pressed.SHIFT)
		{
			char.y += 1;
		}


		if (FlxG.keys.justPressed.N && FlxG.keys.pressed.SHIFT)
		{
			char.x -= 1;
		}

		if (FlxG.keys.justPressed.M && FlxG.keys.pressed.SHIFT)
		{
			char.y -= 1;
		}


		FlxG.watch.addQuick("char.x", char.x);
		FlxG.watch.addQuick("char.y", char.y);
		FlxG.watch.addQuick("char", currentSelectedCharacter.forms[curForm].name);
		#end
	}

	public static function unlockCharacter(character:String)
	{
		if (!FlxG.save.data.charactersUnlocked.contains(character))
		{
			FlxG.save.data.charactersUnlocked.push(character);
			FlxG.save.flush();
		}
	}

	public static function isLocked(character:String):Bool
	{
		return !FlxG.save.data.charactersUnlocked.contains(character);
	}

	public static function reset()
	{
		FlxG.save.data.charactersUnlocked = new Array<String>();
		unlockCharacter('bf');
		FlxG.save.flush();
	}

	public function UpdateBF()
	{
		var newSelectedCharacter = characters[current];
		if (currentSelectedCharacter.forms[curForm].noteType != newSelectedCharacter.forms[curForm].noteType)
		{
			generateStaticArrows(newSelectedCharacter.forms[curForm].noteType, true);
		

		}
		currentSelectedCharacter = newSelectedCharacter;
		characterText.text = currentSelectedCharacter.forms[curForm].polishedName;
		char.visible = false;
		char = new Boyfriend(basePosition.x, basePosition.y, currentSelectedCharacter.forms[curForm].name);
		char.cameras = [camHUD];

		char.x = char.charModelOffset[0];
		char.y = char.charModelOffset[1];


		switch (currentSelectedCharacter.name)
		{
			case 'bf':
				charColorPinter = 0;
			case 'bob':
				charColorPinter = 1;
		}

		FlxTween.color(bg, 0.25, bg.color, charColor[charColorPinter]);

		insert(members.indexOf(strummies), char);
		funnyIconMan.changeIcon(char.curCharacter);
		funnyIconMan.color = FlxColor.WHITE;
		if (isLocked(characters[current].forms[curForm].name))
		{
			char.color = FlxColor.BLACK;
			funnyIconMan.color = FlxColor.BLACK;
			characterText.text = '???';
		}
		characterText.screenCenter(X);
		updateIconPosition();
	}

	override function beatHit()
	{
		super.beatHit();

		scrollSpd.text = "Scroll Speed: < " + Maths.truncateFloat(FlxG.save.data.scrollSpeed, 1) + " >";

		gostTapping.text = "Ghost Tapping: < " + (FlxG.save.data.epico ? "Disabled" : "Enabled") + " >";

		botPlay.text = "BotPlay: < " + (FlxG.save.data.botplay ? "on" : "off") + " >";

		showcaseMode.text = "Showcase Mode: < " + (FlxG.save.data.showcaseMode ? "Enabled" : "Disabled") + " >";

		alternateVocals.text = "Use Alternate Vocals: < " + (StaticData.useAlternateVocals ? "True" : "False") + " >";

		if (char != null && !selectedCharacter && curBeat % 2 == 0 && char.animation.curAnim.name == 'idle')
		{
			char.playAnim('idle', true);
		}
	}

	function updateIconPosition()
	{
		// var xValues = CoolUtil.getMinAndMax(funnyIconMan.width, characterText.width);
		var yValues = CoolUtil.getMinAndMax(funnyIconMan.height, characterText.height);

		funnyIconMan.x = characterText.x + characterText.width / 2;
		funnyIconMan.y = characterText.y + ((yValues[0] - yValues[1]) / 2);
	}

	public function endIt(e:FlxTimer = null)
	{
		StaticData.isInCharacterSelect = false;
		PlayState.characteroverride = currentSelectedCharacter.name;


		if (FlxTransitionableState.skipNextTransIn)
		{
			Transition.nextCamera = null;
		}
		FlxG.sound.music.stop();
		LoadingState.loadAndSwitchState(new PlayState());
	}
}