//
//  determinant_identity.swift
//

private let a: Math = "a"
private let b: Math = "b"
private let i: Math = "i"
private let j: Math = "j"
private let k: Math = "k"
private let l: Math = "l"
private let n: Math = "n"
private let p: Math = "p"
private let P: Math = "P"
private let PP = Math.cal("P")
private let Q: Math = "p"
private let G: Math = "G"

private let sigma = Math.sigma

struct DeterminantIdentityPaper {
    static func main() -> Document {
        let doc = Document(.article, at: #file + ".tex")
        doc.title("A Determinant Identity To Rule Them All", author: "Adolfo Rodríguez")
        doc.abstract(
            """
            This is the abstract. Abstract text!
            """
        )
        doc.section("The Lindström–Gessel–Viennot Lemma") {
            $0.subsection("General Statement and Proof") {
                $0.theorem(
                    "The Lindström–Gessel–Viennot lemma",
                    """
                    Let \(G) be a directed acyclic graph, and let \(a.sub(1, to: n)), \(b.sub(1, to: n)) (\(n ≥ 1)) be distinct vertices of \(G) so that the set \(P.sub(i,j)) of directed paths between \(a.sub(i)) and \(b.sub(j)) is finite for all \([i,j].inSet(1, to: n)). For every permutation \(sigma) of \(Math.set(1, to: n)), let \(PP.sub(sigma)) denote the set of all tuples \(Math.tuple(p.sub(1), to: p.sub(n))) of non-intersecting (no two of them share a vertex) paths in \(P.sub(1,sigma.of(1)) **…** P.sub(n,sigma.of(n))). Then
                    \(§[
                        P.sub(i,j).abs.det(for: 1 ≤ [i,j] ≤ n) *=* .sum(sigma, of: .sign(sigma) * PP.sub(sigma).abs)
                    ])
                    """
                )
            }
            $0.subsection("Second Section") {
                $0 <- """
                Text of the Second Section
                """
            }
        }
        return doc
    }
}



