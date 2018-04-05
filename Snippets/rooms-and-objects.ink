// Using ink for rooms and objects
// ---------------
// https://heavens-vault-game.tumblr.com/post/162943569425/using-ink-for-rooms-and-objects

// Heaven’s Vault is a bit different from our previous game, in that it uses ink - our narrative scripting language - to simulate what a “normal” adventure game would do, with rooms full of interactive props.
// For any ink devs out there, here’s roughly how we’re doing it.
// Each “room” is a knot. Inside the knot, we use threads for each of the props the player can interact with, so we can divide up the action into chunks of interactivity. In each thread, there’s a link back to the top of the location.
// The great thing about this structure it’s very portable - if you have “background” objects that appear in multiple rooms, you simply thread them in and pass a parameter for where to return to. 
// And if you have things that can happen in the room - say, a bit of dialogue for when you stand in a certain place - you can put that in the main “hub” of the location and it’ll always be tested for.
// Heaven’s Vault gets a bit more complicated than this - because we also handle conversation, which can happen anywhere, at any time, from a separate contextual system. But that’s for another post maybe. 


LIST waypoints = PLATEAU_BELOW_TOWER, NEAR_TOWER_BASE //, etc

=== plateau_below_tower ===
- (top)
    <- distant_tower
    <- half_buried_skull
    
= distant_tower
    // This choice syntax is Heaven's Vault specific, and is how we specify choices where you interact with props in the world.
    *   (carved) [Tower -- "Is it really a tower?"]
        El:     It Can't have been built.
        Six:    I believe you can call it what you wish, Mistress.
        Six:    It has, however, been carved.
        
    *   (carvedcrater) {carved} [CraterWalls -- "They carved out this whole crater?"]
        Six:    It is impossible to say, Mistress.
        
    *   [TowerBase >> Approach]
        -> start_walk_to(NEAR_TOWER_BASE) ->
        
        // The '>>>' syntax is Heaven's Vault specific, and is how we write narrated elements.
        >>> We made our way across the desolate plain.
        >>> Perhaps this was once a pilgrim's path; a way of worship.
        
        * * El:     Do you think it's going to fall on top of us?
            Six:    It has stood for thousands of years.
            Six:    But I will charge the hopper, all the same.
        - -     -> end_walk -> near_tower_base
        
    -   -> top
    
= half_buried_skull
    *   (see_skull) [Skull - "Is that a skull?"]
        Six:    I beleive so, Mistress.
        Six:    Thank you for pointing it out, or I would have rolled over it.
    *   {see_skull} [Skull - Work it free]
        El:     Let's see if I can get this free without breaking it...
    -   -> top
    
= near_tower_base
-> END


== start_walk_to(destination) ==
// [Special ink that triggers walk in Heaven's Vault]
->->

== end_walk
// [Special ink that waits for a walk to complete in Heaven's Vault]
->->
