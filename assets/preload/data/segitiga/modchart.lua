local Joe = true

function start (song) -- statr of the song
    print("Modchart loaded!")
    bg = makeSprite('bg','sekolahBelakang', true)
    setActorX(69,'sekolahBelakang') -- RIGHT = X LOWER | -- LEFT = Y UPPER
	setActorY(240,'sekolahBelakang') -- UP = Y LOWER | -- DOWN = y UPPER
    setActorAlpha(0,'sekolahBelakang')
	setActorScale(2,'sekolahBelakang')
end


function update (elapsed) -- every frame
	local currentBeat = (songPos / 1000)*(bpm/60)
    if (Joe) then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 16 * math.sin((currentBeat + i*0.25) * math.pi), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 16 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end

end

function beatHit (beat) -- every beat (1/4 of a step)
    if (beat == 1) then
        Joe = true
    end
    if (beat == 647) then
        setActorAlpha(1,'sekolahBelakang')
        Joe = false
        --REST OF THE CODES ARE IN PLAYSTATE.HX
    end
end

function stepHit (step) -- every step
	-- do nothing
end