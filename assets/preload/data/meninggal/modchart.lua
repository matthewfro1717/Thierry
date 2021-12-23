local banger = true

function start (song) -- statr of the song

end


function update (elapsed) -- every frame


end

function beatHit (beat) -- every beat (1/4 of a step)
    if (curBeat == 145) then
        banger = false
    end
    if (banger) then
        if (curBeat % 4 == 0) then
            setCamZoom(0.2)
        end
    end

    
end

function stepHit (step) -- every step
	-- do nothing
end