local distrupt

function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
end


function update (elapsed) -- examp16 https://twitter.com/KadeDeveloper/status/1382178179184422918
	local currentBeat = (songPos / 16000)*(bpm/60)
    if (distrupt) then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 69 * math.sin((currentBeat + i*3) * math.pi), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 36 * math.cos((currentBeat + i*3) * math.pi) + 10, i)
        end 
    end


end

function beatHit (beat)
    if (beat == 223) then
	   distrupt = true
    end
    if (beat == 635) then
        distrupt = false
    end
end

function stepHit (step)
	-- do nothing
end

print("Mod Chart script loaded :)")