local condom

function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
end


function update (elapsed) -- example https://twitter.com/KadeDeveloper/status/1382178179184422918
	local currentBeat = (songPos / 1000)*(bpm/60)
    if (condom) then
        for i=0,7 do
            setHudPosition(8 * math.sin((currentBeat * 15 + i*1.75) * math.pi), 8 * math.cos((currentBeat * 15 + i*1.75) * math.pi))
			setCamPosition(8 * math.sin((currentBeat * 15 + i*1.75) * math.pi), 8 * math.cos((currentBeat * 15 + i*1.75) * math.pi))
		end  
    end

end

function beatHit (beat)
   -- do nothing
end

function stepHit (step)
	if (step == 23) or (step == 27) or (step == 31) or (step == 1721) or (step == 1724) or (step == 1727) or (step == 1734) or (step == 1735) or (step == 1737) then
        setCamZoom(2)

    end
    if (step == 391) or (step == 1269) or (step == 1311) or (step == 1359) or (step == 1406) or (step == 1446) then
        condom = true;
    end
    if (step == 414) or (step == 1292) or (step == 1334) or (step == 1382) or (step == 1439) or (step == 1634) then
        condom = false;
    end

end

print("Mod Chart script loaded :)")
-- PS. SOME CODES ARE IN PLAYSTATE