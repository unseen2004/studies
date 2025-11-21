# Autor: unseen2004
# Zadanie 6 - Lista 2
# Rownanie rekurencyjne x_{n+1} = x_n^2 + c

using Printf

println("="^80)
println("ZADANIE 6 - Rownanie rekurencyjne x_{n+1} = x_n^2 + c")
println("="^80)
println()

println("To jest podstawowe rownanie z teorii fraktali (zbior Mandelbrota/Julii)!")
println()

# Funkcja obliczajaca jedna iteracje
function iterate_quadratic(x, c)
    return x^2 + c
end

# Funkcja wykonujaca n iteracji i analizujaca zachowanie
function analyze_sequence(x0, c, n, label)
    println("="^80)
    println(label)
    println("="^80)
    @printf("Parametry: c = %.17f, x_0 = %.17f\n", c, x0)
    println()

    # Tablica wynikow
    results = zeros(Float64, n+1)
    results[1] = x0

    # Obliczenia iteracyjne
    diverged = false
    diverged_at = -1

    for i in 1:n
        results[i+1] = iterate_quadratic(results[i], c)

        # Sprawdzenie rozbieznosci (|x| > 10^10)
        if abs(results[i+1]) > 1e10 && !diverged
            diverged = true
            diverged_at = i
        end
    end

    # Wyswietlenie wybranych iteracji
    println("Wybrane iteracje:")
    println("-"^80)
    @printf("%-5s %-25s %-25s\n", "n", "x_n", "|x_n|")
    println("-"^80)

    indices_to_show = [0, 1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 35, 40]

    for i in indices_to_show
        if i+1 <= length(results)
            if abs(results[i+1]) < 1e10
                @printf("%-5d %-25.17f %-25.2e\n", i, results[i+1], abs(results[i+1]))
            else
                @printf("%-5d %-25.2e %-25.2e\n", i, results[i+1], abs(results[i+1]))
            end
        end
    end

    # Analiza zachowania
    println()
    println("ANALIZA ZACHOWANIA:")
    println("-"^80)

    if diverged
        @printf("Ciag ROZBIEGA SIE do nieskonczonosci (|x| > 10^10 w iteracji %d)\n", diverged_at)
    else
        # Sprawdzenie zbieznosci
        last_values = results[end-min(9, n):end]
        if maximum(abs.(diff(last_values))) < 1e-10
            @printf("Ciag ZBIEGA DO PUNKTU STALEGO: x* ≈ %.17f\n", results[end])
            # Weryfikacja: x* = x*^2 + c => x*^2 - x* + c = 0
            fixed_point = results[end]
            residual = fixed_point^2 - fixed_point + c
            @printf("Weryfikacja punktu stalego: x*^2 - x* + c = %.2e\n", residual)
        elseif maximum(abs.(last_values)) < 10
            # Sprawdzenie oscylacji
            if abs(results[end] - results[end-2]) < 1e-10
                @printf("Ciag OSCYLUJE miedzy wartosciami (cykl okresu 2)\n")
                @printf("  x_even ≈ %.17f\n", results[end])
                @printf("  x_odd  ≈ %.17f\n", results[end-1])
            else
                @printf("Ciag jest OGRANICZONY ale nie zbiega (mozliwe chaotyczne zachowanie)\n")
                @printf("Zakres wartosci: [%.4f, %.4f]\n", minimum(last_values), maximum(last_values))
            end
        else
            @printf("Ciag jest OGRANICZONY\n")
            @printf("Zakres wartosci w ostatnich 10 iteracjach: [%.4f, %.4f]\n",
                    minimum(last_values), maximum(last_values))
        end
    end

    println()
    return results
end

# Lista eksperymentow
experiments = [
    (1.0, -2.0, "EKSPERYMENT 1: c = -2, x_0 = 1"),
    (2.0, -2.0, "EKSPERYMENT 2: c = -2, x_0 = 2"),
    (1.99999999999999, -2.0, "EKSPERYMENT 3: c = -2, x_0 = 1.99999999999999"),
    (1.0, -1.0, "EKSPERYMENT 4: c = -1, x_0 = 1"),
    (-1.0, -1.0, "EKSPERYMENT 5: c = -1, x_0 = -1"),
    (0.75, -1.0, "EKSPERYMENT 6: c = -1, x_0 = 0.75"),
    (0.25, -1.0, "EKSPERYMENT 7: c = -1, x_0 = 0.25")
]

n_iterations = 40
all_results = []

for (x0, c, label) in experiments
    results = analyze_sequence(x0, c, n_iterations, label)
    push!(all_results, (x0, c, label, results))
