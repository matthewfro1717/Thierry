local camZooming = false

function start (song) -- statr of the song

end


function update (elapsed) -- every frame

    if (camZooming) then
        
    end
end

function beatHit (beat) -- every beat (1/4 of a step)

    if (curBeat == 2352) then
        showOnlyStrums = true
    end
    if (curBeat == 2638) then
        showOnlyStrums = false
    end
    if (curBeat == 2663 or curBeat == 2792) then
        setCamZoom(2)
    end
    if (curBeat == 3181) then
        camZooming = true
    end
    
end

function stepHit (step) -- every step
	-- do nothing
end