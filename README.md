# calcjuros

Calculadora de juros compostos em Flutter.

## Fórmula

Montante com aporte periódico:

```
M = C · (1 + i)^n + A · ((1 + i)^n − 1) / i
```

- `C`: capital inicial
- `A`: aporte por período (opcional)
- `i`: taxa por período (em decimal)
- `n`: número de períodos

Com `i = 0`, o montante é `C + A · n`.

## Uso

```
flutter pub get
flutter run
```
