package aeroshide;

import openfl.events.Event;
import openfl.system.System;
import haxe.SysTools;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 * Edited by Aeroshide to make converting Bytes to Megabytes very accurate
 */

class MemoryCounter extends TextField
{
	private var times:Array<Float>;
	private var memPeak:Float = 0;
	
	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();

		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 12, inCol);

		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;
	}

	private function onEnter(_)
	{	
        var AccurateMB:Int = 524288; // this is 2^19
		var mem:Float = Math.round(System.totalMemory / AccurateMB);
		if (mem > memPeak) memPeak = mem;

		if (visible)
		{	
			text = "\nMemory Usage: " + mem + " MB\nMemory Peak: " + memPeak + " MB";	
		}
	}
}