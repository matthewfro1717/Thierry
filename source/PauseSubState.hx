package;

import aeroshide.StaticData;
import PlayState;
import llua.Lua;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Quick Options', 'Exit to menu'];
	var menuItemsToo:Array<String> = ['Resume', 'Restart Song', 'Quick Options', 'Exit to menu'];
	var quickSettings:Array<String> = ['Note splash', 'Hitsounds', 'Ghost Tapping', 'Input System', 'Score Text', 'BACK'];
	var curSelected:Int = 0;
	public static var goBack:Bool = false;

	var pauseMusic:FlxSound;
	var perSongOffset:FlxText;
	var notesplashText:FlxText;
	var hitsoundsText:FlxText;
	var ghosttappingText:FlxText;
	var inputsystemText:FlxText;
	var scoreText:FlxText;
	
	var offsetChanged:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		notesplashText = new FlxText(20, 15 + 101, 0, "NOTE SPLASH ON", 32);
		notesplashText.scrollFactor.set();
		notesplashText.setFormat(Paths.font('vcr.ttf'), 32);
		notesplashText.x = FlxG.width - (notesplashText.width + 20);
		notesplashText.updateHitbox();
		add(notesplashText);

		hitsoundsText = new FlxText(20, 45 + 101, 0, "HITSOUNDS ON", 32);
		hitsoundsText.scrollFactor.set();
		hitsoundsText.setFormat(Paths.font('vcr.ttf'), 32);
		hitsoundsText.x = FlxG.width - (hitsoundsText.width + 20);
		hitsoundsText.updateHitbox();
		add(hitsoundsText);

		ghosttappingText = new FlxText(20, 70 + 101, 0, "GHOST TAPPING ALLOWED", 32);
		ghosttappingText.scrollFactor.set();
		ghosttappingText.setFormat(Paths.font('vcr.ttf'), 32);
		ghosttappingText.x = FlxG.width - (ghosttappingText.width + 20);
		ghosttappingText.updateHitbox();
		add(ghosttappingText);
		if (!FlxG.save.data.epico)
		{
			ghosttappingText.text = "GHOST TAPPING ALLOWED";
		}
		else
		{
			ghosttappingText.text = "NO GHOST TAPPING";
		}

		inputsystemText = new FlxText(20, 100 + 101, 0, "INPUT SYSTEM : AEROSHIDE", 32);
		inputsystemText.scrollFactor.set();
		inputsystemText.setFormat(Paths.font('vcr.ttf'), 32);
		inputsystemText.x = FlxG.width - (inputsystemText.width + 20);
		inputsystemText.updateHitbox();
		if (FlxG.save.data.tolol)
		{
			inputsystemText.text = "INPUT SYSTEM : AEROSHIDE";
		}
		else
		{
			inputsystemText.text = "INPUT SYSTEM : KADEDEV";
		}
		add(inputsystemText);

		scoreText = new FlxText(20, 130 + 101, 0, "SCORE DISPLAY : SIMPLIFIED", 32);
		scoreText.scrollFactor.set();
		scoreText.setFormat(Paths.font('vcr.ttf'), 32);
		scoreText.x = FlxG.width - (scoreText.width + 20);
		scoreText.updateHitbox();
		scoreText.visible = true;
		if (!FlxG.save.data.accuracyDisplay)
		{
			scoreText.text = "SCORE DISPLAY : SIMPLIFIED";
		}
		else
		{
			scoreText.text = "SCORE DISPLAY : COMPETITIVE";
		}
		add(scoreText);

		notesplashText.visible = false;
		hitsoundsText.visible = false;
		ghosttappingText.visible = false;
		inputsystemText.visible = false;
		scoreText.visible = false;

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);
		perSongOffset = new FlxText(5, FlxG.height - 18, 0, 'Hi youtube!!', 12);
		perSongOffset.scrollFactor.set();
		perSongOffset.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		#if desktop
			add(perSongOffset);
		#end

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;
		var oldOffset:Float = 0;
		var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';

		if (upP)
		{
			changeSelection(-1);
   
		}else if (downP)
		{
			changeSelection(1);
		}
		

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Quick Options":
					notesplashText.visible = FlxG.save.data.spong;
					hitsoundsText.visible = FlxG.save.data.hitSounds;
					ghosttappingText.visible = true;
					inputsystemText.visible = true;
					scoreText.visible = true;
					menuItems = quickSettings;
					regenMenu();
				case "Exit to menu":
					PlayState.loadRep = false;
					FlxG.switchState(new MainMenuState());
				//QUICK SETTINGS SHIT
				case "Note splash":
					FlxG.save.data.spong = !FlxG.save.data.spong;
					notesplashText.visible = FlxG.save.data.spong;
				case "Hitsounds":
					FlxG.save.data.hitSounds = !FlxG.save.data.hitSounds;
					hitsoundsText.visible = FlxG.save.data.hitSounds;
				case "Ghost Tapping":
					FlxG.save.data.epico = !FlxG.save.data.epico;
					if (FlxG.save.data.epico)
					{
						ghosttappingText.text = "NO GHOST TAPPING";
					}
					else
					{
						ghosttappingText.text = "GHOST TAPPING ALLOWED";
					}
				case "Input System":
					FlxG.save.data.tolol = !FlxG.save.data.tolol;
					if (FlxG.save.data.tolol)
					{
						
						inputsystemText.text = "INPUT SYSTEM : AEROSHIDE";
					}
					else
					{
						inputsystemText.text = "INPUT SYSTEM : KADEDEV";
					}
				case "Score Text":
					FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
					if (!FlxG.save.data.accuracyDisplay)
					{
						scoreText.text = "SCORE DISPLAY : SIMPLIFIED";
					}
					else
					{
						scoreText.text = "SCORE DISPLAY : COMPETITIVE";
					}
				case "BACK":
					notesplashText.visible = false;
					hitsoundsText.visible = false;
					ghosttappingText.visible = false;
					inputsystemText.visible = false;
					scoreText.visible = false;
					menuItems = menuItemsToo;
					regenMenu();

			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
