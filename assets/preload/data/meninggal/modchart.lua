local banger = true

function start (song) -- statr of the song

end


function update (elapsed) -- every frame


end

function beatHit (beat) -- every beat (1/4 of a step)

    if (curBeat == 2352) then
        showOnlyStrums = true
    end
    if (curBeat == 2638) then
        showOnlyStrums = false
    end
    
end

function stepHit (step) -- every step
	-- do nothing
end