// personal assistant agent

/* Initial goals */ 

// The agent has the goal to start
!start.
should_wake_up_owner(0).
propose_raise_blinds(0).

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: greets the user
*/
@start_plan
+!start : true <-
    .print("Hello world");
    .broadcast(tell, should_wake_up_owner(0)); 
    makeArtifact("dweet","room.DweetArtifact", [], Dweet);
    focus(Dweet);
    !sendDweet;
    !wake_up_owner.

@exec_raise_blinds_plan
+propose_raise_blinds(State) : propose_raise_blinds(1) <- 
    .print("PA Raising blinds");
    // TODO
    .send(blinds_controller, tell, raise_blinds);
    // !update_propose_raise_blinds.
    .print("PA Blinds raised").

// start_wake_up_routine(0).

// best_option(natural) :- option(0).
// best_option(artificial) :- option(1).
// option(0).

// @update_option
// +!update_option : true <-
//     ?option(Old);
//     New = ( Old + 1 ) mod 2;
//     -option(Old);
//     +option(New).

// @run_option_natural
// +!fetch_new_option : best_option(natural) & start_wake_up_routine == 1 <-
//     .print("setting blinds");
//     !raise_blinds;
//     !update_option.

// @run_option_artificial
// +!fetch_new_option : best_option(artificial) & start_wake_up_routine == 1 <-
//     .print("setting light");
//     send(lights_controller, tell, )
//     !update_option.

@send_dweet_plan
+!sendDweet : true <- 
    sendDweet("hello=world");
    .print("Sent dweet").

// @upcoming_event_plan
// +upcoming_event(State) : true <-
//     .print("The upcoming event is ", State).

@wake_up_owner_plan
+!wake_up_owner : upcoming_event(Event) & owner_state(State) & Event == "now" & State == "asleep" <-
    .print("Starting wake-up routine");
    .broadcast(untell, should_wake_up_owner(0));
    .broadcast(tell, should_wake_up_owner(1)).

// @wake_up_owner_plan
// +!wake_up_owner : upcoming_event(Event) & owner_state(State) & Event == "now" & State == "asleep" <-
//     .print("Starting wake-up routine");
//     ?start_wake_up_routine(1).

@owner_awake_plan
+!owner_awake : upcoming_event(Event) & owner_state(State) & Event == "now" & State == "awake" <-
    .print("Enjoy your event").


@setup_dweet_artifact_plan
+!setupDweet : true <- 
    makeArtifact("dweet","room.DweetArtifact",[], DweetId);
    .print("Made artifact").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }