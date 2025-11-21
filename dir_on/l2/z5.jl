# Autor: unseen2004
# Zadanie 5 - Lista 2
# Model logistyczny (wzrost populacji)

using Printf

println("="^80)
println("ZADANIE 5 - Model logistyczny (wzrost populacji)")
println("="^80)
println()

println("Rownanie rekurencyjne: p_{n+1} = p_n + r*p_n*(1-p_n)")
println("gdzie:")
println("  p_n - procent maksymalnej wielkosci populacji")
println("  r   - stala wzrostu")
println()

# Funkcja obliczajaca jedna iteracje modelu logistycznego
function logistic_step(p, r, T)
    p_T = T(p)
    r_T = T(r)
    return p_T + r_T * p_T * (T(1) - p_T)
end

# Funkcja wykonujaca n iteracji modelu logistycznego
function logistic_iterations(p0, r, n, T)
    results = zeros(T, n+1)
    results[1] = T(p0)

    for i in 1:n
        results[i+1] = logistic_step(results[i], r, T)
    end

    return results
end

# Funkcja wykonujaca iteracje z obcieciem po k-tej iteracji
function logistic_iterations_truncated(p0, r, n, k, truncate_digits, T)
    results = zeros(T, n+1)
    results[1] = T(p0)

    for i in 1:n
        results[i+1] = logistic_step(results[i], r, T)

        # Obciecie po k-tej iteracji
        if i == k
            # Obcinamy do truncate_digits cyfr po przecinku
            scale = T(10)^truncate_digits
            results[i+1] = floor(results[i+1] * scale) / scale
        end
    end

    return results
end

# ===================================================================
# EKSPERYMENT 1: Wplyw obciecia wyniku (Float32)
# ===================================================================

println("="^80)
println("EKSPERYMENT 1: Wplyw obciecia wyniku po 10. iteracji")
println("="^80)
println()

p0 = 0.01
r = 3.0
n_iterations = 40
truncate_at = 10
truncate_to = 3

println("Parametry:")
@printf("  p_0 = %.2f\n", p0)
@printf("  r = %.1f\n", r)
@printf("  Liczba iteracji: %d\n", n_iterations)
@printf("  Arytmetyka: Float32\n")
println()

# Wersja normalna (bez obciecia)
println("Wykonywanie 40 iteracji bez obciecia...")
results_normal = logistic_iterations(p0, r, n_iterations, Float32)

# Wersja z obcieciem po 10. iteracji do 3 cyfr po przecinku (0.722)
println("Wykonywanie 40 iteracji z obcieciem po 10. iteracji do 0.722...")
results_truncated = logistic_iterations_truncated(p0, r, n_iterations, truncate_at, truncate_to, Float32)

println()
println("="^80)
println("WYNIKI EKSPERYMENTU 1")
println("="^80)
println()

@printf("%-5s %-20s %-20s %-20s\n", "n", "p_n (normalne)", "p_n (obciete)", "Roznica")
println("-"^80)

for i in [1, 5, 10, 11, 15, 20, 25, 30, 35, 40, 41]
    if i <= length(results_normal)
        diff = abs(results_normal[i] - results_truncated[i])
        @printf("%-5d %-20.15f %-20.15f %-20.2e\n",
                i-1, results_normal[i], results_truncated[i], diff)
    end
end

println()
println("PELNA TABELA (wszystkie iteracje):")
println("-"^80)
@printf("%-5s %-20s %-20s %-20s\n", "n", "p_n (normalne)", "p_n (obciete)", "Roznica")
println("-"^80)

for i in 1:(n_iterations+1)
    diff = abs(results_normal[i] - results_truncated[i])
    @printf("%-5d %-20.15f %-20.15f %-20.2e\n",
            i-1, results_normal[i], results_truncated[i], diff)
end

# ===================================================================
# EKSPERYMENT 2: Porownanie Float32 vs Float64
# ===================================================================

println("\n" * "="^80)
println("EKSPERYMENT 2: Porownanie Float32 vs Float64")
println("="^80)
println()

println("Parametry:")
@printf("  p_0 = %.2f\n", p0)
@printf("  r = %.1f\n", r)
@printf("  Liczba iteracji: %d\n", n_iterations)
println()

# Float32
println("Wykonywanie 40 iteracji w Float32...")
results_float32 = logistic_iterations(p0, r, n_iterations, Float32)

# Float64
println("Wykonywanie 40 iteracji w Float64...")
results_float64 = logistic_iterations(p0, r, n_iterations, Float64)

println()
println("="^80)
println("WYNIKI EKSPERYMENTU 2")
println("="^80)
println()

