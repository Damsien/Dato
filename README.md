{::options parse_block_html="true" /}

# Compilateur de code

## Compiler le programme

```sh
# Linux command
gnatmake src/main $(ls -R  | grep -oP 'src/.*(?=:)' | sed -e 's_.*_-I&_' | paste -s)

# Or use the command file
./compile
```

### Explication
Le projet étant découpé en plusieurs modules partagés dans des dossiers différents, il est nécessaire de spécifier l'emplacement de l'ensemble de ces dossiers lors de la compilation du programme.

```sh
ls -R # Affiche la liste des répertoires (sous la forme "chemin/du/dossier:") et leur contenu

grep -oP 'src/.*(?=:)'  # Récupère la liste des dossiers (recherche une chaine finissant par ":" en excluant ce dernier)

sed -e 's_.*_-I&_' # Rajoute à chaque début de chaines "-I"

paste -s # Transforme les lignes en espace


### EXEMPLE DE RESULTAT ###
gnatmake src/main -Isrc/compiler -Isrc/files -Isrc/files/intermediate -Isrc/files/source -Isrc/struct -Isrc/struct/liste -Isrc/struct/object -Isrc/struct/pile
```

## Compilation du programme source

## Interprétation du programme intermédiaire

### Architecture

Dans cet exemple, nous considérons une version simplifiée de la gestion de la mémoire, contenant seulement un espace réservé au programme, et le tas pour les différentes variables. <br/>
Le programme est lu par un interpréteur externe (qui accède à son espace mémoire), qui exécutera le programme et accèdera éventuellement au tas pour enregistrer et lire des variables stockées.

![Mémoire](doc/images/memoire.png)

On se basera sur cette interprétation afin d'implémenter nos différents modules.

```plantuml
@startuml

class Interpreteur {
    int CP
    }

    package "Mémoire" {

        class "Programme Intermédiaire" {
        String[] instructions
        Inserer()
        Inserer_L()
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

        "Programme Intermédiaire" -> Interpreteur
        Tas -> Interpreteur
        "Programme Intermédiaire" -[hidden]-> Tas


@enduml
```

### Analyse sémantique

En analysant le code intermédiaire de notre programme, nous pouvons identifier différents mots clés et opérations :

| Programme      | Opérations |
| ----------- | ----------- |
| n <span style="background-color:#ffff00">←</span> 5      | Affectation       |
| i ← 1   |         |
| Fact ← 1   |         |
| T1 ← i < n   | Comparaison        |
| i ← i + 1   |  Opération       |
| IF T3 GO TO L1  |  Condition / Branchement       |
| NULL  |  Null       |



## Architecture globale

```plantuml
@startuml

package "Architecture" #DDDDDD {


package "Partie 2 : Exécution" #DDDDDD {

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

    package "Mémoire" {

        class "Programme Intermédiaire" {
        String[] instructions
        Inserer()
        Inserer_L()
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

}


"Programme Intermédiaire" -> Interpreteur
Tas -> Interpreteur
"Programme Intermédiaire" -[hidden]-> Tas

}

package "Partie 1 : Traduction/Compilation" #DDDDDD {

class "Programme source" {
String[] instructions
}

class Pile<K> {
    Empiler(K record)
    Depiler(K record)
}

class Compilateur {
int CP
int LABEL_USED
Variable[] Declared_Variables
bool hasProgramStarted
bool hasProgramDebuted
Pile<TQ> TQ
Pile<int> CP_SI
CreerLabel()
TraduireOperation(op)
TraduireCondition(line)
TraduireTantQue(line)
TraduireFinTantQue()
TraduireSi()
TraduireSinon()
TraduireFinSi()
}

Pile <.. Compilateur
"Programme source" <- Compilateur
Compilateur -> "Programme Intermédiaire"


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

annotation " record TQ" {
String LX
String Tx
}

}

@enduml
``` 
