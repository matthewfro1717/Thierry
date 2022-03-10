package;

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
import aeroshide.Maths.*;
import Achievements;

#if windows
import Discord.DiscordClient;
#end
#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class IconBounceState extends MusicBeatState
{

    private var masterIcon:HealthIcon;
    private var frame:Int;
    private var intensity:Float = 1;
    private var freq:Int = 69;
    private var gui:FlxText;
    private var curSelectedChar:Int = 33;

    override function create() 
    {
        masterIcon = new HealthIcon("IBT", true);
        masterIcon.screenCenter();
        add(masterIcon);

        Conductor.bpm = 100;

        gui = new FlxText(0, 100 + 36, FlxG.width, "", 20);
		gui.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		gui.scrollFactor.set();
		gui.screenCenter(X);
		add(gui);

        gui.visible = false;
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        frame++;
        masterIcon.setGraphicSize(Std.int(FlxMath.lerp(150, masterIcon.width, 0.8)),Std.int(FlxMath.lerp(150, masterIcon.height, 0.8)));
        masterIcon.updateHitbox();

        masterIcon.animation.curAnim.curFrame = curSelectedChar;

        gui.text = "INTENSITY = " + truncateFloat(intensity, 2) + " | FREQUENCY = " + freq + " | MASTERCODE = " + curSelectedChar;



        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
        }

        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.play(Paths.sound('click'));
            if (gui.visible)
            {
                gui.visible = false;
            }
            else if (!gui.visible)
            {
                gui.visible = true;
            }
        }

        // INTENSITY SLIDER
        if (FlxG.keys.justPressed.RIGHT)
        {
            intensity = intensity + 0.01;
            gui.visible = true;
            FlxG.sound.play(Paths.sound('click'));
        }
        else if (FlxG.keys.justPressed.LEFT)
        {
            intensity = intensity - 0.01;
            gui.visible = true;
            FlxG.sound.play(Paths.sound('click'));
        }

        // FREQUENCY SLIDER
        if (FlxG.keys.justPressed.UP)
        {
            freq++;
            gui.visible = true;
            FlxG.sound.play(Paths.sound('click'));
        }
        else if (FlxG.keys.justPressed.DOWN)
        {
            freq--;
            gui.visible = true;
            FlxG.sound.play(Paths.sound('click'));
        }

         //CHARACTER SLIDER
        if (FlxG.keys.justPressed.A)
        {
            curSelectedChar++;
            
            changeChar();
            FlxG.sound.play(Paths.sound('click'));
        }
        else if (FlxG.keys.justPressed.D)
        {
            curSelectedChar--;
            changeChar();
            FlxG.sound.play(Paths.sound('click'));
        }



        if (frame % freq == 0)
        {
            masterIcon.setGraphicSize(Std.int(masterIcon.width + (50 * (2 - intensity))),Std.int(masterIcon.height - (25 * (2 - intensity))));
            masterIcon.updateHitbox();

            if (FlxG.save.data.memoryTrace)
                {
                    trace("curBeat " + curBeat);
                    trace("curStep " + curStep);
                    trace("currentBPM " + Conductor.bpm);
        
                }
        }



    }

    function changeChar()
        {
            
        }


    override function beatHit()
        {
            super.beatHit();
    
        

            
            
           
            
        }



}