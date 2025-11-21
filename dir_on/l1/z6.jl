# Plik: z6.jl
# Autor: Maksymilian Kulakowski 
# Opis: Rozwiązanie zadania 6 z listy nr 1 (Obliczenia Naukowe).
#       Porównanie stabilności numerycznej dwóch równoważnych 
#       matematycznie wzorów w obliczu katastrofalnego anulowania.

"""
    f(x::Float64)

Oblicza wartość funkcji \$f(x) = \\sqrt{x^2+1} - 1\$.
Ta forma jest podatna na katastrofalne anulowanie dla małych x.
"""
function f(x::Float64)
    return sqrt(x^2 + 1.0) - 1.0
end

"""
    g(x::Float64)

Oblicza wartość funkcji \$g(x) = x^2 / (\\sqrt{x^2+1}+1)\$.
Ta forma jest numerycznie stabilna dla małych x.
"""
function g(x::Float64)
    # Zgodnie z PDF, używamy poprawnej, 
    # równoważnej matematycznie formy
    return (x^2) / (sqrt(x^2 + 1.0) + 1.0)
end

"""
    run_comparison_test(n_max::Int)

Uruchamia test porównawczy dla f(x) i g(x)
dla x = 8^-n, gdzie n = 1, ..., n_max.
"""
function run_comparison_test(n_max::Int = 14)
    println("--- ZADANIE 6: Błąd utraty precyzji (Katastrofalne anulowanie) ---")
    println("Porównanie f(x) = sqrt(x^2+1)-1  oraz  g(x) = x^2/(sqrt(x^2+1)+1)")
    println("-------------------------------------------------------------------------")
    println("| n | x = 8^-n             | f(x) (Niestabilna)   | g(x) (Stabilna)      |")
    println("|---|----------------------|----------------------|----------------------|")
    
    base = Float64(8.0)
    
    for n in 1:n_max
        x = base^(-n)
        
        val_f = f(x)
        val_g = g(x)
        
        # Formatowanie dla czytelności
        println("| $(rpad(n, 2)) | $(rpad(x, 20)) | $(rpad(val_f, 20)) | $(rpad(val_g, 20)) |")
    end
end

# Uruchomienie testu
run_comparison_test()
