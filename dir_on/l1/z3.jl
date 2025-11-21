# Plik: z3.jl
# Autor: Maksymilian Kulakowski 
# Opis: Rozwiązanie zadania 3 z listy nr 1 (Obliczenia Naukowe).
#       Badanie rozmieszczenia liczb Float64 w przedziałach [1,2],
#       [1/2, 1] oraz [2, 4] przy użyciu funkcji bitstring.

"""
    analyze_distribution()

Funkcja drukuje analizę rozmieszczenia liczb Float64
w trzech kluczowych przedziałach: [1/2, 1], [1, 2] i [2, 4].
"""
function analyze_distribution()
    println("--- ZADANIE 3: Rozmieszczenie liczb Float64 ---")
    
    # --- Analiza przedziału [1.0, 2.0] ---
    println("\n## 1. Analiza przedziału [1.0, 2.0]")
    
    one = Float64(1.0)
    # Delta dla przedziału [1, 2] jest równa eps(1.0)
    delta_1_2 = eps(one)
    next_num_1_2 = nextfloat(one)
    
    println("   Wartość 1.0:         $(one)")
    println("   Reprezentacja bitowa 1.0: $(bitstring(one))")
    println("   Delta (krok) = eps(1.0): $(delta_1_2) (co jest równe 2^-52)")
    println("   Kolejna liczba (1.0 + delta): $(next_num_1_2)")
    println("   Reprezentacja bitowa (1.0 + delta): $(bitstring(next_num_1_2))")
    println("\n   Wnioski dla [1, 2]:")
    println("   W przedziale [1, 2] (dokładniej [1, 2) ) wykładnik jest stały (01111111111 = 1023).")
    println("   Kolejne liczby maszynowe są tworzone przez inkrementację 52-bitowej mantysy.")
    println("   Różnica między nimi jest stała i wynosi \$k \\cdot 2^{-52}\$, co potwierdza tezę.")
    println("   Krok \$delta\$ = $delta_1_2.")


    # --- Analiza przedziału [2.0, 4.0] ---
    println("\n## 2. Analiza przedziału [2.0, 4.0]")
    
    two = Float64(2.0)
    # Delta dla przedziału [2, 4] jest równa eps(2.0)
    delta_2_4 = eps(two)
    next_num_2_4 = nextfloat(two)
    
    println("   Wartość 2.0:         $(two)")
    println("   Reprezentacja bitowa 2.0: $(bitstring(two))")
    println("   Delta (krok) = eps(2.0): $(delta_2_4)")
    println("   Kolejna liczba (2.0 + delta): $(next_num_2_4)")
    println("   Reprezentacja bitowa (2.0 + delta): $(bitstring(next_num_2_4))")
    println("\n   Wnioski dla [2, 4]:")
    println("   W przedziale [2, 4] (dokładniej [2, 4) ) wykładnik jest stały (10000000000 = 1024).")
    println("   Rozmieszczenie jest również równomierne, ale krok jest 2x WIĘKSZY.")
    println("   Krok \$delta\$ = $delta_2_4 (czyli \$2 \\cdot eps(1.0) = 2^{-51}\$).")
    println("   Liczby można przedstawić jako \$x = 2.0 + k \\cdot 2^{-51}\$.")


    # --- Analiza przedziału [0.5, 1.0] ---
    println("\n## 3. Analiza przedziału [0.5, 1.0]")
    
    half = Float64(0.5)
    # Delta dla przedziału [0.5, 1] jest równa eps(0.5)
    delta_05_1 = eps(half)
    next_num_05_1 = nextfloat(half)
    
    println("   Wartość 0.5:         $(half)")
    println("   Reprezentacja bitowa 0.5: $(bitstring(half))")
    println("   Delta (krok) = eps(0.5): $(delta_05_1)")
    println("   Kolejna liczba (0.5 + delta): $(next_num_05_1)")
    println("   Reprezentacja bitowa (0.5 + delta): $(bitstring(next_num_05_1))")
    println("\n   Wnioski dla [0.5, 1.0]:")
    println("   W przedziale [0.5, 1] (dokładniej [0.5, 1) ) wykładnik jest stały (01111111110 = 1022).")
    println("   Rozmieszczenie jest również równomierne, ale krok jest 2x MNIEJSZY.")
    println("   Krok \$delta\$ = $delta_05_1 (czyli \$eps(1.0) / 2 = 2^{-53}\$).")
    println("   Liczby można przedstawić jako \$x = 0.5 + k \\cdot 2^{-53}\$.")
end

# Uruchomienie analizy
analyze_distribution()
