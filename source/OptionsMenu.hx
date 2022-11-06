package;

import flixel.addons.display.FlxBackdrop;
import aeroshide.EngineUtils.PlacementHelper.move;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionCata extends FlxSprite
{
	public var title:String;
	public var options:Array<Option>;

	public var optionObjects:FlxTypedGroup<FlxText>;

	public var titleObject:FlxText;

	public var middle:Bool = false;



	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false)
	{
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType)
			makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.4;

		options = _options;

		optionObjects = new FlxTypedGroup();

		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 0 : 16), 0, title);
		titleObject.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.borderSize = 3;

		if (middleType)
		{
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		}
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);

		titleObject.scrollFactor.set();

		scrollFactor.set();

		for (i in 0...options.length)
		{
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), titleObject.y + 54 + (46 * i), 0, opt.getValue());
			if (middleType)
			{
				text.screenCenter(X);
			}
			text.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 3;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}

	public function changeColor(color:FlxColor)
	{
		makeGraphic(295, 64, color);
	}
}

class OptionsMenu extends FlxSubState
{
	public static var instance:OptionsMenu;

	public var background:FlxSprite;

	public var selectedCat:OptionCata;

	public var selectedOption:Option;

	public var selectedCatIndex = 0;
	public var selectedOptionIndex = 0;

	public var isInCat:Bool = false;

	public var options:Array<OptionCata>;

	public static var isInPause = false;

	public static var spawnObject:Bool = true;

	public var shownStuff:FlxTypedGroup<FlxText>;
	var initX:Int;
	var initY:Int;

	public static var visibleRange = [114, 640];

	public function new(pauseMenu:Bool = false)
	{
		super();

		isInPause = pauseMenu;
	}

	public var menu:FlxTypedGroup<FlxSprite>;

	public var descText:FlxText;
	public var descBack:FlxSprite;
	public	var gameplay:FlxSprite = new FlxSprite().makeGraphic(295, 70, FlxColor.BLACK);

	public var appearence:FlxSprite = new FlxSprite().makeGraphic(295, 70, FlxColor.RED);
	public var misc:FlxSprite = new FlxSprite().makeGraphic(295, 70, FlxColor.BLUE);
	public var saves:FlxSprite = new FlxSprite().makeGraphic(295, 70, FlxColor.GREEN);
	var bg:FlxSprite;
	var bg2:FlxSprite;

