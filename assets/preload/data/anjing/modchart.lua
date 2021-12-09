function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
end


function update (elapsed) -- examp16 https://twitter.com/KadeDeveloper/status/1382178179184422918
	local currentBeat = (songPos / 16000)*(bpm/120)
	for i=0,7 do
		setActorX(_G['defaultStrum'..i..'X'] + 69 * math.sin((currentBeat + i*3) * math.pi), i)
		setActorY(_G['defaultStrum'..i..'Y'] + 36 * math.cos((currentBeat + i*3) * math.pi) + 10, i)
	end

end

function beatHit (beat)
   -- do nothing
end

function stepHit (step)
	-- do nothing
end

print("Mod Chart script loaded :)")