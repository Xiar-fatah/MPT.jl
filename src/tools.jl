function _convex_combination(Q::AbstractMatrix, κ::Real)::AbstractMatrix
    """
    src: https://arxiv.org/pdf/1310.3396.pdf
    ---------
    Parameters:
    Q: Covariance matrix

    """ 
    Q_prim = κ * Q + (1-κ) * I(size(Q)[1])
    return Q_prim
end