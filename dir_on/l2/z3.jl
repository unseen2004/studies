# Autor: unseen2004
# Zadanie 3 - Lista 2
# Uwarunkowanie ukladow rownan liniowych

using LinearAlgebra
using Printf

# Funkcja generujaca macierz Hilberta
function hilb(n::Int)
    # Funkcja generuje macierz Hilberta A rozmiaru n,
    # A(i,j) = 1/(i+j-1)
    # Wejscie:
    #   n: rozmiar macierzy A, n>=1
    if n < 1
        error("size n should be >= 1")
    end
    return [1 / (i + j - 1) for i in 1:n, j in 1:n]
end

# Funkcja generujaca losowa macierz z zadanym wskaznikiem uwarunkowania
function matcond(n::Int, c::Float64)
    # Funkcja generuje losowa macierz kwadratowa A rozmiaru n
    # z zadanym wskaznikiem uwarunkowania c.
    # Wejscie:
    #   n: rozmiar macierzy A, n>1
    #   c: wskaznik uwarunkowania macierzy A, c>=1.0
    if n < 2
        error("size n should be > 1")
    end
    if c < 1.0
        error("condition number c of a matrix should be >= 1.0")
    end
    (U, S, V) = svd(rand(n, n))
    return U * diagm(0 => [LinRange(1.0, c, n);]) * V'
end

println("="^80)
println("ZADANIE 3 - Uwarunkowanie ukladow rownan liniowych")
println("="^80)
println()

# Funkcja obliczajaca blad wzgledny
function relative_error(x_computed, x_exact)
    return norm(x_computed - x_exact) / norm(x_exact)
end

# Funkcja testujaca rozwiazywanie Ax=b dla danej macierzy A
function test_system(A, n, label)
    # Wektor rozwiazania dokladnego
    x_exact = ones(n)

    # Wektor prawych stron
    b = A * x_exact

    # Wskaznik uwarunkowania
    cond_A = cond(A)

    # Rzad macierzy
    rank_A = rank(A)

    # Metoda 1: Eliminacja Gaussa (A\b)
    x_gauss = A \ b
    err_gauss = relative_error(x_gauss, x_exact)

    # Metoda 2: Macierz odwrotna (inv(A)*b)
    x_inv = inv(A) * b
    err_inv = relative_error(x_inv, x_exact)

    return cond_A, rank_A, err_gauss, err_inv
end

# ===================================================================
# EKSPERYMENTY DLA MACIERZY HILBERTA
# ===================================================================
println("\n" * "="^80)
println("EKSPERYMENTY DLA MACIERZY HILBERTA")
println("="^80)
println()

@printf("%-5s %-20s %-10s %-20s %-20s\n",
        "n", "cond(A)", "rank(A)", "Blad Gauss", "Blad inv(A)")
println("-"^80)

hilbert_results = []

for n in 1:20
    try
        A = hilb(n)
        cond_A, rank_A, err_gauss, err_inv = test_system(A, n, "Hilbert n=$n")

        @printf("%-5d %-20.2e %-10d %-20.2e %-20.2e\n",
                n, cond_A, rank_A, err_gauss, err_inv)

        push!(hilbert_results, (n, cond_A, rank_A, err_gauss, err_inv))
    catch e
        @printf("%-5d ERROR: %s\n", n, e)
    end
end

# ===================================================================
# EKSPERYMENTY DLA MACIERZY LOSOWEJ
# ===================================================================
println("\n" * "="^80)
println("EKSPERYMENTY DLA MACIERZY LOSOWEJ")
println("="^80)
println()

sizes = [5, 10, 20]
conditions = [1.0, 10.0, 1e3, 1e7, 1e12, 1e16]

random_results = []

for n in sizes
    println("\n" * "-"^80)
    println("Rozmiar macierzy: n = $n")
    println("-"^80)
    @printf("%-20s %-20s %-10s %-20s %-20s\n",
            "c (zadane)", "cond(A) (rzecz.)", "rank(A)", "Blad Gauss", "Blad inv(A)")
    println("-"^80)

    for c in conditions
        try
            A = matcond(n, c)
            cond_A, rank_A, err_gauss, err_inv = test_system(A, n, "Random n=$n, c=$c")

            @printf("%-20.2e %-20.2e %-10d %-20.2e %-20.2e\n",
                    c, cond_A, rank_A, err_gauss, err_inv)

            push!(random_results, (n, c, cond_A, rank_A, err_gauss, err_inv))
        catch e
            @printf("%-20.2e ERROR: %s\n", c, e)
        end
    end
end

# ===================================================================
# PODSUMOWANIE I ANALIZA
# ===================================================================
println("\n" * "="^80)
println("ANALIZA WYNIKOW")
println("="^80)
println()

println("MACIERZ HILBERTA:")
println("-"^80)
println("Macierz Hilberta jest klasycznym przykladem macierzy ZLE UWARUNKOWANEJ.")
println("Wskaznik uwarunkowania rosnie BARDZO SZYBKO ze wzrostem n:")
for (n, cond_A, rank_A, err_gauss, err_inv) in hilbert_results
    if n in [2, 5, 10, 15, 20]
        @printf("  n=%2d: cond(A) ≈ %.2e, blad Gauss = %.2e, blad inv = %.2e\n",
                n, cond_A, err_gauss, err_inv)
    end
end
println()

println("MACIERZ LOSOWA:")
println("-"^80)
println("Dla macierzy losowej kontrolujemy wskaznik uwarunkowania c.")
println("Wieksze c -> wieksze bledy:")
println()
for n in sizes
    println("  Rozmiar n=$n:")
    for (n_res, c, cond_A, rank_A, err_gauss, err_inv) in random_results
        if n_res == n && c in [1.0, 1e3, 1e7, 1e12, 1e16]
            @printf("    c=%.0e: blad Gauss = %.2e, blad inv = %.2e\n",
                    c, err_gauss, err_inv)
        end
    end
    println()
end

println("POROWNANIE METOD:")
println("-"^80)
println("Eliminacja Gaussa (A\\b) jest zazwyczaj BARDZIEJ STABILNA numerycznie")
println("niz obliczanie przez macierz odwrotna inv(A)*b.")
println()
println("Dlaczego?")
println("- Eliminacja Gaussa: O(n^3) operacji, bezposrednie rozwiazanie")
println("- inv(A)*b: O(n^3) dla inv(A) + O(n^2) dla mnozenia = wiecej operacji")
println("- Obliczanie inv(A) wprowadza dodatkowe bledy zaokraglen")
println()

# Sprawdzenie, ktora metoda jest lepsza (OSTATECZNA POPRAWKA!)
function compare_methods(results)
    gauss_better = 0
    inv_better = 0

    for (n, c, cond_A, rank_A, err_gauss, err_inv) in results
        if err_gauss < err_inv
            gauss_better += 1
        else
            inv_better += 1
        end
    end

    return gauss_better, inv_better
end

gauss_count, inv_count = compare_methods(random_results)

println("Statystyka dla macierzy losowych:")
@printf("  Gauss lepsza: %d/%d przypadkow (%.1f%%)\n",
        gauss_count, length(random_results), 100*gauss_count/length(random_results))
@printf("  inv(A) lepsza: %d/%d przypadkow (%.1f%%)\n",
        inv_count, length(random_results), 100*inv_count/length(random_results))

println("\n" * "="^80)
println("KONIEC EKSPERYMENTOW")
println("="^80)