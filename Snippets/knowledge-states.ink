// Using ink to manage knowledge states
// ---------------
// https://heavens-vault-game.tumblr.com/post/160306503785/what-dyknow

// We’ve said that Heaven’s Vault is really a detective game, with the player-as-archaeologist uncovering what happened where, when and to who using evidence. Which means from a system point of view, we’re tracking what the player knows, what they think they know, what they know they know…
// We’re doing all of our knowledge tracking in ink using a combination of “simple facts” and “chained facts”. 
// A simple fact is one you either know, or you don’t - “There’s water in the well here”, “There’s a door in the hillside”. Once learned, you can’t forget them. 
// A chained fact is one that can be developed in more detail. Perhaps what starts off as “There’s a rock on the hilltop” becomes “There’s a door in the hilltop” becomes “There’s some kind of tomb under the hilltop” becomes “There’s an ancient ship burial under the hilltop.”
// And quite often we have a fact which starts life simple, and becomes a chain as the writing process continues. So we’ve built a system which allows the author to “upgrade” a fact without fuss.
// The “knowledgeState” list is a bucket into which we drop any facts we “learn”. Then when we test if we “know” a fact, we decide which type of test is appropriate based on what list the fact came from. 
// Upgrading a simple fact is a simple as taking it out of the simple facts list, and putting it into its own chained list. Simple!
// (Note that keeping the game-side informed of these changes is a little fiddlier, and uses a combination of external functions and variable observers. Another post, perhaps.)

// ---- root scene

-> example_scene

// ---- example data ---

LIST TempleChain = SOMETHING_UP_THERE, STONES_UP_THERE, TOMB_ON_HILL, SHIP_BURIAL_UNDER_HILL

LIST SimpleFacts = WATER_IN_WELL, SHIPS_ARE_ANCIENT, JAM_IS_TASTY

// ---- system ---

VAR knowledgeState = ()

=== function learn(fact)
    ~ knowledgeState += fact
    
=== function know(fact)
    { LIST_ALL(SimpleFacts) ? fact:
        // simple facts are either known, or not
        ~ return knowledgeState ? fact
    - else:
        // chained facts are more complicated: do we know a fact in the chain of equal or higher value than this one?
        ~ temp factsInThisChain = knowledgeState ^ LIST_ALL(fact)
        ~ return (LIST_MAX(factsInThisChain) >= fact)
    }

// ---- example ---



=== example_scene ===

The camp bustles with activity.

+   {know(JAM_IS_TASTY)} Eat some delicious jam.
    "I should have learned about this years ago!"
*   {!know(SOMETHING_UP_THERE)} "What's all this bustle in the camp?"
    "There's something up there," cries a man eating toast smeared with some kind of delicious substance.
    ~ learn(SOMETHING_UP_THERE)
    * * "What specifically is up there?"
    "Why, it's a tomb I hear," cries the man, through a mouthful of ...something.
    ~ learn(TOMB_ON_HILL)
    * * "Tell me man, quickly, what is that wonderful goo?"
    "Why, jam, of course! It's the honey of the industrial age!"
    ~ learn(JAM_IS_TASTY)
*   {know(SOMETHING_UP_THERE)} Grab your binoculars and take a closer look at the hill.
    Why, it {know(TOMB_ON_HILL):certainly is|looks like there is} a tomb on the hill! Fancy that!
    ~ learn(TOMB_ON_HILL)
*   {know(TOMB_ON_HILL)} Make your way towards the tomb.
    As you get closer, you see the work teams, and see a great prow being exumed from its resting place.
    "My god! Dr. Murdoch was right! A ship! This far east! Astonishing!"
    ~ learn(SHIP_BURIAL_UNDER_HILL)
*   {!know(SHIPS_ARE_ANCIENT)}
    {know(SHIP_BURIAL_UNDER_HILL)}
    "Wait this doesn't make sense, I'm sure boats were only invented a couple of years ago"
    From the looks you recieve you come to the conclusion you might need to adjust your worldview, just a little.
    ~learn(SHIPS_ARE_ANCIENT)
*   {know(SHIP_BURIAL_UNDER_HILL)}
    {know(SHIPS_ARE_ANCIENT)}
    "Good lord, I need to get back to the museum!"
    "I'm going to lose my bet!"
    -> END
- -> example_scene
