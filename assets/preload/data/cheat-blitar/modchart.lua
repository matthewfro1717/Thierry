-- this gets called starts when the level loads.
function start(song) -- arguments, the song name
    print("modchart loaded!")
    for i=0,3 do -- fade out the first 4 receptors (the ai receptors)
		tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 725,getActorAngle(i) - 980, 0.6, 'setDefault')
    end
    for i = 4, 7 do -- go to the center
        tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 625,getActorAngle(i) + 880, 0.6, 'setDefault')
    end

end

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

-- this gets called every frame
function update(elapsed) -- arguments, how long it took to complete a frame
    local currentBeat = (songPos / 2000)*(bpm / 180)
    if distortion then
        for i=0, 7 do -- HOW IT WORKS!!! (['defaultStrum'..i..'Y'] - (INTENSITY) * (HOW FAST IT WILL DO STRUM) * (STRUMPOSITION)
            setActorY(_G['defaultStrum'..i..'Y'] - 32 * math.cos((currentBeat + i*5) * math.pi) + 10,i)
            setActorX(_G['defaultStrum'..i..'X'] - 20 * math.sin((currentBeat + i*0.25) * math.pi),i)
            
            setHudPosition(6 * math.sin((currentBeat * 15 + i*0.25) * math.pi), 6 * math.cos((currentBeat * 12 + i*0.25) * math.pi))


        end
        for i=0,3 do -- fade out the first 4 receptors (the ai receptors)
            
        end
        for i = 4, 7 do -- go to the center
            
        end
    end
end

-- this gets called every beat
function beatHit(beat) -- arguments, the current beat of the song

end

-- this gets called every step
function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)
    if step == 1 then
        distortion = true
    end
    if step == 2560 then
        distortion = false
    end
end