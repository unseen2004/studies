# Plik: z1.jl 
# Autor: Maksymilian Kulakowski 
# Opis: Rozwiązanie zadania 1 z listy nr 1 (Obliczenia Naukowe).
#       Program iteracyjnie wyznacza macheps, eta i MAX dla typów
#       Float16, Float32 i Float64.

"""
    find_macheps(T::Type{<:AbstractFloat})

Iteracyjnie wyznacza epsilon maszynowy (macheps) dla podanego typu T.
Zgodnie z definicją, jest to najmniejsza liczba > 0,
która po dodaniu do jedynki daje wynik większy od jedynki.

Logika: Zaczynamy od 1.0 i dzielimy przez 2.0 tak długo, 
aż (1.0 + macheps/2.0) będzie równe 1.0. Ostatnia wartość `macheps`,
dla której (1.0 + macheps/2.0) > 1.0, jest szukaną wartością.
"""
function find_macheps(T::Type{<:AbstractFloat})
    macheps = T(1.0)
    one = T(1.0)
    two = T(2.0)
    
    # Dzielimy tak długo, jak "połowa" jest wciąż rozróżnialna od zera 
    # po dodaniu do jedynki
    while (one + (macheps / two)) > one
        macheps = macheps / two
    end
    return macheps
end

"""
    find_eta(T::Type{<:AbstractFloat})

Iteracyjnie wyznacza najmniejszą dodatnią liczbę maszynową (eta)
dla podanego typu T.
    
Logika: Zgodnie ze wskazówką, zaczynamy od 1.0 i dzielimy 
w pętli przez 2.0 tak długo, aż (eta / 2.0) będzie równe 0.0.
Ostatnia wartość `eta`, dla której (eta / 2.0) > 0.0, jest szukaną wartością.
"""
function find_eta(T::Type{<:AbstractFloat})
    eta = T(1.0)
    two = T(2.0)
    zero = T(0.0)
    
    # Dzielimy tak długo, jak "połowa" jest wciąż większa od zera
    while (eta / two) > zero
        eta = eta / two
    end
    return eta
end

"""
    find_max_float(T::Type{<:AbstractFloat})

Iteracyjnie wyznacza największą skończoną liczbę maszynową (MAX)
dla podanego typu T.
    
Logika: Zgodnie ze wskazówką, korzystamy z `isinf`.
1. Najpierw znajdujemy największą potęgę dwójki (2^emax) mniejszą od Inf.
2. Następnie "wypełniamy" mantysę, dodając malejące potęgi dwójki 
   (kroki `step`), tak długo, jak długo suma nie staje się Inf.
"""
function find_max_float(T::Type{<:AbstractFloat})
    one = T(1.0)
    two = T(2.0)
    zero = T(0.0)
    
    # 1. Znajdź największą potęgę 2
    max_val = one
    while !isinf(max_val * two)
        max_val *= two
    end
    
    # max_val jest teraz największą potęgą 2 (np. 2^1023 dla Float64)
    
    # 2. Wypełnij mantysę
    step = max_val / two
    while step > zero
        # Dodajemy krok, jeśli wynik wciąż jest skończony
        if !isinf(max_val + step)
            max_val += step
        end
        # Zmniejszamy krok
        step /= two
    end
    return max_val
end

"""
    run_tests()

Funkcja główna uruchamiająca testy dla typów Float16, Float32 i Float64
i drukująca wyniki porównawcze.
"""
function run_tests()
    float_types = [Float16, Float32, Float64]
    
    println("--- ZADANIE 1: ROZPOZNANIE ARYTMETYKI ---")
    
    # --- Test 1: Macheps ---
    println("\n## 1. Epsilon Maszynowy (macheps)")
    println("----------------------------------------")
    println("| Typ     | Wartość iteracyjna      | eps(T)                  | C (float.h)           |")
    println("|---------|-------------------------|-------------------------|-----------------------|")
    
    m16_iter = find_macheps(Float16)
    m16_eps = eps(Float16)
    println("| Float16 | $(m16_iter)             | $(m16_eps)             | (brak)                |")
    
    m32_iter = find_macheps(Float32)
    m32_eps = eps(Float32)
    println("| Float32 | $(m32_iter)         | $(m32_eps)         | $(1.1920929f-7) (FLT_EPSILON) |")
    
    m64_iter = find_macheps(Float64)
    m64_eps = eps(Float64)
    println("| Float64 | $(m64_iter) | $(m64_eps) | $(2.220446049250313e-16) (DBL_EPSILON) |")
    
    
    # --- Test 2: Eta (MIN_sub) ---
    println("\n## 2. Najmniejsza liczba dodatnia (eta / MIN_sub)")
    println("-----------------------------------------------------")
    println("| Typ     | Wartość iteracyjna  | nextfloat(T(0.0))   | C (float.h)                |")
    println("|---------|---------------------|---------------------|----------------------------|")
    
    e16_iter = find_eta(Float16)
    e16_next = nextfloat(Float16(0.0))
    println("| Float16 | $(e16_iter)         | $(e16_next)         | (brak)                     |")
    
    e32_iter = find_eta(Float32)
    e32_next = nextfloat(Float32(0.0))
    println("| Float32 | $(e32_iter)     | $(e32_next)     | (FLT_TRUE_MIN, ~1.4e-45) |")
    
    e64_iter = find_eta(Float64)
    e64_next = nextfloat(Float64(0.0))
    println("| Float64 | $(e64_iter) | $(e64_next) | (DBL_TRUE_MIN, ~4.9e-324)|")
    

    # --- Test 3: MAX (floatmax) ---
    println("\n## 3. Największa liczba skończona (MAX)")
    println("--------------------------------------------------")
    println("| Typ     | Wartość iteracyjna  | floatmax(T)         | C (float.h)            |")
    println("|---------|---------------------|---------------------|------------------------|")
    
    max16_iter = find_max_float(Float16)
    max16_max = floatmax(Float16)
    println("| Float16 | $(max16_iter)             | $(max16_max)             | (brak)                 |")
    
    max32_iter = find_max_float(Float32)
    max32_max = floatmax(Float32)
    println("| Float32 | $(max32_iter)    | $(max32_max)    | $(3.4028235f38) (FLT_MAX)  |")
    
    max64_iter = find_max_float(Float64)
    max64_max = floatmax(Float64)
    println("| Float64 | $(max64_iter) | $(max64_iter) | $(1.7976931348623157e308) (DBL_MAX) |")
    
    # --- Pytania teoretyczne ---
    println("\n## 4. Pytania teoretyczne")
    println("----------------------------------------")
    println("Pytanie: Jaki związek ma liczba macheps z precyzją arytmetyki (oznaczoną na wykładzie przez ε)?")
    # POPRAWKA: Użyto \$\epsilon\$ zamiast $\epsilon$
    println("Odpowiedź: Wyznaczona liczba `macheps` jest DOKŁADNIE tą precyzją, oznaczaną jako \$\epsilon\$. Definiuje ona górny kres względnego błędu reprezentacji dla liczb znormalizowanych. Jest to odległość od 1.0 do następnej reprezentowalnej liczby maszynowej.")
    
    println("\nPytanie: Jaki związek ma liczba eta z liczbą MIN_sub?")
    # POPRAWKA: Użyto \$MIN_{sub}\$ zamiast $MIN_{sub}$
    println("Odpowiedź: Wyznaczona iteracyjnie liczba `eta` (najmniejsza liczba > 0.0) jest DOKŁADNIE równa wartości \$MIN_{sub}\$, czyli najmniejszej dodatniej liczbie zdenormalizowanej (subnormalnej).")
    
    println("\nPytanie: Co zwracają funkcje floatmin(Float32) i floatmin(Float64) i jaki jest związek zwracanych wartości z liczbą MIN_nor?")
    # POPRAWKA: Użyto \$MIN_{nor}\$ zamiast $MIN_{nor}$
    println("Odpowiedź: Funkcje `floatmin(Float32)` i `floatmin(Float64)` zwracają DOKŁADNIE wartość \$MIN_{nor}\$, czyli najmniejszą dodatnią liczbę ZNORMALIZOWANĄ. Jest to wartość większa niż wyznaczona przez nas `eta` (będąca \$MIN_{sub}\$).")
    
    # Te linie były poprawne, ponieważ $(...) to poprawna interpolacja Julii
    println("   - floatmin(Float32) = $(floatmin(Float32)) (vs eta = $(e32_iter))")
    println("   - floatmin(Float64) = $(floatmin(Float64)) (vs eta = $(e64_iter))")
    
end

# Uruchomienie głównej funkcji programu
run_tests()
