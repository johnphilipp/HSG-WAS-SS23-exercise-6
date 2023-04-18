// lights controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights (was:Lights)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/lights.ttl").

// The agent initially believes that the lights are "off"
lights("off").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Lights is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", Url) <-
    makeArtifact("lights", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    .print("Hello world").

@set_lights_state_plan
+!set_lights_state(State) : true <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", [State])[ArtId];
    .print("Set lights ", State);
    -+lights(State).

@lights_on_plan
+!lights_on : true <-
    .print("Turning lights on");
    !set_lights_state("on").

@lights_off_plan
+!lights_off : true <-
    .print("Turning lights off");
    !set_lights_state("off").

@lights_plan
+lights(State) : true <-
    .print("The lights are ", State);
    .send(personal_assistant, tell, lights(State)).

@cfp_propose
+cfp("wake-up")[source(Controller)] :  lights("off") <-
    .print("CFP received; Sending proposal ", "lights");
    -cfp("wake-up")[source(Controller)];
    .send(Controller, tell, propose("lights")[cfp("wake-up")]).

@cfp_decline
+cfp("wake-up")[source(Controller)] : lights("on") <-
    .print("CFP received; Lights are already on");
    -cfp("wake-up")[source(Controller)];
    .send(Controller, tell, decline("wake-up")).

@received_accept
+accept_proposal(Proposal)[source(Controller)] : true <-
    -accept_proposal(Proposal)[source(Controller)];
    !lights_on;
    +completed(Proposal)[source(Controller)].

@received_decline
+decline_proposal(Proposal)[source(Controller)] : true <-
    -reject_proposal(Proposal)[source(Controller)].

-!lights_on : true <-
    .send(personal_assistant, tell, failed("blinds")).

@failed
+failed(Proposal)[source(Controller)] : true <-
    .send(Controller, tell, failed(Proposal)).

@completed
+completed(Proposal)[source(Controller)]: true <-
    .send(Controller, tell, completed(Proposal)).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }