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
private let v: Math = "v"

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
        doc <- Section("The Lindström–Gessel–Viennot Lemma") {
            $0 <- Subsection("General Statement and Proof") {
                $0 <- Theorem(
                    "The Lindström–Gessel–Viennot lemma",
                    """
                    Let \(G) be a directed acyclic graph, and let \(a.sub(1, to: n)), \(b.sub(1, to: n)) (\(n ≥ 1)) be distinct vertices of \(G) so that the set \(P.sub(i,j)) of directed paths between \(a.sub(i)) and \(b.sub(j)) is finite for all \([i,j].isIn(.set(1, to: n))). For every permutation \(sigma) of \(Math.set(1, to: n)), let \(QQ.sub(sigma)) denote the set of all tuples of non-intersecting (no two of them share a vertex) paths in \(P.sub([1,sigma.of(1)], timesTo:[n,sigma.of(n)])). Then
                    \(§[ P.sub(i,j).abs.det(for: 1 ≤ [i,j] ≤ n) == .sum(sigma, of: .sign(sigma) * QQ.sub(sigma).abs) ].comma)
                    where the sum is over all permutations \(sigma) of \(Math.set(1, to: n)).
                    """
                )
                $0 <- Proof {
                    $0 <- """
                    Denote \(PP.sub(sigma) <- P.sub([1,sigma.of(1)], timesTo:[n,sigma.of(n)])). By the definition of the determinant;
                    \(§[ P.sub(i,j).abs.det(for: 1 ≤ [i,j] ≤ n) == .sum(sigma, of: .sign(sigma) * PP.sub(sigma).abs) ].period)
                    Denote \(PP <- .union(sigma, of: PP.sub(sigma))), and \(QQ <- Math.union(sigma, of: QQ.sub(sigma)).isSubsetOrEqual(to: PP)), and define \(Math.sign.function(from: PP, to: .set(1, -1))) by \(.sign(pp) <- .sign(sigma)) for \(pp.isIn(PP.sub(sigma))). So the right hand side of the equation above becomes:
                    \(§[ .sum(pp.isIn(PP), of: .sign(pp))
                    *=* .sum(pp.isIn(QQ), of: .sign(pp)) + .sum(pp.isIn(PP - QQ), of: .sign(pp))
                    *=* .sum(sigma, of: .sign(sigma) * QQ.sub(sigma).abs) + .sum(pp.isIn(PP - QQ), of: .sign(pp)) ].period)
                    It is thus sufficient to prove that the last sum equals zero. One way to do this is by showing the existence of a sign-reversing involution on \(PP - QQ). That is, a function \(f.function(from: PP - QQ, to: PP - QQ)) satisfying:
                    """
                    $0 <- Enumerate {
                        $0 <- "\(Math.sign.of(f.of(pp)) == -.sign(pp)) for all \(pp.isIn(PP - QQ))"
                        $0 <- "\(f.of(f.of(pp)) == pp) for all \(pp.isIn(PP - QQ))"
                    }
                    $0 <- """
                    This would ensure that the elements of \(PP - QQ) come in pairs of opposite signs. One such function \(f) may be defined as follows:
                    
                    For a tuple \(pp == .tuple(p.sub(1, to: n)).isIn(PP.sub(sigma) - QQ.sub(sigma))), let \(i) be the smallest non-negative integer for which \(p.sub(i)) intersects another path in the tuple, and let \(j != i) be the smallest non-negative integer so that \(p.sub(i)) intersects \(p.sub(j)). Let \(v) be the first vertex of \(p.sub(i)) that is also in \(p.sub(j)). Construct \(f.of(pp)) by
                    """
                }
            }
            
            $0 <- Subsection("Second Section") {
                $0 <- """
                Text of the Second Section
                """
            }
        }
        return doc
    }
}



