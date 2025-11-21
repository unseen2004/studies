#!/usr/bin/env python3
# Autor: unseen2004 (converted to Python)
# Zadanie 2 - Lista 2 (ALTERNATYWNY PROGRAM WIZUALIZACJI)
# Wizualizacja funkcji f(x) = e^x * ln(1 + e^(-x)) - PyPlot (Python version)

import numpy as np
import matplotlib
matplotlib.use("Agg")  # force non-interactive backend so script works on servers
import matplotlib.pyplot as plt

print("=" * 70)
print("ZADANIE 2 - Wizualizacja w PyPlot (przekonwertowano do Pythona)")
print("=" * 70)
print()

# Definicja funkcji (vectorized)
def f(x):
    # Use log1p for better accuracy when x is large
    # Note: for very large x, np.exp(x) may overflow; this reproduces the numerical
    # behaviour discussed in the original script (showing the numerical issue).
    return np.exp(x) * np.log1p(np.exp(-x))

print("Generowanie wykresow w PyPlot...")
print("-" * 70)

# WYKRES 1 - PyPlot (zakres 0-100)
print("Wykres 1: zakres 0-100")
x_range1 = np.arange(0, 100.0 + 0.5, 0.5)
y1 = f(x_range1)

plt.figure(figsize=(10, 6))
plt.plot(x_range1, y1, linewidth=2, label=r"f(x) = e^x \ln(1 + e^{-x})", color="blue")
plt.axhline(y=1.0, color="red", linestyle="--", linewidth=2, label="Granica = 1")
plt.xlabel("x", fontsize=12)
plt.ylabel("f(x)", fontsize=12)
plt.title("Wykres funkcji f(x) - zakres [0, 100] (PyPlot)", fontsize=14)
plt.legend(fontsize=10)
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("zadanie2_pyplot_wykres1.png", dpi=150)
print("  Zapisano: zadanie2_pyplot_wykres1.png")
plt.clf()

# WYKRES 2 - PyPlot (zakres 0-500) - pokazuje problem numeryczny
print("Wykres 2: zakres 0-500 (problem numeryczny)")
x_range2 = np.arange(0, 500.0 + 2.0, 2.0)
# compute naive values (this will show numerical problems for large x)
y2 = f(x_range2)

plt.figure(figsize=(10, 6))
plt.plot(x_range2, y2, linewidth=2, label=r"f(x) = e^x \ln(1 + e^{-x})", color="darkblue")
plt.axhline(y=1.0, color="red", linestyle="--", linewidth=2, label="Granica teoretyczna = 1")
plt.axhline(y=0.0, color="orange", linestyle=":", linewidth=2, label="Wynik numeryczny \u2192 0")
plt.xlabel("x", fontsize=12)
plt.ylabel("f(x)", fontsize=12)
plt.title("Problem numeryczny dla duzych x (PyPlot)", fontsize=14)
plt.legend(fontsize=10)
plt.grid(True, alpha=0.3)

# Dodajemy adnotacje dla kluczowych punktow
plt.annotate("Prawidlowe wartosci", xy=(20, 1.0), xytext=(30, 0.85),
             fontsize=10, ha="left",
             arrowprops=dict(arrowstyle="->", color="green", lw=1.5))
plt.annotate("Blad numeryczny!\nf(x)=0 zamiast 1", xy=(200, 0.05), xytext=(250, 0.3),
             fontsize=10, ha="left", color="red",
             arrowprops=dict(arrowstyle="->", color="red", lw=1.5))

plt.tight_layout()
plt.savefig("zadanie2_pyplot_wykres2.png", dpi=150)
print("  Zapisano: zadanie2_pyplot_wykres2.png")
plt.clf()

print()
print("=" * 70)
print("PODSUMOWANIE:")
print("-" * 70)
print("Wygenerowano 2 wykresy uzywajac PyPlot (wersja Python):")
print("  1. zadanie2_pyplot_wykres1.png - zakres [0, 100]")
print("  2. zadanie2_pyplot_wykres2.png - zakres [0, 500] z adnotacjami")
print()
print("PyPlot (matplotlib) pokazuje to samo zjawisko co Plots.jl:")
print("  - Dla x < 40: funkcja poprawnie zmierza do 1")
print("  - Dla x >= 40: blad numeryczny, f(x) -> 0 zamiast 1")
print("=" * 70)
