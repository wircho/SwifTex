//
//  determinant_identity.swift
//

private let a: Math = "a"
private let b: Math = "b"
private let f: Math = "f"
private let i: Math = "i"
private let j: Math = "j"
private let k: Math = "k"
private let l: Math = "l"
private let n: Math = "n"
private let P: Math = "P"
private let PP = Math.cal("P")
private let QQ = Math.cal("Q")
private let pp = Math.bf("p")
private let qq = Math.bf("q")
private let Q: Math = "p"
private let G: Math = "G"

private let sigma = Math.sigma

struct DeterminantIdentityPaper {
    static func main() -> Document {
        let doc = Document(.article, at: #file + ".tex")
        doc <- Title("A Determinant Identity To Rule Them All", author: "Adolfo Rodríguez")
        doc <- Abstract(
            """
            This is the abstract. Abstract text!
            """
        )
        doc.section("The Lindström–Gessel–Viennot Lemma") {
            $0.subsection("General Statement and Proof") {
                $0.theorem(
                    "The Lindström–Gessel–Viennot lemma",
                    """
                    Let \(G) be a directed acyclic graph, and let \(a.sub(1, to: n)), \(b.sub(1, to: n)) (\(n ≥ 1)) be distinct vertices of \(G) so that the set \(P.sub(i,j)) of directed paths between \(a.sub(i)) and \(b.sub(j)) is finite for all \([i,j].isIn(.set(1, to: n))). For every permutation \(sigma) of \(Math.set(1, to: n)), let \(QQ.sub(sigma)) denote the set of all tuples of non-intersecting (no two of them share a vertex) paths in \(P.sub([1,sigma.of(1)], timesTo:[n,sigma.of(n)])). Then
                    \(§[ P.sub(i,j).abs.det(for: 1 ≤ [i,j] ≤ n) == .sum(sigma, of: .sign(sigma) * QQ.sub(sigma).abs) ].comma)
                    where the sum is over all permutations \(sigma) of \(Math.set(1, to: n)).
                    """
                )
                $0.proof {
                    $0 <- """
                    Denote \(PP.sub(sigma) <- P.sub([1,sigma.of(1)], timesTo:[n,sigma.of(n)])). By the definition of the determinant;
                    \(§[ P.sub(i,j).abs.det(for: 1 ≤ [i,j] ≤ n) == .sum(sigma, of: .sign(sigma) * PP.sub(sigma).abs) ].period)
                    Denote \(PP <- .union(sigma, of: PP.sub(sigma))), and \(QQ <- Math.union(sigma, of: QQ.sub(sigma)).isSubsetOrEqual(to: PP)), and define \(Math.sign.function(from: PP, to: .set(1, -1))) by \(.sign(pp) <- .sign(sigma)) for \(pp.isIn(PP.sub(sigma))). So the right hand side of the equation above becomes:
                    \(§[ .sum(pp.isIn(PP), of: .sign(pp))
                    *=* .sum(pp.isIn(QQ), of: .sign(pp)) + .sum(pp.isIn(PP - QQ), of: .sign(pp))
                    *=* .sum(sigma, of: .sign(sigma) * QQ.sub(sigma).abs) + .sum(pp.isIn(PP - QQ), of: .sign(pp)) ].period)
                    It is thus sufficient to prove that the last sum equals zero. One way to do this is to show the existence of a sign-reversing involution on \(PP - QQ). That is, a function \(f.function(from: PP - QQ, to: PP - QQ)) satisfying:
                    
                    """
                    $0 <- Enumerate {
                        $0 <- "\(Math.sign.of(f.of(pp)) == -.sign(pp)) for all \(pp.isIn(PP - QQ))"
                        $0 <- "\(f.of(f.of(pp)) == pp) for all \(pp.isIn(PP - QQ))"
                    }
                }
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



