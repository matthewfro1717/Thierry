package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var charModelOffset:Array<Float> = new Array<Float>();

	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;

	public var globaloffset:Array<Float> = [0,0];
	public var nil:Int = 0;

	public var ground:Int = 200;

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case '3d-bf':
				frames = Paths.getSparrowAtlas('characters/3D_BF');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'LEFT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);

				animation.addByPrefix('singUPmiss', 'MUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MDOWN', 24, false);
				

				addOffset('idle');
				addOffset("singUP", 86, 118);
				addOffset("singRIGHT", -36, 16);
				addOffset("singLEFT", 10, 16);
				addOffset("singDOWN", 6);
				addOffset("singUPmiss", 6, 10);
				addOffset("singRIGHTmiss", -3);
				addOffset("singLEFTmiss", 17);
				addOffset("singDOWNmiss");

				nativelyPlayable = flipX = true;

				antialiasing = false;

				playAnim('idle');

			case 'bf-fps':
				frames = Paths.getSparrowAtlas('characters/shoulder_3d_bf');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'LEFT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);

				animation.addByPrefix('singUPmiss', 'IDLE', 24, false);
				animation.addByPrefix('singLEFTmiss', 'IDLE', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'IDLE', 24, false);
				animation.addByPrefix('singDOWNmiss', 'IDLE', 24, false);
				

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				nativelyPlayable = flipX = true;

				antialiasing = false;

				playAnim('idle');
				
			case 'thierry-mad':
				trace("THIERRY GLITCHED LOADED!");
				tex = Paths.getSparrowAtlas('characters/thierry_mad', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idlee', 24, false);
				animation.addByPrefix('singUP', 'singU', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGH', 24, false);
				animation.addByPrefix('singDOWN', 'singDOW', 24, false);
				animation.addByPrefix('singLEFT', 'singLEF', 24, false);
		
				addOffset('idle');
				addOffset("singUP", 140, -230);
				addOffset("singRIGHT", -180, -100);
				addOffset("singLEFT", 250, -140);
				addOffset("singDOWN", 150, -310);
				globaloffset[0] = 150 * 1.3;
				globaloffset[1] = 750 * 1.3; //this is the y
				setGraphicSize(Std.int((width * 1) / furiosityScale));
				updateHitbox();
				antialiasing = false;
				//playAnim('idle');

			case 'gerlad':
				tex = Paths.getSparrowAtlas('characters/gerlad', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Idle", 24, false);
				animation.addByPrefix('singUP', 'realup', 24, false);
				animation.addByPrefix('singDOWN', 'realdown', 24, false);
				animation.addByPrefix('singLEFT', 'realleft', 24, false);
				animation.addByPrefix('singRIGHT', 'realright', 24, false);

				animation.addByPrefix('singUP-alt', 'up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'right', 24, false);

				animation.addByPrefix('FUCKIDLE', 'FUCKIDLE', 24, false);

				addOffset('idle', 0, -350);
				addOffset("singUP", 0, -350);
				addOffset("singRIGHT", 0, -350);
				addOffset("singLEFT", 0, -350);
				addOffset("singDOWN", 0, -350);
				addOffset("FUCKIDLE", 0, -350);

			case 'gw-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/gw_3d', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'DaveAngry idle dance', 24, false);
				animation.addByPrefix('singUP', 'DaveAngry Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'DaveAngry Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DaveAngry Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'DaveAngry Sing Note LEFT', 24, false);
		
				addOffset('idle', 7, 0);
				addOffset("singUP", -14, 16);
				addOffset("singRIGHT", 13, 23);
				addOffset("singLEFT", 49, -9);
				addOffset("singDOWN", 0, -10);
				globaloffset[0] = 150;
				globaloffset[1] = 450;
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');

				

			case 'spong-3d':
				tex = Paths.getSparrowAtlas('characters/spong_3d', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "spooky dance idle", 24, false);
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);


				addOffset('idle', -41, 0);
				addOffset("singUP", 43, 0);
				addOffset("singRIGHT", 20, 0);
				addOffset("singLEFT", -20, 0);
				addOffset("singDOWN", 450, 0);

			case 'fake':
				tex = Paths.getSparrowAtlas('characters/fake', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "fake idle", 24, false);
				animation.addByPrefix('singUP', 'fake up', 24, false);
				animation.addByPrefix('singDOWN', 'fake down', 24, false);
				animation.addByPrefix('singLEFT', 'fake left', 24, false);
				animation.addByPrefix('singRIGHT', 'fake right', 24, false);

				addOffset('idle', -20, -91);
				addOffset("singUP", -10, -84);
				addOffset("singRIGHT", -2, -80);
				addOffset("singLEFT", 0, -84);
				addOffset("singDOWN", 0, -84);



			case 'bob':
				tex = Paths.getSparrowAtlas('characters/bob_asset', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				charModelOffset = [259, -176]; //x+ is right, y
				addOffset('idle', 0, -250); // -50 + 323
				addOffset("singUP", 0, -250);
				addOffset("singRIGHT", 0, -250);
				addOffset("singLEFT", 0, -250);
				addOffset("singDOWN", 0, -250);
				flipX = true;
			case 'mmm':
				tex = Paths.getSparrowAtlas('characters/Meri_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Meri Idle", 24, false);
				animation.addByPrefix('singUP', 'Meri Up', 24, false);
				animation.addByPrefix('singDOWN', 'Meri Down', 24, false);
				animation.addByPrefix('singLEFT', 'Meri Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Meri Right', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", -12, 3);
				addOffset("singRIGHT", 25, -24);
				addOffset("singLEFT", -7, 6);
				addOffset("singDOWN", 0, -26);

			case 'bob-invis':
				tex = Paths.getSparrowAtlas('characters/bob_invis', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				addOffset('idle', 0, -250);
				addOffset("singUP", 0, -250);
				addOffset("singRIGHT", 0, -250);
				addOffset("singLEFT", 0, -250);
				addOffset("singDOWN", 0, -250);
				flipX = true;

			case 'ron':
				tex = Paths.getSparrowAtlas('characters/Tankman', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Idle", 24);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('cheer', 'Ugh', 24, false);
				addOffset('idle');
				addOffset("singUP", 42, 38);
				addOffset("singLEFT", 98, -27);
				addOffset("singRIGHT", -89, -51);
				addOffset("singDOWN", 40, -120);
				addOffset("Ugh", 71, -40);

			case 'bob-player':
				tex = Paths.getSparrowAtlas('characters/bob_ass_play', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
		
				addOffset('idle', 0, 100);
				addOffset("singUP", 0, 100);
				addOffset("singRIGHT", 0, 100);
				addOffset("singLEFT", 0, 100);
				addOffset("singDOWN", 0, 100);
				flipX = true;
				

			case 'bob-real-omg':
				tex = Paths.getSparrowAtlas('characters/bob_ass_real', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
	
				addOffset('idle', 0, -250);
				addOffset("singUP", 0, -250);
				addOffset("singRIGHT", 0, -250);
				addOffset("singLEFT", 0, -250);
				addOffset("singDOWN", 0, -250);
				flipX = true;

			case 'bob-bersama':
				tex = Paths.getSparrowAtlas('characters/bob_asset', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
	
				addOffset('idle', 0, -250);
				addOffset("singUP", 0, -250);
				addOffset("singRIGHT", 0, -250);
				addOffset("singLEFT", 0, -250);
				addOffset("singDOWN", 0, -250);
				flipX = true;

			case 'matt':
				tex = Paths.getSparrowAtlas('characters/matt_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "matt idle", 24);
				animation.addByPrefix('singUP', 'matt up note', 24, false);
				animation.addByPrefix('singDOWN', 'matt down note', 24, false);
				animation.addByPrefix('singLEFT', 'matt left note', 24, false);
				animation.addByPrefix('singRIGHT', 'matt right note', 24, false);
				addOffset("idle", -160, -280);
				addOffset("singUP", -160, -280);
				addOffset("singRIGHT", -115, -300);
				addOffset("singLEFT", -190, -320);
				addOffset("singDOWN", -160, -300);

			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets', 'shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/christmas/gfChristmas', 'shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'tunnel-bf':
				var tex = Paths.getSparrowAtlas('characters/tunnel_bf', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('turn', 'TURN', 24, false);

				animation.addByPrefix('singUPmiss', 'UP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'LEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'DOWN', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT", 53);
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset('turn');

				playAnim('idle');

				flipX = true;

				nativelyPlayable = true;

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/weeb/gfPixel', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Dave_insanity_lol', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('scared', 'Scared', 24, true);
	
				addOffset('idle', 0, 0 - ground);
				addOffset("singUP", 3, 18 - ground);
				addOffset("singRIGHT", 16, -18 - ground);
				addOffset("singLEFT", 85, -12 - ground);
				addOffset("singDOWN", 0, -34 - ground);
				addOffset("scared", 0, -2 - ground);
	
				playAnim('idle');

			case 'sayagi':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/sayagmoves', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('Attack', 'Attack', 24, true);

				addOffset('idle', 0, 0);
				addOffset("singUP", 20, -60);
				addOffset("singRIGHT", 60, -90);
				addOffset("singLEFT", 171, 26);
				addOffset("singDOWN", 0, -111);
				addOffset("Attack", 680, 118);

				playAnim('idle');

			case 'david':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/david', 'shared');


			case 'cell':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Cell', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 26, 105);
				addOffset("singRIGHT", 110);
				addOffset("singLEFT", 150);
				addOffset("singDOWN", 70);
				addOffset("scared");
	
				playAnim('idle');

			case 'cellMad':
				// CELL MAD STAY MAD
				tex = Paths.getSparrowAtlas('characters/CellMad', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				addOffset('idle');
				addOffset("singUP", 206, 85);
				addOffset("singRIGHT", 231, 54);
				addOffset("singLEFT", 450, 106);
				addOffset("singDOWN", 211);
				addOffset("scared");
	
				playAnim('idle');
			case 'expunged':
				// CELL MAD STAY MAD
				tex = Paths.getSparrowAtlas('characters/ExpungedFinal', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');
			case 'gay':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/shaggy', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'shaggy_idle', 24);
				animation.addByPrefix('idle2', 'shaggy_idle2', 24);
				animation.addByPrefix('singUP', 'shaggy_up', 20);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 20);
				animation.addByPrefix('singDOWN', 'shaggy_down', 24);
				animation.addByPrefix('singLEFT', 'shaggy_left', 24);
				animation.addByPrefix('catch', 'shaggy_catch', 30);
				animation.addByPrefix('hold', 'shaggy_hold', 30);
				animation.addByPrefix('h_half', 'shaggy_h_half', 30);
				animation.addByPrefix('fall', 'shaggy_fall', 30);
				animation.addByPrefix('kneel', 'shaggy_half_ground', 30);

				animation.addByPrefix('power', 'shaggy_powerup', 30);
				animation.addByPrefix('idle_s', 'shaggy_super_idle', 24);
				animation.addByPrefix('singUP_s', 'shaggy_sup2', 20);
				animation.addByPrefix('singRIGHT_s', 'shaggy_sright', 20);
				animation.addByPrefix('singDOWN_s', 'shaggy_sdown', 24);
				animation.addByPrefix('singLEFT_s', 'shaggy_sleft', 24);

				addOffset('idle');
				addOffset('idle2');
				addOffset("singUP", -6, 0);
				addOffset("singRIGHT", -20, -40);
				addOffset("singLEFT", 100, -120);
				addOffset("singDOWN", 0, -170);
				addOffset("catch", 140, 90);
				addOffset("hold", 90, 100);
				addOffset("h_half", 90, 0);
				addOffset("fall", 130, 0);
				addOffset("kneel", 110, -123);

				addOffset('idle_s');
				addOffset('power', 10, 0);
				addOffset("singUP_s", -6, 0);
				addOffset("singRIGHT_s", -20, -40);
				addOffset("singLEFT_s", 100, -120);
				addOffset("singDOWN_s", 0, -170);

				playAnim('idle');
			case 'garrett':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/garrett', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');

			case 'insanidave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/insanidave', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');
			case 'bamb-root':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/root_bamber', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');

			case 'ticking':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/ticking_dude', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');
			case 'garrett-mad':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/garrett_piss', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');

			case 'entityOne':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/algebraicaitrix', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("scared");
	
				playAnim('idle');

			case 'sart-producer-night':
				frames = Paths.getSparrowAtlas('characters/sart_producer');
				animation.addByPrefix('idle', 'idle', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}

				addOffset('idle', 300, 100);
				addOffset('singLEFT', 300, 100);
				addOffset('singDOWN', 300, 100);
				addOffset('singUP', 300, 100);
				addOffset('singRIGHT', 789, 100);


				setGraphicSize(811);
				updateHitbox();

				antialiasing = false;

				playAnim('idle');

			case 'dingle':
				tex = Paths.getSparrowAtlas('characters/dingle', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				addOffset('idle', 0, -200);
				addOffset("singUP", 0, -200);
				addOffset("singRIGHT", 0, -200);
				addOffset("singLEFT", 0, -200);
				addOffset("singDOWN", 0, -200);

				playAnim('idle');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST','shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets', 'shared');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets', 'shared');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar', 'shared');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle', 0, -100);
				addOffset("singUP", -20, -50);
				addOffset("singRIGHT", -51, -100);
				addOffset("singLEFT", -30, -100);
				addOffset("singDOWN", -30, -140);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/christmas/monsterChristmas', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'Fsby':
				tex = Paths.getSparrowAtlas('characters/ohungi', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				animation.addByPrefix('singUP-alt', 'alt-up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'alt-down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'alt-left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'alt-right', 24, false);
				addOffset('idle', nil, -500);
				addOffset("singUP", nil, -500);
				addOffset("singDOWN", nil, -500);
				addOffset("singLEFT", nil, -500);
				addOffset("singRIGHT", nil, -500);

				addOffset("singUP-alt", nil, -500);
				addOffset("singDOWN-alt", nil, -500);
				addOffset("singLEFT-alt", nil, -500);
				addOffset("singRIGHT-alt", nil, -500);
				
				

				playAnim('idle');

			case 'bamburg':
				// BADAI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bamburg', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
		
				addOffset('idle',878, -34);
				addOffset("singUP",449, 309);
				addOffset("singRIGHT",890, 320);
				addOffset("singLEFT",540,-150);
				addOffset("singDOWN",491, -207);
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');

			case 'badai':
				// BADAI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/badai', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BoyFriend_Cuphead', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance instance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP instance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT instance', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT instance', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN instance', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS instance', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS instance', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS instance', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS instance', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				charModelOffset = [414, 143];

				nativelyPlayable = true;

				addOffset('idle', -5);
				addOffset("singUP", -51, 57);
				addOffset("singRIGHT", -38, 0);
				addOffset("singLEFT", 23, -6);
				addOffset("singDOWN", -35, -37);
				addOffset("singUPmiss", -51, 57);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/christmas/bfChristmas', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/weeb/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/weeb/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/weeb/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/weeb/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('weeb/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, 0); //how doesthis work idont udnersstand
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -60, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/christmas/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle', -200, -150);
				addOffset("singUP", -247, -174);
				addOffset("singRIGHT", -201, -127);
				addOffset("singLEFT", -230, -66);
				addOffset("singDOWN", -231, -121);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
		}


		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);


		/*
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}
		/****/

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);

		if (animOffsets.exists(AnimName))
		{
			if (isPlayer)
			{
				if(!nativelyPlayable)
				{
					offset.set((daOffset[0] * -1) + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
				else
				{
					offset.set(daOffset[0] + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
			}
			else
			{
				if(nativelyPlayable)
				{
					offset.set((daOffset[0] * -1), daOffset[1]);
				}
				else
				{
					offset.set(daOffset[0], daOffset[1]);
				}
			}
		}
		else
		{
			offset.set(0, 0);
		}
			
			

		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
