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
    .print("The blinds are lowered and it is time to wake up the owner");
    .send(personal_assistant, tell, propose_raise_blinds(1)).

@set_blinds_state_plan
+!set_blinds_state(State) : true <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState",  ["https://www.w3.org/2019/wot/json-schema#StringSchema"], [State])[ArtId];
    -+blinds(State);
    .print("BC Set blinds ", State);
    .send(personal_assistant, tell, blinds(State)).

@exec_lower_blinds_plan
+!lower_blinds : true <-
    set_blinds_state("lowered").

@exec_raise_blinds_plan
+!raise_blinds : true <-
    .print("BC Raising the blinds");
    set_blinds_state("raised").

@blinds_plan
+blinds(State) : true <-
    .print("The blinds are ", State).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }