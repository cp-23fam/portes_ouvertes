import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:portes_ouvertes/src/features/game/syncstrike_game.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});
  final SyncstrikeGame game = SyncstrikeGame();

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void _onActionSelected(String action) {
    debugPrint('Action choisie : $action');
    if (action == 'move') {
      widget.game.highlightMoveZone('p1');
    } else {
      widget.game.grid.clearHighlights();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Game
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 54 * 9,
                  width: 54 * 9,
                  child: GameWidget(game: widget.game),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final selected = widget.game.grid.selectedCell;
                if (selected != null) {
                  final player = widget.game.players.firstWhere(
                    (p) => p.id == 'p1',
                  );
                  player.moveToCell(selected);
                  widget.game.grid.clearHighlights();
                }
              },
              child: const Text('Valider'),
            ),
            Stack(
              children: [
                // Interface
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    // padding: const EdgeInsets.only(bottom: 40.0),
                    padding: const EdgeInsets.all(40.0),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 0,
                            child: _buildGameButton(
                              icon: Icons.arrow_forward,
                              color: Colors.green,
                              label: 'Move',
                              onPressed: () => _onActionSelected('move'),
                            ),
                          ),

                          Positioned(
                            left: 0,
                            child: _buildGameButton(
                              icon: Icons.flash_on,
                              color: Colors.red,
                              label: 'Atk',
                              onPressed: () => _onActionSelected('attackClose'),
                            ),
                          ),

                          Positioned(
                            top: 0,
                            child: _buildGameButton(
                              icon: Icons.bolt,
                              color: Colors.orange,
                              label: 'Shoot',
                              onPressed: () =>
                                  _onActionSelected('attackDistance'),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            child: _buildGameButton(
                              icon: Icons.shield,
                              color: Colors.blue,
                              label: 'Defend',
                              onPressed: () => _onActionSelected('defend'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: label,
          onPressed: onPressed,
          backgroundColor: color.withAlpha(220),
          shape: const CircleBorder(),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            shadows: [Shadow(blurRadius: 4, color: Colors.black)],
          ),
        ),
      ],
    );
  }
}
