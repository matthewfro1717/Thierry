package;

import AnimationDebugDad.AnimationDebugDad;
import mixins.AnimMixin;
import flixel.tweens.misc.AngleTween;
import aeroshide.StaticData;
import openfl.system.System;
import lime.system.System;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import Achievements;

#if windows
import Discord.DiscordClient;
#end
#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public var dadHealthBar:FlxColor = 0xFFFF0000;
	public var bfHealthBar:FlxColor = 0xFF00b3ff;
	var healthDrainBool:Bool;
	public var susussamongus:Bool;
	var stupidFuckingRedBg:FlxObject;

	public var leftInt:Int;
	public var downInt:Int;
	public var upInt:Int;
	public var rightInt:Int;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;
	public var shouldMuter:Bool = false;
	public var shouldMuterKeras:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	var aeroEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;
	public var bego:FlxSprite;

	private var dad:Character;
	private var surgarDaddy:Character;
	private var gwOppo:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	var doTrace:Bool = true;

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;
	public var UsingNewCam:Bool = false;
	var focusOnDadGlobal:Bool = true;
	private var camZooming:Bool = false;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var segitigaBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	public var pressedSEVEN:Bool;
	private var curSong:String = "";
	public var testshader:Shaders.GlitchEffect;

	var up:Bool;
	var right:Bool;
	var down:Bool;
	var left:Bool;

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	public var elapsedtime:Float = 0;
	public var gwwhatWidth:Int = 364;
	public var gwwhatHeight:Int = 357;
	public var thierrySiang:FlxSprite;
	public var boppersSpawned:Bool = false;
	public var elonMusk:Bool = false;
	public static var botPlay:Bool = false;
	public var maniaSong:Bool = false;
	private var botPlayState:FlxText;
	public var thierryChill:Bool = true;


	private var ss:Bool = false;
	private var doCoolAnim:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	public var secondBG:FlxSprite;
	public var width:Int;
	public var height:Int;
	public var twidth:Int;
	public var theight:Int;
	public var badaix:Int;
	public var badaiy:Int;

	public var judgementCounter:FlxText;
	var camdebug:Bool = false;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	public var dialogueEnd:Array<String> = null;


	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;
	public var dadStrums:FlxTypedGroup<FlxSprite>;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var scoreTxtTween:FlxTween;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var gwwhat:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var thierry:FlxSprite;
	var gw:FlxSprite;
	var achell:FlxSprite;
	var raditz:FlxSprite;
	var meksi:FlxSprite;
	var curbg:FlxSprite;
	public var forceDownscroll:Bool;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var vignetteShader:FlxSprite;
	var inCutscene:Bool = false;
	var usedTimeTravel:Bool;
	public var jancok:Bool;
	public var difficultSong:Bool;
	public var cheated:Bool = false;
	public var DespawnNotes:Bool = false;
	public var jancokKalian:Bool;
	public var gwHasBeenAdded:Bool = false;
	public static var repPresses:Int = 0;
	var blackScreen:FlxSprite;
	public static var repReleases:Int = 0;
	public var mati:Bool;
	public var accStatus:Int = 0;

	public var noteDiff:Float;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public var cameraAmplifierX:Int = 150;
	public var cameraAmplifierY:Int = 100;
	
	public var camAnchorX:Float;
	public var camAnchorY:Float;	

	public var bfCameraAmplifierX:Int = 100;
	public var bfCameraAmplifierY:Int = 100;
	
	public var bfCamAnchorX:Float;
	public var bfCamAnchorY:Float;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;

	private var executeModchart = false;

	// LUA SHIT
		
	public static var lua:State = null;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);

		if (getLuaErrorMessage(lua) != null)
			trace(func_name + ' LUA CALL ERROR ' + Lua.tostring(lua,result));

		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l,type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua,object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua,-1);
		Lua.pop(lua,1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'boyfriend':
				return boyfriend;
			case 'girlfriend':
				return gf;
			case 'dad':
				return dad;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
			return strumLineNotes.members[Std.parseInt(id)];
		return luaSprites.get(id);
	}

	public static var luaSprites:Map<String,FlxSprite> = [];



	function makeLuaSprite(spritePath:String,toBeCalled:String, drawBehind:Bool)
	{
		#if sys
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + PlayState.SONG.song.toLowerCase() + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
		{
			scale = 1;
		}

		sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled,sprite);
		// and I quote:
		// shitty layering but it works!
		if (drawBehind)
		{
			remove(gf);
			remove(boyfriend);
			remove(dad);
		}
		add(sprite);
		if (drawBehind)
		{
			add(gf);
			add(boyfriend);
			add(dad);
		}
		#end
		return toBeCalled;
	}

	// LUA SHIT

	override public function create()
	{
		StaticData.resetStaticData();
		botPlay = FlxG.save.data.botplay;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if sys
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nSTAGE : ' + curStage);
		
		switch (SONG.song)
		{
			case 'Captivity':
				preload('cellMad', 'Character');
			case 'chaos' | 'disarray':
				preload('gw-3d', 'FlxSprite');
				preload('parents-christmas', 'Character');
				preload('badai', 'Character');
			case 'segitiga':
				preload('bob', 'Character');
				preload('bf', 'Character');
			case 'meninggal':
				preload('pico', 'Character');
				preload('parents-christmas', 'Character');
				preload('meksi', 'FlxSprite');
				preload('achel', 'FlxSprite');
				preload('radit', 'FlxSprite');

		}


		switch (SONG.song.toLowerCase())
		{
			case 'ded':
				dialogue = CoolUtil.coolTextFile(Paths.txt('ded/dialog'));
			case 'anjing':
				dialogue = CoolUtil.coolTextFile(Paths.txt('anjing/dialog'));
			case 'meninggal':
				dialogue = CoolUtil.coolTextFile(Paths.txt('meninggal/dialog'));

			case 'gerselo':
				dialogue = CoolUtil.coolTextFile(Paths.txt('gerselo/dialog'));
			case 'get-out':
				dialogue = CoolUtil.coolTextFile(Paths.txt('get-out/dialog'));
			case 'run':
				dialogue = CoolUtil.coolTextFile(Paths.txt('run/dialog'));
			case 'latihan':
				dialogue = CoolUtil.coolTextFile(Paths.txt('latihan/dialog'));
			case 'roasting':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roasting/dialog'));
			case 'segitiga':
				dialogue = CoolUtil.coolTextFile(Paths.txt('segitiga/dialog'));
			case 'revenge':
				if (StaticData.gotBadEnding)
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('revenge/baddialog'));
				}
				else
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('revenge/dialog'));
				}
				
			case 'gerlad':
				dialogue = CoolUtil.coolTextFile(Paths.txt('gerlad/dialog'));

			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		//IF YOURE CONFUSED ABOUT X,Y COORD HERES A TIP FOR YA:
		//Y: UP IS NEGATIVE | DOWN IS POSITIVE
		//X: LEFT IS NEGATIVE | RIGHT IS POSITIVE

		switch(SONG.song.toLowerCase())
		{
			case 'cheat-blitar' | 'purgatory' | 'nether' | 'brutal' | 'hellbreaker' | 'lacuna':
				difficultSong = true;
		}
		//NEW CAM IS NOW MANDATORY AS LEGACY CAM IS NO LONGER SUPPORTED
		UsingNewCam = FlxG.save.data.cameraMov;

		switch(SONG.song.toLowerCase())
		{
			case 'confronting-yourself' | 'termination' | 'ghost' | 'nacreous-snowmelt', 'velmas-spam-challenge':
				curStage = 'dumbshit';
				maniaSong = true;

				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

			case 'purgatory' | 'torment' | 'brutal' | 'nether' | 'hellbreaker': 
			{
				curStage = 'sekolahDPee'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				
				if (SONG.song == 'Nether')
				{
					defaultCamZoom = 4;
				}
				else
				{
					defaultCamZoom = 0.9;
				}

				stupidFuckingRedBg = new FlxSprite().makeGraphic(9999, 9999, FlxColor.fromRGB(42, 0, 0)).screenCenter();
				stupidFuckingRedBg.visible = false;
				var bg:FlxSprite = new FlxSprite(-700, -200).loadGraphic(Paths.image('fucked'));
				bg.setGraphicSize(3840, 2160);
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				add(bg);
				//UsingNewCam = true;

				secondBG = new FlxSprite(-700, -200).loadGraphic(Paths.image('anjayB'));
				secondBG.visible = false;
				secondBG.setGraphicSize(0, 0);
				add(stupidFuckingRedBg);
				add(secondBG);

				thierry = new FlxSprite(-100, 120).loadGraphic(Paths.image('thierry_FinalForm'));
				thierry.setGraphicSize(720, 720);
				thierry.antialiasing = true;
				thierry.scrollFactor.set(1, 1);
				if (SONG.song == 'brutal')
				{
					thierry.visible = false;	
				}
				else
				{
					thierry.visible = true;
				}
				
				thierry.flipX = true;
				add(thierry);

				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			}
			case 'glitcher' | 'meninggal' | 'cut1' | 'five-nights' | 'unturned': 
			{
				curStage = 'sekolahMalam'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS

				if (SONG.song == 'Unturned') {health = 0.01;}

				//UsingNewCam = true;
				defaultCamZoom = 0.9;
				bego = new FlxSprite(-600, -200).loadGraphic(Paths.image('stagemalem'));
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = false;
				add(bego);

				thierry = new FlxSprite(-100, 400).loadGraphic(Paths.image('Thieri'));
				thierry.setGraphicSize(200, 300);
				thierry.antialiasing = true;
				thierry.scrollFactor.set(1, 1);
				thierry.visible = false;


				thierrySiang = new FlxSprite(250, 250).loadGraphic(Paths.image('Thieri'));
				thierrySiang.setGraphicSize(200, 300);
				thierrySiang.antialiasing = true;
				thierrySiang.scrollFactor.set(1, 1);
				thierrySiang.visible = false;

				raditz = new FlxSprite(1250, 250).loadGraphic(Paths.image('radit'));
				raditz.setGraphicSize(300, 400);
				raditz.antialiasing = true;
				raditz.scrollFactor.set(1, 1);
				raditz.visible = false;

				meksi = new FlxSprite(850, 250).loadGraphic(Paths.image('meksi'));
				meksi.setGraphicSize(300, 400);
				meksi.antialiasing = true;
				meksi.scrollFactor.set(1, 1);
				meksi.visible = false;

				achell = new FlxSprite(-250, 490).loadGraphic(Paths.image('achel'));
				achell.setGraphicSize(255, 355);
				achell.antialiasing = true;
				achell.scrollFactor.set(1, 1);//stage code lmafo
				achell.visible = false;
				
	
				gw = new FlxSprite(-100, 220).loadGraphic(Paths.image('gw'));
				gw.setGraphicSize(120, 120);
				gw.antialiasing = true;
				gw.scrollFactor.set(1, 1);
				gw.visible = false;
				gw.flipX = true;
				if (SONG.song == "meninggal")
				{
					add(gw);
					add(meksi);
					add(achell);
					add(raditz);
					add(thierrySiang);
					add(thierry);
					thierry.visible = true;
					//UsingNewCam = true;
				}

	
				gw = new FlxSprite(0, 450).loadGraphic(Paths.image('gw'));
				gw.antialiasing = true;
				gw.scrollFactor.set(1, 1);
				gw.visible = false;
				gw.flipX = true;
				add(gw);
			}
			/**case '1': 
			{
				curStage = 'sekolahMalamB'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
	
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stagemalem'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
				var thierry:FlxSprite = new FlxSprite(-100, 400).loadGraphic(Paths.image('Thieri'));
				thierry.antialiasing = true;
				thierry.scrollFactor.set(1, 1);
				thierry.active = false;
				add(thierry);
			}
			case 'kont': 
			{
				curStage = 'sekolahMalamC'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stagemalem'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
				var gw:FlxSprite = new FlxSprite(-100, 400).loadGraphic(Paths.image('gw'));
				gw.antialiasing = true;
				gw.scrollFactor.set(1, 1);
				gw.active = false;
				add(gw);
			}/****/
			case 'anjing': 
			{
				curStage = 'sekolahSore'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
	
				defaultCamZoom = 0.9;
				bego = new FlxSprite(-700, -200).loadGraphic(Paths.image('stagesore'));
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = false;
				add(bego);


			}

			case 'cheat-blitar': 
			{
				curStage = 'sekolahDP'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-700, -200).loadGraphic(Paths.image('hellstage'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				add(bg);
				//UsingNewCam = true;

				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			}

			case 'segitiga': 
			{
				curStage = 'sekolahSky'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('langit'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				bg.scale.set(1.4, 1.4);
				add(bg);
				//UsingNewCam = true;

				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			}

			case 'decimal': 
			{
				curStage = 'ohungi'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-700, -400).loadGraphic(Paths.image('ohungi-skybox'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				add(bg);

				var tnh:FlxSprite = new FlxSprite(-1000, 200).loadGraphic(Paths.image('ohungi-ground'));
				tnh.antialiasing = true;
				tnh.scrollFactor.set(0.9, 0.9);
				tnh.active = true;
				add(tnh);
				//UsingNewCam = true;

				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			}

			case 'trigometry' | 'wraith' | 'serpent': 
			{
				curStage = 'sekolahDPButCool'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-700, -200).loadGraphic(Paths.image('redsky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				add(bg);
				//UsingNewCam = true;

				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bg.shader = testshader.shader;
				curbg = bg;
			}

			case 'cuberoot': 
			{
				curStage = 'sekolahDPButCool'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				bego = new FlxSprite(-700, -200).loadGraphic(Paths.image('cuberoot'));
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = true;
				add(bego);
				//UsingNewCam = true;

				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bego.shader = testshader.shader;
				curbg = bego;
			}

			case 'ascension': 
			{
				curStage = 'Heaven'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('pobbob'));
				bg.setGraphicSize(3840, 2160);
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				add(bg);




				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 1;
				bg.shader = testshader.shader;
				curbg = bg;
			}

			case 'chaos' | 'disarray' | 'rush' | 'hyperactivity' | 'brute':
				curStage = 'worldeater'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
		
				defaultCamZoom = 0.9;
				if (SONG.song == 'Rush' || SONG.song == 'Hyperactivity' || SONG.song == 'Brute')
				{
					defaultCamZoom = 0.5;
				}
				stupidFuckingRedBg = new FlxSprite().makeGraphic(9999, 9999, FlxColor.fromRGB(42, 0, 0)).screenCenter();
				bego = new FlxSprite(-300, -200).loadGraphic(Paths.image('anjay'));
				bego.setGraphicSize(2048, 2048);
				
				

				
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = true;
				add(stupidFuckingRedBg);
				add(bego);
				add(secondBG);
				
				
				//UsingNewCam = true;

			case 'applecore': 
			{
				curStage = 'sekolahMaxzi'; //ADD JANGKRIK SOUND AMBIENCE FOR LIKE CHANGING SCENES, UDE THWAW AWESOME!! EXCEPT FOR THE FIRST ONE, KEEP IT AS AMOGUS
			
				defaultCamZoom = 0.9;
				bego = new FlxSprite(-700, -200).loadGraphic(Paths.image('greenstage'));
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = true;
				add(bego);
	
				//LMAO LITTERALLY STOLEN CODE FROM VSDAVE
				testshader = new Shaders.GlitchEffect();
				testshader.waveAmplitude = 0.1;
				testshader.waveFrequency = 4;
				testshader.waveSpeed = 2;
				bego.shader = testshader.shader;
				curbg = bego;

				thierry = new FlxSprite(-100, 0).loadGraphic(Paths.image('Thieri'));
				thierry.antialiasing = true;
				thierry.scrollFactor.set(1, 1);
				thierry.visible = false;
				if (SONG.song == "meninggal")
				{
					thierry.visible = true;
				}
				
				add(thierry);
			}
			case 'deformation': 
			{
				curStage = 'Serem';
				var defX:Int = -600;
				var defY:Int = 600;
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(defX, defY).loadGraphic(Paths.image('cave/front'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var bgtoo:FlxSprite = new FlxSprite(defX, defY).loadGraphic(Paths.image('cave/mid'));
				bgtoo.antialiasing = true;
				bgtoo.scrollFactor.set(0.9, 0.9);
				bgtoo.active = false;
				add(bgtoo);

				var bgthree:FlxSprite = new FlxSprite(defX, defY).loadGraphic(Paths.image('cave/back'));
				bgthree.antialiasing = true;
				bgthree.scrollFactor.set(0.9, 0.9);
				bgthree.active = false;
				add(bgthree);
			}

			case 'captivity': 
			{
				curStage = 'Jail';
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, 200).loadGraphic(Paths.image('jail/room'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				bego = new FlxSprite(-150, 865).loadGraphic(Paths.image('jail/desk'));
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = false;
				

			}

			case 'ticking': 
			{
				curStage = 'idunno';
		
				defaultCamZoom = 0.5;
				var bg:FlxSprite = new FlxSprite(200, 200).loadGraphic(Paths.image('dna/gunkk'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.scale.set(2.4, 2.4);
				add(bg);

				bego = new FlxSprite(200, 150);
				bego.frames = Paths.getSparrowAtlas('dna/ticking_tunnel');
				bego.animation.addByPrefix('spin', 'TUNNEL');
				bego.antialiasing = true;
				bego.scrollFactor.set(0.9, 0.9);
				bego.active = false;
				bego.scale.set(2, 2);
				add(bego);
				bego.animation.play('spin', true);
				

			}

			case 'roasting' | 'gerselo' | 'cut2': 
			{
				curStage = 'sekolahTapiBeda';
		
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('stagebelakang'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
			}
			case 'get-out' | 'revenge' | 'latihan' | 'bonus-song' | 'gerlad' | 'los-angeles' | 'copy-cat': 
			{
				curStage = 'sekolahTapiDepan';
			
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('stagedepan'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				thierry = new FlxSprite(250, 250).loadGraphic(Paths.image('Thieri'));
				thierry.setGraphicSize(200, 300);
				thierry.antialiasing = true;
				thierry.scrollFactor.set(1, 1);
				thierry.visible = true;

				raditz = new FlxSprite(1250, 250).loadGraphic(Paths.image('radit'));
				raditz.setGraphicSize(300, 400);
				raditz.antialiasing = true;
				raditz.scrollFactor.set(1, 1);
				raditz.visible = true;

				meksi = new FlxSprite(850, 100).loadGraphic(Paths.image('meksi'));
				meksi.setGraphicSize(300, 400);
				meksi.antialiasing = true;
				meksi.scrollFactor.set(1, 1);
				meksi.visible = true;

				achell = new FlxSprite(-250, 490).loadGraphic(Paths.image('achel'));
				achell.setGraphicSize(255, 355);
				achell.antialiasing = true;
				achell.scrollFactor.set(1, 1);//stage code lmafo
				achell.visible = true;
				
	
				gw = new FlxSprite(-100, 220).loadGraphic(Paths.image('gw'));
				gw.setGraphicSize(120, 120);
				gw.antialiasing = true;
				gw.scrollFactor.set(1, 1);
				gw.visible = true;
				gw.flipX = true;
				if (SONG.song == 'copy-cat')
				{
					//UsingNewCam = true;
				}
				if (SONG.song == 'gerlad')
				{
					bg.y -= 100;
					bg.x += 200;
					add(thierry);
					add(achell);
					add(meksi);
					add(raditz);
					add(gw);
				}

			}
			case 'ferocious': 
			{
				curStage = 'sekolahTapiFO';
			
				defaultCamZoom = 0.8;
				var bg:FlxSprite = new FlxSprite(-450, -250).loadGraphic(Paths.image('ferocious/FO'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.scale.set(1.4 ,1.4);
				bg.updateHitbox();
				add(bg);

				
				

			}
			case 'pico' | 'blammed' | 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

						var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					add(streetBehind);

						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					add(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
						add(street);
			}
			case 'milf' | 'satin-panties' | 'high':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);
			}
			case 'cocoa' | 'eggnog':
			{
						curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					add(santa);
			}
			case 'winter-horrorland':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'senpai' | 'roses':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
						{
							bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
			}
			case 'thorns':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
						var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			default:
			{
					//UsingNewCam = true;
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		if (boyfriend.curCharacter == '3d-bf' || boyfriend.curCharacter == 'tunnel-bf' || boyfriend.curCharacter == 'bf-fps')
		{
			StaticData.using3DEngine = true;
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		if (SONG.song == 'gerlad')
		{
			camPos = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
		}

		switch(boyfriend.curCharacter) // for camera offsets
		{
			case 'bf':
				bfCameraAmplifierX += 500;
			case 'tunnel-bf':
				bfCameraAmplifierY += 250;
				bfCameraAmplifierY -= 250;
		}

		switch(dad.curCharacter)
		{
			case 'gay':
				cameraAmplifierX -= 300;
			case 'Fsby':
				cameraAmplifierX -= 75;
			case 'dave':
				cameraAmplifierY -= 150;
			case 'cell':
				cameraAmplifierY += 150;
			case 'dingle':
				cameraAmplifierY -= 150;
			case 'mmm':
				cameraAmplifierY -= 150;
		}


		if (StaticData.using3DEngine || maniaSong || SONG.song == 'Ticking' || SONG.song == 'Cuberoot')
		{
			trace('event called, gf is deleted');
			gf.visible = false;
		}

		//PRE-SONG EVENTS
		switch(SONG.song.toLowerCase())
		{
			case 'captivity':
				boyfriend.visible = false;
				StaticData.bfExists = false;
			case 'deformation':
				StaticData.bfExists = false;
				


		}

		if (SONG.song == 'decimal' || SONG.song == 'Decimal')
		{
			dad.scale.set(1.6, 1.6);
		}

		if (SONG.song == 'Rush' || SONG.song == 'Hyperactivity' || SONG.song == 'Brute')
		{
			dad.x -= 420;
		}

		switch (SONG.player2)
		{
			case 'garrett':
				dad.x -= 300;
			case 'cell':
				dad.y += 390;
				dad.x -= 40;

			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);

			case 'fake':
				dad.x -= 120;
				camPos.set(dad.getGraphicMidpoint().y - 200);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bob':
				trace(dad.getGraphicMidpoint().x + dad.getGraphicMidpoint().y);
				camPos.set(dad.getGraphicMidpoint().x);
			case 'gw-3d':
				camPos.set(dad.getGraphicMidpoint().y);
			case 'thierry-mad':
				camPos.set(dad.getGraphicMidpoint().y);
				dad.x -= 150;
			case 'gerlad':
				camPos.set(dad.getGraphicMidpoint().y - 500);
		}


		// REPOSITIONING PER SOMEONE
		switch (boyfriend.curCharacter)
		{
			case 'ron':
				boyfriend.y -= 100;
				boyfriend.x += 150;
			case 'tunnel-bf':
				boyfriend.y -= 250;
				boyfriend.x += 250;
		}
		

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'idunno':
				boyfriend.x += 600;
			case 'dumbshit':
				boyfriend.y -= 120;
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		if (SONG.song == 'Captivity') 
			add(bego); // so this layer is higher than dad.
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;


		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		dadStrums = new FlxTypedGroup<FlxSprite>();

		var splash:NoteSplash = new NoteSplash(1000, 1000, 0);
		grpNoteSplashes.add(splash);

		// startCountdown();

		generateSong(SONG.song);

		if (FlxG.sound.music.time != 0)
			{
				var toBeRemoved = [];
				for (i in 0...unspawnNotes.length)
				{
					var dunceNote:Note = unspawnNotes[i];
	
					if (dunceNote.strumTime <= FlxG.sound.music.time)
						toBeRemoved.push(dunceNote);
				}
	
				for (i in toBeRemoved)
					unspawnNotes.remove(i);
	
			}

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		//that does the actual camera change and NOT follow
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 80;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		switch (SONG.song)
		{
			case "ded" | "anjing" | "revenge" | "run" | "screw-you" | "get-out":
				dadHealthBar = 0xFFffff52;
			case "meninggal" | "bonus-song":
				dadHealthBar = 0xFFe30227;
			case "chaos" | "segitiga" | "disarray":
				dadHealthBar = 0xFFda8282;
			case "roasting" | "gerselo":
				dadHealthBar = 0xFF4b6448;
			case "gerlad":
				dadHealthBar = 0xFFdbc9b7;
			case "AppleCore":
				dadHealthBar = 0xFF653537;
			case "ram" | "glitcher":
				dadHealthBar = 0xFF4ef4e9;
			case "final-showdown" | "latihan":
				dadHealthBar = 0xFFff8b00;
		}
		healthBar.createFilledBar(dadHealthBar, bfHealthBar); //the magic shit
		// healthBar
		add(healthBar);
			
		// Aeroshide engine watermark for segitiga
		aeroEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + "" + (Main.watermarks ? " - Aeroshide Engine (3D ENGINE)" + MainMenuState.kadeEngineVer : ""), 16);
		aeroEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		aeroEngineWatermark.scrollFactor.set();		
		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (Main.watermarks ? " - Thierry Engine (KE 1.4.2)" + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();

		if (StaticData.using3DEngine)
		{
			add(aeroEngineWatermark);
		}
		else if (SONG.song == 'chaos' || SONG.song == 'disarray')
		{
			aeroEngineWatermark.text = SONG.song + " " + "3 DIMENSION" + (Main.watermarks ? " - Aeroshide Engine (3D THREADED ENGINE)" + MainMenuState.kadeEngineVer : "");
			add(aeroEngineWatermark);
		}
		else if (SONG.song == 'confronting-yourself')
		{
			kadeEngineWatermark.text = "Original song by Penguin 123-452";
			add(kadeEngineWatermark);
		}
		else
		{
			add(kadeEngineWatermark);

		}



		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.screenCenter(X);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		scoreTxt.scrollFactor.set();
		scoreTxt.screenCenter(X);
		if (offsetTesting)
			scoreTxt.screenCenter(X);
		
		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.scrollFactor.set();
		judgementCounter.cameras = [camHUD];
		judgementCounter.screenCenter(Y);
		judgementCounter.y -= 200;
		judgementCounter.text = 'Rendered notes : ${notes.length}\n\n\n\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}';
		judgementCounter.visible = false;
		add(judgementCounter);

		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0,
		"BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		botPlayState.cameras = [camHUD];
		botPlayState.visible = false;
		add(botPlayState);
			

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			{
				add(replayTxt);
			}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false); // okay so i have a theory that this is how to you change healthicon mid song
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		add(scoreTxt);


		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		judgementCounter.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (StaticData.using3DEngine)
		{
			// Aeroshide engine watermark for segitiga
			aeroEngineWatermark.cameras = [camHUD];
		}
		else
		{
			// Add Kade Engine watermark
			kadeEngineWatermark.cameras = [camHUD];
	
		}
		
		
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'anjing' | 'segitiga' | 'gerlad':
					schoolIntro(doof);
				case 'meninggal':
					schoolIntro(doof);
				case 'gerselo':
					schoolIntro(doof);
				case 'ded':
					schoolIntro(doof);// TODO : ADD MENINGGAL DIALOG, CUS THERES NONE (FUTURE ME : LATER IDIOT)
				case 'roasting':
					schoolIntro(doof);
				case 'get-out':
					schoolIntro(doof);
				case 'revenge':
					schoolIntro(doof);
				case 'latihan':
					schoolIntro(doof);
				case 'cut0':
					schoolIntro(doof);
				case 'cut1':
					schoolIntro(doof);
				case 'cut2':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		if (executeModchart) // dude I hate lua (jkjkjkjk)
			{
				trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace("Lua version: " + Lua.version());
				trace("LuaJIT version: " + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				var result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart")); // execute le file
	
				if (result != 0)
					trace('COMPILE ERROR\n' + getLuaErrorMessage(lua));

				// get some fukin globals up in here bois
	
				setVar("bpm", Conductor.bpm);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", FlxG.save.data.downscroll);
	
				setVar("curStep", 0);
				setVar("curBeat", 0);
	
				setVar("hudZoom", camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", camHUD.angle);
	
				setVar("followXOffset",0);
				setVar("followYOffset",0);
	
				setVar("showOnlyStrums", false);
				setVar("strumLine1Visible", true);
				setVar("strumLine2Visible", true);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("hudWidth", camHUD.width);
				setVar("hudHeight", camHUD.height);
	
				// callbacks
	
				// sprites
	
				trace(Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite));
	
				Lua_helper.add_callback(lua,"destroySprite", function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					remove(sprite);
					return true;
				});
	
				// hud/camera
	
				trace(Lua_helper.add_callback(lua,"setHudPosition", function (x:Int, y:Int) {
					camHUD.x = x;
					camHUD.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudX", function () {
					return camHUD.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudY", function () {
					return camHUD.y;
				}));
				
				trace(Lua_helper.add_callback(lua,"setCamPosition", function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraX", function () {
					return FlxG.camera.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraY", function () {
					return FlxG.camera.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setCamZoom", function(zoomAmount:Float) {
					FlxG.camera.zoom = zoomAmount;
				}));
	
				trace(Lua_helper.add_callback(lua,"setHudZoom", function(zoomAmount:Float) {
					camHUD.zoom = zoomAmount;
				}));
	
				// actors
				/*
				trace(Lua_helper.add_callback(lua,"getRenderedNotes", function() {
					return notes.length;
				}));
	

				
				trace(Lua_helper.add_callback(lua,"getRenderedNoteX", function(id:Int) {
					return notes.members[id].x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteY", function(id:Int) {
					return notes.members[id].y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleX", function(id:Int) {
					return notes.members[id].scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleY", function(id:Int) {
					return notes.members[id].scale.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteAlpha", function(id:Int) {
					return notes.members[id].alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNotePos", function(x:Int,y:Int, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].x = x;
					notes.members[id].y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteAlpha", function(alpha:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].setGraphicSize(Std.int(notes.members[id].width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleX", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleY", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.y = scale;
				}));

				/****/
	
				trace(Lua_helper.add_callback(lua,"setActorX", function(x:Int,id:String) {
					getActorByName(id).x = x;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorAlpha", function(alpha:Int,id:String) {
					getActorByName(id).alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorY", function(y:Int,id:String) {
					getActorByName(id).y = y;
				}));
							
				trace(Lua_helper.add_callback(lua,"setActorAngle", function(angle:Int,id:String) {
					getActorByName(id).angle = angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScale", function(scale:Float,id:String) {
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleX", function(scale:Float,id:String) {
					getActorByName(id).scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleY", function(scale:Float,id:String) {
					getActorByName(id).scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorWidth", function (id:String) {
					return getActorByName(id).width;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorHeight", function (id:String) {
					return getActorByName(id).height;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAlpha", function(id:String) {
					return getActorByName(id).alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAngle", function(id:String) {
					return getActorByName(id).angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorX", function (id:String) {
					return getActorByName(id).x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorY", function (id:String) {
					return getActorByName(id).y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleX", function (id:String) {
					return getActorByName(id).scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleY", function (id:String) {
					return getActorByName(id).scale.y;
				}));
	
				// tweens
				
				Lua_helper.add_callback(lua,"tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeIn", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeOut", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				for (i in 0...strumLineNotes.length) {
					var member = strumLineNotes.members[i];
					trace(strumLineNotes.members[i].x + " " + strumLineNotes.members[i].y + " " + strumLineNotes.members[i].angle + " | strum" + i);
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
					trace("Adding strum" + i);
				}
	
				trace('calling start function');
	
				trace('return: ' + Lua.tostring(lua,callLua('start', [PlayState.SONG.song])));
			}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			if (!StaticData.using3DEngine)
			{
				boyfriend.playAnim('idle');
			}
			

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			if (SONG.song.toLowerCase() == 'cut2' || SONG.song.toLowerCase() == 'cut0' || SONG.song.toLowerCase() == 'cut1')
			{
				endSong();
			}
			else
			{
				introAssets.set('default', ['ready', "set", "go"]);
				introAssets.set('school', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);
				introAssets.set('schoolEvil', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);

				var introAlts:Array<String> = introAssets.get('default');
				var altSuffix:String = "";
	
				for (value in introAssets.keys())
				{
					if (value == curStage)
					{
						introAlts = introAssets.get(value);
						altSuffix = '-pixel';
					}
				}

				switch (swagCounter)

				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					case 1:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						ready.scrollFactor.set();
						ready.updateHitbox();
	
						if (curStage.startsWith('school'))
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
	
						ready.screenCenter();
						add(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
					case 2:
						var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						set.scrollFactor.set();
	
						if (curStage.startsWith('school'))
							set.setGraphicSize(Std.int(set.width * daPixelZoom));
	
						set.screenCenter();
						add(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
					case 3:
						var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						go.scrollFactor.set();
	
						if (curStage.startsWith('school'))
							go.setGraphicSize(Std.int(go.width * daPixelZoom));
	
						go.updateHitbox();
	
						go.screenCenter();
						add(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
					case 4:
			}
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	public var bar:FlxSprite;
	public static var songMultiplier = 1.0;
	


	var songStarted = false;

	function startSong():Void
	{
		trace(curStage);
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (SONG.song == 'meninggal')
		{
			StaticData.isAllowedToBop = true;
			healthDrainBool = true;
		}

		var splash:FlxSprite = new FlxSprite(0, 0);
		splash.frames = Paths.getSparrowAtlas('notesplash');
		splash.animation.addByPrefix('4', 'purple splash', 24, false);
		splash.animation.addByPrefix('5', 'blue splash', 24, false);
		splash.animation.addByPrefix('6', 'green splash', 24, false);
		splash.animation.addByPrefix('7', 'red splash', 24, false);
		splash.animation.finishCallback = function(lol:String)
		{
			remove(splash);
		}
		add(splash);
		splash.visible = false;
		splash.animation.play('4');

		if (SONG.song == 'Ascension')
		{
			health = 168574;
		}

		if (SONG.song == 'cheat-blitar')
		{
			health = 2;
			canPause = false;
		}
		else if (SONG.song == 'confronting-yourself')
		{
			canPause = false;
		}

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = (FlxG.sound.music.length / 1000);

		if (FlxG.save.data.songPosition)
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 

			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			songPosBar = new FlxBar(690 - (Std.int(songPosBG.width - 100) / 2), songPosBG.y + 6, LEFT_TO_RIGHT, Std.int(songPosBG.width - 200),
			Std.int(songPosBG.height - 2), this, 'songPositionBar', 0, songLength);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.fromRGB(255, 255, 255));
			add(songPosBar);

			bar = new FlxSprite(songPosBar.x, songPosBar.y).makeGraphic(Math.floor(songPosBar.width), Math.floor(songPosBar.height), FlxColor.TRANSPARENT);

			add(bar);

			FlxSpriteUtil.drawRect(bar, 0, 0, songPosBar.width, songPosBar.height, FlxColor.TRANSPARENT, {thickness: 6, color: FlxColor.BLACK});

			songPosBG.width = songPosBar.width;

			songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y - 15, 0, SONG.song, 16);
			songName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();

			songName.text = FlxStringUtil.formatTime(songLength, false);
			songName.y = songPosBG.y + ((songPosBG.height / 32) - 4);

			add(songName);

			songName.screenCenter(X);
			//songName.x += 15;

			songPosBG.cameras = [camHUD];
			bar.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		vignetteShader = new FlxSprite().loadGraphic(Paths.image('jail/vig_red'));
		vignetteShader.antialiasing = true;
		vignetteShader.scrollFactor.set(0.9, 0.9);
		vignetteShader.visible = false;
		add(vignetteShader);

		vignetteShader.cameras = [camHUD];
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		for(i in 0...unspawnNotes.length)
			if (unspawnNotes[i].strumTime < FlxG.sound.music.time)
				unspawnNotes.remove(unspawnNotes[i]);
	}

	var debugNum:Int = 0;
	

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());



		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		/*if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 

			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8),
			'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.fromRGB(0, 255, 128));
			add(songPosBar);

			bar = new FlxSprite(songPosBar.x, songPosBar.y).makeGraphic(Math.floor(songPosBar.width), Math.floor(songPosBar.height), FlxColor.TRANSPARENT);

			add(bar);

			FlxSpriteUtil.drawRect(bar, 0, 0, songPosBar.width, songPosBar.height, FlxColor.TRANSPARENT, {thickness: 4, color: FlxColor.BLACK});

			songPosBG.width = songPosBar.width;

			songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y - 15, 0, SONG.song, 16);
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();

			songName.text = SONG.song + ' (' + FlxStringUtil.formatTime(songLength, false) + ')';
			songName.y = songPosBG.y + (songPosBG.height / 3);

			add(songName);

			songName.screenCenter(X);

			songPosBG.cameras = [camHUD];
			bar.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}/****/

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if desktop
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			if (GlitchedMainMenu.fromCheaterEnding)
			{
				// no
			}
			else
			{
				for(file in sys.FileSystem.readDirectory(songPath))
					{
						var path = haxe.io.Path.join([songPath, file]);
						if(!sys.FileSystem.isDirectory(path))
						{
							if(path.endsWith('.offset'))
							{
								trace('Found offset file: ' + path);
								songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
								break;
							}else {
								trace('Offset file not found. Creating one @: ' + songPath);
								sys.io.File.saveContent(songPath + songOffset + '.offset', '');
							}
						}
					}
			}
			
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daNoteStyle);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		if (boyfriend.curCharacter == 'tunnel-bf')
		{
			iconP1.flipX = true;
			boyfriend.scale.set(0.8, 0.8);
		}

		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (StaticData.using3DEngine)
			{
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_3D');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

				babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

				switch (Math.abs(i))
				{
					case 0:
						babyArrow.x += Note.swagWidth * 0;
						babyArrow.animation.addByPrefix('static', 'arrowLEFT');
						babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						babyArrow.x += Note.swagWidth * 1;
						babyArrow.animation.addByPrefix('static', 'arrowDOWN');
						babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						babyArrow.x += Note.swagWidth * 2;
						babyArrow.animation.addByPrefix('static', 'arrowUP');
						babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						babyArrow.x += Note.swagWidth * 3;
						babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
						babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			}
			else
			{
				switch (curStage)
				{
					default:
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
				}
			}

			

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			if (maniaSong)
			{
				babyArrow.x += 50;
			}
			else
			{
				babyArrow.x += 95;
			}
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function generateTimings():String
		{
			var ranking:String = "N/A";
	
			if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
				ranking = "- MFC";
			else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
				ranking = "- GFC";
			else if (misses == 0) // Regular FC
				ranking = "- FC";
			else if (misses < 10) // Single Digit Combo Breaks
				ranking = "- SDCB";
			else if (misses < 100) // Double Digit Combo Breaks
				ranking = "- DDCB";
			else
				ranking = "- Skill Issue";

			return ranking;
		}

	function generateWife():String
		{
			var wife:String = "N/A";

			var wifeConditions:Array<Bool> = [
				accuracy >= 99.9935, // Perfect!! (Aimed for 100%)
				accuracy > 99.50,
				accuracy >= 90, // Sick! (self explanatory)
				accuracy >= 85, // Great
				accuracy >= 80, // Good
				accuracy >= 70, // Okay
				accuracy >= 65, // Goblok
				accuracy <= 65 // Skill Issue
			];
	
			for(i in 0...wifeConditions.length)
			{
				var b = wifeConditions[i];
				if (b)
				{
					switch(i)
					{
						case 0:
							wife = "Perfect!!";
							accStatus = 0;
						case 1:
							wife = "Sick!";
							accStatus = 2;
						case 2:
							wife = "Sick!";
							accStatus = 0;
						case 3:
							wife = "Great";
							accStatus = 0;
						case 4:
							wife = "Good";
							accStatus = 0;
						case 5:
							wife = "Okay";
							accStatus = 0;
						case 6:
							wife = "Goblok";
							accStatus = 0;
						case 7:
							wife = "Skill Issue";
							accStatus = 0;
					}
					break;
				}
			}
	
			if (accuracy == 0)
				wife = "N/A";
	
			return wife;
		}

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}


	function generateRanking():String
	{
		var rankingandwife:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			rankingandwife = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			rankingandwife = "(GFC)";
		else if (misses == 0) // Regular FC
			rankingandwife = "(FC)";
		else if (misses < 10) // Single Digit Combo Breaks
			rankingandwife = "(SDCB)";
		else if (misses < 100) // Double Digit Combo Breaks
			rankingandwife = "(DDCB)";
		else
			rankingandwife = "(Goblok)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy >= 55, // D
			accuracy < 54 // stupid
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 0:
						rankingandwife += " AAAAA";
					case 1:
						rankingandwife += " AAAA:";
					case 2:
						rankingandwife += " AAAA.";
					case 3:
						rankingandwife += " AAAA";
					case 4:
						rankingandwife += " AAA:";
					case 5:
						rankingandwife += " AAA.";
					case 6:
						rankingandwife += " AAA";
					case 7:
						rankingandwife += " AA:";
					case 8:
						rankingandwife += " AA.";
					case 9:
						rankingandwife += " AA";
					case 10:
						rankingandwife += " A:";
					case 11:
						rankingandwife += " A.";
					case 12:
						rankingandwife += " A";
					case 13:
						rankingandwife += " B";
					case 14:
						rankingandwife += " C";
					case 15:
						rankingandwife += " D";
					case 16:
						rankingandwife += " Goblok!";
				}
				break;
			}
		}

		if (accuracy == 0)
			rankingandwife = "N/A";

		return rankingandwife;
	}

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		FlxG.mouse.visible = false;
		#if !debug
		FlxG.save.data.kebal = false;
		#end

		if (unspawnNotes[0] != null)
			{
				var time:Float = 3000;//shit be werid on 4:3 // pogger
	
				while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
				{
					var dunceNote:Note = unspawnNotes[0];
					notes.insert(0, dunceNote);
	
					var index:Int = unspawnNotes.indexOf(dunceNote);
					unspawnNotes.splice(index, 1);
				}
			}

		judgementCounter.visible = StaticData.debugMenu;
		judgementCounter.text = 'Alpha 1.1 - Aeroshide Engine (KadeEngine 1.4.2/Modded)\nRendered notes : ${notes.length}\n\n\n\nTotal Notes Hit: ${totalNotesHit}\nHit Combo: ${combo}\n\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits} 
		\n\nInput nodes : ${left} ${down} ${up} ${right}\n\n\nBeat : ${curBeat}\nStep : ${curStep}\nBPM : ${Conductor.bpm}\n\n\n\n\n';

		if (StaticData.tunnelOpen && width <= 2048 && height <= 2048)
		{
			width += 3;
			height += 3;
			secondBG.setGraphicSize(width, height);
		}

		if (StaticData.sartFade)
		{
			dad.alpha -= 0.01;
			iconP2.alpha -= 0.01;
		}

		if (StaticData.tunnelOpen && twidth >= 0)
		{
			twidth--;
			theight--;
			thierry.setGraphicSize(twidth, theight);
		}

		if (!StaticData.tunnelOpen && StaticData.tunnelHasOpened && height >= 0)
		{
			width -= 4;
			height -= 4;
			secondBG.setGraphicSize(width, height);
		}

		if (StaticData.badaiComesin && badaix <= 1195)
		{
			badaix += 5;
			badaiy += 5;
			dad.setGraphicSize(badaix, badaiy);
		}

		if (startingSong)
		{
			ZoomCam(focusOnDadGlobal, 4);
		}

		if (SONG.song.toLowerCase() == 'torment') // fuck you
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 4) == 0 ? -1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.alpha = 0.3;
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 4) == 0 ? -1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}

		
		if (SONG.song.toLowerCase() == 'purgatory' || SONG.song.toLowerCase() == 'nether' && thierryChill) // fuck you //640	
		{
			playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime + (spr.ID)) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
		}
		else if (SONG.song.toLowerCase() == 'nether' && !thierryChill)
		{
			playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime + (spr.ID)) * 2000);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 4;
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 1000);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 2;
				});
		}



		if (SONG.song == 'copy-cat')
		{
			camFollow.setPosition(gf.getMidpoint().x + 150, gf.getMidpoint().y - 100);
		}

		if (SONG.song == 'brutal' && StaticData.tunnelOpen)
		{
			secondBG.angle += 0.1;
		}



		if (mati && SONG.song == 'brutal' || SONG.song == 'Nether')
		{
			FlxG.camera.shake(0.003, 0.1);
			camHUD.shake(0.003, 0.1);
		}
		else if (jancok && SONG.song == 'brutal')
		{
			FlxG.camera.shake(0.010, 0.1);
		}

		if (SONG.song == 'chaos' || SONG.song == 'disarray' || SONG.song == 'Rush' || SONG.song == 'Hyperactivity' || SONG.song == 'Brute')
		{
			if (mati)
			{
				FlxG.camera.shake(0.010, 0.1);
			}
			
			bego.angle += 0.1;
			if (jancokKalian)
			{
				dad.x += (Math.sin(elapsedtime) * 1.72);
			}
		}

		if (SONG.song == 'cheat-blitar')
		{
			camFollow.x = gf.getMidpoint().x - 150;
			dad.x += (Math.sin(elapsedtime) * 1.72);
		}

		/* DISABLED TEMPORARILY

		if(SONG.song.toLowerCase() == 'segitiga' || SONG.song.toLowerCase() == 'trigometry')
		{
			if (shouldMuter)
			{
				playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.angle += (Math.sin(elapsedtime * 1.5) + 1) * 2;
					});
					dadStrums.forEach(function(spr:FlxSprite)
					{
						spr.angle += (Math.sin(elapsedtime * 1.5) + 1) * 2;
					});
					for(note in notes)
					{
						if(note.mustPress)
						{
							if (!note.isSustainNote)
								note.angle = playerStrums.members[note.noteData].angle;
						}
						else
						{
							if (!note.isSustainNote)
								note.angle = dadStrums.members[note.noteData].angle;
						}
					}
			}
			
		}
		/****/


		if(SONG.song == 'segitiga' && jancok || SONG.song == 'chaos' && jancok || SONG.song == 'disarray' && jancok || SONG.song == 'serpent' || SONG.song == 'Cuberoot')
		{
			dad.y += (Math.sin(elapsedtime) * 0.72);
		}

		if(boyfriend.curCharacter == 'tunnel-bf')
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.82);
		}

		if (dad.curCharacter == 'badai')
		{
			dad.angle = Math.sin(elapsedtime) * 15;
			dad.x += Math.sin(elapsedtime) * 0.6;
			dad.y += (Math.sin(elapsedtime) * 0.6);
		}

		if(SONG.song == 'segitiga' && jancokKalian)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.4);
		}
		if(SONG.song == 'segitiga' && jancokKalian)
		{
			gf.y += (Math.sin(elapsedtime) * 0.4);
		}



		elapsedtime += elapsed; //THIS SHIT IS KINDA LIKE A TEST CODE, THIS WILL BE REPLACED WITH MODCHART SOON
		if (curbg != null) //NVM LMAO I STILL NEED IT FOR THE SHADER TO WORK (yes its stolen from vsdave)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}

		if (SONG.song.toLowerCase() == 'applecore') // fuck you
		{
			if (shouldMuter)
			{
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime + (spr.ID)) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
				dadStrums.forEach(function(spr:FlxSprite)
				{
					spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 500);
					spr.x += 500; 
					spr.y += Math.sin(elapsedtime) * Math.random();
					spr.y -= Math.sin(elapsedtime) * 1.3;
				});
			}
			if (shouldMuterKeras)
			{
				playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin(elapsedtime + (spr.ID)) * 500);
						spr.x += 500; 
						spr.y += Math.sin(elapsedtime) * Math.random();
						spr.y -= Math.sin(elapsedtime) * 1.3;
					});
					dadStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 12) - (spr.width / 7)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 500);
						spr.x += 500; 
						spr.y += Math.sin(elapsedtime) * Math.random();
						spr.y -= Math.sin(elapsedtime) * 1.3;
					});
			}

		}
			
		/**if (SONG.song.toLowerCase() == 'cheat-blitar') // fuck you
		{
			playerStrums.forEach(function(spr:FlxSprite) ok
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
		}/****/

		#if !debug
		perfectMode = false;
		#end

		if (executeModchart && lua != null && songStarted)
		{
			setVar('songPos',Conductor.songPosition);
			setVar('hudZoom', camHUD.zoom);
			setVar('cameraZoom',FlxG.camera.zoom);
			callLua('update', [elapsed]);

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = getVar("strum" + i + "X", "float");
				member.y = getVar("strum" + i + "Y", "float");
				member.angle = getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = getVar('cameraAngle', 'float');
			camHUD.angle = getVar('camHudAngle','float');

			if (getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				if (StaticData.using3DEngine)
				{
					aeroEngineWatermark.visible = false;
				}
				else
				{
					kadeEngineWatermark.visible = false;
				}
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				if (SONG.song == 'cheat-blitar' || SONG.song == 'ghost')
				{
					scoreTxt.visible = false;
				}
				
			}
			else
			{
				healthBarBG.visible = true;
				if (StaticData.using3DEngine)
				{
					aeroEngineWatermark.visible = true;
				}
				else
				{
					kadeEngineWatermark.visible = true;
				}

				if (SONG.song == 'Ascension')
				{
					healthBar.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;
				}
				else
				{
					healthBar.visible = true;
					iconP1.visible = true;
					iconP2.visible = true;
				}

				scoreTxt.visible = true;
			}

			var p1 = getVar("strumLine1Visible",'bool');
			var p2 = getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		if (FlxG.keys.justPressed.F3)
		{
			StaticData.debugMenu = !StaticData.debugMenu;
		}

		if (FlxG.keys.justPressed.F1)
		{
			botPlay = !botPlay;
			cheated = true;
			botPlayState.visible = botPlay;
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		if (!offsetTesting)
		{
			var memek:String = generateWife();

			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (Conductor.safeFrames != 10 ? songScore + " (" + songScoreDef + ")" : "" + songScore) + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking() + " | " + "Combo: " + combo;
			}
			else
			{
				if (memek != "N/A")
				{
					scoreTxt.text = ("Score:" + songScore + " | Misses:" + misses + " | Rating: " + generateWife() + " (" + truncateFloat(accuracy, accStatus) + "%) " + generateTimings());
				}
				else
				{
					scoreTxt.text = ("Score:" + songScore + " | Misses:" + misses + " | Rating: N/A");
				}
				
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;

		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
		else if (FlxG.keys.justPressed.ENTER && startedCountdown && SONG.song == 'cheat-blitar' || FlxG.keys.justPressed.ENTER && SONG.song == 'confronting-yourself')
		{
			FlxG.sound.play(Paths.soundRandom('error', 0, 1), 69.69);
			var blocked:FlxSprite = new FlxSprite(500, 500);
			blocked.loadGraphic(Paths.image("ending/goblok"));
			add(blocked);

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				remove(blocked);
			});
		}

		if (FlxG.keys.justPressed.SIX)
		{
			#if windows
			DiscordClient.changePresence("Cheating using debug menu", null, null, true);
			#end
			#if debug
			FlxG.switchState(new ChartingState());
			#end
		}

		if (FlxG.keys.justPressed.FIVE)
		{
			if (camdebug)
			{
				camHUD.zoom = 0.5;
			}
			else
			{
				camHUD.zoom = 1;
			}
			
		}





		#if debug
		if(FlxG.keys.justPressed.TWO && songStarted) { //Go 60 seconds into the future, credit: Shadow Mario#9396
			if (!usedTimeTravel && Conductor.songPosition + 60000 < FlxG.sound.music.length) 
			{
				usedTimeTravel = true;
				FlxG.sound.music.pause();
				vocals.pause();
				curBeat = curBeat + Conductor.bpm;
				curStep = curBeat * 4;
				Conductor.songPosition += 60000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime + 800 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime + 800 >= Conductor.songPosition) {
						break;
					}
	
					daNote.active = false;
					daNote.visible = false;
	
					daNote.kill();
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
					daNote.destroy();
				}
	
				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();
	
				vocals.time = Conductor.songPosition;
				vocals.play();
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					usedTimeTravel = false;
				});
			}
		}

		if(FlxG.keys.justPressed.THREE && songStarted) { //Go 10 seconds into the future, credit: Shadow Mario#9396
			if (!usedTimeTravel && Conductor.songPosition + 10000 < FlxG.sound.music.length) 
			{
				usedTimeTravel = true;
				FlxG.sound.music.pause();
				vocals.pause();
				curBeat = curBeat + Std.int(Conductor.bpm / 6);
				curStep = curBeat * 4;
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime + 800 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime + 800 >= Conductor.songPosition) {
						break;
					}
	
					daNote.active = false;
					daNote.visible = false;
	
					daNote.kill();
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
					daNote.destroy();
				}
	
				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();
	
				vocals.time = Conductor.songPosition;
				vocals.play();
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					usedTimeTravel = false;
				});
			}
		}
		#end

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (curSong.toLowerCase() == 'cheat-blitar' || curSong.toLowerCase() == 'confronting-yourself')
			{
				FlxG.sound.play(Paths.soundRandom('error', 0, 1), 69.69);
				trace("HAHAHA DEBUG MODE BLOCKED");
			}
			else
			{
				PlayState.SONG = Song.loadFromJson("cheat-blitar", "cheat-blitar");
				FlxG.switchState(new PlayState());
				pressedSEVEN = true;
				trace("bool" + pressedSEVEN);
				checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss']);
				trace("good lUCK");
				
			}
			
			return;
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		var funny:Float = (healthBar.percent * 0.02) + 0.02;

		if (SONG.song == 'gerlad')
		{
			iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));	
		}

		if (SONG.song == 'meninggal')
		{
			if (FlxG.save.data.memoryTrace && curBeat % 4 == 0)
			{
				trace("jumped with eval " + iconP2.height + ' ' + iconP2.width);
			}
			

			if (boppersSpawned)
			{
				thierrySiang.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(1000, iconP2.height, 0.8)));
				achell.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(555, iconP2.height, 0.5)));
				raditz.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(1500, iconP2.height, 0.8)));
				meksi.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(1300, iconP2.height, 0.8)));
			}
			else
			{
				if (StaticData.isAllowedToBop)
				{
					if (thierry.visible)
					{
						thierry.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(2000, iconP2.height, 0.86)));
					}
					if (gw.visible)
					{
						gw.setGraphicSize(Std.int(FlxMath.lerp(800, iconP2.width, 0.8)),Std.int(FlxMath.lerp(300, iconP2.height, 0.1)));
					}
				}

				
			}

		}

		if (SONG.song != 'Cuberoot') //lmfao will be replaced later (yes icon bounce will be varied)
		{
			var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP1.scale.set(mult, mult);
			iconP1.updateHitbox();
	
			var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP2.scale.set(mult, mult);
			iconP2.updateHitbox();
		}


		if (SONG.song == 'gerlad')
		{
			if (FlxG.save.data.memoryTrace)
			{
				trace("jumped with eval " + iconP2.height + ' ' + iconP2.width);
			}
			thierry.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(1000, iconP2.height, 0.8)));
			gw.setGraphicSize(Std.int(FlxMath.lerp(900, iconP2.width, 0.8)),Std.int(FlxMath.lerp(300, iconP2.height, 0.1)));
			achell.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(555, iconP2.height, 0.5)));
			raditz.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(1500, iconP2.height, 0.8)));
			meksi.setGraphicSize(Std.int(FlxMath.lerp(300, iconP2.width, 0.1)),Std.int(FlxMath.lerp(1300, iconP2.height, 0.8)));
		}
		 //PLACEW HERE YOU EDIT BEAT OR SOMETHING YES

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
		

		

		if (health > 2)
		{
			if (SONG.song == 'segitiga' && healthDrainBool)
			{
				//no
			}
			else if (SONG.song == 'cheat-blitar' || SONG.song == 'Ascension' || SONG.song == 'Purgatory')
			{
				//no
			}
			else
			{
				health = 2;
			}
		}

		if (gwHasBeenAdded) //this code is intimidating to see lmfao
			{ //i dont care, what im aiming is that is works lol
				gwwhat.angle += 0.9;

				gwwhatWidth -= 1;
				gwwhatHeight -= 1;

				gwwhat.setGraphicSize(gwwhatWidth, gwwhatHeight);

				if (gwwhat.x <= 2000)
				{
					gwwhat.x += 1;
				}

				if (gwwhat.y <= 2000)
				{
					gwwhat.y += 1;
				}
				
				
			}
			
		else if (healthBar.percent < 20)
		{
			iconP1.animation.curAnim.curFrame = 1;

			
		}
		else if (healthBar.percent > 80)
		{
			if (StaticData.animaticaEngine)
			{
				iconP2.animation.play('lose');
			}
			else
			{
				iconP2.animation.curAnim.curFrame = 1;
			}
			
			iconP1.animation.curAnim.curFrame = 2;
			if (SONG.song == 'gerlad')
			{
				iconP2.angle += 2;
			}
		}
		else
		{
			if (SONG.song == 'gerlad')
			{
				iconP2.angle = 0;
			}
			if (StaticData.animaticaEngine)
			{
				iconP2.animation.play('idle');
			}
			else
			{
				iconP2.animation.curAnim.curFrame = 0;
			}
			
			iconP1.animation.curAnim.curFrame = 0;

		}
			
		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}

		if (FlxG.keys.justPressed.NINE)
		{
			FlxG.switchState(new AnimationDebugDad(dad.curCharacter));
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}
		
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = (Conductor.songPosition / 1000);

			if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;
	
					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
						// Conductor.songPosition += FlxG.elapsed * 1000;
						// trace('MISSED FRAME');
					}

	
					if (FlxG.save.data.songPosition)
						songName.text = FlxStringUtil.formatTime(((songLength / 1000) - songTime / 1000 ), false);
				}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			

			//what the fuck is this even for??
			//oh

			if (!UsingNewCam)
			{
				if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
						if (dad.curCharacter == 'Fsby')
						{
							camFollow.setPosition(dad.getMidpoint().x + 150 + (lua != null ? getVar("followXOffset", "float") : 0), dad.getMidpoint().y + 300 + (lua != null ? getVar("followYOffset", "float") : 0));
						}
						else
							{
								camFollow.setPosition(dad.getMidpoint().x + 150 + (lua != null ? getVar("followXOffset", "float") : 0), dad.getMidpoint().y - 100 + (lua != null ? getVar("followYOffset", "float") : 0));
							}
						
						// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
		
						switch (dad.curCharacter)
						{
							case 'Fsby' | 'fsby':
								camFollow.y = dad.getMidpoint().y - 420;
							case 'mom':
								camFollow.y = dad.getMidpoint().y;
							case 'senpai':
								camFollow.y = dad.getMidpoint().y - 430;
								camFollow.x = dad.getMidpoint().x - 100;
							case 'senpai-angry':
								camFollow.y = dad.getMidpoint().y - 430;
								camFollow.x = dad.getMidpoint().x - 100;
						}
		
						if (dad.curCharacter == 'mom')
							vocals.volume = 1;
		
						if (SONG.song.toLowerCase() == 'tutorial')
						{
							tweenCamIn();
						}
					}
		
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
					{
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + (lua != null ? getVar("followXOffset", "float") : 0), boyfriend.getMidpoint().y - 100 + (lua != null ? getVar("followYOffset", "float") : 0));
		
						switch (curStage)
						{
							case 'limo':
								camFollow.x = boyfriend.getMidpoint().x - 300;
							case 'mall':
								camFollow.y = boyfriend.getMidpoint().y - 200;
							case 'school':
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;
							case 'schoolEvil':
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;
						}
		
						if (SONG.song.toLowerCase() == 'tutorial')
						{
							FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
						}
					}
				}
			}
			

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
			{
				FlxG.watch.addQuick('rep rpesses',repPresses);
				FlxG.watch.addQuick('rep releases',repReleases);
				// FlxG.watch.addQuick('Queued',inputsQueued);
			}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0) //DEAD STATE death state
		{
			if (!FlxG.save.data.kebal)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				switch (SONG.song)
				{
					case 'ded':
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
						if (isStoryMode)
						{
							StaticData.goingBadEndingRoute = true;
						}
					case 'anjing':
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
						if (isStoryMode)
						{
							StaticData.goingBadEndingRoute = true;
						}

					//PUNISHJMENTS
					case 'cheat-blitar':
						FlxG.switchState(new MainMenuState());
					case 'confronting-yourself':
						System.exit(0);
					default:
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}

				

				#if windows
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
				#end

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			else
			{
				health = 0;
				//does absolutely nothing!
			}
			
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						if (startingSong)
						{
							ZoomCam(focusOnDadGlobal, 4);
						}
						//ZoomCam(true);
					}

					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						if (SONG.song == 'ded' && health > 0.015|| SONG.song == 'get-out' && health > 0.015 || SONG.song == 'run' && health > 0.015)
						{
							health -= 0.014;
						}
						if (SONG.song == 'anjing' && health > 0.015)
						{
							health -= 0.0074;
						}
						/*if (SONG.song == 'latihan' && health > 0.025) //HIGH DAMAGE NOT KILLING
						{
							health -= 0.02;
						}/****/
						if (SONG.song == 'revenge' && health > 0.015 || SONG.song == 'brutal' && healthDrainBool && health > 0.015 || SONG.song == 'Torment' && health > 0.015 || SONG.song == 'cheat-blitar' && health > 0.015 || SONG.song == 'latihan' && health > 0.025) //LOW DAMAGE NOT KILLING
						{
							health -= 0.014;
						}

						if (SONG.song == 'Captivity' && health > 0.025 && mati)
						{
							health -= 0.025;
						}

						if (SONG.song == 'Purgatory' && health > 0.015)
						{
							if (health > 2) //HAVING HP MORE THAN 2 IS ABILITY LOL
							{
								health -= 0.001;
							}
							else
							{
								health -= 0.007;
							}
							
						}

						if (SONG.song == 'Torment')
						{
							FlxG.camera.shake(0.010, 0.1);
							camHUD.shake(0.008, 0.1);
						}

						if (SONG.song == 'Purgatory')
						{
							camera.angle += 1;
							camHUD.angle += 1;
							FlxG.camera.shake(0.0050, 0.1);
							camHUD.shake(0.0057, 0.1);
							Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -15, 15),Lib.application.window.y + FlxG.random.int( -12, 12));
						}

						if (SONG.song == 'meninggal' && healthDrainBool && health > 0.015)
						{
							health -= 0.008;
						}

						if (SONG.song == 'AppleCore' && healthDrainBool && health > 0.015)
						{
							health -= 0.0028;
						}

						if (SONG.song == 'Ascension')
						{
							health += 200;
						}

						if(SONG.song == 'cheat-blitar' || SONG.song == 'Nether')
						{
							FlxG.camera.shake(0.020, 0.1);
							camHUD.shake(0.017, 0.1);
						}

						if (SONG.song == 'chaos' || SONG.song == 'disarray' || SONG.song == 'brutal' || SONG.song == 'Rush' || SONG.song == 'Hyperactivity' || SONG.song == 'Brute')
						{
							camHUD.shake(0.0037, 0.1);
						}
						
						if (SONG.song == 'Captivity' && mati)
							{
								FlxG.camera.shake(0.010, 0.1);
							}

						dadStrums.forEach(function(sprite:FlxSprite)
						{
							if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
							{
								sprite.animation.play('confirm', true);
								if (sprite.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
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
									sprite.animation.play('static',true);
									sprite.centerOffsets();
								}
		
							}
						});
	
						switch (Math.abs(daNote.noteData))
						{

							case 2:
								ZoomCam(true, 2);
								if (StaticData.whoIsSinging == 0)
								{
									dad.playAnim('singUP' + altAnim, true);
								}
								else if (StaticData.whoIsSinging == 1)
								{
									surgarDaddy.playAnim('singUP' + altAnim, true);
								}
								else
								{
									dad.playAnim('singUP' + altAnim, true);
									surgarDaddy.playAnim('singUP' + altAnim, true);
								}
								
							case 3:
								ZoomCam(true, 3);
								if (StaticData.whoIsSinging == 0)
									{
										dad.playAnim('singRIGHT' + altAnim, true);
									}
								else if (StaticData.whoIsSinging == 1)
								{
									surgarDaddy.playAnim('singRIGHT' + altAnim, true);
								}
								else
								{
									dad.playAnim('singRIGHT' + altAnim, true);
									surgarDaddy.playAnim('singRIGHT' + altAnim, true);
								}
								
							case 1:
								ZoomCam(true, 1);
								if (StaticData.whoIsSinging == 0)
									{
										dad.playAnim('singDOWN' + altAnim, true);
									}
								else if (StaticData.whoIsSinging == 1)
								{
									surgarDaddy.playAnim('singDOWN' + altAnim, true);
								}
								else
								{
									dad.playAnim('singDOWN' + altAnim, true);
									surgarDaddy.playAnim('singDOWN' + altAnim, true);
								}
								
							case 0:
								ZoomCam(true, 0);
								if (StaticData.whoIsSinging == 0)
									{
										dad.playAnim('singLEFT' + altAnim, true);
									}
								else if (StaticData.whoIsSinging == 1)
								{
									surgarDaddy.playAnim('singLEFT' + altAnim, true);
								}
								else
								{
									dad.playAnim('singLEFT' + altAnim, true);
									surgarDaddy.playAnim('singLEFT' + altAnim, true);
								}

								
									
						}
	
						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
	
					if (FlxG.save.data.downscroll)
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{ // do soft code checks later on, this is WIP
							if (daNote.noteType == 'Damage')
							{

							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
						}
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();

					}


					if ((daNote.y < (-daNote.height + 182) && !FlxG.save.data.downscroll && botPlay || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						goodNoteHit(daNote);
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();

						if (!boyfriend.stunned && generatedMusic)
						{
							repPresses++;
				
							if (StaticData.using3DEngine || botPlay)
							{
								boyfriend.holdTimer = -1.18;
							}
							else
							{
								boyfriend.holdTimer = 0;
							}
						}

						playerStrums.forEach(function(sprite:FlxSprite)
						{
								if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
								{
									sprite.animation.play('confirm', true);
									sprite.centerOffsets();
									sprite.offset.x -= 13;
									sprite.offset.y -= 13;

									sprite.animation.finishCallback = function(name:String)
									{
										sprite.animation.play('static',true);
										sprite.centerOffsets();
									}
			
								}
						});

						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}


		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		if (startingSong)
		{
			ZoomCam(focusOnDadGlobal, 4);
		}
		
	}

	function ZoomCam(focusondad:Bool, noteData:Int):Void
	{
		if (UsingNewCam && !maniaSong)
		{
			var bfplaying:Bool = false;
			if (focusondad)
			{
				AnimMixin.makeOpponentIdle(SONG, dad, surgarDaddy, StaticData.whoIsSinging, true);
				notes.forEachAlive(function(daNote:Note)
				{
					if (!bfplaying && daNote.isBoyfriendNote)
					{
						bfplaying = true;
					}
				});
				if (UsingNewCam && bfplaying)
				{
					return;
				}
			}
			if (focusondad && StaticData.bfExists)
			{
				if (StaticData.theresSecondDad)
				{
					switch(StaticData.whoIsSinging)
					{
						case 0:
							camAnchorX = dad.getMidpoint().x;
							camAnchorY = dad.getMidpoint().y;
						case 1:
							camAnchorX = surgarDaddy.getMidpoint().x;
							camAnchorY = surgarDaddy.getMidpoint().y;
						default:
							camAnchorX = dad.getMidpoint().x;
							camAnchorY = dad.getMidpoint().y;
							
					}
				}
				else
				{
					camAnchorX = dad.getMidpoint().x;
					camAnchorY = dad.getMidpoint().y;
				}

				if (elonMusk)
				{
					camFollow.setPosition(dad.getMidpoint().x + 400, dad.getMidpoint().y - 100);
				}
				else
				{
					switch(noteData)
					{
						case 0:
							camFollow.setPosition(camAnchorX + cameraAmplifierX - 40, camAnchorY - cameraAmplifierY);
						case 1:
							camFollow.setPosition(camAnchorX + cameraAmplifierX, camAnchorY - cameraAmplifierY + 40);
						case 2:
							camFollow.setPosition(camAnchorX + cameraAmplifierX, camAnchorY - cameraAmplifierY - 40);
						case 3:
							camFollow.setPosition(camAnchorX + cameraAmplifierX + 40, camAnchorY - cameraAmplifierY);
						default:
							camFollow.setPosition(camAnchorX + cameraAmplifierX, camAnchorY - cameraAmplifierY);
	
					}
				}
				
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
	
				switch (dad.curCharacter)
				{
					case 'gw-3d': //CLEAN THIS LATER IM LAZY AF
						camFollow.y = dad.getMidpoint().y;
				}
	
				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}
	
			if (!focusondad && StaticData.bfExists)
			{
				AnimMixin.makeOpponentIdle(SONG, dad, surgarDaddy, StaticData.whoIsSinging, false);
				bfCamAnchorX = boyfriend.getMidpoint().x;
				bfCamAnchorY = boyfriend.getMidpoint().y;
	
				switch(noteData)
				{
					case 0:
						camFollow.setPosition(bfCamAnchorX - bfCameraAmplifierX - 40, bfCamAnchorY - bfCameraAmplifierY);
					case 1:
						camFollow.setPosition(bfCamAnchorX - bfCameraAmplifierX, bfCamAnchorY - bfCameraAmplifierY + 40);
					case 2:
						camFollow.setPosition(bfCamAnchorX - bfCameraAmplifierX, bfCamAnchorY - bfCameraAmplifierY - 40);
					case 3:
						camFollow.setPosition(bfCamAnchorX - bfCameraAmplifierX + 40, bfCamAnchorY - bfCameraAmplifierY);
					default:
						camFollow.setPosition(bfCamAnchorX - bfCameraAmplifierX, bfCamAnchorY - bfCameraAmplifierY);
	
				}
				
	
				switch(boyfriend.curCharacter)
				{
					case 'gw-3d':
						camFollow.y = boyfriend.getMidpoint().y;
					case 'bambi-3d' | 'badai':
						camFollow.y = boyfriend.getMidpoint().y - 350;
				}
	
				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}	
		}

	}

	function afterGameplay():Void {
		if (dialogueEnd != null && isStoryMode) {
			//Detener la música
			endingSong = true;
			canPause = false;
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			//FlxG.sound.music.pause();
			//vocals.pause();
			FlxG.sound.music.stop();
			vocals.stop();
			paused = true;
			inCutscene = true;
			talking = true;
			camZooming = false;
			FlxG.camera.zoom = defaultCamZoom;
			//Cargar diálogo de salida
			//dialogue = CoolUtil.coolTextFile(Paths.txt('data/' + songID + '/dialogue-end'));
			var dbox:DialogueBox = new DialogueBox(false, dialogueEnd);
			dbox.scrollFactor.set();
			dbox.finishThing = endSong;
			dbox.cameras = [camHUD];
			add(dbox);
			dbox.visible = true;
		} 
		else 
		{
			this.endSong();
		}
	}
	
	function endSong():Void
	{
		if (SONG.song == 'Tutorial')
		{
			FlxG.switchState(new MainMenuState());
		}

		if (SONG.song == 'cheat-blitar')
		{
			checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
			'week5_nomiss', 'week6_nomiss', 'week7_nomiss']);
			FlxG.switchState(new EndingState('cheatEnding', 'cheatEnding'));
			trace("MS OBAMA GET DOWN");
		}

		if (SONG.song == 'anjing')
		{
			FlxG.save.data.shouldHearAmbience = false;
		}
		else
		{
			FlxG.save.data.shouldHearAmbience = true;
		}

		if (!loadRep)
			rep.SaveReplay();

		if (executeModchart)
		{
			Lua.close(lua);
			lua = null;
		}

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore && !botPlay && !cheated)
		{
			trace("Datas flushed!");
			Highscore.saveMisses(SONG.song, Math.round(misses),storyDifficulty);
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			Highscore.saveAcc(SONG.song, Math.round(accuracy),storyDifficulty);

			Highscore.saveSicks(SONG.song, Math.round(sicks),storyDifficulty);
			Highscore.saveGoods(SONG.song, Math.round(goods),storyDifficulty);
			Highscore.saveBads(SONG.song, Math.round(bads),storyDifficulty);
			Highscore.saveShits(SONG.song, Math.round(shits),storyDifficulty);
		}

		switch (SONG.song)
		{
			case 'confronting-yourself':
				FlxG.switchState(new CrasherStateEnding("crasherEnding", "bSOD"));
			case 'meninggal':
				if (isStoryMode)
				{
					FlxG.save.data.hexSongUnlocked = true;
				}
			case 'segitiga':
				if (isStoryMode)
				{
					FlxG.save.data.mattSongUnlocked = true;
				}
			case 'gerselo':
				if (isStoryMode)
				{
					FlxG.save.data.aeroSongUnlocked = true;
				}
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss']);

				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					if (curSong.toLowerCase() == 'meninggal')
					{
						Achievements.unlockAchievement('week5_nomiss');
						if (StaticData.goingBadEndingRoute)
						{
							Achievements.unlockAchievement('week2_nomiss');
							canPause = false;
							StaticData.gotBadEnding = true;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('meninggal/badEndDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camHUD];
							doof.finishThing = function()
							{
								FlxG.switchState(new EndingState('badEnding', 'badEnding'));
							};
							schoolIntro(doof);
							

						}
						else
						{
							Achievements.unlockAchievement('week1_nomiss');
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('meninggal/goodEndDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camHUD];
							doof.finishThing = function()
							{
								FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
							};
							schoolIntro(doof);
						}
					}
					else if (curSong.toLowerCase() == 'segitiga')
					{
						Achievements.unlockAchievement('week1_nomiss');
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('segitiga/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						doof.cameras = [camHUD];
						doof.finishThing = function()
						{
							FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
						};
						schoolIntro(doof);
					}
					else if (curSong.toLowerCase() == 'gerselo')
					{
						Achievements.unlockAchievement('week1_nomiss');
						FlxG.switchState(new EndingState('goodEnding', 'goodEnding')); //will not count to ending (will be me talking saying thank you f or playing the mod)
					}
					

					//FlxG.switchState(new StoryMenuState());

					if (lua != null)
					{
						Lua.close(lua);
						lua = null;
					}

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore && !botPlay && !cheated)
					{
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					StaticData.isAllowedToBop = false;
					StaticData.goingBadEndingRoute = false;

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{

					switch (SONG.song.toLowerCase())
					{
						case 'anjing':
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('anjing/endDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camHUD];
							schoolIntro(doof);
						case 'revenge':
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('revenge/endDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camHUD];
							schoolIntro(doof);
						case 'gerlad':
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('gerlad/endDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camHUD];
							schoolIntro(doof);
						case 'segitiga':
							canPause = false;
							FlxG.sound.music.volume = 0;
							vocals.volume = 0;
							generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
							boyfriend.stunned = true;
							var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('segitiga/endDialogue')));
							doof.scrollFactor.set();
							doof.finishThing = nextSong;
							doof.cameras = [camHUD];
							schoolIntro(doof);
						default:
							nextSong();
				}   }
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new CoolMenuState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	function nextSong()
	{
		var difficulty:String = "";

		if (storyDifficulty == 0)
			difficulty = '-easy';

		if (storyDifficulty == 2)
			difficulty = '-hard';

		trace('LOADING NEXT SONG OMG');
		trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		LoadingState.loadAndSwitchState(new PlayState());
	}

	//2 dad support soon ig
	public function changeDad(char:String, coorX:Float, coorY:Float) 
    {
        remove(dad);
        dad = new Character(coorX, coorY, char);
		add(dad);

    }


	private function popUpScore(daNote:Note):Void
		{

			if (difficultSong) {health += 0.03;}


			noteDiff = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);

			if (FlxG.save.data.hitSounds)
			{
				FlxG.sound.play(Paths.soundRandom('hitSound', 1, 3), FlxG.random.float(3.5, 3.7));
			}
			

			coolText.setGraphicSize(50, 50);
			if (maniaSong)
			{
				//no
			}
			else
			{
				coolText.screenCenter();
				coolText.x = 500;
				coolText.y -= 350;
				coolText.cameras = [camHUD];
			}

			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			if(scoreTxtTween != null) 
				{
					scoreTxtTween.cancel();
				}
	
				scoreTxt.scale.x = 1.1;
				scoreTxt.scale.y = 1.1;
				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						scoreTxtTween = null;
					}
				});

			if (daRating == 'sick' && FlxG.save.data.spong)//note splash
			{
				spawnNoteSplashOnNote(daNote);

				/*
				var angles:Array<Int> = [25, 60, 180, 260, 0];

				var splash:FlxSprite = new FlxSprite(daNote.x, playerStrums.members[daNote.noteData].y);
				splash.x -= 135;
				splash.y -= 150;
				splash.angle = angles[FlxG.random.int(1, 5)];
				splash.setGraphicSize(Std.int(splash.width / 3));
				splash.frames = Paths.getSparrowAtlas('notesplash');
				splash.antialiasing = true;
				splash.animation.addByPrefix('splash 0', 'purple splash', 24, false);
				splash.animation.addByPrefix('splash 1', 'blue splash', 24, false);
				splash.animation.addByPrefix('splash 2', 'green splash', 24, false);
				splash.animation.addByPrefix('splash 3', 'red splash', 24, false);
				splash.scrollFactor.set();
				splash.cameras = [camHUD];
				add(splash);
				splash.animation.play('splash ' + daNote.noteData);
				FlxTween.tween(splash, {alpha: 0}, 0.3, {
					ease: FlxEase.elasticInOut,
						onComplete: function(twn:FlxTween)
						{
						remove(splash);
					}
				});
				/****/
			}

			switch(daRating)
			{
				case 'shit': //I NEED TO FUCKING FIND OUT HOW TO MAKE IT ACCURATE, THERES NO WAY IM THIS GOOD
					score = -300;
					combo = 0;
					health -= 0.2;
					ss = false;
					if (!botPlay) {shits++; misses++;}
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					health += 0.015;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					health += 0.023;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			//rating.cameras = [camHUD];
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			//comboSpr.cameras = [camHUD];
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;
	
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
	
			add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
			comboSpr.updateHitbox();
			rating.updateHitbox();

			//comboSpr.cameras = [camHUD];
			//rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				//numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	
		

	public function keyShit():Void
	{
		// HOLDING
		up = controls.UP;
		right = controls.RIGHT;
		down = controls.DOWN;
		left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		/*
		if (botPlay)
		{
			controlArray = [false, false, false, false];

			up = false;
			right = false;
			down = false;
			left = false;
	
			upP = false;
			rightP = false;
			downP = false;
			leftP = false;
	
			upR = false;
			rightR = false;
			downR = false;
			leftR = false;
		}
		/****/

		

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				//the 3d magic thing real
				boyfriend.holdTimer = 0;
				
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{

								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							if (loadRep)
							{
								noteDiff = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(daNote);
									trace('force note hit');
								}
								else
									noteCheck(controlArray, daNote);
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								if (loadRep)
									{
										if (NearlyEquals(coolNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
										{
											noteDiff = Math.abs(coolNote.strumTime - Conductor.songPosition);

											if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
												coolNote.rating = "shit";
											else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
												coolNote.rating = "bad";
											else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
												coolNote.rating = "good";
											else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
												coolNote.rating = "sick";
											goodNoteHit(coolNote);
											trace('force note hit');
										}
										else
											noteCheck(controlArray, daNote);
									}
								else
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
							{
								noteDiff = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								goodNoteHit(daNote);
								trace('force note hit');
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
							noteCheck(controlArray, daNote);
					}
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				trace(up + " " + down + " " + right + " " + left);
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.playAnim('idle');
				}
			}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					
					switch (spr.ID)
					{
						case 2:
							if (upP && spr.animation.curAnim.name != 'confirm' && !botPlay)
							{
								spr.animation.play('pressed');
								trace('play');
								
								if (FlxG.save.data.epico && songStarted)
									{
										noteMiss(spr.ID, null);
									}
							}
							if (upR)
							{
								spr.animation.play('static'); //input handler stuff veru coal
								repReleases++;
									
									
							}
						case 3:
							if (rightP && spr.animation.curAnim.name != 'confirm' && !botPlay)
							{
								if (FlxG.save.data.epico && songStarted)
									{
										noteMiss(spr.ID, null);
									}
								spr.animation.play('pressed');
							}
								
							if (rightR)
							{
								spr.animation.play('static');
								repReleases++;
							}
								
						case 1:
							if (downP && spr.animation.curAnim.name != 'confirm' && !botPlay)
							{
								if (FlxG.save.data.epico && songStarted)
									{
										noteMiss(spr.ID, null);
									}
								spr.animation.play('pressed');
							}
								
							if (downR)
							{
								spr.animation.play('static');
								repReleases++;
							}
						case 0:
							if (leftP && spr.animation.curAnim.name != 'confirm' && !botPlay)
							{
								if (FlxG.save.data.epico && songStarted)
									{
										noteMiss(spr.ID, null);
									}
								spr.animation.play('pressed');
							}
							if (leftR)
							{
								spr.animation.play('static');
								repReleases++;
							}
					}
					
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
	}

	function spawnNoteSplashOnNote(note:Note) {
		if(FlxG.save.data.spong && note != null) {
			var strum:FlxSprite = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, 2, 2, 2);
		grpNoteSplashes.add(splash);
	}


	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			if (!botPlay) 
			{
				if (SONG.song == 'Purgatory')
					{
						health -= 0.01;
					}
					else
					{
						health -= 0.04;
					}
			}

			
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}

			if (!botPlay) 
			{
				combo = 0;
				misses++;
			}


			//noteDiff = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			songScore -= 10;

			if (!botPlay) {FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));}
			
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			noteDiff = Math.abs(note.strumTime - Conductor.songPosition);
			susussamongus = true;

			if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
				if (botPlay) {note.rating = "good";} else {note.rating = "shit";}
			else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
				note.rating = "bad";
			else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
				note.rating = "good";
			else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
				note.rating = "sick";

			if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note);
					}
				}
			}
			else if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) && mashViolations < 1000)
					{
						mashViolations++;
						
						goodNoteHit(note, (mashing <= getKeyPresses(note)));
					}
					else
					{
						if (FlxG.save.data.tolol)
						{
							goodNoteHit(note, (mashing <= getKeyPresses(note)));
						}
						else
						{
							playerStrums.members[0].animation.play('static');
							playerStrums.members[1].animation.play('static');
							playerStrums.members[2].animation.play('static');
							playerStrums.members[3].animation.play('static');
							health -= 0.1;
						}
						// this is bad but fuck you
						
						trace('mash ' + mashing);
					}

					if (mashing != 0)
						mashing = 0;
				}
				
			susussamongus = false;
		}

		var nps:Int = 0;

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (SONG.song == 'Captivity' && mati)
				{
					FlxG.camera.shake(0.010, 0.1);
				}

				noteDiff = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				if (UsingNewCam)
				{
					focusOnDadGlobal = false;
					//ZoomCam(false, 4);
				}

				//do note checks later on, this is still WIP, also disable hitsounds + notesplashes later aswell

				if (note.noteType == 'Damage')
				{
					health -= 0.10;
				}


				if (!note.isSustainNote)
					notesHitArray.push(Date.now());

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (note.isSustainNote)
					{
						health += 0.004;
					}
						


					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							ZoomCam(false, 2);
							boyfriend.playAnim('singUP', true);
						case 3:
							ZoomCam(false, 3);
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							ZoomCam(false, 1);
							boyfriend.playAnim('singDOWN', true);
						case 0:
							ZoomCam(false, 0);
							boyfriend.playAnim('singLEFT', true);
					}
		
					if (!loadRep)
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function convertDataType(v:Bool, b:Int)
	{
		if (v && b == 0){leftInt = 1;}
		if (!v && b == 0){leftInt = 0;}

		if (v && b == 1){downInt = 1;}
		if (!v && b == 1){downInt = 0;}

		if (v && b == 2){upInt = 1;}
		if (!v && b == 2){upInt = 0;}

		if (v && b == 0){rightInt = 1;}
		if (!v && b == 0){rightInt = 0;}

	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{

		if (SONG.song == 'Ascension')
			{
				healthBarBG.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
			}

		if (DespawnNotes)
		{
			trace("UNECESARRY NOTES DELETED");
			notes.forEachAlive(function(daNote:Note)
			{
				daNote.active = false;
				daNote.visible = false;
	
				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();

			});
			for (i in 0...unspawnNotes.length) {
				var daNote:Note = unspawnNotes[0];
				break;
	
				daNote.active = false;
				daNote.visible = false;
	
				daNote.kill();
				unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
				daNote.destroy();
			
			}
		}

		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (curSong == 'gerlad')
		{
			switch(curStep)
			{
				case 1721://fuck you
					dad.playAnim('FUCKIDLE', true);
					trace('animaton played ok');
					//REST OF THE CODES ARE WRITTEN IN MODCHART
					
			}


		}

		if (curSong == 'cheat-blitar')
		{
			if (health >= 0.016)
			health -= 0.015;
		}
		if (curSong == 'segitiga')
		{
			if (healthDrainBool && health >= 0.016)
			{
				if (health > 2)
				{
					health -=0.005;
				}
				health -= 0.015;
			}
		}

		if (executeModchart && lua != null)
		{
			setVar('curStep',curStep);
			callLua('stepHit',[curStep]);
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		
		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (botPlay)
			botPlayState.visible = true;

		if (!UsingNewCam)
		{
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
				}

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = true;
					ZoomCam(true, 4);
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					focusOnDadGlobal = false;
					ZoomCam(false, 4);
				}
			}
		}

		/*
		if (SONG.song == 'Cuberoot' && curBeat % 4 == 0)
		{
			var random:Float = FlxG.random.float(0, 1);

			bego.alpha = random;
			trace("randomized! " + random + " " + bego.alpha);
		}
		/****/

		if (FlxG.save.data.memoryTrace)
		{
			//trace("curBeat " + curBeat);
			//trace("curStep " + curStep);
			//trace("currentBPM " + Conductor.bpm);
			if (isStoryMode)
			{
				trace("Ending Status :" + StaticData.goingBadEndingRoute);
			}
			
			if (gwHasBeenAdded)
			{
				trace("gw.position X / Y / A " + gwwhat.x + '|' + gwwhat.y + '|' + gwwhat.angle);
			}

		}
		
		

		if (executeModchart && lua != null)
		{
			setVar('curBeat',curBeat);
			callLua('beatHit',[curBeat]);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		//var funny:Float = (healthBar.percent * 0.02) + 0.02;

		//health icon bounce but epic
		//i agree it is epic
		//I MADE IT EVEN EPICER!!!

		if (SONG.song != 'Cuberoot')
		{
			if (curBeat % gfSpeed == 0) {
				curBeat % (gfSpeed * 2) == 0 ? {
					iconP1.scale.set(1.1, 0.8);
					iconP2.scale.set(1.1, 1.3);
	
					FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				} : {
					iconP1.scale.set(1.1, 1.3);
					iconP2.scale.set(1.1, 0.8);
	
					FlxTween.angle(iconP2, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.angle(iconP1, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				}
	
				FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
				FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
	
				iconP1.updateHitbox();
				iconP2.updateHitbox();
			}
		}
		else
		{
			iconP1.scale.set(1.2, 1.2);
			iconP2.scale.set(1.2, 1.2);
	
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}

		if(curBeat % 2 == 0)
		{
			if(dad.curCharacter == 'Fsby')
			{
				iconP1.animation.play('idle', true);
			}
		}

		if (SONG.song == 'Ascension')
			{
				healthBarBG.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
			}

		if (curSong == 'AppleCore')
		{
			switch(curBeat)
			{
				case 223:
					FlxG.camera.flash(FlxColor.WHITE, 1);
					thierry.visible = true;
					trace('THIERRY ADDED');
					healthDrainBool = true;
				case 636:
					FlxG.camera.flash(FlxColor.BLACK, 3);
					updateHealthColor(0xFFffff52, bfHealthBar);
					iconP2.animation.play("pico", true);
					remove(bego);
					bego = new FlxSprite(-700, -200).loadGraphic(Paths.image('hellstage'));
					add(bego);
					bego.shader = testshader.shader;
					thierry.visible = false;
					remove(dad);
					dad = new Character(200, 400, 'pico');
					add(dad);
					trace('CHARACTER CHANGED!');
					shouldMuter = true;
				case 1068:
					shouldMuter = false;
					shouldMuterKeras = true;



				
			}
		}

		if (curSong == 'Nether')
			{
				switch(curBeat)
				{
					case 1:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 16, {ease: FlxEase.quadInOut});
						new FlxTimer().start(8 , function(tmr:FlxTimer)
							{
								defaultCamZoom = 0.9;
							});

					case 384:
						thierryChill = false;

					case 640:
						thierryChill = true;

	
	
	
	
					
				}
			}
	
		


		if (curSong == 'brutal')
		{
			switch(curBeat)
			{
				case 1:
					mati = true;
					healthBarBG.visible = false;
					healthBar.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;

				case 64:
					healthBarBG.visible = true;
					healthBar.visible = true;
					iconP1.visible = true;
					iconP2.visible = true;
					FlxG.camera.flash(FlxColor.WHITE, 2);
					thierry.visible = true;
					
					healthDrainBool = true;
					mati = false;
					jancok = true;
				case 255:
					healthDrainBool = false;
					mati = true;
					jancok = false;
					FlxG.camera.flash(FlxColor.WHITE, 1);
					StaticData.tunnelHasOpened = true;
					StaticData.tunnelOpen = true;
					trace(secondBG);
					secondBG.visible = true;
					remove(dad);
					thierry.visible = false;
					trace(dad.x);
					trace('THIERRY REMOCVED');
					FlxTween.tween(FlxG.camera, {zoom: 0.5}, 4, {ease: FlxEase.quadInOut});
					new FlxTimer().start(4 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 0.5;
						});
					
					
					//health = 0.01;
					/****/
				case 275:
					mati = false;
					remove(dad);
					iconP2.animation.play("badai", true);
					dad = new Character(-600, 0, 'badai');
					dad.setGraphicSize(0, 0);
					StaticData.badaiComesin = true;
					add(dad);

				case 289:
					FlxG.camera.flash(FlxColor.WHITE, 1);
					stupidFuckingRedBg.visible = true;
					

				/*case 434:
					FlxG.camera.flash(FlxColor.WHITE, 1);
					stupidFuckingRedBg.visible = false;
					StaticData.tunnelOpen = false;
					/****/
				case 517:
					healthDrainBool = true;
					thierry.setGraphicSize(720, 720);
					StaticData.expungedSinging = true;
					thierry.visible = true;
					iconP2.animation.play("bob-invis", true);
				case 676:
					StaticData.expungedSinging = false;
					iconP2.animation.play("badai", true);
				case 738 | 739 | 740:
					StaticData.expungedSinging = true;
					iconP2.animation.play("bob-invis", true);
				case 993 | 994 | 995 | 996 | 997:
					StaticData.expungedSinging = false;
					iconP2.animation.play("badai", true);
				case 1058 | 1059 | 1060 | 1061 | 1062:
					StaticData.expungedSinging = true;
					iconP2.animation.play("bob-invis", true);
				case 1507:
					FlxG.camera.flash(FlxColor.WHITE, 1);
					var loops:Int = 300;
					StaticData.expungedSinging = false;
					iconP2.animation.play("gw-3d", true);
					gwOppo = new Character(-600, -600, 'gw-3d');
					while (gwOppo.y < 0)
					{
						gwOppo.y += 2;
					}
					add(gwOppo);
					gwOppo.playAnim('idle', true);
					//im lazy please add myself later




				
			}
		}

		if (SONG.song == 'Captivity')
		{
			switch(curBeat)
			{
				case 392:
					FlxG.camera.flash(FlxColor.RED, 2);
					vignetteShader.visible = true;
					changeDad('cellMad', dad.x, dad.y);
					mati = true;
					//figure out how to change icon mid song with new icon system lul
					//icons were not even done yet so doesnt matter lol
					




				
			}
		}

		if (curSong == 'Unturned')
			{
				switch(curBeat)
				{
					case 354:
						StaticData.sartFade = true;
				}
	
			}

		if (curSong == 'segitiga')
		{
			switch(curBeat)
			{
				case 1:
					jancok = true;
					shouldMuter = true;
				case 647://647
					jancok = false;
					shouldMuter = false;
					FlxG.camera.flash(FlxColor.WHITE, 1);
					iconP2.animation.play("bob", true);
					remove(boyfriend);
					boyfriend = new Boyfriend(770, 450, 'bf');
					iconP1.animation.play("bf", true);
					add(boyfriend);
					remove(dad);
					dad = new Character(200, 150, 'bob');
					add(dad);
					//REST OF THE CODES ARE WRITTEN IN MODCHART
					
			}


		}

		if (curSong == 'trigometry')
		{
			switch(curBeat)
			{
				case 520://647
					DespawnNotes = true;
					
			}


		}

		if (SONG.song == 'Serpent')
		{
			switch(curBeat)
			{
				case 1:
					SONG.speed = 3;
					trace(SONG.speed);
				case 32:
					SONG.speed = 6.9;
					trace(SONG.speed);
				case 64:
					SONG.speed = 3;
					trace(SONG.speed);
				case 128:
					SONG.speed = 6.9;
					trace(SONG.speed);
				case 160:
					SONG.speed = 3;
					trace(SONG.speed);
				
			}
		}

		if (SONG.song == 'Tutorial')
		{
			switch(curBeat)
			{
				case 109://647
					trace("event fired lol");
					endSong();
						
			}
	
	
		}
	

		if (curSong == 'chaos')
			{

				switch(curBeat)
				{
					case 1:
						mati = true;
						jancok = true;
					case 255://647
						mati = false;
						jancok = false;
						jancokKalian = true;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						iconP2.animation.play("parents-christmas", true);
						updateHealthColor(0xFF6d3c3d, bfHealthBar);

						gwHasBeenAdded = true;
						gwwhat = new FlxSprite(dad.x, dad.y).loadGraphic(Paths.image('gw-3d'));

						remove(dad);
						dad = new Character(-200, 150, 'parents-christmas');
						add(gwwhat);
						add(dad);
						
						//REST OF THE CODES ARE WRITTEN IN MODCHART
						
				}
			}

		if (SONG.song == 'disarray')
		{
			switch(curBeat)
				{
					case 1:
						mati = true;
						jancok = true;
					case 255://647
						mati = false;
						jancok = false;
						jancokKalian = true;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						iconP2.animation.play("badai", true);
						updateHealthColor(0xFF6d3c3d, bfHealthBar);

						gwHasBeenAdded = true;
						gwwhat = new FlxSprite(dad.x, dad.y).loadGraphic(Paths.image('gw-3d'));

						remove(dad);
						dad = new Character(-200, 150, 'badai');
						add(gwwhat);
						add(dad);
						FlxTween.tween(FlxG.camera, {zoom: 0.5}, 8, {ease: FlxEase.quadInOut});
						new FlxTimer().start(8 , function(tmr:FlxTimer)
							{
								defaultCamZoom = 0.5;
							});
						
						//REST OF THE CODES ARE WRITTEN IN MODCHART
				}
		}

		if (SONG.song == 'Ferocious')
		{
			switch(curBeat)
				{
					case 828:
						remove(dad);
						dad = new Character(dad.x, dad.y, 'garrett-mad');
						add(dad);
				}
		}

		if (StaticData.secondDadAnim)
		{
			surgarDaddy.playAnim('idle');
		}

		if (curSong == 'Brute')
			{
				switch(curBeat)
				{
					case 256://607 //BAMBURG!!!!
						StaticData.theresSecondDad = true;
						FlxG.camera.flash(FlxColor.BLACK, 2);
						surgarDaddy = new Character(dad.x - 500, dad.y, 'bamburg');
						surgarDaddy.scale.set(0.7, 0.7);
						add(surgarDaddy);
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						ZoomCam(true, 1);
						StaticData.secondDadAnim = true;
					case 336:
						StaticData.secondDadAnim = false;
					case 365://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
					case 396://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
					case 431://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
					case 524://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
					case 526://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
					case 528://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 2;
						case 559://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						case 591://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
						case 608://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						case 616://all of this is just animation ycle dont be intimitaded
						StaticData.whoIsSinging = 2;
						case 620://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						case 719://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
						case 751://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						case 813://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
						case 847://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						case 879://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("badai", true);
						StaticData.whoIsSinging = 0;
						case 927://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						case 936://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 2;
						case 939://all of this is just animation ycle dont be intimitaded
						iconP2.animation.play("bamburg", true);
						StaticData.whoIsSinging = 1;
						

						
				}
	
	
			}

		if (curSong == 'anjing')
			{
				switch(curBeat)
				{
					case 328://607
					FlxG.camera.flash(FlxColor.WHITE, 2);
					remove(bego);
					bego = new FlxSprite(-700, -200).loadGraphic(Paths.image('stagemalem'));
					add(bego);
						//REST OF THE CODES ARE WRITTEN IN MODCHART
						
				}
	
	
			}

		if (curSong == 'meninggal') //BEAT = 4 STEP
			{

	
				switch(curBeat)//HEY UHHH, IF YOURE LOOKING TO EDIT ME, SPRITE COORDINATES ARE STORED IN STAGE, NOT IT BEAT CHECK!
				{
					case 336:
						jancok = true;

					case 1199:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						trace('CAMERA FLASHED!');

						remove(dad);
						dad = new Character(200, 400, 'pico');
						iconP2.animation.play("pico", true);
						add(dad);
						trace('CHARACTER CHANGED! AT ' + curBeat);
						updateHealthColor(0xFFffff52, bfHealthBar);
	
						gw.visible = true;
						thierry.visible = false;
						trace('STAGE CHANGED!');
					case 1455:

						FlxG.camera.flash(FlxColor.WHITE, 1);
						trace('CAMERA FLASHED!');

						remove(dad);
						dad = new Character(100, 100, 'bob');
						iconP2.animation.play("bob", true);
						add(dad);
						updateHealthColor(0xFFe30227, bfHealthBar);
						trace('CHARACTER CHANGED!');
	
						thierry.visible = true;
						gw.visible = false;
						trace('STAGE CHANGED!');
						trace('ICON CHANGED!');
					case 1584:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						trace('CAMERA FLASHED!');
						remove(dad);
						dad = new Character(200, 400, 'pico');
						iconP2.animation.play("pico", true);
						add(dad);
						updateHealthColor(0xFFffff52, bfHealthBar);
						trace('CHARACTER CHANGED!');
	
						gw.visible = true;
						thierry.visible = false;
						trace('STAGE CHANGED!');
					case 2095:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						trace('CAMERA FLASHED!');
						remove(dad);
						dad = new Character(100, 100, 'bob');
						iconP2.animation.play("bob", true);
						add(dad);
						trace('CHARACTER CHANGED!');
						updateHealthColor(0xFFe30227, bfHealthBar);
	
						thierry.visible = true;
						gw.visible = false;
						trace('STAGE CHANGED!');
						
					case 2352:
						if (FlxG.save.data.memoryTrace)
						{
							trace("internal transform executed");
						}
						blackScreen = new FlxSprite().makeGraphic(9999, 9999, FlxColor.BLACK);
						blackScreen.alpha = 0;
						add(blackScreen);
						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							blackScreen.alpha += 0.01;
						}, 200);
						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							healthDrainBool = false;
							boyfriend.visible = false;
							thierry.visible = false;
							gf.visible = false;
							dad.visible = false;
							blackScreen.visible = false;
							remove(blackScreen);
							remove(bego);
							bego = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							add(bego);
						});

						//DIP TO BLACK
					case 2419:

						
					case 2638:
						if (FlxG.save.data.memoryTrace)
						{
							trace("dad visible");
						}
						FlxG.camera.flash(FlxColor.BLACK, 3);
						dad.visible = true;
					case 2648:
						if (FlxG.save.data.memoryTrace)
						{
							trace("bf visible");
						}
						boyfriend.alpha = 0;
						boyfriend.visible = true;
						new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							boyfriend.alpha += 0.01;
						}, 100);
						
					case 2663:
						if (FlxG.save.data.memoryTrace)
						{
							trace("the weel;y thing");
						}
						boyfriend.alpha = 1;
						FlxG.camera.flash(FlxColor.WHITE, 2);
						boyfriend.visible = true;
						gf.visible = true;
						dad.visible = true;
						remove(bego);
						bego = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						add(bego);
					case 2792:
						boppersSpawned = true;
						FlxG.camera.flash(FlxColor.WHITE, 2);
						thierrySiang.visible = true;
						achell.visible = true;
						meksi.visible = true;
						raditz.visible = true;

						//THE CROWD CAME
					case 3212:
						FlxTween.tween(FlxG.camera, {zoom: 1.3}, 4, {ease: FlxEase.quadInOut});
						new FlxTimer().start(4 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 1.3;
						});
					case 3414:
						elonMusk = true;
						FlxG.camera.flash(FlxColor.WHITE, 2);
						meksi.visible = false;
						gw.visible = true;
						remove(dad);
						dad = new Character(-300, 100, 'parents-christmas');
						iconP2.animation.play("parents-christmas", true);
						add(dad);
						updateHealthColor(0xFF653537, bfHealthBar);
					case 3276:
						FlxTween.tween(FlxG.camera, {zoom: 0.9}, 8, {ease: FlxEase.quadInOut});
						new FlxTimer().start(8 , function(tmr:FlxTimer)
						{
							defaultCamZoom = 0.9;
						});

					case 3928:
						elonMusk = false;
						healthDrainBool = true;
						FlxG.camera.flash(FlxColor.WHITE, 2);
						remove(bego);
						bego = new FlxSprite(-600, -200).loadGraphic(Paths.image('stagesore'));
						add(bego);
						meksi.visible = true;
						thierrySiang.visible = false;
						remove(dad);
						dad = new Character(200, 400, 'pico');
						iconP2.animation.play("pico", true);
						add(dad);
						updateHealthColor(0xFFffff52, bfHealthBar);

					case 4593:
						FlxG.camera.flash(FlxColor.BLACK, 1);
						remove(bego);
						bego = new FlxSprite(-600, -200).loadGraphic(Paths.image('stagemalem'));
						add(bego);

					case 4952:
						healthDrainBool = false;
						FlxG.camera.flash(FlxColor.WHITE, 2);
						thierrySiang.visible = true;
						gw.visible = false;
						remove(dad);
						dad = new Character(100, 100, 'bob');
						iconP2.animation.play("bob", true);
						add(dad);
						updateHealthColor(0xFFe30227, bfHealthBar);
					case 5080:
						FlxG.camera.fade(FlxColor.BLACK, 4);





				}
			}

		
		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	private function checkForAchievement(achievesToCheck:Array<String>):String {
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName)) {
				var unlock:Bool = false;
				var trueunlock:Bool = false;
				switch(achievementName)
				{
					case 'week7_nomiss' | 'week6_nomiss' | 'week5_nomiss' | 'week3_nomiss' | 'week2_nomiss' | 'week1_nomiss':
						var weekName:String = curSong.toLowerCase(); // USE SONG DATA INSTEAD OF WEEK DATA LATER FOR EASIER PURPOSES
						switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
						{ // lmao yandere dev be like
							case 'cheat-blitar':
								if(achievementName == 'week7_nomiss')
								{
									unlock = true;//ending stuff
									trace("dahlah");
									FlxG.save.data.cheaterSongUnlocked = true;
								}
							case 'meninggal':
							/*case 'week2':
								if(achievementName == 'week2_nomiss') unlock = true;
							case 'week3':
								if(achievementName == 'week3_nomiss') unlock = true;
							case 'week4':
								if(achievementName == 'week4_nomiss') unlock = true;
							case 'week5':
								if(achievementName == 'week5_nomiss') unlock = true;
							case 'week6':
								if(achievementName == 'week6_nomiss') unlock = true;
							case 'week7':
								if(achievementName == 'week7_nomiss') unlock = true;
							/****/
							
						}
					case 'week4_nomiss':
						if (pressedSEVEN)
						{
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
				else if (trueunlock)
				{
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}

	function blackScreeneg() 
	{
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackScreen);

	}

	function dependencyBG() 
	{

	}

	function verycoalinternaltransition() 
	{
		boyfriend.visible = false;
		gf.visible = false;
		dad.visible = false;
		bego = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bego);
		remove(blackScreen);
	}

	public function updateHealthColor(dadColor:FlxColor, bfColor:FlxColor)
	{

		remove(healthBar);
		healthBar.createFilledBar(dadColor, bfColor);
		add(healthBar);
	}

	public function preload(graphic:String,datatype:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		


		if (datatype == 'Character')
		{
			var newthingy:Character = new Character(-200, 150, graphic);
			add(newthingy);
			remove(newthingy);
			
		}
		else if (datatype == 'FlxSprite')
		{
			var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
			add(newthing);
			remove(newthing);
		}
		else
		{
			trace("The datatype is not supported!, theres only two datatypes ; Character and FlxSprite, please fed me with the correct datatype!"); 
		}



		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}

	var curLight:Int = 0;

	


}