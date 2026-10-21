# Scream Jam

## Concept
A horror game where you try to play a top-down roguelike game while the backseater (monster), keeps trying to attack you in the real world. Each day you play a different level but the core gameplay is the same, but each day will take more settings away from you that make playing the game more difficult, while the backseater is gets more aggessive every day by attacking more frequently. Dying in the roguelike will cause a spike in aggression, and make the backseater attack much more frequently until threshold will they become unable to be stopped. The player must survive the attacks from the backseater for 5 minutes for 4 nights.

The roguelike part is a very simple top-down roguelike where mobs of enemies spawn from offscreen and swarm the player, the player can earn XP from killing enemies and gain levels to choose what stat to level up. Each day will have a different backdrop, and different enemy sets, but the mechanics will be the same, just different settings that limit the aspect of it.

**Night 1**: Normal gameplay, the backseater will never appear but the player is given the tutorial on the controls, and including the opportunity to leave the game and look around in the room. Future sound cues will be used here as well occasionally to prepare the player to look out for those and check them. The backseater will also be introduced here by sending messages occasionally throughout gameplay.

**Night 2**: Music and Sounds are removed, the backseater will begin to attack while also sending more messages in gameplay. The excuse the backseater has for disabling sound and music is that having them is not optimal as it takes focus away from the game, therefore they disabled it for you.

**Night 3**: Resolution of the game is reduced significantly, the backseater will also begin to send even more messages that cover an even bigger portion of the screen due to the smaller resolution. The excuse the backseater has for reducing resolution is that playing on a smaller resolution is more optimal because the mouse has to travel much less distance, therefore they reduced it for you.

**Night 4**: Frame rate becomes limited and is reduced significantly, the backseater will also always spam messages constantly at this point. The excuse the backseater has for reducing frame rate is that it lets you react to things more quickly because of the game running slower, therefore they reduced it for you.

**Ending**: You fake thanking the backseater for all the recommendations they have done for you, then you sneak in a line that another friend had recently started to play the game too, where the backseater immediately says they will go help them out and leaves you alone.

The real-life part will be task management game, where you have to watch out on your left (the door to your room) and right (the window) for the backseater. The backseater will make a different sound cue when it appears, and the player will have a couple of seconds of opportunity to react to scare the backseater away. The player will be given 1 opportunity to avoid damage on both sides. When the opportunity is used, the door (left) and window (right) will be broken that allows the backseater to get in and attack you. Each day will fix the door and window.

## Implementation
**2D Roguelike**
- WASD movement, using the cursor to aim your shots that fire automatically
- Press tab to exit out of the game screen into the real-life room
- Need to animate messages being appended to screen, where each message is picked from a random selection of quotes

**2D Player**
- Level implementation that gets more expensive the higher level you get
- Ability to upgrade character traits: damage, move speed, health, health regen, attack speed, fire count

**3D Real Life**
- Press A to look left (or click the left side of the screen), Press D to look right(or click the right side of the screen), Perss W to look center(or click whichever opposite corresponding side came from)
- Press tab to go back into the game screen room (or click the screen again)

**Backseater**
- Aggression level from 0 to 20, use some sort of math formula to the odds of transitioning up a stage before attacking
- Backseater needs to go through 4 stages before they launch an attack, whether succeeding in breaking down a structure, or failing an attack, the stage counter goes back to 0
- If backseater was able to attack, the player instantly loses and return back to the beginning of the night.

**Loading Screen**
- Some sort of loading animation, while also displaying some text message exchange between the backseater and the player character as the backdrop premise of the night.

## Credit Links

### Fonts
https://fonts.google.com/specimen/Press+Start+2P?query=pixel

### Shaders
https://godotshaders.com/shader/crt-with-luminance-preservation/

### Models
https://opengameart.org/content/angler-man-3d
https://opengameart.org/content/furniture-kit

### Art
https://opengameart.org/content/brigada-16x16-icon-pack

### Tilesets
https://opengameart.org/content/waterworld-tileset-16x16
https://opengameart.org/content/interior-tileset-16x16
https://opengameart.org/content/zelda-like-tilesets-and-sprites