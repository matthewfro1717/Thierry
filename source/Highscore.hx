package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songAccs:Map<String, Int> = new Map();

	public static var canFlushWifeData:Bool = false;

	//rating
	public static var songMisses:Map<String, Int> = new Map();
	public static var songShits:Map<String, Int> = new Map();
	public static var songBads:Map<String, Int> = new Map();
	public static var songGoods:Map<String, Int> = new Map();
	public static var songSicks:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveAcc(song:String, acc:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songAccs.exists(daSong))
			{
				if (canFlushWifeData)
				{
					setAcc(daSong, acc);
				}
					
			}
			else
				setAcc(daSong, acc);
		}

		//RATING

		public static function saveMisses(song:String, misses:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songMisses.exists(daSong))
			{
				if (songMisses.get(daSong) > misses)
				{
					setMisses(daSong, misses);
					canFlushWifeData = true;
				}
					
			}
			else
				setMisses(daSong, misses);
		}

		public static function saveSicks(song:String, sicks:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songSicks.exists(daSong))
			{
				if (canFlushWifeData)
					setSicks(daSong, sicks);
			}
			else
				setSicks(daSong, sicks);
		}

		public static function saveGoods(song:String, goods:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songGoods.exists(daSong))
			{
				if (canFlushWifeData)
					setGoods(daSong, goods);
			}
			else
				setGoods(daSong, goods);
		}

		public static function saveBads(song:String, bads:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songBads.exists(daSong))
			{
				if (canFlushWifeData)
					setBads(daSong, bads);
			}
			else
				setBads(daSong, bads);
		}

		public static function saveShits(song:String, shits:Int = 0, ?diff:Int = 0):Void
		{
			var daSong:String = formatSong(song, diff);
	
			if (songShits.exists(daSong))
			{
				if (canFlushWifeData)
					setShits(daSong, shits);
			}
			else
				setShits(daSong, shits);
		}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setAcc(song:String, acc:Int):Void
	{
		// what
		songAccs.set(song, acc);
		FlxG.save.data.songacc = songAccs;

		FlxG.save.flush();
	}

	static function setMisses(song:String, miss:Int):Void
	{
		// what
		songMisses.set(song, miss);
		FlxG.save.data.songmiss = songMisses;

		FlxG.save.flush();
	}

	static function setSicks(song:String, sicks:Int):Void
	{
		// what
		songSicks.set(song, sicks);
		FlxG.save.data.songsicks = songSicks;

		FlxG.save.flush();
	}

	static function setGoods(song:String, goods:Int):Void
	{
		// what
		songGoods.set(song, goods);
		FlxG.save.data.songgoods = songGoods;

		FlxG.save.flush();
	}

	static function setBads(song:String, bads:Int):Void
	{
		// what
		songBads.set(song, bads);
		FlxG.save.data.songbads = songBads;

		FlxG.save.flush();
	}

	static function setShits(song:String, shits:Int):Void
	{
		// what
		songShits.set(song, shits);
		FlxG.save.data.songshits = songShits;

		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getAcc(song:String, diff:Int):Int
	{
		if (!songAccs.exists(formatSong(song, diff)))
			setAcc(formatSong(song, diff), 0);

		return songAccs.get(formatSong(song, diff));
	}

	public static function getMisses(song:String, diff:Int):Int
	{
		if (!songMisses.exists(formatSong(song, diff)))
			setMisses(formatSong(song, diff), 0);

		return songMisses.get(formatSong(song, diff));
	}

	public static function getSicks(song:String, diff:Int):Int
	{
		if (!songSicks.exists(formatSong(song, diff)))
			setSicks(formatSong(song, diff), 0);

		return songSicks.get(formatSong(song, diff));
	}

	public static function getGoods(song:String, diff:Int):Int
	{
		if (!songGoods.exists(formatSong(song, diff)))
			setGoods(formatSong(song, diff), 0);

		return songGoods.get(formatSong(song, diff));
	}

	public static function getBads(song:String, diff:Int):Int
	{
		if (!songBads.exists(formatSong(song, diff)))
			setBads(formatSong(song, diff), 0);

		return songBads.get(formatSong(song, diff));
	}

	public static function getShits(song:String, diff:Int):Int
	{
		if (!songShits.exists(formatSong(song, diff)))
			setShits(formatSong(song, diff), 0);

		return songShits.get(formatSong(song, diff));
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null) { songScores = FlxG.save.data.songScores; }
		if (FlxG.save.data.songmiss != null) { songMisses = FlxG.save.data.songmiss; }
		if (FlxG.save.data.songacc != null) { songAccs = FlxG.save.data.songacc; }
		if (FlxG.save.data.songsicks != null) { songSicks = FlxG.save.data.songsicks; }
		if (FlxG.save.data.songgoods != null) { songGoods = FlxG.save.data.songgoods; }
		if (FlxG.save.data.songbads != null) { songBads = FlxG.save.data.songbads; }
		if (FlxG.save.data.songshits != null) { songShits = FlxG.save.data.songshits; }

	}
}
