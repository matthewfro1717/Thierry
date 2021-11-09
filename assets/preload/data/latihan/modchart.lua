local shakeSceen
-- this gets called starts when the level loads.
 function setDefault(id)

 end
 
 
 function start(song) -- arguments, the song name
 
 end
 
 -- this gets called every frame
 function update(elapsed) -- arguments, how long it took to complete a frame
    local currentBeat = (songPos / 1000)*(bpm/60)
     if shakeSceen then
         for i=0,7 do
             setHudPosition(8 * math.sin((currentBeat * 15 + i*0.25) * math.pi), 8 * math.cos((currentBeat * 15 + i*0.25) * math.pi))
             setCamPosition(8 * math.sin((currentBeat * 15 + i*0.25) * math.pi), 8 * math.cos((currentBeat * 15 + i*0.25) * math.pi))
         end
     end
 
 end
 
 -- this gets called every beat
 function beatHit(beat) -- arguments, the current beat of the song
     
 end
 
 -- this gets called every step
 function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)
 
     if step == 768 then --STREAM START
         shakeSceen = true
    end
     if step == 1024 then --STREAM STOP
         shakeSceen = false
     end
     if step == 1280 then --STREAM START
         shakeSceen = true
     end
     if step == 1536 then --STREAM STOP
         shakeSceen = false
     end
     if step == 2048 then --STREAM START
         shakeSceen = true
     end
     if step == 2304 then --STREAM STOP
         shakeSceen = false
     end
 end