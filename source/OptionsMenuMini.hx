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
import OptionsMenu.OptionCata;
import OptionsMenu.OptionsMenu.*;

class OptionsMenuMini extends FlxSubState
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
	public static var instanceMini:OptionsMenuMini;


	override function create()
	{

		options = [
			new OptionCata(467, 40, "Pre-Song Configuration", [
				new ScrollSpeedOption("Change your scroll speed. (1 = Chart dependent)"),
				new GhostTapOption("Toggle counting pressing a directional input when no arrow is there as a miss."),
				new BotPlay("Toggles a bot to play the game for you (F1 to toggle mid game)"),
				new ShowcaseMode("Hide unecesarry texts for better viewing and also makes you invulnerable"),
				new UseAlternateVocals("Switch between the actual vocals for the song, or use a cover for your selected character.")
			]),
			new OptionCata(-1, 40, "Pre-Song Configuration", [
				new FullscreenBind("The keybind used to fullscreen the game")
			], true),
		];

		instanceMini = this;

		menu = new FlxTypedGroup<FlxSprite>();

		shownStuff = new FlxTypedGroup<FlxText>();

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
				descText.text = "Change your scroll speed. (1 = Chart dependent)";
				descText.color = FlxColor.WHITE;

				isInCat = false;

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

						PauseSubState.goBack = true;
						// PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed * PlayState.songMultiplier;
						CharSelectState.scoreBG.visible = true;
						close();

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