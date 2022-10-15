local SpinCW
local SpinCC

function start (song)
   print("Modchart loaded!")
   
end


function update (elapsed)
   local currentBeat = (songPos / 1000)*(bpm/60)
   local currentBeatBiased = (songPos / 2000)*(bpm / 180)
   if (spinny) then
      for i=0,7 do
			setActorAngle(getActorAngle(i) + 0.5, i)
		end
   end

   if (NotesGoBrr) then
      for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10,i)
      end     
   end

   if (HudShake) then
      for i=0,7 do
         setHudPosition(6 * math.sin((currentBeatBiased * 15 + i*0.25) * math.pi), 6 * math.cos((currentBeatBiased * 12 + i*0.25) * math.pi))
      end 
   end


   if (SpinCW) then
      if (camHudAngle <= 359) then
         camHudAngle = camHudAngle + 10
      end
   end

   if (SpinCC) then
      if (camHudAngle >= 1) then
         camHudAngle = camHudAngle - 10
      end
   end


end

function beatHit (beat)
   
   if (lesgoo) then
      setCamZoom(1)
   end
   if (CatJam) then
      setCamZoom(2)
   end
   -- do nothing
end

function stepHit (step)
   if (step == 129) then
      lesgoo = true
   end
	if (step == 144) then
      SpinCW = true
   end
   if (step == 160) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 385) then
      lesgoo = false
      CatJam = true
      NotesGoBrr = true
   end
   if (step == 640) then
      CatJam = false
      NotesGoBrr = false
   end
   if (step == 673) then
      HudShake = true
      lesgoo = true
   end
   if (step == 928) then
      NotesGoBrr = true
   end
   if (step == 1184) then
      NotesGoBrr = false
      lesgoo = false
      HudShake = false
      
   end
   if (step == 1345) then
      lesgoo = true
      
   end
   if (step == 1601) then
      spinny = true
      NotesGoBrr = true
      
   end
   if (step == 1729) then
      spinny = false
      NotesGoBrr = false
      lesgoo = false
      
   end
   if (step == 1857) then
      spinny = true
      NotesGoBrr = true
      lesgoo = true
      HudShake = true
      SpinCW = true
   end
   if (step == 1889) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 1917) then
      SpinCW = true
      SpinCC = false
   end
   if (step == 1984) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 2017) then
      SpinCW = true
      SpinCC = false
   end
   if (step == 2044) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 2113) then
      SpinCW = true
      SpinCC = false
   end
   if (step == 2145) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 2173) then
      SpinCW = true
      SpinCC = false
   end
   if (step == 2241) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 2273) then
      SpinCW = false
      SpinCC = true
   end
   if (step == 2301) then
      SpinCW = true
      SpinCC = false
   end
   if (step == 2301) then
      SpinCW = false
      SpinCC = true
      spinny = false
      NotesGoBrr = false
      lesgoo = false
      HudShake = false
   end

end