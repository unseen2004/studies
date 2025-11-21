# Autor: unseen2004
# Zadanie 4 - Lista 2
# "Zlosliwy wielomian" Wilkinsona

# Instalacja pakietu Polynomials jesli nie jest zainstalowany
try
    using Polynomials
catch
    import Pkg
    println("Instalowanie pakietu Polynomials...")
    Pkg.add("Polynomials")
    using Polynomials
end

using Printf

println("="^80)
println("ZADANIE 4 - 'Zlosliwy wielomian' Wilkinsona")
println("="^80)
println()

# Wspolczynniki wielomianu P w postaci naturalnej (od x^0 do x^20)
# P(x) = a_0 + a_1*x + a_2*x^2 + ... + a_20*x^20
coeffs_original = [
    2432902008176640000.0,
    -8752948036761600000.0,
    13803759753640704000.0,
    -12870931245150988800.0,
    8037811822645051776.0,
    -3599979517947607200.0,
    1206647803780373360.0,
    -311333643161390640.0,
    63030812099294896.0,
    -10142299865511450.0,
    1307535010540395.0,
    -135585182899530.0,
    11310276995381.0,
    -756111184500.0,
    40171771630.0,
    -1672280820.0,
    53327946.0,
    -1256850.0,
    20615.0,
    -210.0,
    1.0
]

# Funkcja obliczajaca wartosc wielomianu w postaci iloczynowej
# p(x) = (x-1)(x-2)(x-3)...(x-20)
function p_wilkinson(x)
    result = 1.0
    for k in 1:20
        result *= (x - k)
    end
    return result
end

# Funkcja obliczajaca wartosc wielomianu w postaci naturalnej
function P_wilkinson(x, coeffs)
    n = length(coeffs) - 1
    result = 0.0
    for i in 0:n
        result += coeffs[i+1] * x^i
    end
    return result
end

# Funkcja analizujaca pierwiastki
function analyze_roots(roots_computed, coeffs, label)
    println("="^80)
    println("WYNIKI DLA $label")
    println("="^80)
    println()

    # Sortowanie pierwiastkow
    roots_sorted = sort(roots_computed, by=x->real(x))

    @printf("%-5s %-25s %-15s %-15s %-15s\n",
            "k", "z_k (obliczony)", "|P(z_k)|", "|p(z_k)|", "|z_k - k|")
    println("-"^80)

    max_error_P = 0.0
    max_error_p = 0.0
    max_error_root = 0.0

    for k in 1:20
        z_k = roots_sorted[k]

        # Obliczenie |P(z_k)|
        P_val = abs(P_wilkinson(z_k, coeffs))

        # Obliczenie |p(z_k)|
        p_val = abs(p_wilkinson(z_k))

        # Obliczenie |z_k - k|
        error_root = abs(z_k - k)

        max_error_P = max(max_error_P, P_val)
        max_error_p = max(max_error_p, p_val)
        max_error_root = max(max_error_root, error_root)

        # Wyswietlenie (real dla rzeczywistych, z "i" dla zespolonych)
        if abs(imag(z_k)) < 1e-10
            z_str = @sprintf("%.15f", real(z_k))
        else
            z_str = @sprintf("%.6f%+.6fi", real(z_k), imag(z_k))
        end

        @printf("%-5d %-25s %-15.2e %-15.2e %-15.2e\n",
                k, z_str, P_val, p_val, error_root)
    end

    println("-"^80)
    @printf("Maksymalne bledy: |P(z_k)|=%.2e, |p(z_k)|=%.2e, |z_k-k|=%.2e\n",
            max_error_P, max_error_p, max_error_root)
    println()

    return max_error_P, max_error_p, max_error_root
end

println("="^80)
println("CZESC (a) - Wielomian oryginalny")
println("="^80)
println()

println("Wielomian Wilkinsona p(x) = (x-1)(x-2)(x-3)...(x-20)")
println("ma 20 znanych pierwiastkow: 1, 2, 3, ..., 20")
println()
println("Obliczamy pierwiastki z postaci naturalnej P(x) uzywajac funkcji roots()...")
println()

# Utworzenie wielomianu z wspolczynnikow
P_poly = Polynomial(coeffs_original)

# Obliczenie pierwiastkow
println("Obliczanie pierwiastkow...")
roots_computed = roots(P_poly)

