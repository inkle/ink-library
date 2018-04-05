// Threading tunnels
// ------------------------
// Originally from:
// https://heavens-vault-game.tumblr.com/post/166256097210/threading-tunnels
-> example

// Two powerful features of ink that we’re slowly starting to use all the time are threads (which let you bring choices and content from another knot into the current knot, potentially diverting the flow) and tunnels (which let you drop into another knot, and return when you’re done, like a classic function call)
// But one problem that starts to arise is how to thread in content that’s been written as a tunnel. Is it possible?
// Well, yes it is. But it requires a slightly cunning bit of ink. 

=== tunnel_as_thread(-> tunnel, -> ret )
- (top) 
   -> tunnel -> 
   {TURNS_SINCE(-> top) == 0: -> DONE }  -> ret

// This runs the tunnel and threads in any choices inside that tunnel. 

// If the player doesn’t choose an option from inside that tunnel, this thread will die, and the last line is never hit. If they do choose an option from inside the tunnel, then when the tunnel finishes goes back to the given return point. 

// The TURNS_SINCE check is almost unnecessary: it’s needed in case the tunnel contains no choices at all: the -> DONE ensures the thread stops safely, instead of continuing onto the return point. 

// Here’s an example of this in action:

== example ==
- (opts) 
<- tunnel_as_thread(-> ask_about_urns, -> opts)
<- tunnel_as_thread(-> ask_about_coins, -> opts)
*  {ask_about_urns.done && ask_about_coins.done} [Finish talking]
   El:     Okay, we’re done!
-   -> END

== ask_about_urns ===
   *   El:    Are urns useful? 
       Six:   Depends on what you want to put in them.
   -   (done) ->->

=== ask_about_coins ===
   *   El:     Do coins float? 
       Six:    Depends on what they’re made from. 
   -   (done) ->->

// Of course, if you don’t think you need to thread a tunnel, you probably don’t. It can be useful because tunnels are portable - when they finish, they don’t need to know where to go back to, they just return - and threads allow the player to choose content from lots of different places in the source.

// We use threaded tunnels for our conversations: each one is a little packet of interaction, but there are hundreds of them, separated, and with their own conditions. Writing as tunnels means we can write them without caring about where they came from, and also inject them into the story if we want to; and using threads means they can be written independently from each other. 