	override function create()
	{

		options = [
			new OptionCata(50, 40, "Gameplay", [
				new ScrollSpeedOption("Change your scroll speed. (1 = Chart dependent)"),
				new OffsetThing("Change the note audio offset (how many milliseconds a note is offset in a chart)"),
				new GhostTapOption("Toggle counting pressing a directional input when no arrow is there as a miss."),
				new DownscrollOption("Toggle making the notes scroll down rather than up."),
				new BotPlay("Toggles a bot to play the game for you (F1 to toggle mid game)"),
				#if desktop new FPSCapOption("Change your FPS Cap."),
				#end
				new ResetButtonOption("Toggle pressing R to gameover."),
				new InstantRespawn("Toggle if you instantly respawn after dying."),
				new DFJKOption(),
				new Judgement("Create a custom judgement preset"),
			]),
			new OptionCata(345, 40, "Appearence", [
				new GPUOption("Toggle shaders distractions that can hinder your gameplay. (Turn off if laggy)"), // note : needs to be implemented
				new NoteSplashes("Toggle a note splash whenever you hit a SICK timing (like in FNF week 7 update)."), 
				new JudgementCounter("Show your judgements that you've gotten in the song"), // note : needs to be implemented
				new AccuracyOption("Toggles between Psych Engine type of display or Kade Engine's"),
				new SongPositionOption("Show the song's current position as a scrolling bar."),
				new HitSounds("You would hear a TICK, if you hit a note to better time your presses."),
				new IconBounceMode("Choose between icon bounce animations."),
				new MissSoundsOption("Toggle miss sounds playing when you don't hit a note."),
			]),
			new OptionCata(640, 40, "Engine", [
				new FPSOption("Toggle the FPS Counter"),
				new RainbowFPSOption("Make the FPS Counter flicker through rainbow colors."),
				new MemOption("Toggle the Memory counter (the memory that the game is using)"),
				new DiscordRPC("Shows your current detailed play status on Discord for everyone to see"),
				new AntialiasingOption("Toggle antialiasing, improving graphics quality at a slight performance penalty."),
				
			]),
			new OptionCata(935, 40, "Saves", [
				new LockWeeksOption("Reset your story mode progress. This is irreversible!"),
				new ResetSettings("Reset ALL your settings. This is irreversible!")
			]),
			new OptionCata(-1, 125, "Editing Keybinds", [
				new LeftKeybind("The left note's keybind"), new DownKeybind("The down note's keybind"), new UpKeybind("The up note's keybind"),
				new RightKeybind("The right note's keybind"), new PauseKeybind("The keybind used to pause the game"),
				new ResetBind("The keybind used to die instantly"), new MuteBind("The keybind used to mute game audio"),
				new VolUpBind("The keybind used to turn the volume up"), new VolDownBind("The keybind used to turn the volume down"),
				new FullscreenBind("The keybind used to fullscreen the game")], true),
			new OptionCata(-1, 125, "Editing Judgements", [
				new SickMSOption("How many milliseconds are in the SICK hit window"),
				new GoodMsOption("How many milliseconds are in the GOOD hit window"),
				new BadMsOption("How many milliseconds are in the BAD hit window"),
				new ShitMsOption("How many milliseconds are in the SHIT hit window")
			], true)
		];

		instance = this;

		menu = new FlxTypedGroup<FlxSprite>();

		shownStuff = new FlxTypedGroup<FlxText>();



		bg2 = new FlxSprite().makeGraphic(FlxG.width * 16, FlxG.height * 16, FlxColor.GRAY);
		move(-650, -550, bg2);
		bg2.antialiasing = true;
		bg2.alpha = 0.7;
		add(bg2);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.antialiasing = true;
		bg.color = 0xFF4F4F4F;
		add(bg);

		background = new FlxSprite(50, 40).makeGraphic(1180, 640, FlxColor.BLACK);
		background.alpha = 0.5;
		background.scrollFactor.set();
		menu.add(background);

		descBack = new FlxSprite(50, 640).makeGraphic(1180, 38, FlxColor.BLACK);
		descBack.alpha = 0.3;
		descBack.scrollFactor.set();
		menu.add(descBack);


		

		if (isInPause)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			menu.add(bg);

			background.alpha = 0.5;
			bg.alpha = 0.6;

			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}

		selectedCat = options[0];

		selectedOption = selectedCat.options[0];

		add(menu);

		add(shownStuff);

		for (i in 0...options.length - 1)
		{
			if (i >= 4)
				continue;
			var cat = options[i];
			add(cat);
			add(cat.titleObject);
		}

		descText = new FlxText(62, 648);
		descText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 2;

		add(descBack);
		add(descText);

		isInCat = true;

		switchCat(selectedCat);

		selectedOption = selectedCat.options[0];


		//figure out how to make mouse movement shit on the gameplay options
		// for now we have mouse scroll, this is a backup plan if we didnt make it

		var gap:Int = Math.round(gameplay.width);
	
		initX = 50;
		initY = 30;


		move(initX, initY, gameplay);
		move(initX+(gap*1), initY, appearence);
		move(initX+(gap*2), initY, misc);
		move(initX+(gap*3), initY, saves);