println()
max_err_P_orig, max_err_p_orig, max_err_root_orig = analyze_roots(
    roots_computed, coeffs_original, "WIELOMIANU ORYGINALNEGO"
)

# ===================================================================
# CZESC (b) - Zmiana wspolczynnika -210 na -210 - 2^(-23)
# ===================================================================

println("\n" * "="^80)
println("CZESC (b) - Eksperyment Wilkinsona")
println("="^80)
println()

perturbation = 2.0^(-23)
println("Zmieniamy wspolczynnik -210 na -210 - 2^(-23)")
@printf("Perturbacja: 2^(-23) = %.17e\n", perturbation)
@printf("Nowy wspolczynnik: %.17f\n", -210.0 - perturbation)
println()

# Modyfikacja wspolczynnika przy x^19 (indeks 20)
coeffs_perturbed = copy(coeffs_original)
coeffs_perturbed[20] = -210.0 - perturbation

# Utworzenie wielomianu z zaburzonych wspolczynnikow
P_poly_perturbed = Polynomial(coeffs_perturbed)

# Obliczenie pierwiastkow
println("Obliczanie pierwiastkow zaburzonego wielomianu...")
roots_perturbed = roots(P_poly_perturbed)

println()
max_err_P_pert, max_err_p_pert, max_err_root_pert = analyze_roots(
    roots_perturbed, coeffs_perturbed, "WIELOMIANU ZABURZONEGO"
)

# ===================================================================
# ANALIZA I WNIOSKI
# ===================================================================

println("\n" * "="^80)
println("ANALIZA ZJAWISKA")
println("="^80)
println()

println("1. PROBLEM Z POSTACIA NATURALNA:")
println("-"^80)
println("Wielomian w postaci naturalnej jest EKSTREMALNIE ZLE UWARUNKOWANY.")
println("Wspolczynniki roznia sie o wiele rzedow wielkosci:")
@printf("  - Wyraz wolny: %.2e\n", coeffs_original[1])
@printf("  - Wspolczynnik przy x^19: %.2e\n", coeffs_original[20])
@printf("  - Stosunek: %.2e\n", abs(coeffs_original[1] / coeffs_original[20]))
println()

println("2. POROWNANIE |P(z_k)| vs |p(z_k)|:")
println("-"^80)
println("- |P(z_k)| - duze wartosci (bledy w postaci naturalnej)")
println("- |p(z_k)| - male wartosci (postac iloczynowa jest stabilna)")
println("Postac iloczynowa p(x) = (x-1)(x-2)...(x-20) jest NUMERYCZNIE STABILNA!")
println()

println("3. WRAZLIWOSC NA PERTURBACJE:")
println("-"^80)
@printf("Zmiana wspolczynnika o %.2e (czyli o ~%.6f%%) powoduje:\n",
        perturbation, 100*perturbation/210)
@printf("- Zmiane maksymalnego bledu pierwiastka z %.2e na %.2e\n",
        max_err_root_orig, max_err_root_pert)
if max_err_root_orig > 1e-15
    @printf("- Wzmocnienie bledu: %.2e razy!\n", max_err_root_pert / max_err_root_orig)
else
    @printf("- Wzmocnienie bledu: OGROMNE (z praktycznie 0 do %.2e)!\n", max_err_root_pert)
end
println()

println("4. WSKAZNIK UWARUNKOWANIA:")
println("-"^80)
println("Problem obliczania pierwiastkow wielomianu w postaci naturalnej")
println("jest ZLE UWARUNKOWANY, szczegolnie dla wielomianow wysokiego stopnia")
println("z pierwiastkami o roznicy rzedow wielkosci.")
println()
println("Arytmetyka Float64 ma 15-17 cyfr znaczacych, ale wspolczynniki")
println("wielomianu Wilkinsona maja ~20 cyfr. Bledy zaokraglen sa nieuniknione!")
println()

println("5. WNIOSKI PRAKTYCZNE:")
println("-"^80)
println("- NIGDY nie obliczaj pierwiastkow z postaci naturalnej!")
println("- Uzywaj postaci iloczynowej, jesli to mozliwe")
println("- Problem obliczania pierwiastkow wielomianow jest niestabilny")
println("- Male zmiany wspolczynnikow -> OGROMNE zmiany pierwiastkow")
println("- To jest klasyczny przyklad ZLE UWARUNKOWANEGO problemu")

println("\n" * "="^80)
println("KONIEC EKSPERYMENTU")
println("="^80)