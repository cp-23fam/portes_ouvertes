# Portes ouvertes
Projet pour les portes ouvertes du CEFF.  
But :  Créer un  jeu interractif sur mobile en utilisant Flutter
# Classes
```mermaid
classDiagram
    direction TB

    Room -- RoomStatus
    Room -- User
    Room .. Game
    Game -- GameStatus
    Game -- PlayerModel
    PlayerModel -- PlayerAction


    class Room {
        RoomId id
        String name
        UserId hostId
        List~UserId~ users
        RoomStatus status
        int maxPlayers
        GameId? gameId

        Map toMap()
        Room fromMap(Map map)
    }

    class RoomStatus {
        <<enum>>
        creating
        waiting
        playing
    }

    class User {
        UserId uid
        String username
        String? imageUrl

        Map toMap()
        User fromMap(Map map)
    }

    class Game {
        GameId id
        int? timestamp
        List~PlayerModel~ players
        GameStatus status

        Map toMap()
        User fromMap(Map map)
    }

    class GameStatus {
        <<enum>>
        starting
        playing
        ended
    }

    class PlayerModel {
        UserId uid
        Vector2 position
        PlayerAction action
        String? imageUrl
    }

    class PlayerAction {
        <<enum>>
        move
        melee
        shoot
        block
        none
    }
```
# Fonctionnalités
- [X] Lister les salles présentes
- [X] Créer une salle
- [X] Afficher les détails d'une salle
- [X] Afficher le status d'une salle
- [X] Afficher les joueurs d'une salle
- [ ] Afficher les photos de profil des joueurs d'une salle
- [X] Afficher le host d'une salle
- [X] Se connecter
- [X] Rejoindre une salle
- [X] Quitter une salle
- [ ] Lancer le jeu
- [ ] Participer
- [ ] Regarder la partie une fois mort
# Émulateurs
Le projet utilise des émulateurs pour développer de tout.
## Mise en place
1. `mkdir backend`
2. `cd backend`
3. `firebase emulators:start`

Note : Si la commande firebase n'est pas reconnue, `npm i -g firebase_tools`