@printf("%-5s %-25s %-25s %-20s\n", "n", "p_n (Float32)", "p_n (Float64)", "Roznica")
println("-"^80)

for i in [1, 5, 10, 15, 20, 25, 30, 35, 40, 41]
    if i <= length(results_float32)
        diff = abs(Float64(results_float32[i]) - results_float64[i])
        @printf("%-5d %-25.15f %-25.15f %-20.2e\n",
                i-1, results_float32[i], results_float64[i], diff)
    end
end

println()
println("PELNA TABELA (wszystkie iteracje):")
println("-"^80)
@printf("%-5s %-25s %-25s %-20s\n", "n", "p_n (Float32)", "p_n (Float64)", "Roznica")
println("-"^80)

for i in 1:(n_iterations+1)
    diff = abs(Float64(results_float32[i]) - results_float64[i])
    @printf("%-5d %-25.15f %-25.15f %-20.2e\n",
            i-1, results_float32[i], results_float64[i], diff)
end

# ===================================================================
# ANALIZA I WNIOSKI
# ===================================================================

println("\n" * "="^80)
println("ANALIZA ZJAWISKA")
println("="^80)
println()

println("1. WRAŻLIWOSC NA MALE PERTURBACJE (Eksperyment 1):")
println("-"^80)
println("Obciecie wyniku po 10. iteracji z")
@printf("  %.15f do 0.722\n", results_normal[11])
println("spowodowalo perturbacje rzedu:")
perturbation = abs(results_normal[11] - 0.722f0)
@printf("  %.2e\n", perturbation)
println()
println("Ta MIKROSKOPUJNA zmiana (~1e-6) prowadzi do:")
max_diff = maximum(abs.(results_normal - results_truncated))
@printf("  - Maksymalnej roznicy po 40 iteracjach: %.2e\n", max_diff)
println()
println("To jest klasyczny przyklad CHAOTYCZNEGO ZACHOWANIA!")
println("W ukladach chaotycznych male perturbacje poczatkowe")
println("prowadza do CALKOWICIE ROZNYCH trajektorii (efekt motyla).")
println()

println("2. WPLYW PRECYZJI ARYTMETYKI (Eksperyment 2):")
println("-"^80)
println("Float32 ma ~7 cyfr znaczacych")
println("Float64 ma ~15-17 cyfr znaczacych")
println()
max_diff_precision = maximum(abs.(Float64.(results_float32) .- results_float64))
@printf("Maksymalna roznica miedzy Float32 i Float64: %.2e\n", max_diff_precision)
println()
println("Bledy zaokraglen w Float32 akumuluja sie w kazdej iteracji")
println("i po kilkudziesieciu iteracjach prowadza do znaczacych roznic.")
println()

println("3. CHAOS DETERMINISTYCZNY:")
println("-"^80)
println("Model logistyczny dla r=3 wykazuje CHAOTYCZNE zachowanie.")
println("Rownianie jest DETERMINISTYCZNE (znamy dokladny wzor),")
println("ale zachowanie jest NIEPRZEWIDYWALNE w dlugim czasie")
println("ze wzgledu na EKSTREMALNA WRAZLIWOSC na warunki poczatkowe.")
println()
println("To jest podstawowy przyklad TEORII CHAOSU:")
println("  - Uklad jest deterministyczny")
println("  - Male bledy (zaokraglen, pomiarow) rosna WYKLADNICZO")
println("  - Przewidywanie dlugoterminowe jest NIEMOZLIWE")
println()

println("4. WYKLADNIK LAPUNOWA:")
println("-"^80)
println("Dla modelu logistycznego z r=3, uklad jest w reżimie chaotycznym.")
println("Dodatni wykladnik Lapunowa oznacza, ze male perturbacje")
println("rosna WYKLADNICZO w czasie, co widac w naszych wynikach.")
println()

println("5. WNIOSKI PRAKTYCZNE:")
println("-"^80)
println("- Dla ukladow chaotycznych przewidywanie dlugoterminowe jest niemozliwe")
println("- Wyzsze precyzje arytmetyki pozwalaja na dluzsze przewidywanie,")
println("  ale nie eliminuja chaosu")
println("- Male bledy (pomiarowe, obliczeniowe) ZAWSZE prowadza")
println("  do roznych trajektorii w ukladach chaotycznych")
println("- To wyjasnia, dlaczego prognoza pogody jest trudna:")
println("  atmosfera jest ukladem chaotycznym!")

println("\n" * "="^80)
println("KONIEC EKSPERYMENTOW")
println("="^80)