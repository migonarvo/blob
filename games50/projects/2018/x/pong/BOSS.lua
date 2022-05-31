--[[ This is the BOSS for the paddles. Based on taping
 myself playing against the BOSS (and, honestly, on my
 experience playing online games), I think they should
 have a "personality", reflected on what I
 think to be the qualitative aspects that can be shown
 through gameplay:
 skill
 sass
 no sass and no skill: boringly easy
 sass and no skill: goofy
 no sass and skill: robotic, respectful
 sass and skill: disrespect, more humanlike
 skill is reflected upon the chances that the ai reflects
 

 sass is reflected by risks taken, and disrespect given.
 To take its risks, the ai has to have a moveset of sorts.
 it can either be: goofing around (goof),
                   following the ball (follow),
                   predicting the ball's position(predict),
                   clutching the hit (clutch),`

 but it should also be capable of modifying its behaviour
 depending on the score, so the probability of each action
 taken should vary if it's losing or winning. 

 Also, goofing around should be followed up by clutching the
 hit every time. This would add to the skill and sass percieved.
 A sore but skillful winner would be easier to program with a modifying behaviour
 because it is disrespectful when it wins and tries to be
 pure skill when it loses:
let 
    ai = sore winner ; p1 = human player

    if(ai.score>p1.score) then
        goof
        clutch
        follow
        predict
    elseif(ai.score<p1.score) then
        predict
        follow

this could be extended to losing by a little or a lot, viceversa
where 'a' is some arbitrary constant defining what is a lot
    if(ai.score>p1.score) then
        goof
        clutch
        follow
        predict
    elseif(ai.score<p1.score) then
        predict
        follow

    elseif(ai.score>p1.score + a) then
        goof
        clutch
        follow
        predict
    elseif(ai.score<p1.score - a) then
        predict
        follow

but this constant could also be enriched by some arbitrary set of percentages,
which i think would feel more natural because of the varying changes.

so we could define pToMp(player) = 10 - player.score as the points left to the matchpoint.
and aiP = pToMp(ai); p1P = pToMp(ai)
which adds to the importance of by how much the ai is losing
then, the easiest thing to do is a probability based state machine 

    ]]


BOSS = Class{}

function BOSS:init(player, ball, PADDLE_SPEED,playerScore,otherScore,dt)
    self.player = player
    self.ball = ball
    self.PADDLE_SPEED = PADDLE_SPEED
    


end

function BOSS:update(player,ball,PADDLE_SPEED,playerScore,otherScore,dt)
    approaching = (ball.dx*(player.x - 30)>0)
    winning = false
    if not zawarudo then
        
        zawarudo = 0
    end
    
    
    if approaching then
        zawarudo = zawarudo + dt --saves the total time the object has been approaching for


        if winning then
            --p = math.random(1000)
                      
            if math.abs(- ball.x + player.x) > 7*VIRTUAL_WIDTH/10 and math.pow(ball.dx,2) < math.pow(PADDLE_SPEED,2)  then
                BOSS:goof(player,PADDLE_SPEED,dt)
            elseif math.abs(- ball.x + player.x) < 8*VIRTUAL_WIDTH/10 and (math.pow(ball.dx,2) > 2*math.pow(PADDLE_SPEED,2) or (VIRTUAL_HEIGHT/2 - 2 - ball.y)*math.abs(ball.dy) > (PADDLE_SPEED*(VIRTUAL_HEIGHT/2 - 2 - player.y))) then
                
                BOSS:follow(player,ball,PADDLE_SPEED,dt)
                
            elseif math.abs(- ball.x + player.x) > 4*VIRTUAL_WIDTH/10 then
                BOSS:serious_goof(player,PADDLE_SPEED,dt)
            elseif math.abs(- ball.x + player.x) < 5*VIRTUAL_WIDTH/10 or math.abs(ball.y - VIRTUAL_HEIGHT*1.5 - 2)>math.abs(player.y - VIRTUAL_HEIGHT*1.4 - 2) then
                BOSS:follow(player,ball,PADDLE_SPEED,dt)
            
                
            
                
            end
        else 
            
                BOSS:follow(player,ball,PADDLE_SPEED,dt)
            --BOSS:predict(player,ball,PADDLE_SPEED,dt)
        end

    elseif not approaching then
        zawarudo = 0
        if winning then
            
            BOSS:goof(player,PADDLE_SPEED,dt) --they goof
        
        else
            BOSS:follow(player,ball,PADDLE_SPEED,dt)
            --BOSS:resetPos(player,ball,200,dt) --modo serio
        end
    end
end


function BOSS:resetPos(player,ball,PADDLE_SPEED,dt)
    
    if (VIRTUAL_HEIGHT/2 - 2) > player.y+ 10 then
        player.dy = PADDLE_SPEED
    elseif (VIRTUAL_HEIGHT/2 - 2)<player.y-10 then
        player.dy = -PADDLE_SPEED
    else
        player.dy = 0
    end 
    
end

function BOSS:goof(player,PADDLE_SPEED,dt)

    if not deltime then
        deltime = dt
        randPos = math.random(-20,20)
    end
    deltime = deltime + dt
    if deltime > 20/60 then
        randPos = math.random(-80,80)
    end
    if ((VIRTUAL_HEIGHT/2 + randPos) < player.y - 10) then
        player.dy = -PADDLE_SPEED
        deltime = 0
        
    elseif (VIRTUAL_HEIGHT/2 - 4 + randPos) > player.y - 10 then
        player.dy = PADDLE_SPEED
        deltime = 0
        

    else
        player.dy = 0   
    end
    
    
    
    
     
end
function BOSS:serious_goof(player,PADDLE_SPEED,dt) 

    if not deltime then
        deltime = 0
    end
    deltime = deltime + dt
    
    if deltime >15/60 and randPos then
        randPos = math.random(-10,10)

        if ((ball.y - 2 + randPos) > player.y - 10) then
            player.dy = PADDLE_SPEED
            
        elseif (ball.y - 2 + randPos)<player.y - 10 then
            player.dy = -PADDLE_SPEED
            
    
        else
            player.dy = 0
            
        end
        deltime = 0

    elseif not randPos then
        randPos = math.random(-16,16)
    end
    
    
    
     
end
function BOSS:follow(player,ball,PADDLE_SPEED,dt)
    --player.dy = PADDLE_SPEED
    if (player.y < ball.y - 4 ) then
        player.dy = PADDLE_SPEED
    elseif (player.y > ball.y) then
        player.dy = -PADDLE_SPEED
    else
        player.dy = 0

    end

end




