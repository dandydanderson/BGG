var buffer = argument[0];
var msgId = buffer_read(buffer, buffer_u8);//find the tag

switch(msgId)
{
    case 1://latency response
        var time = buffer_read(buffer, buffer_u32);//read in the time from the server
        latency = current_time - time;//update our latency
    break;
    
    case 2://registration response
        var response = buffer_read(buffer, buffer_u8);
        
        switch(response)
        {
            case 0://failure
                scr_showNotification("Registration failed! Username already exists!");
            break;
            
            case 1://success
                room_goto(rm_mainMenu);
            break;
        }
    break;
    
    case 3://login response
        var response = buffer_read(buffer, buffer_u8);
        
        switch(response)
        {
            case 0://failure
                scr_showNotification("Login failed! Username doesn't exist or password is incorrect!");
            break;
            
            case 1://success
                room_goto(rm_mainMenu);
            break;
        }
    break;
    
    case 4://player ID response
        global.playerId = buffer_read(buffer, buffer_u32);
        scr_showNotification("Our playerId has been received!");
    break;
    
    case 5://remote player disconnect response
        var pId = buffer_read(buffer, buffer_u32);
        with (obj_remoteplayer)
        {
            if (remotePlayerId == pId)
            {
                instance_destroy();
            }
        }
    break;
    
    case 6://room change response
        var pId = buffer_read(buffer, buffer_u32);
        var pName = buffer_read(buffer, buffer_string);
        
        var instance = noone;

        with (obj_remoteplayer)
        {
            if (remotePlayerId == pId)
            {
                instance = id;
            }
        }
        
        if (instance == noone)//if this player doesn't yet exist
        {
            //only if we exist in the gameworld
            if (instance_exists(obj_localplayer))
            {
                //create a remote player
                var remotePlayer = instance_create(room_width/2, room_height/2, obj_remoteplayer);
                remotePlayer.remotePlayerId = pId;
                remotePlayer.remotePlayerName = pName;
            }
        }
        else//otherwise destroy this player as he/she is leaving
        {
            with (instance)
            {
                instance_destroy();
            }
        }
    break;
    
    case 7://player movement update response
        var pId = buffer_read(buffer, buffer_u32);
        var xx = buffer_read(buffer, buffer_f32);
        var yy = buffer_read(buffer, buffer_f32);
        var sprNumber = buffer_read(buffer, buffer_u8);
        var imageIndex = buffer_read(buffer, buffer_u8);
       var abilCast = buffer_read(buffer, buffer_u8);
        var facing = buffer_read(buffer, buffer_u8);
        
        
        with (obj_remoteplayer)
        {
            if (remotePlayerId == pId)
            {
                x = xx;
                y = yy;
                
                switch (sprNumber)
                {//movement
                case 0:
                    sprite_index = spr_heroright;
                break;
                
                case 1:
                    sprite_index = spr_heroback;
                break;
                
                case 2:
                    sprite_index = spr_heroleft;
                break;
                
                case 3:
                    sprite_index = spr_herofront;
                break;
                //casting
                case 4:
                    sprite_index = spr_castright;
                break;
                
                case 5:
                    sprite_index = spr_castup;
                break;
                
                case 6:
                    sprite_index = spr_castleft;
                break;
                
                case 7:
                    sprite_index = spr_castdown;
                break;
            }
            
            image_index = imageIndex;
        }
        
         switch (facing)
           {
           case 0: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx + 32, yy);
                obj_fireball.direction = 0;
                obj_fireball.image_angle = 0;
                }
           break;
           
           case 1: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx, yy - 64);
                obj_fireball.direction = 90;
                obj_fireball.image_angle = 90;
                }
           break;
           
           case 2: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx - 32, yy);
                obj_fireball.direction = 180;
                obj_fireball.image_angle = 180;
                }
           break;
           
           case 3: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx, yy + 64);
                obj_fireball.direction = 270;
                obj_fireball.image_angle = 270;
                }
           break;
           }
    break;
    
    
}


    
           switch (facing)
           {
           case 0: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx + 32, yy);
                obj_fireball.direction = 0;
                obj_fireball.image_angle = 0;
                }
           break;
           
           case 1: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx, yy - 64);
                obj_fireball.direction = 90;
                obj_fireball.image_angle = 90;
                }
           break;
           
           case 2: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx - 32, yy);
                obj_fireball.direction = 180;
                obj_fireball.image_angle = 180;
                }
           break;
           
           case 3: 
            if (abilCast == 1)
                {
                instance_create(obj_fireball, xx, yy + 64);
                obj_fireball.direction = 270;
                obj_fireball.image_angle = 270;
                }
           break;
           }
        
    break;
}
