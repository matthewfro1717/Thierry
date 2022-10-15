package;

import aeroshide.StaticData;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 *
	 * THERE I FUCKING CHANGED IT, ITS NOT ANNOYING ANYMORE!!!
	 */

	 //i understand
	public var sprTracker:FlxSprite;
	public var char:String;
	public var isPlayer:Bool;
	

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		if (char == 'Fsby')
		{
			frames = Paths.getSparrowAtlas('ohungi-icon');
			animation.addByPrefix('idle', 'idle', 24, true, isPlayer, false);
			animation.addByPrefix('lose', 'lose', 24, true, isPlayer, false);
			animation.play('idle');
			StaticData.animaticaEngine = true;
		}
		else
		{

			changeIcon(char, isPlayer);
		}
		
		






		
		switch(char){
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				{

				}
			default:
				{
					antialiasing = true;
				}
		}
		scrollFactor.set();
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, isPlayer:Bool = false)
	{
		if(this.char != char) 
		{
			var name:String = 'icons/' + char;
			var legacyIcon:Bool = false;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE))
			{
				name = 'icons/legacy-' + char; //2 frames animations icons
				legacyIcon = true;
			} 

			if(!Paths.fileExists('images/' + name + '.png', IMAGE) && !Paths.fileExists('images/legacy-' + name + '.png', IMAGE))
			{
				name = 'icons/placeholder'; //Prevents crash from missing icon
				legacyIcon = false;
			} 
			var file:Dynamic = Paths.image(name);

			var frames:Int = 3;
			if (legacyIcon) frames = 2;

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / frames), Math.floor(height)); //Then load it fr
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			animation.play(char);
			//updateHealthColor(0xFFe30227, bfHealthBar); since DE is still in development, this wouldnt work well while debugging,
       		//so disabled temporarily
			this.char = char;


		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		//offset.y = iconOffsets[1];
	}


	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
