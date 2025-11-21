# Autor: unseen2004
# Zadanie 2 - Lista 2
# Wizualizacja funkcji f(x) = e^x * ln(1 + e^(-x))

# Instalacja pakietu Plots jesli nie jest zainstalowany
try
    using Plots
catch
    import Pkg
    println("Instalowanie pakietu Plots...")
    Pkg.add("Plots")
    using Plots
end

using Printf

println("="^70)
println("ZADANIE 2 - Analiza funkcji f(x) = e^x * ln(1 + e^(-x))")
println("="^70)
println()

# Definicja funkcji
f(x) = exp(x) * log(1 + exp(-x))

# Alternatywna forma (bardziej stabilna numerycznie dla duzych x)
# Wykorzystujemy fakt, ze ln(1 + e^(-x)) ≈ e^(-x) dla duzych x
f_stable(x) = x > 20 ? exp(x) * exp(-x) : exp(x) * log(1 + exp(-x))

println("ANALIZA MATEMATYCZNA:")
println("-"^70)
println("Funkcja: f(x) = e^x * ln(1 + e^(-x))")
println()
println("Obliczenie granicy lim(x->inf) f(x):")
println("Dla duzych x: e^(-x) -> 0")
println("Wiec: ln(1 + e^(-x)) -> ln(1 + 0) = 0")
println("Mamy nieoznaczonosc inf * 0")
println()
println("Rozwijajac ln(1 + e^(-x)) w szereg Taylora:")
println("ln(1 + e^(-x)) ≈ e^(-x) - e^(-2x)/2 + ... dla malych e^(-x)")
println("f(x) ≈ e^x * e^(-x) = 1")
println()
println("GRANICA TEORETYCZNA: lim(x->inf) f(x) = 1")
println("="^70)
println()

# Obliczenia numeryczne dla roznych wartosci x
println("OBLICZENIA NUMERYCZNE:")
println("-"^70)
@printf("%-10s %-25s %-25s %-15s\n", "x", "f(x) [bezposrednia]", "e^(-x)", "1+e^(-x)")
println("-"^70)

x_values = [1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 100.0, 200.0, 300.0, 500.0, 700.0]

for x in x_values
    fx = f(x)
    exp_minus_x = exp(-x)
    one_plus_exp = 1 + exp(-x)
    @printf("%-10.1f %-25.17e %-25.17e %-15.17e\n", x, fx, exp_minus_x, one_plus_exp)
end

println("="^70)
println()

# Przygotowanie danych do wykresow
x_range1 = 0:0.1:10
x_range2 = 0:1:100
x_range3 = 0:5:500

y1 = [f(x) for x in x_range1]
y2 = [f(x) for x in x_range2]
y3 = [f(x) for x in x_range3]

# WYKRES 1 - Plots.jl (zakres 0-10)
println("Generowanie wykresu 1 (Plots.jl, zakres 0-10)...")
p1 = plot(x_range1, y1,
    label="f(x) = e^x * ln(1 + e^(-x))",
    xlabel="x",
    ylabel="f(x)",
    title="Wykres funkcji f(x) - zakres [0, 10]",
    linewidth=2,
    legend=:right,
    size=(800, 600))
hline!([1.0], label="Granica = 1", linestyle=:dash, linewidth=2, color=:red)
savefig(p1, "zadanie2_wykres1_0_10.png")
println("Zapisano: zadanie2_wykres1_0_10.png")

# WYKRES 2 - Plots.jl (zakres 0-100)
println("Generowanie wykresu 2 (Plots.jl, zakres 0-100)...")
p2 = plot(x_range2, y2,
    label="f(x) = e^x * ln(1 + e^(-x))",
    xlabel="x",
    ylabel="f(x)",
    title="Wykres funkcji f(x) - zakres [0, 100]",
    linewidth=2,
    legend=:right,
    size=(800, 600))
hline!([1.0], label="Granica = 1", linestyle=:dash, linewidth=2, color=:red)
savefig(p2, "zadanie2_wykres2_0_100.png")
println("Zapisano: zadanie2_wykres2_0_100.png")

# WYKRES 3 - Plots.jl (zakres 0-500) - tutaj zobaczymy problem!
println("Generowanie wykresu 3 (Plots.jl, zakres 0-500)...")
p3 = plot(x_range3, y3,
    label="f(x) = e^x * ln(1 + e^(-x))",
    xlabel="x",
    ylabel="f(x)",
    title="Wykres funkcji f(x) - zakres [0, 500] - PROBLEM!",
    linewidth=2,
    legend=:right,
    size=(800, 600))
hline!([1.0], label="Granica = 1", linestyle=:dash, linewidth=2, color=:red)
savefig(p3, "zadanie2_wykres3_0_500.png")
println("Zapisano: zadanie2_wykres3_0_500.png")

# WYKRES 4 - Porownanie form obliczeniowych
println("Generowanie wykresu 4 - porownanie stabilnosci...")
x_range4 = 0:1:100
y_direct = [f(x) for x in x_range4]
y_stable = [f_stable(x) for x in x_range4]

p4 = plot(x_range4, y_direct,
    label="Forma bezposrednia",
    xlabel="x",
    ylabel="f(x)",
    title="Porownanie form obliczeniowych",
    linewidth=2,
    legend=:right,
    size=(800, 600))
plot!(x_range4, y_stable, label="Forma stabilna", linewidth=2, linestyle=:dash)
hline!([1.0], label="Granica = 1", linestyle=:dot, linewidth=2, color=:red)
savefig(p4, "zadanie2_wykres4_porownanie.png")
println("Zapisano: zadanie2_wykres4_porownanie.png")

println()
println("="^70)
println("ANALIZA ZJAWISKA:")
println("-"^70)
println("Dla duzych wartosci x (np. x > 700):")
println("1. e^(-x) staje sie tak male, ze w arytmetyce Float64 wynosi 0.0")
println("2. Wtedy 1 + e^(-x) = 1 + 0 = 1")
println("3. ln(1) = 0")
println("4. f(x) = e^x * 0 = 0  [zamiast poprawnej wartosci 1]")
println()
println("To jest przyklad UTRATY CYFR ZNACZACYCH (catastrophic cancellation)")
println("W wyrazeniu 1 + e^(-x), gdy e^(-x) < macheps ≈ 2.22e-16,")
println("wynik zaokraglenia daje dokladnie 1.0, co prowadzi do bledu.")
println()
println("Wykres powinien dazyc do 1, ale dla bardzo duzych x")
println("numerycznie otrzymujemy 0 z powodu ograniczen precyzji Float64.")
println("="^70)