		super.create();
	}

	public function switchCat(cat:OptionCata, checkForOutOfBounds:Bool = true)
	{
		try
		{
			visibleRange = [114, 640];
			if (cat.middle)
				visibleRange = [Std.int(cat.titleObject.y), 640];
			if (selectedOption != null)
			{
				var object = selectedCat.optionObjects.members[selectedOptionIndex];
				object.text = selectedOption.getValue();
			}

			if (selectedCatIndex > options.length - 3 && checkForOutOfBounds)
				selectedCatIndex = 0;

			if (selectedCat.middle)
				remove(selectedCat.titleObject);

			selectedCat.changeColor(FlxColor.BLACK);
			selectedCat.alpha = 0.3;

			for (i in 0...selectedCat.options.length)
			{
				var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.titleObject.y + 54 + (46 * i);
			}

			while (shownStuff.members.length != 0)
			{
				shownStuff.members.remove(shownStuff.members[0]);
			}
			selectedCat = cat;
			selectedCat.alpha = 0.2;
			selectedCat.changeColor(FlxColor.WHITE);

			if (selectedCat.middle)
				add(selectedCat.titleObject);

			for (i in selectedCat.optionObjects)
				shownStuff.add(i);

			selectedOption = selectedCat.options[0];

			if (selectedOptionIndex > options[selectedCatIndex].options.length - 1)
			{
				for (i in 0...selectedCat.options.length)
				{
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
			}

			selectedOptionIndex = 0;

			if (!isInCat)
				selectOption(selectedOption);

			for (i in selectedCat.optionObjects.members)
			{
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					i.alpha = 0.4;
				}
			}
		}
		catch (e)
		{
			selectedCatIndex = 0;
		}

	}

	public function selectOption(option:Option)
	{
		var object = selectedCat.optionObjects.members[selectedOptionIndex];

		selectedOption = option;

		if (!isInCat)
		{
			if (!option.isModifiable())
			{
				object.color = 0xFFe30227;
				object.text = "X > " + option.getValue();

				descText.color = 0xFFe30227;
				descText.text = option.getDescription();


			}
			else
			{
				object.color = 0xffffffff;
				object.text = "> " + option.getValue();

				descText.color = 0xffffffff;
				descText.text = option.getDescription();
			}

		}
	}



	override function update(elapsed:Float)
	{

		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;

		super.update(elapsed);

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		var accept = false;
		var right = false;
		var left = false;
		var up = false;
		var down = false;
		var any = false;
		var escape = false;

		var wheelStatus:Int = Math.round(FlxG.mouse.wheel);
		var hoveringOnMenus:Bool = FlxG.mouse.overlaps(gameplay) || FlxG.mouse.overlaps(appearence) || FlxG.mouse.overlaps(misc) || FlxG.mouse.overlaps(saves);

		accept = FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed || (gamepad != null ? gamepad.justPressed.A : false);
		right = FlxG.keys.justPressed.RIGHT || (FlxG.mouse.justPressedRight && !isInCat) || (wheelStatus > 0 && isInCat) || (gamepad != null ? gamepad.justPressed.DPAD_RIGHT : false);
		left = FlxG.keys.justPressed.LEFT || (FlxG.mouse.justPressed && !isInCat && !hoveringOnMenus) || (wheelStatus < 0 && isInCat) || (gamepad != null ? gamepad.justPressed.DPAD_LEFT : false);
		up = FlxG.keys.justPressed.UP || (wheelStatus > 0) || (gamepad != null ? gamepad.justPressed.DPAD_UP : false);
		down = FlxG.keys.justPressed.DOWN || (wheelStatus < 0) || (gamepad != null ? gamepad.justPressed.DPAD_DOWN : false);

		any = FlxG.keys.justPressed.ANY || (gamepad != null ? gamepad.justPressed.ANY : false);
		escape = FlxG.keys.justPressed.ESCAPE || (gamepad != null ? gamepad.justPressed.B : false);

		if (isInCat)
		{
			if (FlxG.mouse.overlaps(gameplay))
			{
				if (selectedCatIndex != 0)
				{
					selectedCatIndex = 0;
					switchCat(options[selectedCatIndex]);
						
				}
		
			}
		
			if (FlxG.mouse.overlaps(appearence))
			{
				if (selectedCatIndex != 1)
				{
					selectedCatIndex = 1;
					switchCat(options[selectedCatIndex]);
				}
			}

			if (FlxG.mouse.overlaps(misc))
			{
				if (selectedCatIndex != 2)
				{
					selectedCatIndex = 2;
					switchCat(options[selectedCatIndex]);
				}

			}

			if (FlxG.mouse.overlaps(saves))
			{
				if (selectedCatIndex != 3)
				{
					selectedCatIndex = 3;
					switchCat(options[selectedCatIndex]);
				}

			}
				
		}
		else
		{
			if (FlxG.mouse.overlaps(gameplay) && accept)
			{
				if (selectedCatIndex != 0)
				{
					selectedCatIndex = 0;
					switchCat(options[selectedCatIndex]);
				}
			}

			if (FlxG.mouse.overlaps(appearence) && accept)
			{
				if (selectedCatIndex != 1)
				{
					selectedCatIndex = 1;
					switchCat(options[selectedCatIndex]);
				}
			}

			if (FlxG.mouse.overlaps(misc) && accept)
			{
				if (selectedCatIndex != 2)
				{
					selectedCatIndex = 2;
					switchCat(options[selectedCatIndex]);
				}
			}

			if (FlxG.mouse.overlaps(saves) && accept)
			{
				if (selectedCatIndex != 3)
				{
					selectedCatIndex = 3;
					switchCat(options[selectedCatIndex]);
				}
			}
		}
		


		


		if (selectedCat != null && !isInCat)
		{
			for (i in selectedCat.optionObjects.members)
			{
				if (selectedCat.middle)
				{
					i.screenCenter(X);
				}

				// I wanna die!!!
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					if (selectedCat.optionObjects.members[selectedOptionIndex].text != i.text)
					{
						i.alpha = 0.4;
						i.color = FlxColor.WHITE;
					}	
					else
						i.alpha = 1;
				}
			}
		}

		try
		{
			if (isInCat)
			{
				descText.text = "Please select a category";
				descText.color = FlxColor.WHITE;
				if (right)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex++;

					if (selectedCatIndex > options.length - 3)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 3;

					switchCat(options[selectedCatIndex]);
				}
				else if (left)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex--;

					if (selectedCatIndex > options.length - 3)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 3;

					switchCat(options[selectedCatIndex]);
				}

				if (accept)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedOptionIndex = 0;
					isInCat = false;
					selectOption(selectedCat.options[0]);
				}

				if (escape)
				{
					if (!isInPause)
						FlxG.switchState(new MainMenuState());
					else
					{
						PauseSubState.goBack = true;
						//PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed * PlayState.songMultiplier;
						close();
					}
				}
			}
			else
			{
				if (selectedOption != null)
					if (selectedOption.acceptType)
					{
						if (escape && selectedOption.waitingType)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							selectedOption.waitingType = false;
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							if (selectedOption.isModifiable())
								object.text = "> " + selectedOption.getValue();
							return;
						}
						else if (any)
						{
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							selectedOption.onType(gamepad == null ? FlxG.keys.getIsDown()[0].ID.toString() : gamepad.firstJustPressedID());
							if (selectedOption.isModifiable())
								object.text = "> " + selectedOption.getValue();
						}
					}
				if (selectedOption.acceptType || !selectedOption.acceptType)
				{
					if (accept)
					{
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.press();

						if (selectedOptionIndex == prev)
						{
							FlxG.save.flush();

							if (selectedOption.isModifiable())
								object.text = "> " + selectedOption.getValue();
						}
					}

					if (down)
					{
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex++;

						// just kinda ignore this math lol

						if (selectedOptionIndex > options[selectedCatIndex].options.length - 1)
						{
							selectedOptionIndex = 0;
						}

						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}
					else if (up)
					{
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex--;

						// just kinda ignore this math lol

						if (selectedOptionIndex < 0)
						{
							selectedOptionIndex = options[selectedCatIndex].options.length - 1;
						}

						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}

					if (right)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.right();

						FlxG.save.flush();

						if (selectedOption.isModifiable())
							object.text = "> " + selectedOption.getValue();
					}
					else if (left)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.left();

						FlxG.save.flush();

						if (selectedOption.isModifiable())
							object.text = "> " + selectedOption.getValue();
					}

					if (escape)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));

						if (selectedCatIndex >= 4)
							selectedCatIndex = 0;

						PlayerSettings.player1.controls.loadKeyBinds();

						Ratings.timingWindows = [
							FlxG.save.data.shitMs,
							FlxG.save.data.badMs,
							FlxG.save.data.goodMs,
							FlxG.save.data.sickMs
						];

						for (i in 0...selectedCat.options.length)
						{
							var opt = selectedCat.optionObjects.members[i];
							opt.y = selectedCat.titleObject.y + 54 + (46 * i);
						}
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						isInCat = true;
						if (selectedCat.optionObjects != null)
							for (i in selectedCat.optionObjects.members)
							{
								if (i != null)
								{
									i.color = FlxColor.WHITE;

									if (i.y < visibleRange[0] - 24)
										i.alpha = 0;
									else if (i.y > visibleRange[1] - 24)
										i.alpha = 0;
									else
									{
										i.alpha = 0.4;
									}
								}
							}
						if (selectedCat.middle)
							switchCat(options[0]);
					}
				}
			}
		}
		catch (e)
		{
			selectedCatIndex = 0;
			selectedOptionIndex = 0;
			FlxG.sound.play(Paths.sound('scrollMenu'));
			if (selectedCat != null)
			{
				for (i in 0...selectedCat.options.length)
				{
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
				selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
				isInCat = true;
			}
		}
	}
}