end

# ===================================================================
# PODSUMOWANIE I WNIOSKI
# ===================================================================

println("\n" * "="^80)
println("PODSUMOWANIE I ANALIZA TEORETYCZNA")
println("="^80)
println()

println("1. PUNKTY STALE:")
println("-"^80)
println("Punkty stale spelniaja rownanie: x* = x*^2 + c")
println("Czyli: x*^2 - x* + c = 0")
println()
println("Rozwiazania: x* = (1 ± sqrt(1 - 4c)) / 2")
println()
println("Dla c = -2:")
c = -2.0
discriminant = 1 - 4*c
if discriminant >= 0
    x1 = (1 + sqrt(discriminant)) / 2
    x2 = (1 - sqrt(discriminant)) / 2
    @printf("  x*_1 = %.17f\n", x1)
    @printf("  x*_2 = %.17f\n", x2)
end
println()
println("Dla c = -1:")
c = -1.0
discriminant = 1 - 4*c
if discriminant >= 0
    x1 = (1 + sqrt(discriminant)) / 2
    x2 = (1 - sqrt(discriminant)) / 2
    @printf("  x*_1 = %.17f\n", x1)
    @printf("  x*_2 = %.17f\n", x2)
end
println()

println("2. STABILNOSC PUNKTOW STALYCH:")
println("-"^80)
println("Punkt staly x* jest:")
println("  - STABILNY (przyciagajacy) jesli |f'(x*)| < 1")
println("  - NIESTABILNY (odpychajacy) jesli |f'(x*)| > 1")
println()
println("Dla f(x) = x^2 + c: f'(x) = 2x")
println()
println("Dla c = -2, x* = 2:")
@printf("  f'(2) = 4 > 1 => NIESTABILNY (ciag rozbiega sie)\n")
println()
println("Dla c = -2, x* = -1:")
@printf("  f'(-1) = -2, |f'(-1)| = 2 > 1 => NIESTABILNY\n")
println()
println("Dla c = -1, x* = (1±sqrt(5))/2:")
x_plus = (1 + sqrt(5)) / 2
x_minus = (1 - sqrt(5)) / 2
@printf("  x*_+ ≈ %.4f: f'(x*_+) = %.4f, |f'| > 1 => NIESTABILNY\n", x_plus, 2*x_plus)
@printf("  x*_- ≈ %.4f: f'(x*_-) = %.4f, |f'| < 1 => STABILNY\n", x_minus, 2*x_minus)
println()

println("3. ZBIOR MANDELBROTA I JULII:")
println("-"^80)
println("To rownanie jest podstawa zbiorow fraktalnych:")
println("  - Zbior Julii: dla stalego c, ktore x_0 prowadza do ograniczonego ciagu")
println("  - Zbior Mandelbrota: ktore c daja ograniczony ciag dla x_0 = 0")
println()
println("Dla c = -2: zbior Julii to odcinek [-2, 2]")
println("Dla c = -1: zbior Julii jest bardziej skomplikowany")
println()

println("4. WRAZLIWOSC NA WARUNKI POCZATKOWE:")
println("-"^80)
println("Porownajmy eksperymenty 2 i 3 (c = -2):")
println("  Eksperyment 2: x_0 = 2.0 (dokladnie)")
println("  Eksperyment 3: x_0 = 1.99999999999999 (roznica 10^-14)")
println()
if length(all_results) >= 3
    diff_2_3 = abs(all_results[2][4][end] - all_results[3][4][end])
    @printf("  Roznica po 40 iteracjach: %.2e\n", diff_2_3)
    if diff_2_3 > 1e10
        println("  => EKSTREMALNA wrazliwosc! Male zmiany -> ogromne roznice!")
    elseif diff_2_3 > 1
        println("  => Znaczna wrazliwosc na warunki poczatkowe")
    else
        println("  => Umiarkowana wrazliwosc")
    end
end
println()

println("5. WNIOSKI:")
println("-"^80)
println("- Rownanie x_{n+1} = x_n^2 + c wykazuje bogate zachowania dynamiczne")
println("- Zaleznosc od c i x_0 determinuje: zbieznosc, rozbieznosc lub chaos")
println("- Jest to podstawa teorii fraktali (Mandelbrot, Julia)")
println("- Ekstremalna wrazliwosc na warunki poczatkowe dla pewnych parametrow")
println("- Proste rownanie moze generowac niezwykle zlozne struktury")

println("\n" * "="^80)
println("KONIEC EKSPERYMENTOW")
println("="^80)