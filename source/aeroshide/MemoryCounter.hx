package aeroshide;

import openfl.events.Event;
import openfl.system.System;
import haxe.SysTools;
import openfl.text.TextField;
import openfl.text.TextFormat;
import aeroshide.Maths;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 * Edited by Aeroshide to make converting Bytes to Megabytes very accurate
 */

class MemoryCounter extends TextField
{
	private var times:Array<Float>;
	private var memPeak:Float = 0;

	var overflow:Bool = false;
	
	public function new(inX:Float = 10.0, inY:Float = 15.0, inCol:Int = 0x000000) 
	{
		super();

		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 16, inCol, true);

		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 200;
		height = 70;
	}

	private function onEnter(_)
	{	
        var AccurateMB:Int = 524288; // this is 2^19
		var AccurateGB:Int = 1024; //MB to GB
		var mem:Float = Math.round(System.totalMemory / AccurateMB);
		var memGB:Float = mem / AccurateGB;
		if (mem > memPeak) memPeak = mem;

		if (mem < 0)
		{
			overflow = true;
		}

		//Intieger catcher

		if (visible)
		{	
			if (mem < 0 || overflow) // 8000
			{
				text = "\nMemory Usage: " + (Maths.truncateFloat(memGB + 2, 2)) + " GB";
			}
			else if (mem > 1000)
			{
				text = "\nMemory Usage: " + Maths.truncateFloat(memGB, 2) + " GB";
			}
			else if (mem < 1000)
			{
				text = "\nMemory Usage: " + mem + " MB";
			}
				
		}
	}
}