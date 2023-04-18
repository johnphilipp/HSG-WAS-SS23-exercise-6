// personal assistant agent

/* Initial beliefs */
rank(0).

preferred_method("lights") :- rank(1).
preferred_method("blinds") :- rank(0).

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
    makeArtifact("dweet","room.DweetArtifact", [], Dweet);
    focus(Dweet).

@update_rank
+!update_rank : true <-
    ?rank(Old);
    New = ( Old + 1 ) mod 3;
    -rank(Old);
    +rank(New).

+owner_state("asleep") : owner_state("asleep") <-
    .print("Starting wake-up routine");
    !wake_up_routine.

+!sendDweet : true <-
    sendDweet("please=help");
    .print("Sent dweet").

+!request_friend_help : true <-
    .print("Sending dweet to get help");
    !sendDweet;
    !update_rank.

+upcoming_event("now") : owner_state("asleep") & not decline("wake-up")[source
(blinds_controller),source(lights_controller)] <-
    .print("Starting wake-up routine");
    !wake_up_routine.

+!wake_up_routine : decline("wake-up")[source(blinds_controller),source
(lights_controller)]<-
    !request_friend_help.

+!wake_up_routine : owner_state("asleep") & not decline("wake-up")[source
(blinds_controller),source(lights_controller)] <-
    .broadcast(tell, cfp("wake-up"));
    .wait(4000);
    !wake_up_routine.

+propose(Proposal)[cfp("wake-up"), source(Controller)] : true <-
    -propose(Proposal)[cfp("wake-up"), source(Controller)];
    !send_proposal(Proposal)[source(Controller)].

+decline(Proposal)[cfp("wake-up")]  : true <-
    .print("Declined ", Proposal).

+upcoming_event("now") : owner_state("awake") <-
    .print("Enjoy your event").

+!send_proposal(Proposal)[source(Controller)] : preferred_method
(ProposalInfered) & not (ProposalInfered == Proposal) <-
    .print("Declining ", Proposal);
    .send(Controller, tell, decline_proposal(Proposal)).

+!send_proposal(Proposal)[source(Controller)] : preferred_method
(ProposalInfered) & (ProposalInfered == Proposal) <-
    .print("Accepting ", Proposal);
    .send(Controller, tell, accept_proposal(Proposal)).

+completed(Proposal)[source(Controller)]  : true <-
    !update_rank.

+failed(Proposal)[source(Controller)] : true <-
    !update_rank.

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }