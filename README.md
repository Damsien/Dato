# interpreteur-code



## Architecture

![Architecture](./doc/images/architecture.png)

```plantuml
@startuml

package "Architecture" #DDDDDD {


package "Partie 2 : Compilation" #DDDDDD {

class "Programme Intermédiaire" {
String[] instructions
}

class Tas {
Variable[] variables
Label[] labels
int TAILLE

AjouterLabel(String intitule, int instruction) 
AjouterVariable(String intitule, String type) 
Modifier(String intitule, int variable) 
GetLabel(String intitule) : Label
}

class Interpreteur {
int CP

Affecter(int e1, int e2,  char op)
Comparer(int e1, int e2, char op) : bool
Operer(int e1, int e2, char op) : int
Declarer(String intitule, String type)
GoTo(String label)
GoTo(int instruction)
Null_Op()
}

Interpreteur --> Tas : "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"
"Programme Intermédiaire" <- Interpreteur


}

package "Partie 1 : Traduction" #DDDDDD {

class "Programme source" {
String[] instructions
}

class Traducteur {
int CP
TraduireOperation(op)
TraduireCondition(String[] cond)
TraduireBranchement(String[] branch)
}

"Programme source" <- Traducteur
Traducteur -> "Programme Intermédiaire"


}
}

package "Record" #DDDDDD {

annotation " record Variable" {
String intitule
int value
String type
}

annotation " record Label" {
String intitule
int instruction
}

annotation " record Instruction" {
String regexp
String[] template
}

}

@enduml
``` 
