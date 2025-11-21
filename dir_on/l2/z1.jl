# Autor: unseen2004
# Zadanie 1 - Lista 2
# Wplyw malych zmian danych na obliczanie iloczynu skalarnego

# Oryginalne wektory z zadania 5 (Lista 1)
x_original = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

# Zmodyfikowane wektory (usunieta ostatnia 9 z x4 i ostatnia 7 z x5)
x_modified = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]

# Prawidlowa wartosc (z zadania 5)
correct_value = -1.00657107000000e-11

println("="^70)
println("ZADANIE 1 - Wplyw malych zmian danych na wyniki")
println("="^70)
println()

# Funkcja obliczajaca iloczyn skalarny "w przod"
function dot_forward(x, y, T)
    x_T = T.(x)
    y_T = T.(y)
    S = T(0.0)
    for i in 1:length(x_T)
        S += x_T[i] * y_T[i]
    end
    return S
end

# Funkcja obliczajaca iloczyn skalarny "w tyl"
function dot_backward(x, y, T)
    x_T = T.(x)
    y_T = T.(y)
    S = T(0.0)
    for i in length(x_T):-1:1
        S += x_T[i] * y_T[i]
    end
    return S
end

# Funkcja obliczajaca iloczyn skalarny od najwiekszego do najmniejszego
function dot_largest_to_smallest(x, y, T)
    x_T = T.(x)
    y_T = T.(y)

    # Oblicz wszystkie iloczyny
    products = x_T .* y_T

    # Podziel na dodatnie i ujemne
    positive = filter(p -> p > 0, products)
    negative = filter(p -> p < 0, products)

    # Sortuj dodatnie malejaco (od najwiekszego)
    sort!(positive, rev=true)
    # Sortuj ujemne rosnaco (od najmniejszego, czyli najbardziej ujemnego)
    sort!(negative)

    # Sumuj dodatnie
    sum_pos = T(0.0)
    for p in positive
        sum_pos += p
    end

    # Sumuj ujemne
    sum_neg = T(0.0)
    for n in negative
        sum_neg += n
    end

    return sum_pos + sum_neg
end

# Funkcja obliczajaca iloczyn skalarny od najmniejszego do najwiekszego
function dot_smallest_to_largest(x, y, T)
    x_T = T.(x)
    y_T = T.(y)

    # Oblicz wszystkie iloczyny
    products = x_T .* y_T

    # Podziel na dodatnie i ujemne
    positive = filter(p -> p > 0, products)
    negative = filter(p -> p < 0, products)

    # Sortuj dodatnie rosnaco (od najmniejszego)
    sort!(positive)
    # Sortuj ujemne malejaco (od najmniej ujemnego)
    sort!(negative, rev=true)

    # Sumuj dodatnie
    sum_pos = T(0.0)
    for p in positive
        sum_pos += p
    end

    # Sumuj ujemne
    sum_neg = T(0.0)
    for n in negative
        sum_neg += n
    end

    return sum_pos + sum_neg
end

# Funkcja uruchamiajaca wszystkie testy dla danego wektora x
function run_tests(x, y, label)
    println("\n" * "="^70)
    println(label)
    println("="^70)

    methods = [
        ("W przod", dot_forward),
        ("W tyl", dot_backward),
        ("Od najwiekszego do najmniejszego", dot_largest_to_smallest),
        ("Od najmniejszego do najwiekszego", dot_smallest_to_largest)
    ]

    for precision in [Float32, Float64]
        println("\n--- Precyzja: $precision ---")
        for (name, func) in methods
            result = func(x, y, precision)
            error = abs(result - correct_value)
            println("$name:")
            println("  Wynik: $result")
            println("  Blad: $error")
        end
    end
end

# Test dla oryginalnych danych
run_tests(x_original, y, "ORYGINALNE DANE (z Zadania 5)")

# Test dla zmodyfikowanych danych
run_tests(x_modified, y, "ZMODYFIKOWANE DANE (usunieta 9 z x4, 7 z x5)")

# Porownanie zmian w danych
println("\n" * "="^70)
println("ANALIZA ZMIAN W DANYCH")
println("="^70)
println("\nZmiany w wektorze x:")
println("x[4]: $(x_original[4]) -> $(x_modified[4]) (roznica: $(abs(x_original[4] - x_modified[4])))")
println("x[5]: $(x_original[5]) -> $(x_modified[5]) (roznica: $(abs(x_original[5] - x_modified[5])))")
println("\nWspolczynniki y:")
println("y[4]: $(y[4])")
println("y[5]: $(y[5])")
println("\nWplyw na iloczyny czastkowe:")
println("x[4]*y[4]: $(x_original[4]*y[4]) -> $(x_modified[4]*y[4]) (roznica: $(abs(x_original[4]*y[4] - x_modified[4]*y[4])))")
println("x[5]*y[5]: $(x_original[5]*y[5]) -> $(x_modified[5]*y[5]) (roznica: $(abs(x_original[5]*y[5] - x_modified[5]*y[5])))")