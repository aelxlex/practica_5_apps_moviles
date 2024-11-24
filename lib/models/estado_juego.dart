import 'package:flutter/material.dart';
import 'dart:math';

class EstadoJuego with ChangeNotifier {
  List<String> _tablero = List.filled(9, ''); // Estado inicial vacío
  String _jugadorActual = 'X';
  bool _juegoTerminado = false;
  String _ganador = '';
  bool _modoContraMaquina = false;

  List<String> get tablero => _tablero;
  String get jugadorActual => _jugadorActual;
  bool get juegoTerminado => _juegoTerminado;
  String get ganador => _ganador;

  void habilitarModoContraMaquina(bool habilitar) {
    if (_modoContraMaquina != habilitar) {
      _modoContraMaquina = habilitar;
      reiniciarJuego(); // Reinicia el juego si cambiamos el modo
    }
  }

  void marcarCasilla(int indice) {
    if (_tablero[indice].isEmpty && !_juegoTerminado) {
      _tablero[indice] = _jugadorActual;
      if (_verificarGanador()) {
        _ganador = _jugadorActual;
        _juegoTerminado = true;
      } else if (!_tablero.contains('')) {
        _juegoTerminado = true;
      } else {
        _cambiarTurno();
        if (_modoContraMaquina && _jugadorActual == 'O') {
          _movimientoMaquina();
        }
      }
      notifyListeners();  // Notifica para que la UI se actualice
    }
  }

  void _movimientoMaquina() {
    // Lógica simple de la máquina: elige una casilla vacía al azar
    int indice = _tablero.indexWhere((casilla) => casilla.isEmpty);
    if (indice != -1) marcarCasilla(indice);
  }

  bool _verificarGanador() {
    const posicionesGanadoras = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var posiciones in posicionesGanadoras) {
      if (_tablero[posiciones[0]] == _jugadorActual &&
          _tablero[posiciones[1]] == _jugadorActual &&
          _tablero[posiciones[2]] == _jugadorActual) {
        return true;
      }
    }
    return false;
  }

  void _cambiarTurno() {
    _jugadorActual = _jugadorActual == 'X' ? 'O' : 'X';
  }

  void reiniciarJuego() {
    _tablero = List.filled(9, '');  // Reinicia el tablero vacío
    _jugadorActual = 'X';           // El jugador 'X' inicia
    _juegoTerminado = false;
    _ganador = '';
    notifyListeners();  // Notifica a la UI para que se actualice
  }
}
