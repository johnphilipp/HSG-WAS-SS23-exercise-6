// blinds controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds (was:Blinds)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/blinds.ttl").

// the agent initially believes that the blinds are "lowered"
blinds("lowered").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Blinds is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", Url) <-
    makeArtifact("blinds", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    .print("Hello world").

@raise_blinds_plan
+should_wake_up_owner(State) : should_wake_up_owner(1) & blinds("lowered") <- 
    .print("The blinds are lowered and it is time to wake up the owner").

@set_blinds_state_plan
+!set_blinds_state(State) : true <-
    .print("Invoking action");
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", [State])[ArtId];
    -+blinds(State);
    .print("Set blinds ", State).

@exec_lower_blinds_plan
+!lower_blinds : true <-
    .print("Lowering blinds");
    !set_blinds_state("lowered").

@exec_raise_blinds_plan
+!raise_blinds : true <-
    .print("Raising blinds");
    !set_blinds_state("raised").

@blinds_plan
+blinds(State) : true <-
    .print("The blinds are ", State);
    .send(personal_assistant, tell, blinds(State)).

@cfp_propose
+cfp("wake-up")[source(Controller)] :  blinds("lowered") <-
    .print("CFP received; Sending proposal ", "blinds");
    -cfp("wake-up")[source(Controller)];
    .send(Controller, tell, propose("blinds")[cfp("wake-up")]).

@cfp_decline
+cfp("wake-up")[source(Controller)] : blinds("raised") <-
    .print("CFP received; Blinds are already raised");
    -cfp("wake-up")[source(Controller)];
    .send(Controller, tell, decline("wake-up")).

@received_accept
+accept_proposal(Proposal)[source(Controller)] : true <-
    !raise_blinds;
    +completed(Proposal)[source(Controller)].

@received_decline
+decline_proposal(Proposal)[source(Controller)] : true <-
    -decline_proposal(Proposal)[source(Controller)].

-!raise_blinds : true <-
    .send(personal_assistant, tell, failed("blinds")).

@failed
+failed(Proposal)[source(Controller)] : true <-
    .send(Controller, tell, failed(Proposal)).

@completed
+completed(Proposal)[source(Controller)]: true <-
    .send(Controller, tell, completed(Proposal)).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }