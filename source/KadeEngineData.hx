import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = false;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = true;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 0;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.epico == null)
			FlxG.save.data.epico = false;
		
		if (FlxG.save.data.among == null)
			FlxG.save.data.among = false;

		if (FlxG.save.data.mailcat == null)
			FlxG.save.data.mailcat = false; //TODO : FIND A WAY TO DIFFERENTIATE SETTINGS KADE ENGINE OK???

		if (FlxG.save.data.ilang == null)
			FlxG.save.data.ilang = true; //TODO : FIND A WAY TO DIFFERENTIATE SETTINGS KADE ENGINE OK???

		if (FlxG.save.data.tolol == null)
			FlxG.save.data.tolol = true; //TODO : DO SOME BACKGROUND CHEKCING FORL IKE THE DEFAULT VAUES AND SHOT
		
		if (FlxG.save.data.merg == null)
			FlxG.save.data.merg = true; //TODO : DO SOME BACKGROUND CHEKCING FORL IKE THE DEFAULT VAUES AND SHOT

				
		if (FlxG.save.data.kebal == null)
			FlxG.save.data.kebal = false; //TODO : DO SOME BACKGROUND CHEKCING FORL IKE THE DEFAULT VAUES AND SHOT

		if (FlxG.save.data.achievementsMap == null)
			FlxG.save.data.achievementsMap = Achievements.achievementsMap;

		if (FlxG.save.data.willSeeCrashEnding == null)
			FlxG.save.data.willSeeCrashEnding = false;

		if (FlxG.save.data.hasSeenCrashEnding == null)
			FlxG.save.data.hasSeenCrashEnding = false;

		if (FlxG.save.data.shouldHearAmbience == null)
			FlxG.save.data.shouldHearAmbience = true;

		if (FlxG.save.data.spong == null)
			FlxG.save.data.spong = true;
		
		if (FlxG.save.data.hitSounds == null)
			FlxG.save.data.hitSounds = false;
		

		Conductor.recalculateTimings();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}
