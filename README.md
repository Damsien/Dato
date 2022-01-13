
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

### Analyse sémantique

| Motif | Règle |
| ----------- | ----------- |
| - -  | Tout caractère après ce motif est autorisé |
| Programme \<name> est | Variable **isInProgram** = true
| \<variable> : \<Type> | Vérifier que **isInProgram** = true ET que **isDebut** = false<br/> Vérifier que Type existe <br/> Vérifier que variable n'est pas déjà déclaré |
| Début | Vérifier que **isInProgram** = true <br/> Variable **isDebut** = true |
| \<variable> <- \<valeur> | Vérifier que variable est déclaré <br> Vérifier le type de la valeur |
| \<variable \| constante> \<op> \<variable \| constante> | Vérifier que op existe <br> Ajouter des variables intermédiaires (condition) <br> Ajouter des lignes |
| Tant Que \<condition> Faire | Isoler et traiter la condition <br/> Créer des labels <br/> Ajouter des branchements |

## Interprétation du programme intermédiaire

### Représentation de la mémoire

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
| n **←** 5     | Affectation       |
| i ← 1   |         |
| Fact ← 1   |         |
| T1 ← **i < n**   | Comparaison        |
| i ← **i + 1**   |  Opération       |
| **IF** T3 **GO TO** L1  |  Condition / Branchement       |
| **NULL**  |  Null       |

### Raffinage

**<R0\> :** Comment **Interpréter et exécuter un code intermédiaire** ?

- Charger le fichier
- POUR CHAQUE LIGNE :
  - Vérifier et appliquer les règles d'exécution (\<R1>)

**<R1\> :** Comment **Vérifier et appliquer les règles d'exécution** ? 

- SI _Vérifier **commentaire**_ (\<R2.1>) ALORS :
    - _Appliquer **commentaire**_ (\<R2.1bis>)
- SI _Vérifier **déclaration**_ (\<R2.2>) ALORS :
    - _Appliquer **déclaration**_ (\<R2.2bis>)
- SI _Vérifier **affectation**_ (\<R2.3>) ALORS :
    - _Appliquer **affectation**_ (\<R2.3bis>)
- SI _Vérifier **opération**_ (\<R2.4>) ALORS :
    - _Appliquer **opération**_ (\<R2.4bis>)
- SI _Vérifier **comparaison**_ (\<R2.5>) ALORS :
    - _Appliquer **comparaison**_ (\<R2.5bis>)
- SI _Vérifier **condition**_ (\<R2.6>) ALORS :
    - _Appliquer **condition**_ (\<R2.6bis>)
- SI _Vérifier **branchement**_ (\<R2.7>) ALORS :
    - _Appliquer **branchement**_ (\<R2.7bis>)
- SI _Vérifier **Null**_ (\<R2.8>) ALORS :
    - _Appliquer **Null**_ (\<R2.8bis>)

Après analyse, nous pouvons spécifier de nouvelles fonctions à notre module Interpréteur.

```plantuml
@startuml

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

@enduml
```

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
