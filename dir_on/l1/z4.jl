# Plik: z4.jl
# Autor: Maksymilian Kulakowski 
# Opis: Rozwiązanie zadania 4 z listy nr 1 (Obliczenia Naukowe).
#       Znalezienie najmniejszej liczby x w (1, 2) takiej, 
#       że fl(x * fl(1/x)) != 1.

"""
    find_smallest_reciprocal_error()

Iteruje przez liczby Float64 w przedziale (1.0, 2.0), 
aby znaleźć pierwszą (i zarazem najmniejszą) liczbę `x`,
dla której operacja \$fl(x * fl(1/x))\$ nie jest równa 1.0.

Odpowiada na pytania (a) i (b) z zadania.
"""
function find_smallest_reciprocal_error()
    println("--- ZADANIE 4: Błąd iloczynu odwrotności ---")
    println("Szukanie najmniejszej liczby x w (1, 2) takiej, że x * (1/x) != 1.0 ...")
    println("(To może zająć dłuższą chwilę)")

    one = Float64(1.0)
    two = Float64(2.0)
    
    # Zaczynamy od pierwszej liczby maszynowej WIĘKSZEJ niż 1.0
    x = nextfloat(one)
    
    found = false
    counter = 0

    # Pętla przez wszystkie $2^{52}$ liczb maszynowych w [1, 2)
    while x < two
        counter += 1
        
        # Krok 1: fl(1/x)
        reciprocal = one / x
            
        # Krok 2: fl(x * fl(1/x))
        result = x * reciprocal
            
        # Krok 3: Sprawdzenie warunku
        if result != one
            println("\n## (a) Znaleziono liczbę (pierwszą napotkaną):")
            println("   Wartość x:         $(x)")
            println("   Wartość fl(1/x):   $(reciprocal)")
            println("   Wynik fl(x*fl(1/x)): $(result) (co jest != 1.0)")
            println("   (Znaleziono po sprawdzeniu $counter liczb)")

            println("\n## (b) Najmniejsza taka liczba:")
            println("   Ponieważ iterowaliśmy od 1.0 w górę, pierwsza znaleziona liczba")
            println("   jest jednocześnie najmniejszą szukaną wartością: $(x)")
            
            found = true
            break # Przerywamy pętlę
        end
        
        # Przejdź do kolejnej liczby maszynowej
        x = nextfloat(x)
    end
        
    if !found
        println("Nie znaleziono takiej liczby w przedziale (1, 2).")
    end
end

# Uruchomienie programu
find_smallest_reciprocal_error()
