function start (song) -- statr of the song
    print("Modchart loaded!")
    bg = makeSprite('bg','sekolahBelakang', true)
    setActorX(69,'sekolahBelakang') -- RIGHT = X LOWER | -- LEFT = Y UPPER
	setActorY(240,'sekolahBelakang') -- UP = Y LOWER | -- DOWN = y UPPER
    setActorAlpha(0,'sekolahBelakang')
	setActorScale(2,'sekolahBelakang')
end


function update (elapsed) -- every frame

end

function beatHit (beat) -- every beat (1/4 of a step)
    if (beat == 96) then
        setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 10,i)
    end
    if (beat == 607) then
        setActorAlpha(1,'sekolahBelakang')
        --REST OF THE CODES ARE IN PLAYSTATE.HX
    end
end

function stepHit (step) -- every step
	-- do nothing
end